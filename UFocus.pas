unit UFocus;

interface

uses
	Windows,
	UPlayer, UResString, UType, UConfig;

type
	CFocus = class
	protected
		t_type: TFocusType;
		t_selected: integer;
		t_lockedPos: TPoint;

	public
		constructor Create();
		procedure Free();

		function  Looking(): integer; virtual; abstract;
		function  LookingMore(): integer; virtual; abstract;

		property  FocusType: TFocusType read t_type;
		property  Selected : integer read t_selected;
		property  LockedPos: TPoint read t_lockedPos;
	end;

////////////////////////////////////////////////////////////////////////////////
const
	MAX_LOOK_VECTOR_TABLE = 6;
	LOOK_VECTOR_TABLE: array[0..pred(MAX_LOOK_VECTOR_TABLE)] of TVector =
	(
		(dx: 0; dy: 1),
		(dx: 0; dy: 2),
		(dx: 1; dy: 1),
		(dx: 1; dy: 2),
		(dx: 2; dy: 2),
		(dx: 2; dy: 1)
	);

type
	CFocusLook = class(CFocus)
	private
		function m_GetDirId(): integer;

	public
		constructor Create();
		procedure   Free();

		function  Looking(): integer; override;
		function  LookingMore(): integer; override;
	end;

////////////////////////////////////////////////////////////////////////////////
const
	MAX_SEARCH_VECTOR_TABLE = 2;
	SEARCH_VECTOR_TABLE: array[0..pred(MAX_SEARCH_VECTOR_TABLE)] of TVector =
	(
		(dx: 0; dy: 1),
		(dx: 1; dy: 1)
	);

type
	CFocusSearch = class(CFocus)
	private
		function m_GetDirId(): integer;

	public
		constructor Create(); overload;
		constructor Create(lockedPos: TPoint); overload;
		procedure Free();

		function  Looking(): integer; override;
		function  LookingMore(): integer; override;
	end;

////////////////////////////////////////////////////////////////////////////////
const
	MAX_PERSON_LIST = 50;

type
	CFocusTalk = class(CFocus)
	private
		m_isAccepted: boolean;
		m_currPersobList: integer;
		m_maxPersonList: integer;
		m_personList: array[0..pred(MAX_PERSON_LIST)] of integer;

		procedure m_SearchPerson();

	public
		constructor Create();
		procedure Free();

		function  Looking(): integer; override;
		function  LookingMore(): integer; override;
		property  IsAccepted: boolean read m_isAccepted write m_isAccepted;
	end;

////////////////////////////////////////////////////////////////////////////////
type
	CFocusEnemy = class(CFocus)
	private

	public
		constructor Create();
		procedure Free();

		function  Looking(): integer; override;
		function  LookingMore(): integer; override;
	end;

function  CreateFocus(focusType: TFocusType; var focus: CFocus): boolean;
procedure DestroyFocus(var focus: CFocus);

implementation

uses
	UGameMain;

constructor CFocus.Create();
begin
	t_type        := ftDisable;
	t_selected    := 0;
	t_lockedPos.x := 0;
	t_lockedPos.y := 0;
end;

procedure   CFocus.Free();
begin
	t_type := ftDisable;
end;

////////////////////////////

constructor CFocusLook.Create();
begin
	inherited;
	t_type := ftLook;
end;

procedure   CFocusLook.Free();
begin
	inherited;
end;

function CFocusLook.m_GetDirId(): integer;
begin
	result := (ord(g_tileMap.GetPC.m_face_dir) - ord(fdDown)) * MAX_LOOK_VECTOR_TABLE + t_selected;
end;

function CFocusLook.Looking(): integer;
var
	prevSelected     : integer;
	selectedVector   : TVector;
	xOrigin, yOrigin : integer;
	xMap, yMap, tile : integer;
	xObject, yObject : integer;
begin
	prevSelected := m_GetDirId();
	xOrigin := g_tileMap.GetPC.m_pos.x div BLOCK_W_SIZE;
	yOrigin := g_tileMap.GetPC.m_pos.y div BLOCK_H_SIZE;

	// look for a interested one
	repeat
		selectedVector := g_tileMap.GetPC.ConvertFacedVector(LOOK_VECTOR_TABLE[t_selected]);

		xMap := xOrigin + selectedVector.dx;
		yMap := yOrigin + selectedVector.dy;
		tile := g_tileMap[xMap, yMap];

		if (tile in LOOKABLE_OBJECT_SET) then begin
			xObject := BLOCK_W_SIZE * (xOrigin + selectedVector.dx) + BLOCK_W_SIZE div 2;
			yObject := BLOCK_H_SIZE * (yOrigin + selectedVector.dy) + BLOCK_H_SIZE div 2;

//			if IsMyEyesReached(g_tileMap.GetPC.m_pos.x, g_tileMap.GetPC.m_pos.y, xObject, yObject) then begin
			if IsSeen(g_tileMap.GetPC.m_pos.x, g_tileMap.GetPC.m_pos.y, xObject, yObject) then begin
				t_lockedPos.x := xMap;
				t_lockedPos.y := yMap;
				result        := t_selected;

				if not g_tileMap.QueryReadingEvent(t_lockedPos.x, t_lockedPos.y) then begin
					if tile in LOOKABLE_OBJECT_NAME_SET then begin
						g_textArea.RandomWriteLn(RES_DESCRIPT_OBJECT_NAME, LOOKABLE_OBJECT_NAME[tile]);
//						g_textArea.WriteLn('이것은 ' + LOOKABLE_OBJECT_NAME[tile]);
						g_textArea.WriteLn('');
					end
					else begin
						// 문의 글자 읽기
					end;
				end;

				exit;
			end;
		end;
	until (self.LookingMore() = prevSelected);

	if m_GetDirId() <> prevSelected then begin
		result := t_selected;
	end
	else begin
		// cannot find anything
		g_textArea.RandomWriteLn(RES_OBJECT_NOT_FOUND);
		g_textArea.WriteLn('');

		t_type := ftDisable;
		result := -1;
	end;
end;

function CFocusLook.LookingMore(): integer;
begin
	inc(t_selected);
	if selected >= MAX_LOOK_VECTOR_TABLE then begin
		g_tileMap.GetPC.TurnFace(fdCCW);
		t_selected := 0;
	end;
	result := m_GetDirId();
end;

////////////////////////////

constructor CFocusSearch.Create();
begin
	inherited;
	t_type := ftSearch;
end;

constructor CFocusSearch.Create(lockedPos: TPoint);
var
	i: integer;
	selectedVector  : TVector;
	xOrigin, yOrigin: integer;
	xMap, yMap, tile: integer;
begin
	Create();

	xOrigin := g_tileMap.GetPC.m_pos.x div BLOCK_W_SIZE;
	yOrigin := g_tileMap.GetPC.m_pos.y div BLOCK_H_SIZE;

	// 지정한 위치에서부터 search를 시작한다.
	for i := 0 to pred(MAX_SEARCH_VECTOR_TABLE) do begin
		selectedVector := g_tileMap.GetPC.ConvertFacedVector(SEARCH_VECTOR_TABLE[i]);

		xMap := xOrigin + selectedVector.dx;
		yMap := yOrigin + selectedVector.dy;

		if (lockedPos.x = xMap) and (lockedPos.y = yMap) then begin
			tile := g_tileMap[xMap, yMap];

			if (tile in LOOKABLE_OBJECT_SET) then begin
				t_lockedPos := lockedPos;
				t_selected  := i;

				if not g_tileMap.QuerySearchEvent(lockedPos.x, lockedPos.y) then begin
					g_textArea.WriteLn('특별히 눈에 띄는 것이 없다');
					g_textArea.WriteLn('');
				end;

				exit;
			end;
		end;
	end;

	// 찾지 못했을 때는 disable 상태가 된다.
	t_type := ftDisable;
end;

procedure   CFocusSearch.Free();
begin
	inherited;
end;

function CFocusSearch.m_GetDirId(): integer;
begin
	result := (ord(g_tileMap.GetPC.m_face_dir) - ord(fdDown)) * MAX_SEARCH_VECTOR_TABLE + t_selected;
end;

function CFocusSearch.Looking(): integer;
var
	prevSelected     : integer;
	selectedVector   : TVector;
	xOrigin, yOrigin : integer;
	xMap, yMap, tile : integer;
begin
	prevSelected := m_GetDirId();
	xOrigin := g_tileMap.GetPC.m_pos.x div BLOCK_W_SIZE;
	yOrigin := g_tileMap.GetPC.m_pos.y div BLOCK_H_SIZE;

	// look for a interested one
	repeat
		selectedVector := g_tileMap.GetPC.ConvertFacedVector(SEARCH_VECTOR_TABLE[t_selected]);

		xMap := xOrigin + selectedVector.dx;
		yMap := yOrigin + selectedVector.dy;
		tile := g_tileMap[xMap, yMap];

		if (tile in LOOKABLE_OBJECT_SET) then begin
			t_lockedPos.x := xMap;
			t_lockedPos.y := yMap;
			result        := t_selected;

			if not g_tileMap.QuerySearchEvent(lockedPos.x, lockedPos.y) then begin
				g_textArea.RandomWriteLn(RES_OBJECT_NOT_INTERESTED);
				g_textArea.WriteLn('');
			end;

			exit;
		end;
	until (self.LookingMore() = prevSelected);

	if m_GetDirId() <> prevSelected then begin
		result := t_selected;
	end
	else begin
		// cannot find anything
		g_textArea.RandomWriteLn(RES_OBJECT_NOT_FOUND);
		g_textArea.WriteLn('');

		t_type := ftDisable;
		result := -1;
	end;
end;

function CFocusSearch.LookingMore(): integer;
begin
	inc(t_selected);
	if t_selected >= MAX_SEARCH_VECTOR_TABLE then begin
		g_tileMap.GetPC.TurnFace(fdCCW);
		t_selected := 0;
	end;
	result := m_GetDirId();
end;

////////////////////////////////

procedure CFocusTalk.m_SearchPerson();
var
	arrDistance: array[0..pred(MAX_PERSON_LIST)] of integer;
	i, j, k, diff: integer;
	xOrigin, yOrigin: integer;
begin
	xOrigin := g_tileMap.GetPC.m_pos.x;
	yOrigin := g_tileMap.GetPC.m_pos.y;

	m_maxPersonList := 0;

	for i := 1 to pred(MAX_PLAYER) do begin
		if not assigned(g_tileMap.GetPlayer(i)) then
			continue;

		diff := sqr(xOrigin - g_tileMap.GetPlayer(i).m_pos.x) + sqr(yOrigin - g_tileMap.GetPlayer(i).m_pos.y);
		if diff < sqr(BLOCK_W_SIZE*3) then begin
			if IsSeen(xOrigin, yOrigin, g_tileMap.GetPlayer(i).m_pos.x, g_tileMap.GetPlayer(i).m_pos.y) then begin
				m_personList[m_maxPersonList] := i;
				arrDistance[m_maxPersonList] := diff;
				inc(m_maxPersonList);
			end;
		end;
	end;

	for j := 0 to m_maxPersonList - 2 do begin
		for i := j+1 to m_maxPersonList - 1 do begin
			if arrDistance[i] < arrDistance[j] then begin
				k               := arrDistance[i];
				arrDistance[i]  := arrDistance[j];
				arrDistance[j]  := k;

				k               := m_personList[i];
				m_personList[i] := m_personList[j];
				m_personList[j] := k;
			end;
		end;
	end;

	m_currPersobList := 0;
end;

constructor CFocusTalk.Create();
begin
	inherited;
	t_type := ftTalk;
	m_isAccepted := FALSE;

	m_SearchPerson();
end;

procedure   CFocusTalk.Free();
begin
	inherited;
end;

function CFocusTalk.Looking(): integer;
var
	name: widestring;
begin
	if m_maxPersonList > 0 then begin
		t_selected := m_personList[m_currPersobList];

		if g_tileMap.QueryNameOfPerson(t_selected, name) then
			g_textArea.WriteLn('이 사람은 ' + name + '.')
		else
			g_textArea.WriteLn('내가 잘 모르는 사람이다.');
		g_textArea.WriteLn('');

		result     := t_selected;
	end
	else begin
		// cannot find anyone
		g_textArea.RandomWriteLn(RES_PERSON_NOT_FOUND);
		g_textArea.WriteLn('');

		t_type := ftDisable;
		result := -1;
	end;
end;

function CFocusTalk.LookingMore(): integer;
begin
	if m_maxPersonList > 0 then begin
		inc(m_currPersobList);
		if m_currPersobList >= m_maxPersonList then
			m_SearchPerson();

		g_tileMap.GetPC.TurnFace(fdCCW);

		result := 0;
	end
	else begin
		result := -1;
	end;
end;

////////////////////////////////

constructor CFocusEnemy.Create();
begin
	inherited;
	t_type := ftEnemy;
end;

procedure   CFocusEnemy.Free();
begin
	inherited;
end;

function CFocusEnemy.Looking(): integer;
begin
	result := -1;
end;

function CFocusEnemy.LookingMore(): integer;
begin
	result := -1;
end;

////////////////////////////////

function CreateFocus(focusType: TFocusType; var focus: CFocus): boolean;
begin
	result := TRUE;

	DestroyFocus(focus);

	case focusType of
		ftLook:
			focus := CFocusLook.Create();
		ftSearch:
			focus := CFocusSearch.Create();
		ftTalk:
			focus := CFocusTalk.Create();
		ftEnemy:
			focus := CFocusEnemy.Create();
		else
			result := FALSE;
	end;
end;

procedure DestroyFocus(var focus: CFocus);
begin
	if assigned(focus) then begin
		focus.Free;
		focus := nil;
	end;
end;

end.

