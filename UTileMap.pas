unit UTileMap;

interface

uses
	Windows,
	USmUtil, USmResManager,
	UPlayer, UType, UConfig;

const
	MAX_EVENT_LIST_BLOCK = 100;
	MAX_TIME_EVENT       = 10;

type
	// event structure
	PMapEventData = ^TMapEventData;
	TMapEventData = record
		mapPos    : TPoint;
		eventType : TEventType;
		eventFlag : integer;
		id        : integer;
	end;

	PMapEventList = ^TMapEventList;
	TMapEventList = record
		list  : array[0..pred(MAX_EVENT_LIST_BLOCK)] of PMapEventData;
		pNext : PMapEventList;
	end;

	TTimeEvent = record
		eventTick: longword;
		eventId: integer;
	end;

	// map structure
	TEvent = record
		case longword of
		0: (value: longword);
		1: (_id: word; _type: byte; _count: byte);
	end;

	PMapData = ^TMapData;
	TMapData = record
		tile  : longword;
		event : TEvent;
	end;

	TTileMapHeader = record
		xMapSize      : integer;
		yMapSize      : integer;
		xMapPitch     : integer;
		mapId         : integer;
		maxEvent      : integer;
		// timer event
		maxTimeEvent  : integer;
		timeEvent     : array[0..pred(MAX_TIME_EVENT)] of TTimeEvent;
	end;

	TTileMap = class
	private
		m_              : TTileMapHeader;
		m_pMapData      : PMapData;
		m_pMapEventList : PMapEventList;

		// player list
		m_player        : array[0..pred(MAX_PLAYER)] of TPlayer;

		function    m_GetTile(x, y: integer): longword;
		procedure   m_SetTile(x, y: integer; tile: longword);

		// event: 32-bit  cccccccc tttttttt nnnnnnnn nnnnnnnn
		// c: event count
		// e: event type
		// n: event number id
		function    m_GetEvent(x, y: integer): TEvent;
		procedure   m_SetEvent(x, y: integer; event: TEvent);
		function    m_SearchEvent(x, y: integer; eventType: TEventType): TEvent;

		function    m_String2Id(strId: string): integer;

	public
		constructor Create(mapId: string;  prevMapId: integer = 0; prevPosX: longint = 0; prevPosY: longint = 0); overload;
		constructor Create(mapId: integer; prevMapId: integer = 0; prevPosX: longint = 0; prevPosY: longint = 0); overload;
		procedure   Free;

		procedure   Init(pMapString: Pstring; nMapData: integer); overload;
		procedure   Init(pMapString: Pwidestring; nMapData: integer); overload;
		procedure   Done();
		function    IsWall(x, y: integer): boolean;
		function    IsMoveable(x, y: integer; defaultOutOfRangeFlag: boolean = FALSE): boolean;
		function    Istransmitable(x, y: integer; defaultOutOfRangeFlag: boolean = FALSE): boolean;
		function    XMapSize(): integer;
		function    YMapSize(): integer;
		property    Map[x, y: integer]: longword read m_GetTile write m_SetTile; default;
		property    Event[x, y: integer]: TEvent read m_GetEvent write m_SetEvent;

		// event method
		procedure   RegisterMapEvent(pos: TPoint; eventType: TEventType; eventId: integer; nEventFlag: integer);
		procedure   RegisterTimeEvent(reachedTick: longword; eventId: integer);
		function    GetMapEvent(eventListId: integer; eventMask: TEventTypeSet; out mapData: TMapEventData; isPeekingOnly: boolean = FALSE): boolean;
		procedure   RemoveMapEvent(pos: TPoint; eventType: TEventType);

		function    CheckOnEvent(x, y: integer; var dx, dy: integer): boolean;
		function    QueryReadingEvent(x, y: integer): boolean;
		function    CheckSearchEvent(x, y: integer): boolean;
		function    QuerySearchEvent(x, y: integer): boolean;
		function    CheckOpenEvent(x, y: integer): boolean;
		function    CheckActionEvent(x, y: integer): boolean;
		function    CheckTimeEvent(refTick: longword): boolean;

		// name cognizing event
		procedure   SetNameFlag(index: integer; flag: boolean = TRUE);
		function    GetNameFlag(index: integer): boolean;
		function    QueryNameOfPerson(index: integer; out name: widestring): boolean;
		property    NameFlag[index: integer]: boolean read GetNameFlag write SetNameFlag;

		// game event
		procedure   SetMapFlag(mapId: integer; index: integer; flag: boolean = TRUE);
		function    GetMapFlag(mapId: integer; index: integer): boolean;
		property    MapFlag[mapId: integer; index: integer]: boolean read GetMapFlag write SetMapFlag;

		// talk method
		procedure   TalkTo(personalId : integer; question : widestring);

		// character manipulation
		function    GetPlayer(index: integer): TPlayer; overload;
		function    GetPlayer(name: string): TPlayer; overload;
		property    GetPC: TPlayer read m_player[0];
		function    CreateObject(charaType: integer; xPos, yPos: integer; name: widestring = ''): TPlayer;
		procedure   ArrangePlayer();

		property    MapId: integer read m_.mapId;

		// load & save method
		function    LoadData(var inFile: TSmReadFileStream): boolean;
		function    SaveData(var outFile: TSmWriteFileStream): boolean;
	end;

const
	SCRIPT_MY_APART       = 1;
	SCRIPT_MY_ROOM        = 2;
	SCRIPT_DESERT         = 3;
	SCRIPT_AVEJ_WEST_LV1  = 4;
	SCRIPT_AVEJ_WEST_LV0  = 5;
	SCRIPT_AVEJ_WEST_LV2  = 6;
	SCRIPT_COSTABELLA_LV1 = 7;
	SCRIPT_LAST           = SCRIPT_COSTABELLA_LV1;
	SCRIPT_COSTABELLA_LV2 = 8;

procedure   ClearEventFlag();

implementation

uses
	UGameMain,
	UMapData01, UMapData02, UMapData03, UMapData04, UMapData05, UMapData06,
	UMapData_COSBEL01;

const
	// 최대 맵 개수
	MAX_MAP_DESC    = SCRIPT_LAST;

	MAP_DESC: array[1..MAX_MAP_DESC] of TMapDesc =
	(
		(
			idString   : 'my_apart';
			nMapData   : high(MAP_DATA_01);  pMapData   : @MAP_DATA_01;
			nEventData : high(MAP_EVENT_01); pEventData : @MAP_EVENT_01;
			nNPCData   : high(MAP_NPC_01);   pNPCData   : @MAP_NPC_01;
			fnTalkProc : TalkData01;
			fnEventProc: EventData01;
			fnChar2MapProc: nil;
			fnInitProc : InitProc01;
		),
		(
			idString   : 'my_room';
			nMapData   : high(MAP_DATA_02);  pMapData   : @MAP_DATA_02;
			nEventData : high(MAP_EVENT_02); pEventData : @MAP_EVENT_02;
			nNPCData   : high(MAP_NPC_02);   pNPCData   : @MAP_NPC_02;
			fnTalkProc : TalkData02;
			fnEventProc: EventData02;
			fnChar2MapProc: nil;
			fnInitProc : InitProc02;
		),
		(
			idString   : 'desert';
			nMapData   : high(MAP_DATA_03);  pMapData   : @MAP_DATA_03;
			nEventData : high(MAP_EVENT_03); pEventData : @MAP_EVENT_03;
			nNPCData   : high(MAP_NPC_03);   pNPCData   : @MAP_NPC_03;
			fnTalkProc : TalkData03;
			fnEventProc: EventData03;
			fnChar2MapProc: Char2MapProc03;
			fnInitProc : InitProc03;
		),
		(
			idString   : 'avej_west_lv1';
//			nMapData   : high(MAP_DATA_04);  pMapData   : @MAP_DATA_04;
			nMapData   : 0;  pMapData   : nil;
			nMapDataW  : high(MAP_DATA_04W); pMapDataW  : @MAP_DATA_04W;
			nEventData : high(MAP_EVENT_04); pEventData : @MAP_EVENT_04;
			nNPCData   : high(MAP_NPC_04);   pNPCData   : @MAP_NPC_04;
			fnTalkProc : TalkData04;
			fnEventProc: EventData04;
			fnChar2MapProc: Char2MapProc04;
			fnInitProc : InitProc04;
			idUpStairs: SCRIPT_AVEJ_WEST_LV2;
			xOffUpStairs  : 0;
			yOffUpStairs  : 10;
			idDownStairs: SCRIPT_AVEJ_WEST_LV0;
			xOffDownStairs: 0;
			yOffDownStairs: -5;
		),
		(
			idString      : 'avej_west_lv0';
			nMapData      : 0;  pMapData   : nil;
			nMapDataW     : high(MAP_DATA_05W); pMapDataW  : @MAP_DATA_05W;
			nEventData    : high(MAP_EVENT_05); pEventData : @MAP_EVENT_05;
			nNPCData      : high(MAP_NPC_05);   pNPCData   : @MAP_NPC_05;
			fnTalkProc    : TalkData05;
			fnEventProc   : EventData05;
			fnChar2MapProc: Char2MapProc05;
			fnInitProc    : InitProc05;
			idUpStairs    : SCRIPT_AVEJ_WEST_LV1;
			xOffUpStairs  : 0;
			yOffUpStairs  : 5;
			idDownStairs  : 0
		),
		(
			idString      : 'avej_west_lv2';
			nMapData      : 0;  pMapData   : nil;
			nMapDataW     : high(MAP_DATA_06W); pMapDataW  : @MAP_DATA_06W;
			nEventData    : high(MAP_EVENT_06); pEventData : @MAP_EVENT_06;
			nNPCData      : high(MAP_NPC_06);   pNPCData   : @MAP_NPC_06;
			fnTalkProc    : TalkData06;
			fnEventProc   : EventData06;
			fnChar2MapProc: Char2MapProc06;
			fnInitProc    : InitProc06;
			idUpStairs    : 0;
			xOffUpStairs  : 0;
			yOffUpStairs  : 0;
			idDownStairs  : SCRIPT_AVEJ_WEST_LV1;
			xOffDownStairs: 0;
			yOffDownStairs: -10;
		),
		(
			idString      : 'costa_bella_lv1';
			nMapData      : 0;  pMapData   : nil;
			nMapDataW     : high(MAP_DATA_COSBEL01W); pMapDataW  : @MAP_DATA_COSBEL01W;
			nEventData    : high(MAP_EVENT_COSBEL01); pEventData : @MAP_EVENT_COSBEL01;
			nNPCData      : high(MAP_NPC_COSBEL01);   pNPCData   : @MAP_NPC_COSBEL01;
			fnTalkProc    : TalkData_COSBEL01;
			fnEventProc   : EventData_COSBEL01;
			fnChar2MapProc: Char2MapProc_COSBEL01;
			fnInitProc    : InitProc_COSBEL01;
			idUpStairs    : 0;
			xOffUpStairs  : 0;
			yOffUpStairs  : 0;
			idDownStairs  : SCRIPT_COSTABELLA_LV2;
			xOffDownStairs: 0;
			yOffDownStairs: -10;
		)
	);

type
	TSbyte = set of byte;
var
	s_eventFlag : record
		nameCognizing : array[1..MAX_MAP_DESC] of TSbyte;
		gameTag       : array[1..MAX_MAP_DESC] of TSbyte;
		mapTag        : array[1..MAX_MAP_DESC] of TSbyte;
	end;

procedure   ClearEventFlag();
begin
	ZeroMemory(@s_eventFlag, sizeof(s_eventFlag));
end;

constructor TTileMap.Create(mapId: string; prevMapId: integer = 0; prevPosX: longint = 0; prevPosY: longint = 0);
begin
	self.Create(m_String2Id(mapId), prevMapId);
end;

constructor TTileMap.Create(mapId: integer; prevMapId: integer = 0; prevPosX: longint = 0; prevPosY: longint = 0);
var
	i: integer;
	pList: PMapEventList;
begin
	if (mapId < low(MAP_DESC)) or (mapId > high(MAP_DESC)) then begin
		assert(FALSE, 'map descriiption is not defined.');
		exit;
	end;

	ZeroMemory(@m_, sizeof(m_));

	m_.mapId        := mapId;
	m_pMapData      := nil;

	// enable the map event manager
	pList           := AllocMem(sizeof(TMapEventList));
	pList.pNext     := nil;
	ZeroMemory(@pList.list, sizeof(pList.list));

	m_pMapEventList := pList;

	// initialize characters
	ZeroMemory(@m_player, sizeof(m_player));

	if m_.mapId in [1..MAX_MAP_DESC] then
	with MAP_DESC[m_.mapId] do begin
		if assigned(pMapData) then
			self.Init(pMapData, nMapData)
		else
			self.Init(pMapDataW, nMapDataW);

		for i := 0 to nEventData do
			with pEventData^[i] do
				self.RegisterMapEvent(pos, eventType, id, flag);
		for i := 0 to nNPCData do
			with pNPCData^[i] do
				m_player[i] := CreateCharacter(charType, pos.x, pos.y, name);
	end;

	if assigned(MAP_DESC[m_.mapId].fnInitProc) then
		MAP_DESC[m_.mapId].fnInitProc(self, prevMapId, Point(prevPosX, prevPosY));
end;

procedure TTileMap.Free;
begin
	self.Done();
end;

function  TTileMap.m_GetTile(x, y: integer): longword;
var
	pMap: PMapData;
begin
	result := 0;

	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	result := pMap.tile;
end;

procedure TTileMap.m_SetTile(x, y: integer; tile: longword);
var
	pMap: PMapData;
begin
	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	pMap.tile := tile;
end;

function  TTileMap.m_GetEvent(x, y: integer): TEvent;
var
	pMap: PMapData;
begin
	result.value := 0;

	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	result := pMap.event;
end;

procedure TTileMap.m_SetEvent(x, y: integer; event: TEvent);
var
	pMap: PMapData;
begin
	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	// 이벤트 중복
	if pMap.event.value = 0 then begin
		pMap.event := event;
	end
	else begin
		assert(pMap.event._count < 255);
		inc(pMap.event._count);
		pMap.event._id   := event._id;
		pMap.event._type := event._type;
	end;
end;

function  TTileMap.m_SearchEvent(x, y: integer; eventType: TEventType): TEvent;
var
	i: integer;
	pMap: PMapData;
	pList: PMapEventList;
begin
	result.value := 0;

	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	if pMap.event._type = byte(eventType) then begin
		result := pMap.event;
	end
	else begin
		pList := m_pMapEventList;
		assert(assigned(pList));
		for i := 0 to pred(MAX_EVENT_LIST_BLOCK) do begin
			if assigned(pList.list[i]) then
			if (pList.list[i].mapPos.x = x) and (pList.list[i].mapPos.y = y) and (pList.list[i].eventType = eventType) then begin
				result._count := 1;
				result._type  := ord(pList.list[i].eventType);
				result._id    := pList.list[i].id;

				exit;
			end;
		end;
	end;
end;

function TTileMap.m_String2Id(strId: string): integer;
var
	i: integer;
begin
	for i := 1 to MAX_MAP_DESC do begin
		if strId = MAP_DESC[i].idString then begin
			result := i;
			exit;
		end;
	end;

	// can not find a ID
	result := 0;
end;

/////////////////////////////

type
	TQ = record
		c: char;
		w: string
	end;

const
	MAX_TABLE = 50;
	TABLE: array[0..MAX_TABLE] of TQ =
	(
		(c:'+'; w:'▦'),
		(c:'='; w:'▤'),
		(c:'%'; w:'▩'),
		(c:'O'; w:'▥'),
		(c:'<'; w:'◁'),
		(c:'('; w:'＜'),
		(c:'{'; w:'≪'),
		(c:' '; w:'　'),
		(c:'.'; w:'▣'),
		(c:','; w:'⊙'),
		(c:':'; w:'▒'),
		(c:';'; w:'∴'),
		(c:chr(130); w:'Θ'),
		(c:chr(132); w:'※'),
		(c:chr(133); w:'Γ'),
		(c:'N'; w:'Ｎ'),
		(c:'#'; w:'＃'),
		(c:'3'; w:'３'),
		(c:'*'; w:'＊'),
		(c:'8'; w:'８'),
		(c:'!'; w:'！'),
		(c:'1'; w:'１'),
		(c:'@'; w:'□'),
		(c:'f'; w:'♧'),
		(c:'T'; w:'Ⅱ'),
		(c:'c'; w:'∂'),
		(c:'h'; w:'￡'),
		(c:'H'; w:'￥'),
		(c:'k'; w:'◆'),
		(c:'C'; w:'п'),
		(c:'['; w:'〔'),
		(c:'|'; w:'‡'),
		(c:']'; w:'〕'),
		(c:'d'; w:'∏'),
		(c:'b'; w:'Œ'),
		(c:'v'; w:'♀'),
		(c:'t'; w:'〓'),
		(c:'B'; w:'◇'),
		(c:'-'; w:'≠'),
		(c:'"'; w:'€'),
		(c:'X'; w:'Ⅹ'),
		(c:'x'; w:'ⅹ'),
		(c:'/'; w:'♣'),
		(c:'\'; w:'♠'),
		(c:'P'; w:'㉺'),
		(c:'p'; w:'㈚'),
		(c:'I'; w:'▲'),
		(c:'U'; w:'↖'),
		(c:'u'; w:'↗'),
		(c:'W'; w:'↙'),
		(c:'w'; w:'↘')
	);

function s_Char2Wchar(cTemp: char): string;
var
	i: integer;
begin
	for i := low(TABLE) to high(TABLE) do begin
		if cTemp = TABLE[i].c then begin
			result := TABLE[i].w;
			exit;
		end;
	end;
	result := '★';
end;

function s_Wchar2Char(wcTemp: widechar): char;
var
	i: integer;
begin
	for i := low(TABLE) to high(TABLE) do begin
		if wcTemp = TABLE[i].w then begin
			result := TABLE[i].c;
			exit;
		end;
	end;
	result := '$';
end;

/////////////////////////////

function s_DefaultChar2Map(cTemp: char): longword;
begin
	case cTemp of
		// floor
		' ': result := FLOOR_INNER_TILE1;
		'.': result := FLOOR_BOARD_BLOCK;
		',': result := FLOOR_BOARD_BLOCK1;
		':': result := FLOOR_INNER_TILE2;
		';': result := FLOOR_GREEN;
		chr(130): result := FLOOR_INNER_TILE3;
		chr(131): result := FLOOR_BLANK;
		chr(132): result := FLOOR_INNER_X;
		chr(133): result := FLOOR_INNER_TILE4;

		// wall
		'+': result := WALL_BASE + 0;
		'%': result := WALL_BASE + 1;
		'=': result := WALL_BASE + 2;
		'O': result := WALL_BASE + 9;
		'<': result := WALL_ARROW_LEFT;
		'(': result := WALL_ARROW_LEFT + 2;
		'{': result := WALL_ARROW_LEFT + 4;
		// door & window
		'N': result := OBJ_DOOR_NAMED_CLOSE;
		'#': result := OBJ_DOOR_WINDOWED_CLOSE;
		'3': result := OBJ_DOOR_WINDOWED_OPEN;
		'*': result := OBJ_DOOR_CLOSE;
		'8': result := OBJ_DOOR_OPEN;
		'!': result := OBJ_DOOR_LOCKED_CLOSE;
		'1': result := OBJ_DOOR_LOCKED_OPEN;
		'@': result := OBJ_WINDOW;
		// object
		'f': result := OBJ_FLOWERPOT;
		'T': result := OBJ_TABLE_V;
		'c': result := OBJ_CHAIR_LEFT;
		'h': result := OBJ_CHAIR_RIGHT;
		'H': result := OBJ_CHAIR_DOWN;
		'C': result := OBJ_STOOL;
		'k': result := OBJ_CABINET;
		'[': result := OBJ_TABLE_LEFT;
		'|': result := OBJ_TABLE_CENTER;
		']': result := OBJ_TABLE_RIGHT;
		'd': result := OBJ_DESK;
		'b': result := OBJ_BED;
		'v': result := OBJ_TELEVISION;
		't': result := OBJ_TABLE;
		'B': result := OBJ_BOOKCASE;
		'X': result := OBJ_BOX_OPEN;
		'x': result := OBJ_BOX_CLOSE;
		'/': result := OBJ_TREE1;
		'\': result := OBJ_TREE2;
		'P': result := OBJ_PANEL1;
		'p': result := OBJ_PANEL2;
		'I': result := OBJ_PILLAR;
		// motion object
		'-': result := OBJ_QAZ;
		'"': result := OBJ_QAZ1;
		// stairs
		'U': result := STAIRS_UP_L;
		'u': result := STAIRS_UP_R;
		'W': result := STAIRS_DOWN_L;
		'w': result := STAIRS_DOWN_R;
		// OOPS!!
		else result := BLOCK_W_PITCH * 1 + 1;
	end;
end;

procedure TTileMap.Init(pMapString: Pstring; nMapData: integer);
var
	i, j: integer;
	pMap: PMapData;
	pMapLine: Pstring;
	cTemp: char;
	CHAR2MAP_TABLE: array[char] of longword;
	fnChar2MapProc: TFnChar2Map;
begin
	m_.xMapSize  := Length(pMapString^);
	m_.yMapSize  := nMapData + 1;

	// find max xMapSize
	begin
		pMapLine := pMapString;
		for j := 1 to pred(m_.yMapSize) do begin
			if m_.xMapSize < Length(pMapLine^) then
				m_.xMapSize := Length(pMapLine^);
			inc(pMapLine);
		end;
	end;

	m_.xMapPitch := m_.xMapSize;

	GetMem(m_pMapData, sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);
	ZeroMemory(m_pMapData, sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);

	if assigned(MAP_DESC[m_.mapId].fnChar2MapProc) then
		fnChar2MapProc := MAP_DESC[m_.mapId].fnChar2MapProc
	else
		fnChar2MapProc := s_DefaultChar2Map;

	for cTemp := low(char) to high(char) do begin
		CHAR2MAP_TABLE[cTemp] := fnChar2MapProc(cTemp);
		if CHAR2MAP_TABLE[cTemp] = high(longword) then
			CHAR2MAP_TABLE[cTemp] := s_DefaultChar2Map(cTemp);
	end;

	for j := 0 to pred(m_.yMapSize) do begin
		pMap := m_pMapData;
		inc(pMap, j * m_.xMapPitch);
		for i := 1 to Length(pMapString^) do begin
			pMap.tile := CHAR2MAP_TABLE[pMapString^[i]];
			inc(pMap);
		end;
		inc(pMapString);
	end;

end;

procedure TTileMap.Init(pMapString: Pwidestring; nMapData: integer);
var
	i, j: integer;
	pMap: PMapData;
	pMapLine: Pwidestring;
	cTemp: char;
	CHAR2MAP_TABLE: array[char] of longword;
	fnChar2MapProc: TFnChar2Map;
begin
	m_.xMapSize  := Length(pMapString^);
	m_.yMapSize  := nMapData + 1;

	// find max xMapSize
	begin
		pMapLine := pMapString;
		for j := 1 to pred(m_.yMapSize) do begin
			if m_.xMapSize < Length(pMapLine^) then
				m_.xMapSize := Length(pMapLine^);
			inc(pMapLine);
		end;
	end;

	m_.xMapPitch := m_.xMapSize;

	GetMem(m_pMapData, sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);
	ZeroMemory(m_pMapData, sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);

	if assigned(MAP_DESC[m_.mapId].fnChar2MapProc) then
		fnChar2MapProc := MAP_DESC[m_.mapId].fnChar2MapProc
	else
		fnChar2MapProc := s_DefaultChar2Map;

	for cTemp := low(char) to high(char) do begin
		CHAR2MAP_TABLE[cTemp] := fnChar2MapProc(cTemp);
		if CHAR2MAP_TABLE[cTemp] = high(longword) then
			CHAR2MAP_TABLE[cTemp] := s_DefaultChar2Map(cTemp);
	end;

	for j := 0 to pred(m_.yMapSize) do begin
		pMap := m_pMapData;
		inc(pMap, j * m_.xMapPitch);
		for i := 1 to Length(pMapString^) do begin
			pMap.tile := CHAR2MAP_TABLE[s_Wchar2Char(pMapString^[i])];
			inc(pMap);
		end;
		inc(pMapString);
	end;

end;

procedure TTileMap.Done();
var
	i: integer;
	pList: PMapEventList;
begin
	for i := 0 to pred(MAX_PLAYER) do begin
		if assigned(m_player[i]) then begin
			m_player[i].Free();
			m_player[i] := nil;
		end;
	end;

	// delocate all list nodes
	while (assigned(m_pMapEventList)) do begin
		pList := m_pMapEventList;
		for i := 0 to pred(MAX_EVENT_LIST_BLOCK) do begin
			if assigned(pList.list[i]) then
				FreeMem(pList.list[i]);
		end;
		m_pMapEventList := m_pMapEventList.pNext;
		FreeMem(pList);
	end;

	if assigned(m_pMapData) then
		FreeMem(m_pMapData);
end;

function  TTileMap.IsWall(x, y: integer): boolean;
var
	pMap: PMapData;
begin
	result := FALSE;

	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	result := (pMap.tile in [WALL_BASE..WALL_END, OBJ_DOOR_BASE..OBJ_DOOR_END]);
end;

function  TTileMap.IsMoveable(x, y: integer; defaultOutOfRangeFlag: boolean = FALSE): boolean;
var
	pMap: PMapData;
begin
	result := defaultOutOfRangeFlag;

	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	result := (pMap.tile in MOVEABLE_TILE_SET);
end;

function  TTileMap.Istransmitable(x, y: integer; defaultOutOfRangeFlag: boolean = FALSE): boolean;
var
	pMap: PMapData;
begin
	result := defaultOutOfRangeFlag;

	if (x < 0) or (x >= m_.xMapSize) or (y < 0) or (y >= m_.yMapSize) then
		exit;

	pMap := m_pMapData;
	inc(pMap, y * m_.xMapPitch + x);

	result := (pMap.tile in TRANSMITABLE_TILE_SET);
end;

function TTileMap.XMapSize(): integer;
begin
	result := m_.xMapSize;
end;

function TTileMap.YMapSize(): integer;
begin
	result := m_.yMapSize;
end;

procedure TTileMap.RegisterMapEvent(pos: TPoint; eventType: TEventType; eventId: integer; nEventFlag: integer);
var
	mapEvent : TMapEventData;
	pList    : PMapEventList;
	pTemp    : PMapEventList;
	hundred  : integer;
	tempData : TEvent;
begin
	if not (nEventFlag in s_eventFlag.mapTag[m_.mapId]) then begin
		pList   := m_pMapEventList;
		hundred := m_.maxEvent div MAX_EVENT_LIST_BLOCK;
		while (hundred > 0) and assigned(pList) do begin
			pList := pList.pNext;
			dec(hundred);
		end;

		assert(hundred = 0);

		if not assigned(pList) then begin
			pTemp       := AllocMem(sizeof(TMapEventList));
			ZeroMemory(@pTemp.list, sizeof(pTemp.list));
			pTemp.pNext := nil;

			pList := m_pMapEventList;
			while assigned(pList) do begin
				if not assigned(pList.pNext) then begin
					pList.pNext := pTemp;
					pList := pTemp;
					break;
				end;
				pList := pList.pNext;
			end;
		end;

		pList.list[m_.maxEvent mod MAX_EVENT_LIST_BLOCK] := AllocMem(sizeof(TMapEventData));

		mapEvent.mapPos    := pos;
		mapEvent.eventType := eventType;
		mapEvent.eventFlag := nEventFlag;
		mapEvent.id        := eventId;

		// map에는 eventType과 리스트의 인덱스를 준다
		tempData._count := 1;
		tempData._type  := ord(eventType);
		tempData._id    := m_.maxEvent;
		m_SetEvent(pos.x, pos.y, tempData);

		pList.list[m_.maxEvent mod MAX_EVENT_LIST_BLOCK]^ := mapEvent;

		inc(m_.maxEvent);
	end;
end;

procedure TTileMap.RemoveMapEvent(pos: TPoint; eventType: TEventType);
var
	event   : TEvent;
	mapData : TMapEventData;
begin
	event := m_SearchEvent(pos.x, pos.y, eventType);
	if event.value > 0 then begin
		self.GetMapEvent(event._id, [eventType], mapData);
	end;
end;

function TTileMap.GetMapEvent(eventListId: integer; eventMask: TEventTypeSet; out mapData: TMapEventData; isPeekingOnly: boolean = FALSE): boolean;
var
	hundred  : integer;
	pList    : PMapEventList;
begin
	result := FALSE;

	// check invalid parameter
	if eventListId >= m_.maxEvent then
		exit;

	pList   := m_pMapEventList;
	hundred := eventListId div MAX_EVENT_LIST_BLOCK;

	while (hundred > 0) and assigned(pList) do begin
		pList := pList.pNext;
		dec(hundred);
	end;

	assert(hundred = 0);

	if not assigned(pList.list[eventListId mod MAX_EVENT_LIST_BLOCK]) then
		exit;

	mapData := pList.list[eventListId mod MAX_EVENT_LIST_BLOCK]^;

	// check if wanted
	if mapData.eventType in eventMask then begin
		if not isPeekingOnly then begin
			FreeMem(pList.list[eventListId mod MAX_EVENT_LIST_BLOCK]);
			pList.list[eventListId mod MAX_EVENT_LIST_BLOCK] := nil;
		end;
		result := TRUE;
	end;
end;

function TTileMap.CheckOnEvent(x, y: integer; var dx, dy: integer): boolean;
var
	oldPos  : TPoint;
	newPos  : TPoint;
	event   : TEvent;
	mapData : TMapEventData;
	tile    : longword;
begin
	result := FALSE;

	oldPos := Point(x div BLOCK_W_SIZE, y div BLOCK_H_SIZE);
	newPos := Point((x + dx) div BLOCK_W_SIZE, (y + dy) div BLOCK_H_SIZE);

	if (oldPos.x = newPos.x) and (oldPos.y = newPos.y) then
		exit;

	event := m_SearchEvent(newPos.x, newPos.y, etOn);

	if event.value > 0 then begin
		if not self.GetMapEvent(event._id, [etOn], mapData, TRUE) then
			exit;

		if MAP_DESC[m_.mapId].fnEventProc(etOn, mapData.id) then begin
			// remove event data from the event list
			self.GetMapEvent(event._id, [etOn], mapData);
			result := TRUE;
		end;
	end
	else begin
		// checks if on stairs
		tile := self[newPos.x, newPos.y];
		if tile in [STAIRS_BASE..STAIRS_END] then begin
			if tile in [STAIRS_DOWN_L, STAIRS_DOWN_R] then begin
				if MAP_DESC[m_.mapId].idDownStairs > 0 then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT_STAIRS, MAP_DESC[m_.mapId].idDownStairs);
					inc(g_tileMap.GetPC.m_pos.x, MAP_DESC[MAP_DESC[m_.mapId].idDownStairs].xOffUpStairs * BLOCK_W_SIZE);
					inc(g_tileMap.GetPC.m_pos.y, MAP_DESC[MAP_DESC[m_.mapId].idDownStairs].yOffUpStairs * BLOCK_H_SIZE);
				end;
			end
			else begin
				if MAP_DESC[m_.mapId].idUpStairs > 0 then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT_STAIRS, MAP_DESC[m_.mapId].idUpStairs);
					inc(g_tileMap.GetPC.m_pos.x, MAP_DESC[MAP_DESC[m_.mapId].idUpStairs].xOffDownStairs * BLOCK_W_SIZE);
					inc(g_tileMap.GetPC.m_pos.y, MAP_DESC[MAP_DESC[m_.mapId].idUpStairs].yOffDownStairs * BLOCK_H_SIZE);
				end;
			end;
		end;
	end;
end;

function TTileMap.QueryReadingEvent(x, y: integer): boolean;
var
	event   : TEvent;
	mapData : TMapEventData;
begin
	result := FALSE;

	event := m_SearchEvent(x, y, etRead);

	if event.value = 0 then
		exit;

	if not self.GetMapEvent(event._id, [etRead], mapData, TRUE) then
		exit;

	MAP_DESC[m_.mapId].fnEventProc(etReadQuery, mapData.id);

	result := TRUE;
end;

function TTileMap.CheckSearchEvent(x, y: integer): boolean;
var
	event   : TEvent;
	mapData : TMapEventData;
begin
	result := FALSE;

	event := m_SearchEvent(x, y, etSearch);

	if event.value = 0 then
		exit;

	if not self.GetMapEvent(event._id, [etSearch], mapData) then
		exit;

	MAP_DESC[m_.mapId].fnEventProc(etSearch, mapData.id);

	result := TRUE;
end;

function TTileMap.QuerySearchEvent(x, y: integer): boolean;
var
	event   : TEvent;
	mapData : TMapEventData;
begin
	result := FALSE;

	event := m_SearchEvent(x, y, etSearch);

	if event.value = 0 then
		exit;

	if not self.GetMapEvent(event._id, [etSearch], mapData, TRUE) then
		exit;

	result := MAP_DESC[m_.mapId].fnEventProc(etSearchQuery, mapData.id);
end;

function TTileMap.CheckOpenEvent(x, y: integer): boolean;
var
	event   : TEvent;
	mapData : TMapEventData;
begin
	// default return value is TRUE
	result := TRUE;

	event := m_SearchEvent(x, y, etOpen);

	if event.value = 0 then
		exit;

	if not self.GetMapEvent(event._id, [etOpen], mapData, TRUE) then
		exit;

	if MAP_DESC[m_.mapId].fnEventProc(etOpen, mapData.id) then begin
		// remove event data from the event list
		self.GetMapEvent(event._id, [etOpen], mapData);
	end
	else begin
		result := FALSE;
	end;
end;

function TTileMap.CheckActionEvent(x, y: integer): boolean;
var
	event   : TEvent;
	mapData : TMapEventData;
begin
	// default return value is FALSE
	result := FALSE;

	event := m_SearchEvent(x, y, etAction);

	if event.value = 0 then
		exit;

	if not self.GetMapEvent(event._id, [etAction], mapData, TRUE) then
		exit;

	if MAP_DESC[m_.mapId].fnEventProc(etAction, mapData.id) then begin
		// remove event data from the event list
		self.GetMapEvent(event._id, [etAction], mapData);
	end;
	result := TRUE;
end;

procedure   TTileMap.RegisterTimeEvent(reachedTick: longword; eventId: integer);
var
	i, j: integer;
	iTemp: TTimeEvent;
begin
	if m_.maxTimeEvent > 9 then
		exit;

	m_.timeEvent[m_.maxTimeEvent].eventTick := reachedTick + g_refTick;
	m_.timeEvent[m_.maxTimeEvent].eventId := eventId;

	inc(m_.maxTimeEvent);

	for i := 0 to (m_.maxTimeEvent-2) do begin
		for j := i+1 to (m_.maxTimeEvent-1) do begin
			if m_.timeEvent[i].eventTick > m_.timeEvent[j].eventTick then begin
				iTemp          := m_.timeEvent[i];
				m_.timeEvent[i] := m_.timeEvent[j];
				m_.timeEvent[j] := iTemp;
			end;
		end;
	end;
end;

function    TTileMap.CheckTimeEvent(refTick: longword): boolean;
var
	i: integer;
begin
	result := FALSE;

	if m_.maxTimeEvent <= 0 then
		exit;

	if m_.timeEvent[0].eventTick > refTick then
		exit;

	MAP_DESC[m_.mapId].fnEventProc(etTime, m_.timeEvent[0].eventId);

	for i := 1 to pred(m_.maxTimeEvent) do begin
		m_.timeEvent[i-1] := m_.timeEvent[i];
	end;

	dec(m_.maxTimeEvent);
end;

procedure TTileMap.SetNameFlag(index: integer; flag: boolean = TRUE);
begin
	assert(m_.mapId in [1..MAX_MAP_DESC]);

	if flag then
		s_eventFlag.nameCognizing[m_.mapId] := s_eventFlag.nameCognizing[m_.mapId] + [index]
	else
		s_eventFlag.nameCognizing[m_.mapId] := s_eventFlag.nameCognizing[m_.mapId] - [index]
end;

function  TTileMap.GetNameFlag(index: integer): boolean;
begin
	assert(m_.mapId in [1..MAX_MAP_DESC]);

	result := index in s_eventFlag.nameCognizing[m_.mapId];
end;

function  TTileMap.QueryNameOfPerson(index: integer; out name: widestring): boolean;
var
	player: TPlayer;
begin
	result := FALSE;

	if not self.GetNameFlag(index) then
		exit;

	player := self.GetPlayer(index);
	if not assigned(player) then
		exit;

	name := player.m_name;

	result := TRUE;
end;

function TTileMap.GetPlayer(index: integer): TPlayer;
begin
	if index in [0..pred(MAX_PLAYER)] then
		result := m_player[index]
	else
		result := nil;
end;

function TTileMap.GetPlayer(name: string): TPlayer;
var
	i: integer;
begin
	for i := 0 to pred(MAX_PLAYER) do begin
		if assigned(m_player[i]) then begin
			if m_player[i].m_name = name then begin
				result := m_player[i];
				exit;
			end;
		end;
	end;
	result := nil;
end;

function  TTileMap.CreateObject(charaType: integer; xPos, yPos: integer; name: widestring = ''): TPlayer;
var
	i: integer;
begin
	result := nil;
	for i := 0 to pred(MAX_PLAYER) do begin
		if not assigned(m_player[i]) then begin
			m_player[i] := UPlayer.CreateObject(charaType, xPos, yPos, name);
			result := m_player[i];
			exit;
		end;
	end;
end;

procedure TTileMap.ArrangePlayer();
var
	i: integer;
begin
	for i := 0 to pred(MAX_PLAYER) do begin
		if assigned(m_player[i]) then begin
			if not m_player[i].IsAlive then begin
				m_player[i].Free();
				m_player[i] := nil;
			end;
		end;
	end;
end;

procedure TTileMap.TalkTo(personalId : integer; question : widestring);
const
	LatestId : integer = 0;
var
	i : integer;
	keyword : widestring;
begin
	if personalId = 0 then
		personalId := LatestId;

	LatestId := personalId;

	while (TRUE) do begin
		i := Pos(' ', question);
		if i > 0 then begin
			question := Copy(question, 1, i-1) + Copy(question, i+1, 60000);
			if question <> ' ' then
				continue;
		end;
		break;
	end;

	keyword := LowerCase(question);

	if Length(keyword) > KEYWORD_LIMIT then
		SetLength(keyword, KEYWORD_LIMIT);

	MAP_DESC[m_.mapId].fnTalkProc(personalId, keyword, question);
end;

procedure TTileMap.SetMapFlag(mapId: integer; index: integer; flag: boolean = TRUE);
begin
	if mapId = 0 then
		mapId := m_.mapId;

	if not (mapId in [1..MAX_MAP_DESC]) then
		exit;

	if flag then
		s_eventFlag.gameTag[mapId] := s_eventFlag.gameTag[mapId] + [index]
	else
		s_eventFlag.gameTag[mapId] := s_eventFlag.gameTag[mapId] - [index]
end;

function  TTileMap.GetMapFlag(mapId: integer; index: integer): boolean;
begin
	if mapId = 0 then
		mapId := m_.mapId;

	if not (mapId in [1..MAX_MAP_DESC]) then begin
		result := FALSE;
		exit;
	end;

	result := index in s_eventFlag.gameTag[mapId];// m_.mapId];
end;

const
	DATA_EXIST: byte = $80;
	DATA_EMPTY: byte = $00;

function  TTileMap.LoadData(var inFile: TSmReadFileStream): boolean;
var
	i: integer;
	data: byte;
	pList: PMapEventList;
begin
	result := FALSE;

	if not inFile.IsAvailable then
		exit;

	self.Done();

	// event flags
	inFile.Read(s_eventFlag, sizeof(s_eventFlag));

	// map header
	inFile.Read(m_, sizeof(m_));

	// map data
	m_pMapData := AllocMem(sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);
	inFile.Read(m_pMapData^, sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);

	// map event list
	inFile.Read(data, sizeof(DATA_EMPTY));
	while data <> DATA_EMPTY do begin
		//?? 두번째 진입에서 문제 발생
		m_pMapEventList := AllocMem(sizeof(m_pMapEventList^));
		m_pMapEventList.pNext := nil;

		pList := m_pMapEventList;

		for i := 0 to pred(MAX_EVENT_LIST_BLOCK) do begin
			inFile.Read(data, sizeof(DATA_EMPTY));
			if data <> DATA_EMPTY then begin
				pList.list[i] := AllocMem(sizeof(pList.list[i]^));
				inFile.Read(pList.list[i]^, sizeof(pList.list[i]^));
			end
			else begin
				pList.list[i] := nil;
			end;
		end;

		inFile.Read(data, sizeof(DATA_EMPTY));
	end;

	for i := 0 to pred(MAX_PLAYER) do begin
		inFile.Read(data, sizeof(DATA_EMPTY));
		if data <> DATA_EMPTY then begin
			m_player[i] := CreateCharacter(data and $7F, 0, 0);
			m_player[i].LoadData(inFile);
		end
		else begin
			m_player[i] := nil;
		end;
	end;

	g_inventory.LoadData(inFile);

	result := TRUE;
end;

function  TTileMap.SaveData(var outFile: TSmWriteFileStream): boolean;
var
	i: integer;
	data: byte;
	pList: PMapEventList;
begin
	// revise time event
	for i := 0 to pred(m_.maxTimeEvent) do begin
		assert(integer(m_.timeEvent[i].eventTick) - integer(g_refTick) >= 0);
		dec(m_.timeEvent[i].eventTick, g_refTick);
	end;

	// event flags
	outFile.Write(s_eventFlag, sizeof(s_eventFlag));

	// map header
	outFile.Write(m_, sizeof(m_));

	// map data
	outFile.Write(m_pMapData^, sizeof(TMapData) * m_.xMapPitch * m_.yMapSize);

	// map event list
	pList := m_pMapEventList;
	while (assigned(pList)) do begin
		outFile.Write(DATA_EXIST, sizeof(DATA_EXIST));
		for i := 0 to pred(MAX_EVENT_LIST_BLOCK) do begin
			if assigned(pList.list[i]) then begin
				outFile.Write(DATA_EXIST, sizeof(DATA_EXIST));
				outFile.Write(pList.list[i]^, sizeof(pList.list[i]^));
			end
			else begin
				outFile.Write(DATA_EMPTY, sizeof(DATA_EMPTY));
			end;
		end;
		pList := pList.pNext;
	end;
	outFile.Write(DATA_EMPTY, sizeof(DATA_EMPTY));

	for i := 0 to pred(MAX_PLAYER) do begin
		if assigned(m_player[i]) then begin
			data := DATA_EXIST or byte(m_player[i].m_playerType);
			outFile.Write(data, sizeof(DATA_EXIST));
			m_player[i].SaveData(outFile);
		end
		else begin
			outFile.Write(DATA_EMPTY, sizeof(DATA_EMPTY));
		end;
	end;

	g_inventory.SaveData(outFile);

	result := TRUE;
end;

initialization
	ClearEventFlag();

end.

