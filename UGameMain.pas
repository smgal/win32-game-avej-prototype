unit UGameMain;

// {$DEFINE _DEBUG}
// {$DEFINE _LOAD_FROM_FILE}
// {$DEFINE _MANUAL_SAVE}

(*-------------------------------- TO DO LIST --------------------------------*)

(******************************************************************************
 *  최적화 이슈
   -------------------------------------------------------------------------
	문자열 하나로 통일하기 & string resource 관리하기
	type writer 시뮬레이션
	위로 열리는 선반 적용
	움직이는 사람 구현
	주인공 집에 보관창고 만들기
	message box
	버퍼의 내용을 저장했다가 출력
 ******************************************************************************)

(******************************************************************************
 *  기능적 추가
   -------------------------------------------------------------------------
	사후세계입문서 만들기

	Direct Sound 추가
	AVEJ title 만들기
	save file에 대한 checksum
	Elemental 공격
	MP(-)인 물체의 회피 본능
	다른 층의 맵 자동 연결


	map 5의 오른쪽 상자에서 파이로 Ball Bullet 입수
	map 4의 숨겨진 문에서 air cell이 없는 air blaster 입수, 에어 카트리지
	map 4의 숨겨진 문에서 air blaster 매뉴얼 입수

	초기에는 air blaster가 아닌 단순한 air gun이다.
	출력은 좋지만 일반 플라스틱 BB탄을 사출하기 위한 것으로
	나중에 개조를 통해 air blaster로 개조해야 한다.

	>> air blaster 사용법
	1. air blaster에 air cell을 장착한다.
	2. air cell은 분출 회수가 정해져 있다.
	3. 파이로 Ball Bullet 등의 탄환을 장착하면 air cell의 힘으로 탄환을 밀어 낸다.

 ******************************************************************************)

(******************************************************************************
 *  버그
   -------------------------------------------------------------------------
	D3D에러에 대한 유연한 대응이 필요

오르츠의 지하실의 가장 왼쪽 방에서...
오른쪽 최하단의 두 캐비넷 중 왼쪽 것에서,
[q] 키로 관심을 가지고 [a] 키로 자세히 살피면,
[캐비넷을 좀 더 자세히 보았다.]
라는 말만 나옵니다.
원래는 [특별히 눈에 띄는 것이 없다.] 는 말이 나와야 하지 않을까요?

 ******************************************************************************)

interface

uses
	Windows, Messages,
	USmD3D9, USmD3D9Ex, USmUtil, USmHangul, USmIme, USmResManager,
	UTextArea, UTileMap, UPlayer, UFocus, UInventory, UBook, UDebug, UResource, UType, UConfig;

const
	WM_IDLE = (WM_USER + 100);

const
	WM_GAME_COMMAND                 = WM_USER + $4FED;
	GAME_COMMAND                    = $8000;
	GAME_COMMAND_SHOW_MEMO          = GAME_COMMAND or 0;
	GAME_COMMAND_EXIT_GAME          = GAME_COMMAND or 1;
	GAME_COMMAND_LOAD_GAME          = GAME_COMMAND or 2;
	GAME_COMMAND_END_TALK           = GAME_COMMAND or 3;
	GAME_COMMAND_LOAD_SCRIPT        = GAME_COMMAND or 4;
	GAME_COMMAND_LOAD_SCRIPT_STAIRS = GAME_COMMAND or 5;
	GAME_COMMAND_LOST_DEVICE        = GAME_COMMAND or 6;

type
	TGameMode = (gmGame, gmInventory, gmReadBook, gmPressAnyKey);

	TScreenInfo = record
		width  : integer;
		height : integer;
		depth  : integer;
		isFullScreen : boolean;
	end;

	TGameMain = class
	private
		m_hWindow    : THandle;
		m_screenInfo : TScreenInfo;
		m_TickCount  : integer;
		// world map
		m_xMap       : integer;
		m_yMap       : integer;
		m_xMapOffset : integer;
		m_yMapOffset : integer;
		// sort
		m_ySort      : array[0..pred(MAX_PLAYER)] of integer;
		m_maxSort    : integer;
		// focus
		m_focus      : CFocus;

		m_gameMode   : TGameMode;

		m_currBook   : integer;
		m_readPage   : integer;

		procedure m_InitGfxResource();
		procedure m_DoneGfxResource();

		procedure m_ResetGameTick();
		procedure m_UpdateGameTick();
		procedure m_ApplyTileAnime(refTime: longword; var tile: integer);

		procedure m_ProcAction();
		procedure m_ProcDisplay();
		procedure m_ProcDisplayInventory();
		procedure m_SelectAction(key: char);

		procedure m_StartTalking(personId: integer);
		procedure m_EndTalking(personId: integer);

		procedure m_OnOpen();
		function  m_OnSearch(focusType: TFocusType): boolean;
		procedure m_OnAction(focusType: TFocusType);
		procedure m_OnLostDevice();

		procedure m_ChangeEquipment(isDownward: boolean);
		procedure m_UpdateStatus();

		procedure m_ReadMemo(memo: longword);
		procedure m_ReadPoster(poster: longword);
		procedure m_ReadBook(book: longword; var page: integer);

		procedure m_ClearScreen(method: integer);

		procedure m_NewGame();
		procedure m_LoadGame();
		procedure m_SaveGame();

	public
		procedure Init(window: THandle; width, height: integer; depth: integer; isFullScreen: boolean);
		procedure Done();
		procedure Run();

		function  ProcWindowsMessage(invokeIdle: boolean): boolean;
		procedure ProcKeyDown(key: word);
		procedure ProcKeyUp(key: word);
		procedure ProcGameCommand(command: longint; param1: longint);

		procedure SendCommand(command: word; param1: longint = 0; param2: word = 0);
		procedure UpdateStatus();
		procedure UpdateDisplay();
		procedure PressAnyKey();

		property  GameMode: TGameMode read m_gameMode write m_gameMode;

	end;

var
	g_gameMain    : TGameMain  = nil;
	g_tileMap     : TTileMap   = nil;
	g_textArea    : TTextArea  = nil;
	g_InputArea   : TInputArea = nil;
	g_statusArea  : TTextArea  = nil;
	g_smIme       : TSmIme     = nil;
	g_inventory   : TInventory = nil;

	g_gameCursor  : TPoint;
	g_mapCursor   : TPoint;

	g_refTick     : longword = 0;
	g_refAnime    : longword = 0;

	g_hTexture    : integer = 0;
	g_hObject     : integer = 0;
	g_fontImage   : integer = 0;

	g_baseXPos    : integer = 0;
	g_baseYPos    : integer = 0;

	g_isActivate  : boolean = FALSE;
	g_enableDisplay: boolean = TRUE;

	g_enableCheat : boolean = FALSE;
	g_cheatList   : set of (CHEAT_FITTED_TILE, CHEAT_DISPLAY_FPS, CHEAT_DISPALY_EVENT, CHEAT_MAP_EDITOR) = [];

procedure DxBitBlt(xDest, yDest: integer; width, height: integer; xSour, ySour: integer; color: longword); stdcall;

implementation

procedure DxBitBlt(xDest, yDest: integer; width, height: integer; xSour, ySour: integer; color: longword); stdcall;
begin
	g_d3Device.BitBlt(xDest, yDest, g_fontImage, xSour, ySour, width, height, color);
end;

procedure TGameMain.m_InitGfxResource();
begin
	// enable the video device
	with m_screenInfo do begin
		g_d3Device.Init(width, height, depth, isFullScreen);

		if not g_d3Device.IsValid() then
			raise EAvejD3D.Create('D3D9 device instance creation fails.');

		g_d3Device.GetBufferInfo(width, height);
	end;

	// load textures
{$IFDEF _LOAD_FROM_FILE}
	g_hTexture  := LoadTile(g_d3Device, './tiles1bit.bmp');
	g_hObject   := LoadD3DBitmapEx(g_d3Device, './object.bmp', $0000FF);
	g_fontImage := LoadD3DBitmap(g_d3Device, './han1bit.bmp');
{$ELSE}
	g_hTexture  := LoadTileFromMemory(g_d3Device, @pResTile1bit, sizeof(pResTile1bit));
	g_hObject   := LoadD3DBitmapExFromMemory(g_d3Device, @pResObject, sizeof(pResObject), $0000FF);
	g_fontImage := LoadD3DBitmapFromMemory(g_d3Device, @pResHan1bit, sizeof(pResHan1bit));
{$ENDIF}

	if (g_hTexture = 0) or (g_hObject = 0) or (g_fontImage = 0) then
		raise EAvejD3D.Create('D3D9 texture instance creation fails.');

	// enable text area
	g_textArea  := TTextArea.Create(400-20, 20, 400, 470, 0);
	g_inputArea := TInputArea.Create(400-20, 510, 400, 16*5, 0);
	g_statusArea:= TTextArea.Create(WORLD_MAP_XPOS, WORLD_MAP_YPOS+WORLD_MAP_HEIGHT+16-2, WORLD_MAP_WIDTH, 16*8, 0);

	if not (g_textArea.IsValid() and g_inputArea.IsValid() and g_statusArea.IsValid()) then
		raise EAvejD3D.Create('Memo instance creation fails.');
end;

procedure TGameMain.m_DoneGfxResource();
begin
	// release gfx resources
	if assigned(g_statusArea) then begin
		g_statusArea.Free();
		g_statusArea := nil;
	end;
	if assigned(g_inputArea) then begin
		g_inputArea.Free();
		g_inputArea := nil;
	end;
	if assigned(g_textArea) then begin
		g_textArea.Free();
		g_textArea := nil;
	end;

	if assigned(g_d3Device) then begin
		g_d3Device.DestroyImage(g_fontImage);
		g_d3Device.DestroyImage(g_hObject);
		g_d3Device.DestroyImage(g_hTexture);
		g_d3Device.Done();
		g_d3Device := nil;
	end;
end;

procedure TGameMain.Init(window: THandle; width, height: integer; depth: integer; isFullScreen: boolean);
begin
	// initialize class member variables
	m_hWindow                 := window;

	m_screenInfo.width        := width;
	m_screenInfo.height       := height;
	m_screenInfo.depth        := depth;
	m_screenInfo.isFullScreen := isFullScreen;

	m_TickCount               := 0;
	m_focus                   := nil;
	m_gameMode                := gmGame;
	m_currBook                := 0;
	m_readPage                := 0;

	// initialize member classes
	g_smIme    := TSmIme.Create();
	g_d3Device := TD3DDevice.Create(window, USE_AUX_DISPLAY);
	g_d3Device.SetCallback(self.m_OnLostDevice);

	// enable the video device and initialize H/W images
	m_InitGfxResource();

	// enable the map manager
	g_tileMap   := TTileMap.Create('my_apart');

	// create inventory
	g_inventory := TInventory.Create();

{$IFDEF _MANUAL_SAVE}
{$ELSE}
	SendCommand(GAME_COMMAND_LOAD_GAME);
{$ENDIF}
end;

procedure TGameMain.Done();
begin
	// release inventory
	if assigned(g_inventory) then begin
		g_inventory.Free();
		g_inventory := nil;
	end;

	// release tile data
	if assigned(g_tileMap) then begin
		g_tileMap.Free();
		g_tileMap := nil;
	end;

	// release gfx resources
	m_DoneGfxResource();

	if assigned(g_d3Device) then begin
		g_d3Device.Free();
		g_d3Device := nil;
	end;

	// release IME
	if assigned(g_smIme) then begin
		g_smIme.Free();
		g_smIme := nil;
	end;
end;

procedure TGameMain.m_OnLostDevice();
begin
//	DestroyWindow(m_hWindow);
	SendCommand(GAME_COMMAND_LOST_DEVICE);
end;

function  TGameMain.ProcWindowsMessage(invokeIdle: boolean): boolean;
var
	uMsg: TMsg;
begin
	result := FALSE;

	if PeekMessage(uMsg, 0, 0, 0, PM_NOREMOVE) then begin
		result := TRUE;
		if not GetMessage(uMsg, 0, 0, 0) then
			exit;
		TranslateMessage(uMsg);
		DispatchMessage(uMsg);
	end
	else if invokeIdle then begin
		if g_isActivate then
			PostMessage(m_hWindow, WM_IDLE, 0, 0);
		WaitMessage();
	end;
end;

procedure TGameMain.ProcKeyDown(key: word);
begin
	if not (self.GameMode in [gmGame]) then
		exit;

	if assigned(m_focus) and (m_focus.FocusType = ftTalk) and ((m_focus as CFocusTalk).IsAccepted) then begin
		if key = VK_HANGUL then begin
			// change IME
			if g_smIme.InputMode = INPUTMODE_ENG then
				g_smIme.InputMode := INPUTMODE_HAN
			else
				g_smIme.InputMode := INPUTMODE_ENG
		end
		else if key = VK_ESCAPE then begin
			// stop talking
			g_inputArea.WriteLn('');
			g_tileMap.TalkTo(0, '');
			g_smIme.Reset();
		end
		else if key = VK_RETURN then begin
			// ask a question or respond to a question
			g_inputArea.WriteLn('');
			g_tileMap.TalkTo(m_focus.selected, g_smIme.wComplete + g_smIme.wComposite);
			g_smIme.Reset();
		end
		else if ((key >= $20) and (key < $80)) or (key = VK_BACK) then begin
			if HiByte(GetAsyncKeyState(VK_SHIFT)) > 0 then begin
				if g_smIme.InputMode = INPUTMODE_HAN then begin
					if char(key) in ['a'..'z'] then
						key := key - ord(' ');
				end;
				g_smIme.ProcKeyUp(key, [ssShift]);
			end
			else begin
				if g_smIme.InputMode = INPUTMODE_HAN then begin
					if char(key) in ['A'..'Z'] then
						key := key + ord(' ');
				end;
				g_smIme.ProcKeyUp(key, []);
			end;

			g_inputArea.InputQuery(g_smIme.wComplete, g_smIme.wComposite);
		end;
	end
	else begin
		case key of
			VK_ESCAPE:
			begin
				if assigned(m_focus) then begin
					DestroyFocus(m_focus);
				end;
			end;
			ord('A')..ord('Z'), ord('a').. ord('z'):
				if self.GameMode in [gmGame] then
					m_SelectAction(UpCase(chr(key)));
{$IFDEF _DEBUG}
			ord('|'):
			begin
				g_enableCheat := not g_enableCheat;
				g_cheatList   := [CHEAT_FITTED_TILE, CHEAT_DISPLAY_FPS, CHEAT_DISPALY_EVENT, CHEAT_MAP_EDITOR];
			end;
{$ENDIF}
		end;
	end;
end;

procedure TGameMain.ProcKeyUp(key: word);
begin
	case self.GameMode of
		gmPressAnyKey:
		begin
			if key = VK_SPACE then
				self.GameMode := gmGame;
		end;
		gmReadBook:
		begin
			if (key = VK_RETURN) or (key = VK_SPACE) or (key = VK_NEXT) then begin
				inc(m_readPage);
				m_ReadBook(m_currBook, m_readPage);
			end;
			if key = VK_PRIOR then begin
				dec(m_readPage);
				m_ReadBook(m_currBook, m_readPage);
			end;
			if key = VK_ESCAPE then begin
				g_textArea.WriteLn('책을 다시 덮었다.');
				g_textArea.WriteLn();
				self.GameMode := gmGame;
			end;
		end;
		gmGame:
		begin
			if key = VK_ESCAPE then begin
				SendCommand(GAME_COMMAND_EXIT_GAME);
				{$IFDEF _MANUAL_SAVE}
				{$ELSE}
				m_SaveGame();
				{$ENDIF}
			end;

			if (key = ord('N')) and (HiByte(GetAsyncKeyState(VK_CONTROL)) > 0) then begin
				m_NewGame();
			end;

			if key = VK_F1 then begin
				m_ReadMemo(ITEM_MEMO_HELP_MESSAGE);
			end;
			if key = VK_F2 then begin
				if g_screenColor = high(TScreenColor) then
					g_screenColor := low(TScreenColor)
				else
					inc(g_screenColor);

				ChangeScreenColor(g_screenColor);

				g_textArea.Refresh();
				g_inputArea.Refresh();
				g_statusArea.Refresh();
				m_UpdateStatus();

				SendCommand(GAME_COMMAND_SHOW_MEMO, ITEM_MEMO_START_MESSAGE);
			end;
		end;
		gmInventory:
		begin
			//assert(FALSE);
		end;
	end;

{$IFDEF _DEBUG}
	if (key = ord('L')) and (HiByte(GetAsyncKeyState(VK_CONTROL)) > 0) then begin
		m_LoadGame();
	end;
	if (key = ord('S')) and (HiByte(GetAsyncKeyState(VK_CONTROL)) > 0) then begin
		m_SaveGame();
	end;
{$ENDIF}
end;

procedure TGameMain.ProcGameCommand(command: longint; param1: longint);
var
	i: integer;
	param2: word;
	prevMainPCPosX, prevMainPCPosY: longint;
	equipment: TItem;
	nameOfPC: widestring;
begin
	param2  := (command shr 16) and $FFFF;
	command := command and $FFFF;

	case command of
		GAME_COMMAND_SHOW_MEMO:
			m_ReadMemo(param1);
		GAME_COMMAND_END_TALK:
			m_EndTalking(param1);
		GAME_COMMAND_LOAD_SCRIPT,
		GAME_COMMAND_LOAD_SCRIPT_STAIRS:
		begin
			equipment := g_tileMap.GetPC.Equipment;
			nameOfPC  := g_tileMap.GetPC.m_name;
			if command = GAME_COMMAND_LOAD_SCRIPT_STAIRS then begin
				prevMainPCPosX := g_tileMap.GetPC.m_pos.x;
				prevMainPCPosY := g_tileMap.GetPC.m_pos.y;
			end
			else begin
				prevMainPCPosX := -1;
				prevMainPCPosY := -1;

				m_ClearScreen(1);
			end;

			g_tileMap.Free();

			m_ResetGameTick();
			g_tileMap := TTileMap.Create(param1, param2, prevMainPCPosX, prevMainPCPosY);

			g_tileMap.GetPC.m_name    := nameOfPC;
			g_tileMap.GetPC.Equipment := equipment;

			m_UpdateStatus();

			g_enableDisplay := TRUE;
		end;
		GAME_COMMAND_LOST_DEVICE:
		begin
			m_DoneGfxResource();

			if assigned(g_d3Device) then
				g_d3Device.Free();

			g_d3Device := TD3DDevice.Create(m_hWindow);
			g_d3Device.SetCallback(self.m_OnLostDevice);

			m_InitGfxResource();

			for i := 0 to pred(MAX_PLAYER) do begin
				if assigned(g_tileMap.Getplayer(i)) then
					g_tileMap.Getplayer(i).m_hTexture := g_hTexture;
			end;

			g_inventory.IsModified := TRUE;
		end;
		GAME_COMMAND_LOAD_GAME:
		begin
			m_LoadGame();
		end;
	end;
end;

procedure TGameMain.SendCommand(command: word; param1: longint; param2: word);
begin
	case command of
		GAME_COMMAND_EXIT_GAME,
		GAME_COMMAND_LOAD_GAME:
		begin
			PostMessage(m_hWindow, WM_GAME_COMMAND, command, param1);
		end;
		GAME_COMMAND_SHOW_MEMO,
		GAME_COMMAND_END_TALK,
		GAME_COMMAND_LOST_DEVICE:
		begin
			PostMessage(m_hWindow, WM_GAME_COMMAND, (longword(param2) shl 16) or command, param1);
		end;
		GAME_COMMAND_LOAD_SCRIPT,
		GAME_COMMAND_LOAD_SCRIPT_STAIRS:
		begin
			g_enableDisplay := FALSE;

			param2 := g_tileMap.MapId;
			PostMessage(m_hWindow, WM_GAME_COMMAND, (longword(param2) shl 16) or command, param1);
		end;
		else begin
			assert(FALSE, 'Unknown command');
		end;
	end;
end;

procedure TGameMain.UpdateStatus();
begin
	m_UpdateStatus();
end;

procedure TGameMain.UpdateDisplay();
begin
	m_ProcDisplay();
end;

procedure TGameMain.PressAnyKey();
begin
	while Self.ProcWindowsMessage(FALSE) do begin end;

	self.GameMode := gmPressAnyKey;

	while (self.GameMode = gmPressAnyKey) do begin
		Self.ProcWindowsMessage(TRUE);
	end;
end;

procedure TGameMain.m_ResetGameTick();
begin
	g_refTick := 0;
	g_refAnime := 0;
	g_textArea.Clear();
	g_inputArea.Clear();
	g_statusArea.Clear();
end;

procedure TGameMain.m_ApplyTileAnime(refTime: longword; var tile: integer);
const
	MAX_OBJ_CATEGORY = 2;
	OBJ_CATEGORY_TABLE: array[OBJ_MOVEABLE_BASE.. OBJ_MOVEABLE_END] of word =
	(
		$0000, $0100, $0101, $0102, $0103
	);
	OBJ_ANIME_TABLE: array[1..pred(MAX_OBJ_CATEGORY)] of string =
	(
		'ABCBAD'
	);

	MAX_WALL_CATEGORY = 2;
	WALL_CATEGORY_TABLE: array[WALL_MOVEABLE_BASE.. WALL_MOVEABLE_END] of word =
	(
		$0100, $0101, $0102, $0103, $0104, $0105
	);
	WALL_ANIME_TABLE: array[1..pred(MAX_OBJ_CATEGORY)] of string =
	(
		'ABCDEF'
	);
var
	ixTile: integer;
	ixCount: integer;
	category: word;
begin
	if tile in [OBJ_MOVEABLE_BASE..OBJ_MOVEABLE_END] then begin
		category := OBJ_CATEGORY_TABLE[tile];
		ixTile   := integer(category shr 8);
		ixCount  := integer(category and $FF);
		assert((ixTile >= 0) and (ixTile < MAX_OBJ_CATEGORY));

		// if ixTile is NULL, it is not an animated tile
		if ixTile > 0 then begin
			tile := tile + integer(OBJ_ANIME_TABLE[ixTile, (integer(refTime)+ixCount) mod length(OBJ_ANIME_TABLE[ixTile])+1]) - integer('A') - ixCount;
		end;
	end;

	if tile in [WALL_MOVEABLE_BASE..WALL_MOVEABLE_END] then begin
		category := WALL_CATEGORY_TABLE[tile];
		ixTile   := integer(category shr 8);
		ixCount  := integer(category and $FF);
		assert((ixTile >= 0) and (ixTile < MAX_WALL_CATEGORY));

		// if ixTile is NULL, it is not an animated tile
		if ixTile > 0 then begin
			tile := tile + integer(WALL_ANIME_TABLE[ixTile, (integer(refTime)+ixCount) mod length(WALL_ANIME_TABLE[ixTile])+1]) - integer('A') - ixCount;
		end;
	end;
end;

procedure TGameMain.m_SelectAction(key: char);
begin
	case UpCase(key) of
		'Q': // quick view
			m_OnSearch(ftLook);
		'W': // who
			m_OnSearch(ftTalk);
		'S': // search
			m_OnSearch(ftSearch);
		'A': // action
			if assigned(m_focus) then begin
				m_OnAction(m_focus.FocusType);
			end
			else begin
				m_OnAction(ftDisable);
			end;
		'Z': // use something
			begin
				if assigned(m_focus) then
					DestroyFocus(m_focus);
				m_ChangeEquipment(HiByte(GetAsyncKeyState(VK_SHIFT)) = 0);
			end;
		'X': // inventory
			begin
				//self.GameMode := gmInventory;
			end;
	end;
end;

procedure TGameMain.m_StartTalking(personId: integer);
begin
	assert(assigned(m_focus) and (m_focus.FocusType = ftTalk));

	// accept to talk from user
	(m_focus as CFocusTalk).IsAccepted := TRUE;

	// 최초 프롬프트를 위한 편법
	g_inputArea.WriteLn('');

	g_inputArea.InputQuery('');

	g_tileMap.TalkTo(personId, KEYWORD_GREETING);

end;

procedure TGameMain.m_EndTalking(personId: integer);
begin
	g_inputArea.InputQuery('');

	// end of talking
	(m_focus as CFocusTalk).IsAccepted := FALSE;

	DestroyFocus(m_focus);
end;

procedure TGameMain.m_OnOpen();
var
	xTemp, yTemp: integer;
	base: TPoint;
	dir : TVector;
begin
	base  := g_tileMap.GetPC.GetTilePos();
	dir   := g_tileMap.GetPC.GetFacedVector();

	if g_tileMap[base.x+dir.dx, base.y+dir.dy] = OBJ_CABINET then begin
	end;

	if g_tileMap[base.x+dir.dx, base.y+dir.dy] = OBJ_DOOR_LOCKED_CLOSE then begin
		if not g_inventory.Search(ITEM_KEY, base.x+dir.dx, base.y+dir.dy) then begin
			g_textArea.WriteLn('잠겨진 문이다. 열쇠가 필요하다');
			g_textArea.WriteLn('');
			exit;
		end;
	end;

	if g_tileMap[base.x+dir.dx, base.y+dir.dy] in SET_OBJ_DOOR then begin
		if g_tileMap.CheckOpenEvent(base.x+dir.dx, base.y+dir.dy) then begin
			g_tileMap[base.x+dir.dx, base.y+dir.dy] := g_tileMap[base.x+dir.dx, base.y+dir.dy] xor $01;

			// detect jamming a body in the door
			xTemp := (g_tileMap.GetPC.m_pos.x + (dir.dx * BLOCK_W_SIZE div 2 - dir.dx)) div BLOCK_W_SIZE;
			yTemp := (g_tileMap.GetPC.m_pos.y + (dir.dy * BLOCK_H_SIZE div 2 - dir.dy)) div BLOCK_H_SIZE;

			if g_tileMap[xTemp, yTemp] in SET_OBJ_DOOR then begin
				g_tileMap.GetPC.m_pos.x := base.x * BLOCK_W_SIZE + BLOCK_W_SIZE div 2;
				g_tileMap.GetPC.m_pos.y := base.y * BLOCK_H_SIZE + BLOCK_H_SIZE div 2;
			end;
		end;
	end;

end;

function TGameMain.m_OnSearch(focusType: TFocusType): boolean;
begin
	if assigned(m_focus) and (m_focus.FocusType = focusType) then begin
		m_focus.LookingMore();
	end
	else begin
		CreateFocus(focusType, m_focus);
	end;

	result := (m_focus.Looking() >= 0);
end;

procedure TGameMain.m_OnAction(focusType: TFocusType);

	function SearchTelevision(player: TPlayer; out posTV: TPoint): boolean;
	var
		i, j         : integer;
		base         : TPoint;
		dir          : TVector;
		xTemp, yTemp : integer;
		xObj,  yObj  : integer;
	begin
		result := FALSE;

		base := player.GetTilePos();
		dir  := player.GetFacedVector();
		for i := 1 to SHOW_TILE_W_RADIUS do begin
			for j := -i to i do begin
				xTemp := base.x + dir.dy * j + dir.dx * i;
				yTemp := base.y + dir.dy * i + dir.dx * j;
				if g_tileMap[xTemp, yTemp] = OBJ_TELEVISION then begin
					xObj := BLOCK_W_SIZE * xTemp + BLOCK_W_SIZE div 2;
					yObj := BLOCK_H_SIZE * yTemp + BLOCK_H_SIZE div 2;
					if IsMyEyesReached(player.m_pos.x, player.m_pos.y, xObj, yObj) then begin
						posTV  := Point(xTemp, yTemp);
						result := TRUE;
						exit;
					end;
				end;
			end;
		end;
	end;

var
	tile        : integer;
	pos         : TPoint;
	focusSearch : CFocusSearch;
	base        : TPoint;
	dir         : TVector;
begin
	case focusType of
		ftDisable:
		begin
			base := g_tileMap.GetPC.GetTilePos();
			dir  := g_tileMap.GetPC.GetFacedVector();

			if g_tileMap[base.x+dir.dx, base.y+dir.dy] = OBJ_CABINET then begin
				if g_tileMap.CheckActionEvent(base.x+dir.dx, base.y+dir.dy) then
					exit;
			end;

			case g_tileMap.GetPC.Equipment.itemId of
				ITEM_NONE, ITEM_KEY:
				begin
					if not g_tileMap.CheckActionEvent(base.x+dir.dx, base.y+dir.dy) then begin
						m_OnOpen();
					end;
				end;
				ITEM_TV_REMOCON:
				begin
					if SearchTelevision(g_tileMap.GetPC, pos) then begin
						// TV is found
						if g_tileMap.CheckActionEvent(pos.x, pos.y) then begin
						end;
					end
					else begin
						g_textArea.WriteLn('가까운 곳에 TV가 없다.');
						g_textArea.WriteLn();
					end;
				end;
				ITEM_REG_FORM_MT:
				begin
					g_textArea.Clear();
					g_textArea.WriteLn('등록 서류의 빈 곳을 채워 넣었다', tcMonolog);
					g_textArea.WriteLn();
					g_textArea.ReservedClear();

					g_inventory.Remove(ITEM_REG_FORM_MT);
					g_inventory.Add(ITEM_REG_FORM);
				end;
				ITEM_BOOK:
				begin
					m_readPage := 0;
					m_ReadBook(g_tileMap.GetPC.Equipment.aux1, m_readPage);
				end;
				ITEM_POSTER:
				begin
					m_ReadPoster(g_tileMap.GetPC.Equipment.aux1);
				end;
				ITEM_MEMO:
				begin
					m_ReadMemo(g_tileMap.GetPC.Equipment.aux1);
				end;
				else begin
					//?? 순수한 이벤트
					if not g_tileMap.CheckActionEvent(base.x+dir.dx, base.y+dir.dy) then begin
						m_OnOpen();
					end;
				end;
			end;

		end;
		ftLook:
		begin
			tile := g_tileMap[m_focus.lockedPos.x, m_focus.lockedPos.y];
			if tile in LOOKABLE_OBJECT_SET then begin
				if tile in LOOKABLE_OBJECT_NAME_SET then begin
					g_textArea.WriteLn(LOOKABLE_OBJECT_NAME[tile] + SmGetHangulO(LOOKABLE_OBJECT_NAME[tile]) + ' 좀 더 자세히 보았다.');
				end
				else begin
					g_textArea.WriteLn('좀 더 자세히 보았다.');
				end;
				g_textArea.WriteLn('');

				focusSearch := CFocusSearch.Create(m_focus.lockedPos);
				if focusSearch.FocusType = ftSearch then begin
					DestroyFocus(m_focus);
					m_focus := focusSearch;
				end
				else begin
					focusSearch.Free;
					g_textArea.WriteLn('하지만 자세히 보기에는 좀 멀었다');
					g_textArea.WriteLn('');
				end;

			end;
		end;
		ftSearch:
		begin
			if not (g_tileMap.CheckSearchEvent(m_focus.lockedPos.x, m_focus.lockedPos.y)) then begin
				g_textArea.WriteLn('찾아 보았지만 별로 눈에 띄는 것이 없다');
				g_textArea.WriteLn('');
			end;
		end;
		ftTalk:
			m_StartTalking(m_focus.Selected);
		ftEnemy:
		begin
		end;
	end;
end;

procedure TGameMain.m_ChangeEquipment(isDownward: boolean);
var
	i            : integer;
	strEquipment : array[0..pred(MAX_NUMOF_ITEM)] of widestring;
	cntEquipment : array[0..pred(MAX_NUMOF_ITEM)] of TInventoryItem;
	nEquipment   : integer;
	equipment    : TItem;
begin
	//?? 좀 더 간단하게 수정 필요
	equipment  := g_tileMap.GetPC.Equipment;
	nEquipment := g_inventory.GetItemName(strEquipment, cntEquipment);

	assert(nEquipment > 0);

	for i := 0 to pred(nEquipment) do begin
		if IsIdenticalItem(equipment, cntEquipment[i].entry) then begin
			if isDownward then begin
				if i < pred(nEquipment) then
					equipment := cntEquipment[i+1].entry
				else
					equipment := cntEquipment[0].entry;
			end
			else begin
				if i > 0 then
					equipment := cntEquipment[i-1].entry
				else
					equipment := cntEquipment[nEquipment-1].entry;
			end;

			break;
		end;
	end;

	g_tileMap.GetPC.Equipment := equipment;

	m_UpdateStatus();
end;

procedure TGameMain.m_UpdateStatus();
const
	MAX_TABLE = 7;
	STATUS_STRING: array[0..pred(MAX_TABLE)] of widestring =
	(
		'$',
		'[생명력]',
		'[체  력]',
		'[지  력]',
		'[손재주]',
		'[매  력]',
		'[행  운]'
	);
var
	i, j, add    : integer;
	strEquipment : array[0..pred(MAX_NUMOF_ITEM)] of widestring;
	cntEquipment : array[0..pred(MAX_NUMOF_ITEM)] of TInventoryItem;
	nEquipment   : integer;
	equipment    : TItem;
	pAbility     : ^TPlayerAbility;
	s            : string;
begin
	equipment  := g_tileMap.GetPC.Equipment;
	nEquipment := g_inventory.GetItemName(strEquipment, cntEquipment);
	pAbility   := @g_tileMap.GetPC.m_ability;

	assert(nEquipment > 0);

	if equipment.itemId > 0 then begin
		if not g_inventory.Search(equipment) then begin
			equipment.itemId := 0;
			equipment.aux1   := 0;
			equipment.aux2   := 0;
			g_tileMap.GetPC.Equipment := equipment;
		end;
	end;

	j := -1;
	for i := 0 to pred(nEquipment) do begin
		if IsIdenticalItem(equipment, cntEquipment[i].entry) then begin
			j := i;
			break;
		end;
	end;

	add := j + 2 - MAX_TABLE;
	if add < 0 then
		add := 0;

	g_statusArea.Clear();
	g_statusArea.Write(': ' + g_tileMap.GetPC.m_name);

	if add > 0 then begin
		g_statusArea.LocateX := 20;
		g_statusArea.Write('-more-');
	end;

	g_statusArea.WriteLn();

	for i := 0 to pred(MAX_TABLE) do begin
		case i of
			0: str(g_tileMap.GetPC.m_param.GOLD, s);
			1: str(g_tileMap.GetPC.m_param.HP:3, s);
			2: str(pAbility.STR:3, s);
			3: str(pAbility.INT:3, s);
			4: str(pAbility.DEX:3, s);
			5: str(pAbility.CHA:3, s);
			6: str(pAbility.LUC:3, s);
			else s := '';
		end;

		g_statusArea.Write(STATUS_STRING[i] + ' ' + s);

		if (i+add < nEquipment) and (i < pred(MAX_TABLE)) then begin
			if j = i+add then begin
				g_statusArea.LocateX := 18;
				g_statusArea.Write(widechar(31));
				g_statusArea.LocateX := 20;
				g_statusArea.IsReversed := TRUE;
				g_statusArea.WriteLn(strEquipment[i+add]);
				g_statusArea.IsReversed := FALSE;
			end
			else begin
				g_statusArea.LocateX := 20;
				g_statusArea.WriteLn(strEquipment[i+add]);
			end;
		end
		else begin
			if (i = pred(MAX_TABLE)) and (i + add < nEquipment) then begin
				g_statusArea.LocateX := 20;
				g_statusArea.Write('-more-');
			end;
			g_statusArea.WriteLn('');
		end;
	end;

end;

procedure TGameMain.m_ReadMemo(memo: longword);
var
	pwString: Pwidestring;
	s: widestring;
	openedMemo: TItemMemo;
begin
	openedMemo := TItemMemoCreator(memo);

	if assigned(openedMemo) then begin
		g_textArea.Clear();
		openedMemo.Reset();
		while (openedMemo.GetString(pwString)) do begin
			if (Length(pwString^) > 0) and (pwString^[1] = '@') then begin
				s := Copy(pwString^, 2, 60000);
				g_textArea.WriteLn(s, tcHelp);
			end
			else begin
				g_textArea.WriteLn(pwString^);
			end;
		end;
		g_textArea.ReservedClear();
	end;
end;

procedure TGameMain.m_ReadPoster(poster: longword);
var
	image: integer;
begin
	case poster of
		ITEM_POSTER_JR:
		begin
{$IFDEF _LOAD_FROM_FILE}
			image := LoadD3DJpeg(g_d3Device, './JumpRevolution.jpg');
{$ELSE}
			image := LoadD3DJpegFromMemory(g_d3Device, @pResJumpRevolution, sizeof(pResJumpRevolution));
{$ENDIF}
			if image > 0 then begin
				g_textArea.Clear();
				g_textArea.WriteLn();
				g_textArea.DrawImage(8, 3, image, 0, 0, 384, 475);
				g_textArea.DrawText(16, 416+26, '이 게임은 한게임에서 서비스하고 있는', $FF000000);
				g_textArea.DrawText(10+16*8+8, 416+42, '{점프 레볼루션}이라는 게임이다', $FF000000);
				g_textArea.ReservedClear();
				g_d3Device.DestroyImage(image);
			end
			else begin
				g_textArea.Clear();
				g_textArea.WriteLn('포스트를 펼쳐 보려 했지만 손상되어져서 더 이상 볼 수가 없다.');
				g_textArea.ReservedClear();
			end;
		end;
	end;
end;

procedure TGameMain.m_ReadBook(book: longword; var page: integer);
var
	s1, s2: widestring;
	pwString: Pwidestring;
	openedBook: TItemBook;
begin
	openedBook := TItemBookCreator(book);

	if assigned(openedBook) then begin
		case openedBook.BookType of
			btBook:
			begin
				m_currBook := book;
				self.GameMode := gmReadBook;

				openedBook.Page := m_readPage;
				m_readPage := openedBook.Page;

				str(openedBook.Page, s1);
				str(openedBook.MaxPage, s2);
				g_textArea.Clear();
				g_textArea.WriteLn(openedBook.Name + ' (#' + s1 + '/' + s2 + ')', tcEvent);
				g_textArea.WriteLn();

				openedBook.Reset();
				while (openedBook.GetString(pwString)) do begin
					g_textArea.WriteLn(pwString^);
				end;

				g_textArea.DrawText(0, 470 - 16, 'PageUp/Down 페이지 넘기기         Esc 그만보기', g_textColor[tcHelp]);
				g_textArea.ReservedClear();
			end;
			btMemo:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn(openedBook.Name, tcEvent);
				g_textArea.WriteLn();

				openedBook.Reset();
				while (openedBook.GetString(pwString)) do begin
					g_textArea.WriteLn(pwString^);
				end;
			end;
		end;
	end;

	openedBook.Free();
end;

procedure TGameMain.m_ClearScreen(method: integer);
var
	i, j: integer;
	x1, y1, x2, y2: integer;
	x, y, w, h: integer;
begin
	g_d3Device.SetBlendingMode(bmNormal);
	g_d3Device.SetClip(WORLD_MAP_XPOS, WORLD_MAP_YPOS, WORLD_MAP_WIDTH, WORLD_MAP_HEIGHT);

	w  := WORLD_MAP_WIDTH;
	h  := WORLD_MAP_HEIGHT;

	x1 := WORLD_MAP_XPOS;
	y1 := WORLD_MAP_YPOS;
	x2 := x1 + w;
	y2 := y1 + h;

	for i := 0 to w div 8 do begin
		for j := 1 to 2 do begin
		g_d3Device.BeginScene();

		x := x1 + i*8 + 4;
		g_d3Device.FillRect($FF000000, x, y1, 4, h);

		x := x1 + w - i*8 - 1;
		g_d3Device.FillRect($FF000000, x-3, y1, 4, h);

		g_d3Device.EndScene();
		g_d3Device.Flush();
		end;
	end;

end;

procedure TGameMain.m_NewGame();
begin
	g_inventory.Free();
	g_tileMap.Free();
	ClearEventFlag();

	g_tileMap   := TTileMap.Create('my_apart');
	g_inventory := TInventory.Create();
end;

procedure TGameMain.m_LoadGame();
var
	inFile  : TSmReadFileStream;
begin
	inFile := TSmReadFileStream.Create(GetWindowsTempPath() + 'tempsav02.data');
	if inFile.IsAvailable then begin
		g_tileMap.LoadData(inFile);
		inFile.Free;

		g_inventory.IsModified := TRUE;
		m_ResetGameTick();
		m_UpdateStatus();
	end;
end;

procedure TGameMain.m_SaveGame();
var
	outFile : TSmWriteFileStream;
begin
	outFile := TSmWriteFileStream.Create(GetWindowsTempPath() + 'tempsav02.data');
	if outFile.IsAvailable then begin
		g_tileMap.SaveData(outFile);
		outFile.Free;
	end;
end;

procedure TGameMain.m_UpdateGameTick();
begin
	g_tileMap.CheckTimeEvent(g_refTick);

	inc(g_refTick);
	if (g_refTick mod 20) = 0 then
		inc(g_refAnime);
end;

procedure TGameMain.m_ProcAction();
var
	i, j: integer;
	iTemp: integer;
begin
	g_baseXPos := g_tileMap.GetPC.m_pos.x;
	g_baseYPos := g_tileMap.GetPC.m_pos.y;

	m_xMap := g_baseXPos div BLOCK_W_SIZE;
	m_yMap := g_baseYPos div BLOCK_H_SIZE;

	m_xMapOffset := g_baseXPos - m_xMap * BLOCK_W_SIZE;
	m_yMapOffset := g_baseYPos - m_yMap * BLOCK_H_SIZE;

	dec(m_xMap, SHOW_TILE_W_RADIUS);
	dec(m_yMap, SHOW_TILE_H_RADIUS);

	for i := 0 to pred(MAX_PLAYER) do begin
		if assigned(g_tileMap.GetPlayer(i)) then begin
			g_tileMap.GetPlayer(i).DoAction(m_TickCount);
		end;
	end;

	g_tileMap.ArrangePlayer();

	// object sort
	begin
		m_maxSort := 0;

		for i := 0 to pred(MAX_PLAYER) do begin
			if assigned(g_tileMap.GetPlayer(i)) then begin
				if (abs(g_tileMap.GetPlayer(i).m_pos.x - g_baseXPos) < WORLD_MAP_HALF_WIDTH)
				   and (abs(g_tileMap.GetPlayer(i).m_pos.y - g_baseYPos) < WORLD_MAP_HALF_HEIGHT) then begin
					m_ySort[m_maxSort] := i;
					inc(m_maxSort);
			   end;
			end;
		end;

		for i := 0 to (m_maxSort-2) do begin
			for j := i+1 to (m_maxSort-1) do begin
				if g_tileMap.GetPlayer(m_ySort[i]).m_pos.y > g_tileMap.GetPlayer(m_ySort[j]).m_pos.y then begin
					iTemp      := m_ySort[i];
					m_ySort[i] := m_ySort[j];
					m_ySort[j] := iTemp;
				end;
			end;
		end;
	end;

	inc(m_TickCount);
end;

procedure TGameMain.m_ProcDisplay();
const
	DIR_ADD_TABLE: array[0..7] of integer = (0, 1, 1, 1, 0, -1, -1, -1);
var
	i, j, tile: integer;
	x, y: integer;
	xBase, yBase, x1Target, y1Target: integer;
	vertices: array[0..3] of TfPoint;
	alphaMask: longword;
	colorMask: longword;
	shadowMap: array[0..SHOW_TILE_WIDTH, 0..SHOW_TILE_HEIGHT] of byte;

	function GetMap(x, y: integer): boolean;
	begin
		if (x in [0..SHOW_TILE_WIDTH]) and (y in [0..SHOW_TILE_HEIGHT]) then
			result := g_tileMap.Istransmitable(m_xMap+x, m_yMap+y)
		else
			result := FALSE
	end;

	function SetMap(x, y: integer): boolean;
	begin
		if (x in [0..SHOW_TILE_WIDTH]) and (y in [0..SHOW_TILE_HEIGHT]) and (shadowMap[x, y] = 0) then begin
			shadowMap[x, y] := 1;
			result := GetMap(x, y);
		end else begin
			result := FALSE;
		end;
	end;

	procedure ProcessMap(x, y: integer);
	begin
		if not SetMap(x, y) then
			exit;

		ProcessMap(x+0, y-1);
		ProcessMap(x+1, y-1);
		ProcessMap(x+1, y+0);
		ProcessMap(x+1, y+1);
		ProcessMap(x+0, y+1);
		ProcessMap(x-1, y+1);
		ProcessMap(x-1, y+0);
		ProcessMap(x-1, y-1);
	end;
begin
	fillchar(shadowMap, sizeof(shadowMap), $00);

	ProcessMap(SHOW_TILE_W_RADIUS, SHOW_TILE_H_RADIUS);
	if GetMap(SHOW_TILE_W_RADIUS, SHOW_TILE_H_RADIUS) then begin
		for i := 0 to 7 do
			ProcessMap(SHOW_TILE_W_RADIUS+DIR_ADD_TABLE[i], SHOW_TILE_H_RADIUS+DIR_ADD_TABLE[(i+6) mod 8]);
	end;

	alphaMask := $FF;
	colorMask := g_colorMask;

	g_d3Device.SetBlendingMode(bmAlpha);

	// gfx begin
	g_d3Device.Clear($FF000000);

	g_d3Device.SetClip(WORLD_MAP_XPOS, WORLD_MAP_YPOS, WORLD_MAP_WIDTH, WORLD_MAP_HEIGHT);

	g_d3Device.BeginScene();

	// floor
	for j := 0 to SHOW_TILE_HEIGHT do begin
		xBase := WORLD_MAP_XPOS + (-1 * BLOCK_W_SIZE - m_xMapOffset);
		yBase := WORLD_MAP_YPOS + ( j * BLOCK_H_SIZE - m_yMapOffset);
		for i := 0 to SHOW_TILE_WIDTH do begin
			inc(xBase, BLOCK_W_SIZE);

			if shadowMap[i, j] = 0 then
				continue;

			if g_tileMap.IsWall(m_xMap+i, m_yMap+j) then
				continue;

			tile := g_tileMap[m_xMap+i, m_yMap+j];

			if tile > OBJ_MOVEABLE_BASE then begin
				m_ApplyTileAnime(g_refAnime, tile);
			end;

			x := (tile mod BLOCK_W_PITCH) * BLOCK_W_GAP;
			y := (tile div BLOCK_W_PITCH) * BLOCK_H_GAP;

			g_d3Device.DrawImageEx(xBase, yBase, g_hTexture, x, y, BLOCK_W_SIZE, BLOCK_H_SIZE, alphaMask, colorMask);

			if g_enableCheat and (CHEAT_DISPALY_EVENT in g_cheatList) then begin
				if g_tileMap.Event[m_xMap+i, m_yMap+j].value > 0 then
					g_d3Device.FillRect($80FF0000, xBase, yBase, BLOCK_W_SIZE, BLOCK_H_SIZE);
			end;
		end;
	end;

	// shadow
	xBase := WORLD_MAP_XPOS + (SHOW_TILE_W_RADIUS * BLOCK_W_SIZE);
	yBase := WORLD_MAP_YPOS + (SHOW_TILE_H_RADIUS * BLOCK_H_SIZE);

	for j := 0 to SHOW_TILE_HEIGHT do begin
		for i := 0 to SHOW_TILE_WIDTH do begin
			if shadowMap[i, j] = 0 then
				continue;

			if g_tileMap.Istransmitable(m_xMap+i, m_yMap+j) then
				continue;

			x1Target := WORLD_MAP_XPOS + (i * BLOCK_W_SIZE - m_xMapOffset);
			y1Target := WORLD_MAP_YPOS + (j * BLOCK_H_SIZE - m_yMapOffset);

			MakeShadow(xBase, yBase, x1Target, y1Target, x1Target + BLOCK_W_SIZE, y1Target + BLOCK_H_SIZE, vertices);

			g_d3Device.DrawPolygon($FF000000, vertices, 4);
		end;
	end;

	// wall bottom
	for j := 0 to SHOW_TILE_HEIGHT do begin
		xBase := WORLD_MAP_XPOS + (-1 * BLOCK_W_SIZE - m_xMapOffset);
		yBase := WORLD_MAP_YPOS + ( j * BLOCK_H_SIZE - m_yMapOffset);
		for i := 0 to SHOW_TILE_WIDTH do begin
			inc(xBase, BLOCK_W_SIZE);

			if shadowMap[i, j] = 0 then
				continue;

			if not g_tileMap.IsWall(m_xMap+i, m_yMap+j) then
				continue;

			tile := g_tileMap[m_xMap+i, m_yMap+j];

			if tile in [WALL_MOVEABLE_BASE..WALL_MOVEABLE_END] then begin
				m_ApplyTileAnime(g_refAnime, tile);
			end;

			x    := (tile mod BLOCK_W_PITCH) * BLOCK_W_GAP;
			y    := (tile div BLOCK_W_PITCH) * BLOCK_H_GAP;

			g_d3Device.DrawImageEx(xBase, yBase, g_hTexture, x, y, BLOCK_W_SIZE, BLOCK_H_SIZE, alphaMask, colorMask);
		end;
	end;

	if g_enableCheat and (CHEAT_FITTED_TILE in g_cheatList) then begin
		// display the fitted tile position of a character
		x1Target := WORLD_MAP_XPOS + (SHOW_TILE_W_RADIUS * BLOCK_W_SIZE - m_xMapOffset);
		y1Target := WORLD_MAP_YPOS + (SHOW_TILE_H_RADIUS * BLOCK_H_SIZE - m_yMapOffset);
		g_d3Device.FillRect($40FF0000, x1Target, y1Target, BLOCK_W_SIZE, BLOCK_H_SIZE);
	end;

	// player
	for i := 0 to pred(m_maxSort) do begin
		g_tileMap.GetPlayer(m_ySort[i]).Display();
	end;

	// display the focused tile
	if assigned(m_focus) then begin
		case m_focus.FocusType of
			ftLook, ftSearch:
			begin
				x1Target := WORLD_MAP_XPOS - m_xMapOffset + (m_focus.lockedPos.x - m_xMap) * BLOCK_W_SIZE;
				y1Target := WORLD_MAP_YPOS - m_yMapOffset + (m_focus.lockedPos.y - m_yMap) * BLOCK_H_SIZE;
			end;
			ftTalk:
			begin
				g_tileMap.GetPlayer(m_focus.Selected).GetDisplayAxis(x1Target, y1Target);
			end;
			ftEnemy:
			begin
				g_tileMap.GetPlayer(m_focus.Selected).GetDisplayAxis(x1Target, y1Target);
			end;
		end;

		case m_focus.FocusType of
			ftLook:
				g_d3Device.FillRect(g_focusColor[ftLook], x1Target, y1Target, BLOCK_W_SIZE, BLOCK_H_SIZE);
			ftSearch:
				g_d3Device.FillRect(g_focusColor[ftSearch], x1Target, y1Target, BLOCK_W_SIZE, BLOCK_H_SIZE);
			ftTalk:
				g_d3Device.FillRect(g_focusColor[ftTalk], x1Target, y1Target, BLOCK_W_SIZE, BLOCK_H_SIZE);
		end;
	end;

	g_d3Device.SetClip(0, 0, m_screenInfo.width, m_screenInfo.height);

	// 인풋 토글
	if assigned(m_focus) and (m_focus.FocusType = ftTalk) and ((m_focus as CFocusTalk).IsAccepted) then begin
		if (g_refTick mod 20) = 0 then
			g_inputArea.ToggleCaret();
	end;

	// I/O 관련 업데이트
	g_textArea.Flush();
	g_inputArea.Flush();
	g_statusArea.Flush();

	if g_inventory.IsModified then begin
		m_UpdateStatus();
		g_inventory.IsModified := FALSE;
	end;

	if g_enableCheat and (CHEAT_MAP_EDITOR in g_cheatList) then begin
		// map editor mode
		g_mapCursor.x := (g_gameCursor.x - WORLD_MAP_XPOS - m_xMapOffset) div BLOCK_W_SIZE;
		g_mapCursor.y := (g_gameCursor.y - WORLD_MAP_YPOS - m_yMapOffset) div BLOCK_H_SIZE;

		g_mapCursor.x := (g_gameCursor.x + m_xMapOffset - WORLD_MAP_XPOS) div BLOCK_W_SIZE + m_xMap;
		g_mapCursor.y := (g_gameCursor.y + m_yMapOffset - WORLD_MAP_YPOS) div BLOCK_H_SIZE + m_yMap;

		x1Target := WORLD_MAP_XPOS - m_xMapOffset + (g_mapCursor.x - m_xMap) * BLOCK_W_SIZE;
		y1Target := WORLD_MAP_YPOS - m_yMapOffset + (g_mapCursor.y - m_yMap) * BLOCK_H_SIZE;

		g_d3Device.FillRect($80FFFF00, x1Target, y1Target, BLOCK_W_SIZE, BLOCK_H_SIZE);

		if LoByte(GetAsyncKeyState(VK_LBUTTON)) > 0 then begin
			g_tileMap[g_mapCursor.x, g_mapCursor.y] := 1;
		end;
	end;

	if g_enableCheat and (CHEAT_DISPLAY_FPS in g_cheatList) then begin
		// display FPS on the frame buffer
		Debug_DisplayFPS();
		Debug_DisplayAxis();
	end;

	g_d3Device.EndScene();
	g_d3Device.Flush();
end;

procedure TGameMain.m_ProcDisplayInventory();
var
	i, j, add    : integer;
	strEquipment : array[0..pred(MAX_NUMOF_ITEM)] of widestring;
	cntEquipment : array[0..pred(MAX_NUMOF_ITEM)] of TInventoryItem;
	nEquipment   : integer;
	equipment    : TItem;
	s            : string;
begin
	g_d3Device.Clear($FF000000);

	g_d3Device.SetClip(0, 0, m_screenInfo.width, m_screenInfo.height);

	g_d3Device.BeginScene();

	g_d3Device.FillRect($FFFFFFFF, 400, 0, 10, 600);
	g_d3Device.FillRect($FFFFFFFF, 0, 200, 800, 10);

	equipment  := g_tileMap.GetPC.Equipment;
	nEquipment := g_inventory.GetItemName(strEquipment, cntEquipment);

	assert(nEquipment > 0);

	for i := 0 to pred(nEquipment) do begin
		SmDrawText(420, 220 + i*16, strEquipment[i], $FFFFFFFF, $FFFF0000, DxBitBlt);


	end;

	g_d3Device.EndScene();
	g_d3Device.Flush();
end;

procedure TGameMain.Run();
const
	isFirst: boolean = TRUE;
begin
	if isFirst then begin
{$IFDEF _DEBUG}
		g_tileMap.GetPC.m_name := '슴갈';
		g_inventory.Add(ITEM_TV_REMOCON, ITEM_TV_REMOCON);
		g_inventory.Add(ITEM_WISKEY);
		g_inventory.Add(ITEM_MEMO, ITEM_MEMO_PROCRETE);
		g_inventory.Add(ITEM_BOOK, ITEM_BOOK_DERIKUS);
		g_inventory.Add(ITEM_BOOK, ITEM_BOOK_ALBIREO);
{$ENDIF}
		SendCommand(GAME_COMMAND_SHOW_MEMO, ITEM_MEMO_START_MESSAGE);

		isFirst := FALSE;
	end;

	case self.GameMode of
		gmGame:
		begin
			m_ProcAction();
			if g_enableDisplay then
				m_ProcDisplay();
		end;
		gmInventory:
		begin
			m_ProcAction();
			if g_enableDisplay then
				m_ProcDisplayInventory();
		end;
		gmReadBook, gmPressAnyKey:
		begin
			if g_enableDisplay then
				m_ProcDisplay();
		end;
	end;

	m_UpdateGameTick();

{
	if not QAZ then begin
		else if question = '영원한생' then begin
G_TEXT(0,'그것 참 어려운 질문이군. 여기에서는 육체가 존재하지 않기 때문에 죽음의 시점이라는 것을 정확하게 알 수 있는 것은 아니네.' +
'자네는 야광 물체를 본 적이 있나? 야광 물체는 처음에는 빛을 머금고 있기 때문에 어두운 곳에서도 환한 빛을 내지.' +
'하지만 시간이 지나면 어떤가. 점점 자신이 가진 에너지를 소비하다가 결국은 희미해지고말지. 우리도 마찬가지야.' +
'점점 시간이 지나면 그 존재가 희미해져 가는거야. 영원히 사라지는 것은 아니지만 영원히 희미해지지.' +
'아무도 그 존재를 깨닭지 못할 정도로.' +
'자신의 존재가 희미해지면 주위의 세계도 같이 희미해져 보이나봐. 주위를 인지하기 위한 힘마저도 쇠퇴해버린 것이거든.' +
'결국은 존재하되 존재하지 않는 것이 되어버리겠지. 자신의 존재가 희미해졌다는 것마저도 알아차릴 힘이 없을 정도로 희미하게.');
		end
//
//
	end;

				g_statusArea.Clear();
				g_statusArea.WriteLn('No name');
				g_statusArea.WriteLn('[HP] 120/120   [Equipment] fist');
				g_statusArea.WriteLn('[SP]   0/ 40   [Equipment] fist');
				g_statusArea.WriteLn('[STR] 25       [Accessory] Hand-held phone');
				g_statusArea.WriteLn('[INT] 15       [Accessory] none');
				g_statusArea.WriteLn('[AGL] 16');
				g_statusArea.WriteLn('[LCK] 30');
}
end;

end.

