unit UMapData03;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc03(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData03(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData03(eventType: TEventType; eventId : integer): boolean;
function  Char2MapProc03(cTemp: char): longword;

const
	MAP_DATA_03: array[0..8] of string =
	(
		'+++++++++++++++++++++++++++++++',
		'+    v    +    v    +    v    +',
		'+         +         +         +',
		'+         +         +         +',
		'+                             +',
		'+         +         +         +',
		'+         +         +         +',
		'+    v    +    v    +    v    +',
		'+++++++++++++++++++++++++++++++'
	);

	MAP_EVENT_03: array[0..3] of TMapEventDesc =
	(
		(pos: (x: 15; y: 1); eventType: etAction; id: 1; flag: 1),
		(pos: (x: 15; y: 7); eventType: etAction; id: 2; flag: 2),
		(pos: (x:  9; y: 4); eventType: etOn;     id: 1; flag: 10),
		(pos: (x: 21; y: 4); eventType: etOn;     id: 2; flag: 11)
	);

	MAP_NPC_03: array[0..0] of TMapNPCDesc =
	(
		(charType: 0; pos: (x: 15; y: 2); name: '')
	);

implementation

uses
	UGameMain, UTileMap;

const
	FLAG_SHOW_TRANS_MESSAGE = 1;

procedure InitProc03(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	if prevMapId = SCRIPT_MY_ROOM then
		(sender as TTileMap).GetPC.WarpOnTile(15, 6, fdUp);

	if not (sender as TTileMap).MapFlag[0, FLAG_SHOW_TRANS_MESSAGE] then begin
		(sender as TTileMap).RegisterTimeEvent(10, 1);
		(sender as TTileMap).MapFlag[0, FLAG_SHOW_TRANS_MESSAGE] := TRUE;
	end;
end;

function  Char2MapProc03(cTemp: char): longword;
begin
	case cTemp of
		' ': result := 4;
		'+': result := BLOCK_W_PITCH * 1 + 1;
		else result := high(longword);
	end;
end;

procedure TalkData03(personalId : integer; const question : widestring; const fullInput : wideString = '');
begin
	g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
end;

function EventData03(eventType: TEventType; eventId : integer): boolean;
begin
	result := TRUE;

	case eventType of
		etOn:
		case eventId of
			1:
			begin
				inc(g_tileMap.GetPC.m_pos.x, 10 * BLOCK_W_SIZE);
				result := FALSE;
			end;
			2:
			begin
				inc(g_tileMap.GetPC.m_pos.x, -10 * BLOCK_W_SIZE);
				result := FALSE;
			end;
		end;

		etAction:
		case eventId of
			1:
			begin
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_AVEJ_WEST_LV1);
				end
				else begin
					g_textArea.WriteLn('''TV�� ������ ������ �ȵȴ�.', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.ReservedClear();
				end;
				result := FALSE;
			end;
			2:
			begin
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_MY_ROOM);
				end
				else begin
					g_textArea.WriteLn('''TV�� ������ ������ �ȵȴ�.', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.ReservedClear();
				end;
				result := FALSE;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('''��...�̰��� �����ΰ��� �̻��ϴ�.''', tcMonolog);
				g_textArea.WriteLn('');
				g_textArea.WriteLn('���� TV ���������� TV ä���� �ٲپ��� ���ε� ������ ����� ���� ���ȴ�. ������ ����� ���ߴٱ� ���ٴ� ��ġ ���� �ٸ� ������ �̵��� �� �͸� ����. ä���� �ٲٴ� ���� ���� TV�� �����ϴ� ���ļ��� �����Ѵٴ� ���� �� �� �̻��� �ƹ��� �ǹ̰� ����� �ϴ� ���̴�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('�� �տ� ������ �ϱ��� �ʴ� �� ��ȭ�� �׳� ������ ġ���ع����⿡�� �ʹ� �����ϴ�.');
				g_textArea.WriteLn('');
			end;
		end;
	end;
end;

end.

