unit UMapData05;

interface

uses
	Windows,
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc05(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData05(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData05(eventType: TEventType; eventId : integer): boolean;
function  Char2MapProc05(cTemp: char): longword;

const
	BACK_LOCKED_DOOR_POS_X = 49;
	BACK_LOCKED_DOOR_POS_Y = 15;
	BACK_LOCKED_DOOR_POS: TPoint = (x: BACK_LOCKED_DOOR_POS_X; y: BACK_LOCKED_DOOR_POS_Y);

const
	MAP_DATA_05W: array[0..22] of widestring =
	(
		'�ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢ�',
		'�ˢˢƣ��ƢƢƢƢƢƢƢƢƢƢˡ���������',
		'�ˢˢƢˢƢƢƢƢƢƢƢƢƢƢˡ���������',
		'�ˢˢƢˢƢƢƢƢƢƢƢƢƢƢˡ���������',
		'�ˢˢƢˢƢƢƢƢƢƢƢƢƢƢˡ���������',
		'�ˢˢƢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢ�',
		'�ˢơޢƢƢ��������ƢˡšŢˢ������ˢ֢�',
		'�ˢ��ƢƢƢƢƢƢƢƢˢˢˢˡ������ˣ���',
		'�ˢƢƢƢƢƢƢƢƢƣ�������������������',
		'�ˢƢƢƢƢƢƢƢƢƢˢˢˢˡ�����������',
		'�ˢ��ӢƢƢƢƢơߡߢˡšŢˢ�����������',
		'�ˢˢˢˢˢˢˢˢˢˢˡšŢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢ�',
		'�ˢââââââââââââââââââââââââââââââââââââ��âââââââˢǡޢơ��Ƣ����ˢ֢Ǣƨ��ϢƢ֢�',
		'�ˢ��ââââââââââââââââââââââ��ââââââââââââââââââââˢƢƢƢƢƢƢƢƢƢơ�ƢƢƢƢƢ�',
		'�ˢ������âââââââââââââââââââââââââââââââââââââââââˢ����ƢƢƢƢƢƢƢƢǢƢƢƢƢ���',
		'�ˢˢˢˢˢˢˢˢˢˢˢˡ�ˢˢˢˢˢˢˢˢˣ΢ˢˢˡ�ˢˢˢˢˢˢâââˢˢˢˢˢˢˢˢˢˢˢˢˣ��ˢˢˢˢˢˢˢˢˣ��ˢˢˢˢˢˢˢˢˢˢ�',
		'�ˡޡެᥱ�������Ȣ��ޢƢƢơӢƢˡ������������������������ӡ��ߢˢâââˢƢƢƢƢƢƢƢƢƢƢˡءءߡߡߡߡߡߡߡߡءءآǢǡ���������������',
		'�ˡޡ������������ȢƢƢƢơ��Ƣˡ������������������������ӡ��ߢˢâââˢƢƢƢƢƢƢƢƢƢƢˡءءءءءءءءءءءءآǢǡ���������������',
		'�ˡޡ������͡������ƢƢƢƢƢƢƢˡ������������������������ӡ��ߢˢâââˢƢƢƢƢƢƢƢƢƢƢˡإ��إ��إ��إ��إ��إ��آǢǡ���������������',
		'�ˡޡ����롲�����ȢƢƢƢƢƢƢơࡡ�����������������������ӡ��ߢˢâââˢƢƢƢƢƢƢƢƢƢƢˡإ��إ��إ��إ��إ��إ��آǢǡ���������������',
		'�ˢȢȢȢȢȢȢȢȢȢȢȢƢƢƢƢˡ������롲�ԡ����ԡ�������������âââˢƢƢƢƢƢƢƢƢƢƢˡإ��إ��إ��إ��إ��إ��آǢǡ���������������',
		'�ˢء������������ȢآƢƢƢƢƢƣ������������ᡡ���ᡡ�����������ˢâ��âˢƢƢƢƢƢƢƢƢƢƢˡإ��إ��إ��إ��إ��إ��آǢǡ���������������',
		'�ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢâââˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢ�'
	);

	MAP_EVENT_05: array[0..7] of TMapEventDesc =
	(
		(pos: (x:  2; y:  6); eventType: etAction; id: 1; flag: 1),
		(pos: (x:  8; y: 10); eventType: etSearch; id: 1; flag: 100),
		(pos: (x: 59; y: 12); eventType: etAction; id: 2; flag: 2), // TV to Costalica
		(pos: (x: 55; y: 13); eventType: etOn;     id: 1; flag: 21),
		(pos: (x: 59; y: 16); eventType: etOn;     id: 2; flag: 22),
		(pos: (x: 51; y: 20); eventType: etSearch; id: 2; flag: 101), // wiskey
		(pos: (x: 55; y: 19); eventType: etSearch; id: 3; flag: 102),
		(pos: (x: BACK_LOCKED_DOOR_POS_X; y: BACK_LOCKED_DOOR_POS_Y); eventType: etAction; id: 3; flag: 3)
	);

	MAP_NPC_05: array[0..3] of TMapNPCDesc =
	(
		(charType: $00; pos: (x:  2; y:  1); name: ''),
//		(charType: $00; pos: (x: 49; y: 16); name: ''),
		(charType: $40; pos: (x:  6; y:  2); name: ''),
		(charType: $40; pos: (x:  7; y:  2); name: ''),
		(charType: $40; pos: (x:  8; y:  2); name: '')
	);

implementation

uses
	UGameMain, UTileMap;

const
	FLAG_GET_PYRO_BOMB = 1;
	FLAG_SHOW_FIRST_MESSAGE = 2;
	FLAG_SHOW_SECOND_MESSAGE = 3;
	FLAG_OPEN_BACK_LOCKED_DOOR = 4;
	FLAG_GET_WISKEY = 5;

procedure InitProc05(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	if prevMapId = SCRIPT_AVEJ_WEST_LV1 then begin
		if (prevPos.x >= 0) and (prevPos.y >= 0) then begin
			(sender as TTileMap).GetPC.WarpOnTile(prevPos.x div BLOCK_W_SIZE, prevPos.y div BLOCK_H_SIZE);
		end;
	end;
	if prevMapId = SCRIPT_COSTABELLA_LV1 then begin
		(sender as TTileMap).GetPC.WarpOnTile(59, 13, fdUp);
	end;

	// if the back locked door opened,
	if (sender as TTileMap).MapFlag[SCRIPT_AVEJ_WEST_LV0, FLAG_OPEN_BACK_LOCKED_DOOR] then begin
		(sender as TTileMap).RemoveMapEvent(BACK_LOCKED_DOOR_POS, etAction);
	end;
end;

function  Char2MapProc05(cTemp: char): longword;
begin
	case cTemp of
		chr(255): result := 3;
		else result := high(longword);
	end;
end;

procedure TalkData05(personalId : integer; const question : widestring; const fullInput : wideString = '');
begin
	g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
end;

function GetEventPos(eventType: TEventType; eventId : integer): TPoint;
var
	i: integer;
begin
	for i := low(MAP_EVENT_05) to high(MAP_EVENT_05) do begin
		if (MAP_EVENT_05[i].eventType = eventType) and (MAP_EVENT_05[i].id = eventId) then begin
			result := MAP_EVENT_05[i].pos;
			exit;
		end;
	end;

	// cannot find the specified event
	result.x := 0;
	result.y := 0;
end;

function EventData05(eventType: TEventType; eventId : integer): boolean;
begin
	result := TRUE;

	case eventType of
		etOn:
		case eventId of
			1:
			begin
				if not g_tileMap.MapFlag[0, FLAG_SHOW_FIRST_MESSAGE] then begin
					g_tileMap.RegisterTimeEvent(10, 1);
					g_tileMap.MapFlag[0, FLAG_SHOW_FIRST_MESSAGE] := TRUE;
				end;
			end;
			2:
			begin
				if not g_tileMap.MapFlag[0, FLAG_SHOW_SECOND_MESSAGE] then begin
					g_tileMap.RegisterTimeEvent(10, 2);
					g_tileMap.MapFlag[0, FLAG_SHOW_SECOND_MESSAGE] := TRUE;
				end;
			end;
		end;

		etOpen:
		case eventId of
			1:
			begin
			end;
		end;

		etSearch, etSearchQuery:
		case eventId of
			1:
			if not g_tileMap.MapFlag[0, FLAG_GET_PYRO_BOMB] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('ĳ��ݿ��� �������� �ο� �ִ� ���𰡰� �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''�̰��� �������� ���ϴ� ���̷�����ź�ΰ�����.''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[���̷�����ź +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_PYRO_BOMB);
					g_tileMap.MapFlag[0, FLAG_GET_PYRO_BOMB] := TRUE;
				end;
			end;
			2:
			if not g_tileMap.MapFlag[0, FLAG_GET_WISKEY] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('������ ���� �ȿ��� � ���� ���δ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''�״��� ��� �������� �ʴ� ���̷α�.''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[����� ���̴� �� +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_WISKEY);
					g_tileMap.MapFlag[0, FLAG_GET_WISKEY] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
		end;

		etReadQuery:
		case eventId of
			1:
			begin
			end;
		end;

		etAction:
		case eventId of
			1:
			begin
				if (g_tileMap.GetPC.m_ability.STR >= 53) then begin
					g_textArea.WriteLn('å���� �� �� �ֵ��� �Ʒ��� ������ ��� �־���, ���� �־� ������ ���� å���� �߰� �߰� �Ҹ��� ���� ���� ���� ��������.');
					g_textArea.WriteLn('');
					g_tileMap[1, 6] := g_tileMap[2, 6];
					g_tileMap[2, 6] := g_tileMap[3, 6];
					result := TRUE;
				end
				else begin
					g_textArea.WriteLn('å���� �� �� �ֵ��� �Ʒ��� ������ ��� ������ �������� ������� ���� ſ���� ���� �����δ� �и��� �ʾҴ�.');
					g_textArea.WriteLn('');
					result := FALSE;
				end;
			end;
			2:
			begin
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_COSTABELLA_LV1);
				end;
				result := FALSE;
			end;
			3:
			begin
				// door opens if result is TRUE
				result := GetEventPos(eventType, eventId).y < g_tileMap.GetPC.m_pos.y div BLOCK_H_SIZE;
				if result then begin
					g_textArea.WriteLn('�� �������� ����� �����ߴ�.');
					g_textArea.WriteLn('');
					g_tileMap.MapFlag[0, FLAG_OPEN_BACK_LOCKED_DOOR] := TRUE;
				end
				else begin
					g_textArea.WriteLn('���� �����̰� ���ư��� �ʴ´�. �Ƹ��� �������� ���� �ϴ�.');
					g_textArea.WriteLn('');
				end;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('�ణ�� ���ܿ� ������ ������ ���� ���Ͻ��̴�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('�״��� ���ִ� ����ϴ� �� ������ ������ �ٴ��� ���� ������ �״�� ���� �־��� ��ü������ �������� ���� ������ �� �� �־���. �Ƹ��� ������ �� ������ â��� ���̰� �ִ� �� ����.');
				g_textArea.WriteLn('');
			end;
			2:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('�� �����Ǿ� �ִ� �ڽ��� �����Ǿ� �ִ� ���̴�. �Ƹ��� �� ���Կ��� �Ǹ��ϰ� �ִ� ���ǵ��� ��� �ִ� �� ����.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('''Ȥ�� ���⿡�� ������ �������� �����˰� �ǳ�?''', tcMonolog);
				g_textArea.WriteLn('');
			end;
		end;
	end;
end;

end.

