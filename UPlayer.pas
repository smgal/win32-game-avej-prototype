unit UPlayer;

interface

uses
	Windows,
	USmD3D9, USmUtil, USmResManager,
	UInventory, UType, UConfig;

type
	TPlayerAbility = record
		// strength: 그 사람이 가지고 있는 체력, 물리적인 힘을 끌어내는 정도, 무거운 것을 들거나 운반하기 위한 근력
		STR: longint;
		// intelligence: 사물을 이해하고 이용하기 위한 지적인 능력, 그 사람이 가지고 있는 고유한 학습 능력, 사람들과의 대화를 이끌어가기 위한 언변
		INT: longint;
		// dexterity: 사물을 능숙하게 다루기 위한 손재주, 사물을 고치거나 고장나지 않게 다루는 능력, 사물을 보다 정확하고 세밀하게 이용하는 능력
		DEX: longint;
		// charm: 남에게 비춰지는 그 사람의 매력, 사람들과의 생활에서 첫인상을 결정 짓는 척도, 남으로 하여금 자신을 믿도록 만드는 재능
		CHA: longint;
		// luck: 그 사람에게 알게 모르게 미치고 있는 행운, 자신에게 해를 끼치는 부분을 약간씩 감소시키는 운, 우연 또는 확률적인 일에서 남들보다 유리한 위치를 가지는 운
		LUC: longint;
	end;

	TPlayerParameter = record
		HP: longint;
		MP: longint;
		GOLD: longint;
	end;

	TplayerEquipment = record
	end;

	TPlayerBase = class
		m_playerType: integer;

		m_hTexture: integer;
		m_pos: TPoint;
		m_face: integer;
		m_face_dir: TFaceDir;
		m_face_inc: integer;
		m_space: TPoint;
		m_move_inc: integer;

		m_ani_pattern: integer;
		m_ani_pattern_inc: integer;

		m_name: string[16];
		m_equipment: array[0..0] of TItem;

		m_ability: TPlayerAbility;
		m_max_ability: TPlayerAbility;

		m_param: TPlayerParameter;
		m_max_param: TPlayerParameter;

		// load & save
		function  LoadData(var inFile: TSmReadFileStream): boolean; virtual;
		function  SaveData(var outFile: TSmWriteFileStream): boolean; virtual;
	end;

	TPlayer = class(TPlayerBase)
	private
		m_isAlive: boolean;

	public
		constructor Create();
		procedure   Free();

		function  m_MoveTest(x, y: integer): boolean;
		// facing
		procedure TurnFace(faceDir: TFaceDir);
		function  GetFacedVector(): TVector;
		function  ConvertFacedVector(vector: TVector): TVector;
		// atribute
		function  GetTilePos(): TPoint;
		// moving
		procedure Warp(x, y: integer; face: TFaceDir = fdNone);
		procedure WarpOnTile(x, y: integer; face: TFaceDir = fdNone);
		function  IsMoveable(dx, dy: integer): boolean;
		function  Move(dx, dy: integer; turnFace: boolean = TRUE): boolean;
		// displaying
		procedure GetDisplayAxis(out x, y: integer);
		procedure Display(lighten: longword = 255); virtual;
		// act
		procedure DoAction(refTime: longint); virtual; abstract;

		property  Equipment: TItem read m_equipment[0] write m_equipment[0];
		property  IsAlive: boolean read m_isAlive;
	end;

	TNonPlayer = class(TPlayer)
	public
		function  m_IsSeen(x1, y1: integer; x2, y2: integer; var nReached: integer): boolean;

		procedure Display(lighten: longword = 255); override;
		procedure DoAction(refTime: longint); override;
	end;

	TBullet = class(TNonPlayer)
	public
		m_realPos: TPosDouble;
		m_direction: TVectorDouble;

		procedure SetDestination(dx, dy: double);

		procedure DoAction(refTime: longint); override;
	end;

	THomming = class(TNonPlayer)
	public
		m_realPos: TPosDouble;
		m_target: TPlayer;
		m_velocity: double;

		procedure SetDestination(const target: TPlayer; velocity: double);

		procedure DoAction(refTime: longint); override;
	end;

	TMainPlayer = class(TPlayer)
	public
		procedure Display(lighten: longword = 255); override;
		procedure DoAction(refTime: longint); override;
	end;

function CreateObject(charaType: integer; xPos, yPos: integer; name: widestring = ''): TPlayer;
function CreateCharacter(charaType: integer; xPos, yPos: integer; name: widestring = ''): TPlayer;
function IsMyEyesReached(x1, y1: integer; x2, y2: integer): boolean;
function IsSeen(x1, y1: integer; x2, y2: integer): boolean;

implementation

uses
	UGameMain, UTileMap;

const
	MAX_FACE = 8;

	ENEMY_BASE     = $40;
	ENEMY_FIRE     = ENEMY_BASE + $00;
	QAZ_FIRE_BALL  = ENEMY_BASE + $01;
	QAZ_FIRE_BALL2 = ENEMY_BASE + $02;
	MAX_ENEMY_FACE = QAZ_FIRE_BALL2 + $01;

//////////////////

function  TPlayerBase.LoadData(var inFile: TSmReadFileStream): boolean;
var
	data: integer;
begin
	inFile.Read(m_playerType, sizeof(m_playerType));
	inFile.Read(m_space, sizeof(m_space));
	inFile.Read(m_ani_pattern, sizeof(m_ani_pattern));

	inFile.Read(m_pos, sizeof(m_pos));
	inFile.Read(m_face, sizeof(m_face));
	inFile.Read(m_face_dir, sizeof(m_face_dir));

	inFile.Read(data, sizeof(data));
	SetLength(m_name, data);
	inFile.Read(m_name[1], sizeof(widechar) * data);

	inFile.Read(m_ability, sizeof(m_ability));
	inFile.Read(m_max_ability, sizeof(m_max_ability));
	inFile.Read(m_param, sizeof(m_param));
	inFile.Read(m_max_param, sizeof(m_max_param));

	result := TRUE;
end;

function  TPlayerBase.SaveData(var outFile: TSmWriteFileStream): boolean;
var
	data: integer;
begin
	outFile.Write(m_playerType, sizeof(m_playerType));
	outFile.Write(m_space, sizeof(m_space));
	outFile.Write(m_ani_pattern, sizeof(m_ani_pattern));

	outFile.Write(m_pos, sizeof(m_pos));
	outFile.Write(m_face, sizeof(m_face));
	outFile.Write(m_face_dir, sizeof(m_face_dir));

	data := length(m_name);
	outFile.Write(data, sizeof(data));
	outFile.Write(m_name[1], sizeof(widechar) * data);

	outFile.Write(m_ability, sizeof(m_ability));
	outFile.Write(m_max_ability, sizeof(m_max_ability));
	outFile.Write(m_param, sizeof(m_param));
	outFile.Write(m_max_param, sizeof(m_max_param));

	result := TRUE;
end;

//////////////////

constructor TPlayer.Create();
begin
	inherited;

	m_isAlive := TRUE;
	ZeroMemory(@m_equipment, sizeof(m_equipment));
end;

procedure   TPlayer.Free();   begin inherited end;

function s_GetFaceIndex(id: integer): integer;
const
	FACE_TABLE: array[0..pred(MAX_FACE)] of integer =
	(
		0, 3, 6, 9, 13, 18, 22, 26
	);
	ENEMY_FACE_TABLE: array[0..pred(MAX_ENEMY_FACE-ENEMY_BASE)] of integer =
	(
		18*2, 18*2+4, 18*2+5
	);
begin
	if id in [0..pred(MAX_FACE)] then
		result := FACE_TABLE[id]
	else if id in [ENEMY_BASE..MAX_ENEMY_FACE-1] then
		result := ENEMY_FACE_TABLE[id-ENEMY_BASE]
	else
		result := 0;
end;

function s_ApplyFaceAnime(refTime: longword; face: integer; var count: integer): integer;
const
	ANIME_TABLE: array[0..pred(MAX_FACE)] of string =
	(
		'AAAABAAAAC',
		'AAAAAABAC',
		'BBBAAAC',
		'BBDBABCA',
		'CCBCCA',
		'AAAAAABBCD',
		'AAAAAABCCD',
		'AAAAABCBC'
	);
	ENEMY_ANIME_TABLE: array[0..pred(MAX_ENEMY_FACE-ENEMY_BASE)] of string =
	(
		'ABCD', 'A', 'A'
	);
begin
	result := 0;

	if face in [0..pred(MAX_FACE)] then begin
		result := integer(ANIME_TABLE[face, (integer(refTime)+count) mod length(ANIME_TABLE[face])+1]) - integer('A')
	end
	else if face in [ENEMY_BASE..MAX_ENEMY_FACE-1] then begin
		result := integer(ENEMY_ANIME_TABLE[face-ENEMY_BASE, (integer(refTime)+count) mod length(ENEMY_ANIME_TABLE[face-ENEMY_BASE])+1]) - integer('A')
	end;
end;

function TPlayer.m_MoveTest(x, y: integer): boolean;
var
	i, j: integer;
begin
	result := FALSE;

	repeat
		i := (x - m_space.x) div BLOCK_W_SIZE;
		j := (y - m_space.y) div BLOCK_H_SIZE;
		if not g_tileMap.IsMoveable(i, j) then begin
			break;
		end;

		i := (x + m_space.x - 1) div BLOCK_W_SIZE;
		j := (y - m_space.y) div BLOCK_H_SIZE;
		if not g_tileMap.IsMoveable(i, j) then begin
			break;
		end;

		i := (x + m_space.x - 1) div BLOCK_W_SIZE;
		j := (y + m_space.y - 1) div BLOCK_H_SIZE;
		if not g_tileMap.IsMoveable(i, j) then begin
			break;
		end;

		i := (x - m_space.x) div BLOCK_W_SIZE;
		j := (y + m_space.y - 1) div BLOCK_H_SIZE;
		if not g_tileMap.IsMoveable(i, j) then begin
			break;
		end;

		for i := 0 to pred(MAX_PLAYER) do begin
			if assigned(g_tileMap.GetPlayer(i)) then
			if g_tileMap.GetPlayer(i) <> self then begin
				if (abs(x - g_tileMap.GetPlayer(i).m_pos.x) < (m_space.x + g_tileMap.GetPlayer(i).m_space.x)) and
				   (abs(y - g_tileMap.GetPlayer(i).m_pos.y) < (m_space.y + g_tileMap.GetPlayer(i).m_space.y)) then begin
					exit;
				end;
			end;
		end;

		result := TRUE;
	until TRUE;
end;

procedure TPlayer.TurnFace(faceDir: TFaceDir);
const
	CW_TABLE  : array[TFaceDir] of TFaceDir = (fdLeft, fdUp, fdRight, fdDown, fdNone, fdCW, fdCCW);
	CCW_TABLE : array[TFaceDir] of TFaceDir = (fdRight, fdUp, fdLeft, fdDown, fdNone, fdCW, fdCCW);
begin
	assert(m_face_dir in [fdDown, fdRight, fdUp, fdLeft]);

	case faceDir of
		fdCW  : m_face_dir := CW_TABLE[m_face_dir];
		fdCCW : m_face_dir := CCW_TABLE[m_face_dir];
		fdDown, fdRight, fdUp, fdLeft: m_face_dir := faceDir;
		else begin end;
	end;
end;

function  TPlayer.GetFacedVector(): TVector;
begin
	case m_face_dir of
		fdDown  : begin result.dx := 0; result.dy := 1; end;
		fdRight : begin result.dx := 1; result.dy := 0; end;
		fdUp    : begin result.dx := 0; result.dy :=-1; end;
		fdLeft  : begin result.dx :=-1; result.dy := 0; end;
		else      begin result.dx := 0; result.dy := 0; end;
	end;
end;

function  TPlayer.ConvertFacedVector(vector: TVector): TVector;
begin
	assert(m_face_dir in [fdDown, fdRight, fdUp, fdLeft]);

	case m_face_dir of
		fdDown  : result := vector;
		fdRight : begin result.dx := +vector.dy; result.dy := -vector.dx; end;
		fdUp    : begin result.dx := -vector.dx; result.dy := -vector.dy; end;
		fdLeft  : begin result.dx := -vector.dy; result.dy := +vector.dx; end;
		else begin end;
	end;
end;

function  TPlayer.GetTilePos(): TPoint;
begin
	result.x := m_pos.x div BLOCK_W_SIZE;
	result.y := m_pos.y div BLOCK_H_SIZE;
end;

procedure TPlayer.Warp(x, y: integer; face: TFaceDir = fdNone);
begin
	self.TurnFace(face);
	m_pos.x := x;
	m_pos.y := y;
end;

procedure TPlayer.WarpOnTile(x, y: integer; face: TFaceDir = fdNone);
begin
	self.TurnFace(face);
	m_pos.x := x * BLOCK_W_SIZE + BLOCK_W_SIZE div 2;
	m_pos.y := y * BLOCK_H_SIZE + BLOCK_H_SIZE div 2;
end;

function  TPlayer.IsMoveable(dx, dy: integer): boolean;
begin
	result := m_MoveTest(m_pos.x + dx, m_pos.y + dy);
end;

function  TPlayer.Move(dx, dy: integer; turnFace: boolean = TRUE): boolean;
begin
	if turnFace then begin
		if dy < 0 then m_face_dir := fdUp;
		if dy > 0 then m_face_dir := fdDown;
		if dx < 0 then m_face_dir := fdLeft;
		if dx > 0 then m_face_dir := fdRight;
	end;

	if (dx <> 0) or (dy <> 0) then begin
		repeat
			if not m_MoveTest(m_pos.x + dx, m_pos.y + dy) then begin
				if (dx = 0) or (dy = 0) then begin
					dx := 0;
					dy := 0;
					break;
				end;

				if not m_MoveTest(m_pos.x + dx, m_pos.y) then begin
					if not m_MoveTest(m_pos.x, m_pos.y + dy) then begin
						dx := 0;
						dy := 0;
						break;
					end;
					dx := 0;
					break;
				end;
				dy := 0;
				break;
			end;

		until TRUE;

		if ((m_pos.x div BLOCK_W_SIZE) <> ((m_pos.x + dx) div BLOCK_W_SIZE)) or
			((m_pos.y div BLOCK_H_SIZE) <> ((m_pos.y + dy) div BLOCK_H_SIZE)) then begin
			g_tileMap.CheckOnEvent(m_pos.x, m_pos.y, dx, dy);
//			CheckEvent(m_pos.x, m_pos.y, dx, dy)
		end;

		m_pos.x := m_pos.x + dx;
		m_pos.y := m_pos.y + dy;

		result  := (dx <> 0) or (dy <> 0);
	end
	else begin
		result  := TRUE;
	end;
end;

procedure TPlayer.GetDisplayAxis(out x, y: integer);
begin
	x := WORLD_MAP_XPOS + (m_pos.x-(BLOCK_W_SIZE div 2) - g_baseXPos + SHOW_TILE_W_RADIUS * BLOCK_W_SIZE);
	y := WORLD_MAP_YPOS + (m_pos.y-(BLOCK_H_SIZE-m_space.y) - g_baseYPos + SHOW_TILE_H_RADIUS * BLOCK_H_SIZE);
end;

procedure TPlayer.Display(lighten: longword = 255);
var
	x, y: integer;
	addPattern: integer;
	r, g, b: longword;
	opacity: longint;
begin
	self.GetDisplayAxis(x, y);
//	g_d3Device.DrawImageEx(x, y, m_hTexture, (m_face_dir*2+m_face_inc) * BLOCK_W_SIZE, (m_face+2)*BLOCK_H_SIZE, BLOCK_W_SIZE, BLOCK_H_SIZE, 255, lighten);
	addPattern := s_ApplyFaceAnime(g_refAnime, m_ani_pattern, m_ani_pattern_inc);

	opacity := $FF;
	if m_param.HP < 0 then
		opacity := 255 + 255 * m_param.HP div m_max_param.HP;

	if lighten >= 255 then begin
		g_d3Device.DrawImageEx(x, y, m_hTexture, ((m_face mod BLOCK_W_PITCH)+addPattern)*BLOCK_W_GAP, TILE_CHARACTER_YPOS+(m_face div BLOCK_W_PITCH)*BLOCK_H_GAP, BLOCK_W_SIZE, BLOCK_H_SIZE, opacity, g_colorMask);
	end
	else begin
		lighten := lighten + (lighten shr 7);
		r := (((g_colorMask shr 16) and $FF) * lighten) shr 8;
		g := (((g_colorMask shr  8) and $FF) * lighten) shr 8;
		b := (((g_colorMask       ) and $FF) * lighten) shr 8;
		g_d3Device.DrawImageEx(x, y, m_hTexture, ((m_face mod BLOCK_W_PITCH)+addPattern)*BLOCK_W_GAP, TILE_CHARACTER_YPOS+(m_face div BLOCK_W_PITCH)*BLOCK_H_GAP, BLOCK_W_SIZE, BLOCK_H_SIZE, opacity, (r shl 16) or (g shl 8) or b);
	end;
end;

function  TNonPlayer.m_IsSeen(x1, y1: integer; x2, y2: integer; var nReached: integer): boolean;
var
	angle: extended;
begin
	angle := SmAtan(y1 - y2, x1 - x2);

	nReached := 0;
	if IsMyEyesReached(x1, y1, x2, y2) then
		inc(nReached);
	if IsMyEyesReached(x1, y1, x2+round(cos(angle-PI/2)*m_space.x*0.9), y2+round(sin(angle-PI/2)*m_space.y*0.9)) then
		inc(nReached);
	if IsMyEyesReached(x1, y1, x2+round(cos(angle+PI/2)*m_space.x*0.9), y2+round(sin(angle+PI/2)*m_space.y*0.9)) then
		inc(nReached);

	result := (nReached > 0);
end;

procedure TNonPlayer.Display(lighten: longword = 255);
var
	nReached: integer;
begin
	if m_IsSeen(g_baseXPos, g_baseYPos, m_pos.x, m_pos.y, nReached) then begin
		inherited Display(nReached*255 div 3);
{ 주인공에게 선 긋기
	var
		xBase, yBase: integer;
		xTarget, yTarget: integer;
	begin
		xBase := WORLD_MAP_XPOS + (SHOW_TILE_W_RADIUS * BLOCK_W_SIZE);
		yBase := WORLD_MAP_YPOS + (SHOW_TILE_H_RADIUS * BLOCK_H_SIZE);
		xTarget := xBase-(g_player[0].m_pos.x - m_pos.x);
		yTarget := yBase-(g_player[0].m_pos.y - m_pos.y);
		g_d3Device.DrawLine($8000FF00, xBase, yBase, xTarget, yTarget);

		dec(xTarget, 12);
		dec(yTarget, 12+4);
		g_d3Device.DrawLine($FF00FF00, xTarget, yTarget, xTarget+24, yTarget);
		g_d3Device.DrawLine($FF00FF00, xTarget, yTarget+24, xTarget+24, yTarget+24);
		g_d3Device.DrawLine($FF00FF00, xTarget, yTarget, xTarget, yTarget+24);
		g_d3Device.DrawLine($FF00FF00, xTarget+24, yTarget, xTarget+24, yTarget+24);
	end;
}
	end;
end;

procedure TNonPlayer.DoAction(refTime: longint);
var
	angle: integer;
	mainPC: TPlayer;
	tempPC: TPlayer;
	dx, dy: integer;
begin
	m_face_inc := (refTime div 20) mod 2;

	case m_playerType of
		ENEMY_FIRE:
		begin
			mainPC := g_tileMap.GetPC;
			angle  := round(SmAtan(mainPC.m_pos.y - m_pos.y, mainPC.m_pos.x - m_pos.x) * 180.0 / PI);
			dx     := round(1*SmCos(angle))*2;
			dy     := round(1*SmSin(angle))*2;
			Move(dx, dy);
{ homming이 들어가는 경우
			mainPC := g_tileMap.GetPC;
			angle  := round(SmAtan(mainPC.m_pos.y - m_pos.y, mainPC.m_pos.x - m_pos.x) * 180.0 / PI);
			Move(round(0.6*SmCos(angle))*2, round(0.6*SmSin(angle))*2);
			if random(3) = 0 then begin
				tempPC := g_tileMap.CreateObject(QAZ_FIRE_BALL2, m_pos.x + round(m_space.x *SmCos(angle))*2, m_pos.y + round(m_space.y *SmSin(angle))*2);
				if assigned(tempPC) then begin
//					(tempPC as TBullet).SetDestination(round(4*SmCos(angle))*2, round(4*SmSin(angle))*2);
					(tempPC as THomming).SetDestination(mainPC, 8);
				end;
			end;
}
		end;
{
		QAZ_FIRE_BALL:
		begin
			mainPC := g_tileMap.GetPC;
			angle  := round(SmAtan(mainPC.m_pos.y - m_pos.y, mainPC.m_pos.x - m_pos.x) * 180.0 / PI);
			dx     := round(4*SmCos(angle))*2;
			dy     := round(4*SmSin(angle))*2;
			m_isAlive := IsMoveable(dx, dy);
			Move(dx, dy);
		end;
		QAZ_FIRE_BALL2:
		begin
			mainPC := g_tileMap.GetPC;
			angle  := round(SmAtan(mainPC.m_pos.y - m_pos.y, mainPC.m_pos.x - m_pos.x) * 180.0 / PI);
			dx     := round(4*SmCos(angle))*2;
			dy     := round(4*SmSin(angle))*2;
			m_isAlive := IsMoveable(dx, dy);
			Move(dx, dy);
		end;
		else begin
			if m_param.HP < 0 then
				Move((Random(3)-1)*2, (Random(3)-1)*2);
		end;
}
	end;

end;

//////////////////////////

procedure TBullet.SetDestination(dx, dy: double);
begin
	m_realPos.x    := m_pos.x;
	m_realPos.y    := m_pos.y;
	m_direction.dx := dx;
	m_direction.dy := dy;
end;

procedure TBullet.DoAction(refTime: longint);
begin
	inherited;

	m_isAlive := IsMoveable(round(m_direction.dx), round(m_direction.dx));
	if m_isAlive then begin
		m_realPos.x := m_realPos.x + m_direction.dx;
		m_realPos.y := m_realPos.y + m_direction.dy;
		m_pos.x := round(m_realPos.x);
		m_pos.y := round(m_realPos.y);
	end
	else begin
		//!! -HP
	end;
end;

//////////////////////////

procedure THomming.SetDestination(const target: TPlayer; velocity: double);
begin
	m_realPos.x := m_pos.x;
	m_realPos.y := m_pos.y;
	m_target    := target;
	m_velocity  := velocity;
end;

procedure THomming.DoAction(refTime: longint);
var
	angle: integer;
	dx, dy: integer;
begin
	inherited;

	angle  := round(SmAtan(m_target.m_pos.y - m_pos.y, m_target.m_pos.x - m_pos.x) * 180.0 / PI);
	dx     := round(m_velocity*SmCos(angle)/2)*2;
	dy     := round(m_velocity*SmSin(angle)/2)*2;

	m_isAlive := IsMoveable(dx, dy);

	if m_isAlive then begin
		m_realPos.x := m_realPos.x + dx;
		m_realPos.y := m_realPos.y + dy;
		m_pos.x := round(m_realPos.x);
		m_pos.y := round(m_realPos.y);
	end
	else begin
		//!! -HP
	end;
end;

//////////////////////////

procedure TMainPlayer.Display(lighten: longword);
var
	xDest, yDest: integer;
	xSour, ySour, wSour, hSour: integer;
begin
	inherited;

	// display the direction of the specified character
	self.GetDisplayAxis(xDest, yDest);

	inc(xDest, BLOCK_W_SIZE div 2);
	inc(yDest, BLOCK_H_SIZE div 2);

	case m_face_dir of
		fdDown:
		begin
			inc(xDest, -2);
			inc(yDest, (BLOCK_H_SIZE div 2)-4);
			xSour := DIR_MAKER_X+10;
			ySour := DIR_MAKER_Y+28;
			wSour := 8;
			hSour := 4;
		end;
		fdLeft:
		begin
			inc(xDest, -(BLOCK_W_SIZE div 2));
			inc(yDest, -2);
			xSour := DIR_MAKER_X+ 0;
			ySour := DIR_MAKER_Y+12;
			wSour := 4;
			hSour := 8;
		end;
		fdRight:
		begin
			inc(xDest, (BLOCK_W_SIZE div 2)-4);
			inc(yDest, -2);
			xSour := DIR_MAKER_X+24;
			ySour := DIR_MAKER_Y+12;
			wSour := 4;
			hSour := 8;
		end;
		fdUp:
		begin
			inc(xDest, -2);
			inc(yDest, -(BLOCK_H_SIZE div 2));
			xSour := DIR_MAKER_X+10;
			ySour := DIR_MAKER_Y+ 0;
			wSour := 8;
			hSour := 4;
		end;
		else
			exit;
	end;

	g_d3Device.DrawImageEx(xDest, yDest, g_hObject, xSour, ySour, wSour, hSour, $FF);
end;

procedure TMainPlayer.DoAction(refTime: longint);
var
	dx, dy: integer;
	accel: boolean;
begin
	dx := 0;
	dy := 0;

	{$R-}
	accel := (HiByte(GetAsyncKeyState(VK_CONTROL)) > 0);
	accel := accel or TRUE;

	if HiByte(GetAsyncKeyState(VK_UP   )) > 0 then dy := -m_move_inc;
	if HiByte(GetAsyncKeyState(VK_DOWN )) > 0 then dy :=  m_move_inc;
	if HiByte(GetAsyncKeyState(VK_LEFT )) > 0 then dx := -m_move_inc;
	if HiByte(GetAsyncKeyState(VK_RIGHT)) > 0 then dx :=  m_move_inc;
	{$R+}

	if accel then
		m_face_inc := (refTime div 10) mod 2
	else
		m_face_inc := (refTime div 20) mod 2;

	if (dx <> 0) or (dy <> 0) then begin
		if accel then begin
			dx := dx * 2;
			dy := dy * 2;
		end;
		Move(dx, dy, TRUE);
		g_gameMain.ProcKeyDown(VK_ESCAPE);
	end;
end;

function  IsMyEyesReached(x1, y1: integer; x2, y2: integer): boolean;
var
	dx, dy, xDir, yDir: integer;
	d, x, y, incR, incUR: integer;
	preX, preY: integer;
begin
	if (abs(x1-x2) <= BLOCK_W_SIZE) and (abs(y1-y2) <= BLOCK_H_SIZE) then begin
		result := TRUE;
		exit;
	end;

	result := FALSE;

	if (x1 > x2) then begin
		x1 := x1 xor x2; x2 := x2 xor x1; x1 := x1 xor x2;
		y1 := y1 xor y2; y2 := y2 xor y1; y1 := y1 xor y2;
	end;

	dx := x2 - x1;
	dy := y2 - y1;

	if dy < 0 then yDir := -1 else yDir := 1;
	if dx < 0 then xDir := -1 else xDir := 1;

	if dx >= (dy * yDir) then begin
		if (yDir < 0) then dy := -dy;

		d     := 2 * dy - dx;
		incR  := 2 * dy;
		incUR := 2 * (dy - dx);
		x     := x1;
		y     := y1;

		preX := x div BLOCK_W_SIZE;
		preY := y div BLOCK_H_SIZE;

		while (x < x2) do begin
			inc(x);

			if (d <= 0) then
				inc(d, incR)
			else begin
				inc(d, incUR);
				inc(y, yDir);
			end;

			if (preX <> x div BLOCK_W_SIZE) or (preY <> y div BLOCK_H_SIZE) then begin
				if not g_tileMap.Istransmitable(x div BLOCK_W_SIZE, y div BLOCK_H_SIZE) then
					exit;
				preX := x div BLOCK_W_SIZE;
				preY := y div BLOCK_H_SIZE;
			end;
		end;
	end
	else begin
		if (yDir < 0) then dy := -dy;

		d     := 2 * dx - dy;
		incR  := 2 * dx;
		incUR := 2 * (dx - dy);
		x     := x1;
		y     := y1;

		preX := x div BLOCK_W_SIZE;
		preY := y div BLOCK_H_SIZE;

		while (y*yDir < y2*yDir) do begin
			inc(y, yDir);

			if (d <= 0) then
				inc(d, incR)
			else begin
				inc(d, incUR);
				inc(x, xDir);
			end;

			if (preX <> x div BLOCK_W_SIZE) or (preY <> y div BLOCK_H_SIZE) then begin
				if not g_tileMap.Istransmitable(x div BLOCK_W_SIZE, y div BLOCK_H_SIZE) then
					exit;
				preX := x div BLOCK_W_SIZE;
				preY := y div BLOCK_H_SIZE;
			end;
		end;
	end;

	result := TRUE;
end;

function  IsSeen(x1, y1: integer; x2, y2: integer): boolean;
var
	nReached: integer;
	angle: extended;
	xSpace, ySpace: integer;
begin
	xSpace := round(BLOCK_W_SIZE * 0.4);
	ySpace := round(BLOCK_H_SIZE * 0.4);

	angle  := SmAtan(y1 - y2, x1 - x2);

	nReached := 0;
	if IsMyEyesReached(x1, y1, x2, y2) then
		inc(nReached);
	if IsMyEyesReached(x1+round(cos(angle-PI/2)*xSpace), y1+round(sin(angle-PI/2)*ySpace), x2, y2) then
		inc(nReached);
	if IsMyEyesReached(x1+round(cos(angle+PI/2)*xSpace), y1+round(sin(angle+PI/2)*ySpace), x2, y2) then
		inc(nReached);

	result := (nReached > 0);
end;

function CreateObject(charaType: integer; xPos, yPos: integer; name: widestring = ''): TPlayer;
var
	tempPlayer: TPlayer;
begin
	tempPlayer := nil;

	case charaType of
		0:
		begin
			tempPlayer                   := TMainPlayer.Create();
			tempPlayer.m_hTexture        := g_hTexture;
			tempPlayer.m_face            := s_GetFaceIndex(0);
			tempPlayer.m_face_dir        := fdDown;
			tempPlayer.m_face_inc        := 0;
			tempPlayer.m_space.x         := BLOCK_W_SIZE div 2;
			tempPlayer.m_space.y         := BLOCK_H_SIZE div 2;
			tempPlayer.m_move_inc        := PLAYER_MOVE_INC;
			tempPlayer.m_ani_pattern     := 0;
			tempPlayer.m_ani_pattern_inc := 0;

			Randomize();
			tempPlayer.m_max_ability.STR := 45 + Random(11);
			tempPlayer.m_max_ability.INT := 45 + Random(11);
			tempPlayer.m_max_ability.DEX := 45 + Random(11);
			tempPlayer.m_max_ability.CHA := 45 + Random(11);
			tempPlayer.m_max_ability.LUC := 45 + Random(11);
			tempPlayer.m_ability         := tempPlayer.m_max_ability;

			tempPlayer.m_max_param.HP    := 100;
			tempPlayer.m_max_param.MP    := 100;
			tempPlayer.m_max_param.GOLD  := 0;
			tempPlayer.m_param           := tempPlayer.m_max_param;

		end;
		1, 2, 3, 4, 5, 6, 7:
		begin
			tempPlayer                   := TNonPlayer.Create;
			tempPlayer.m_hTexture        := g_hTexture;
			tempPlayer.m_face            := s_GetFaceIndex(charaType);
			tempPlayer.m_face_dir        := fdDown;
			tempPlayer.m_face_inc        := 0;
			tempPlayer.m_space.x         := BLOCK_W_SIZE div 2;
			tempPlayer.m_space.y         := BLOCK_H_SIZE div 2;
			tempPlayer.m_move_inc        := PLAYER_MOVE_INC;
			tempPlayer.m_ani_pattern     := charaType;
			tempPlayer.m_ani_pattern_inc := Random(10);

			tempPlayer.m_max_param.HP    := 100;
			tempPlayer.m_max_param.MP    := 100;
			tempPlayer.m_max_param.GOLD  := 0;
			tempPlayer.m_param           := tempPlayer.m_max_param;
		end;
		ENEMY_FIRE:
		begin
			tempPlayer                   := TNonPlayer.Create();
			tempPlayer.m_hTexture        := g_hTexture;
			tempPlayer.m_face            := s_GetFaceIndex(charaType);
			tempPlayer.m_face_dir        := fdDown;
			tempPlayer.m_face_inc        := 0;
			tempPlayer.m_space.x         := BLOCK_W_SIZE div 2;
			tempPlayer.m_space.y         := BLOCK_H_SIZE div 2;
			tempPlayer.m_move_inc        := PLAYER_MOVE_INC;
			tempPlayer.m_ani_pattern     := charaType;
			tempPlayer.m_ani_pattern_inc := Random(10);

			tempPlayer.m_max_param.HP    := 100;
			tempPlayer.m_max_param.MP    := 100;
			tempPlayer.m_max_param.GOLD  := 0;
			tempPlayer.m_param           := tempPlayer.m_max_param;
			tempPlayer.m_param.HP        := -10;
		end;
		QAZ_FIRE_BALL:
		begin
			tempPlayer                   := TBullet.Create();
			tempPlayer.m_hTexture        := g_hTexture;
			tempPlayer.m_face            := s_GetFaceIndex(charaType);
			tempPlayer.m_face_dir        := fdDown;
			tempPlayer.m_face_inc        := 0;
			tempPlayer.m_space.x         := 2;
			tempPlayer.m_space.y         := 2;
			tempPlayer.m_move_inc        := PLAYER_MOVE_INC;
			tempPlayer.m_ani_pattern     := charaType;
			tempPlayer.m_ani_pattern_inc := Random(10);

			tempPlayer.m_max_param.HP    := 10;
			tempPlayer.m_max_param.MP    := 10;
			tempPlayer.m_max_param.GOLD  := 0;
			tempPlayer.m_param           := tempPlayer.m_max_param;
			tempPlayer.m_param.HP        := 10;
		end;
		QAZ_FIRE_BALL2:
		begin
			tempPlayer                   := THomming.Create();
			tempPlayer.m_hTexture        := g_hTexture;
			tempPlayer.m_face            := s_GetFaceIndex(charaType);
			tempPlayer.m_face_dir        := fdDown;
			tempPlayer.m_face_inc        := 0;
			tempPlayer.m_space.x         := 2;
			tempPlayer.m_space.y         := 2;
			tempPlayer.m_move_inc        := PLAYER_MOVE_INC;
			tempPlayer.m_ani_pattern     := charaType;
			tempPlayer.m_ani_pattern_inc := Random(10);

			tempPlayer.m_max_param.HP    := 10;
			tempPlayer.m_max_param.MP    := 10;
			tempPlayer.m_max_param.GOLD  := 0;
			tempPlayer.m_param           := tempPlayer.m_max_param;
			tempPlayer.m_param.HP        := 10;
		end;
		MAX_FACE, MAX_ENEMY_FACE:
		begin
		end;
		else begin
			assert(false);
		end;
	end;

	if assigned(tempPlayer) then begin
		tempPlayer.m_pos.x := xPos;
		tempPlayer.m_pos.y := yPos;
		tempPlayer.m_name  := name;
		tempPlayer.m_playerType  := charaType;
	end;

	result := tempPlayer;
end;

function CreateCharacter(charaType: integer; xPos, yPos: integer; name: widestring = ''): TPlayer;
begin
	xPos := xPos * BLOCK_W_SIZE + BLOCK_W_SIZE div 2;
	yPos := yPos * BLOCK_H_SIZE + BLOCK_H_SIZE div 2;

	result := CreateObject(charaType, xPos, yPos, name);
end;

end.

