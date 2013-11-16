unit UMapData02;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc02(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData02(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData02(eventType: TEventType; eventId : integer): boolean;

const
	MAP_DATA_02: array[0..9] of string =
	(
		'++++++++++',
		'+v BB+kkk+',
		'+    +   +',
		'+b   ++8++',
		'+        +',
		'+       t+',
		'+        +',
		'+[|]     +',
		'+++++++*++',
		'          '
	);

	MAP_EVENT_02: array[0..6] of TMapEventDesc =
	(
		(pos: (x: 7; y: 2); eventType: etOn; id: 1; flag: 1),
		(pos: (x: 7; y: 8); eventType: etOpen; id: 1; flag: 40),
		(pos: (x: 1; y: 3); eventType: etSearch; id: 1; flag: 100),
		(pos: (x: 8; y: 1); eventType: etSearch; id: 2; flag: 101),
		(pos: (x: 8; y: 5); eventType: etSearch; id: 3; flag: 102),
		(pos: (x: 1; y: 1); eventType: etAction; id: 1; flag: 200),
		(pos: (x: 7; y: 1); eventType: etAction; id: 2; flag: 201)
	);

	MAP_NPC_02: array[0..0] of TMapNPCDesc =
	(
		(charType: 0; pos: (x: 1; y: 2); name: '')
	);

implementation

uses
	UGameMain, UTileMap;

const
	FLAG_SHOW_HELP_MESSAGE = 1;
	FLAG_TRY_TO_OPEN_DOOR  = 2;
	FLAG_GET_REMOCON       = 3;
	FLAG_GET_POSTER_JR     = 4;
	FLAG_GET_MY_MESSAGE    = 5;

procedure G_TEXT(color : integer; s : widestring);
begin
	g_textArea.WriteLn(s);
end;

procedure G_INQUERY(color : integer; complete : widestring; incomplete : widestring);
begin
	g_inputArea.InputQuery(complete + incomplete);
end;

procedure InitProc02(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	if not (sender as TTileMap).MapFlag[0, FLAG_SHOW_HELP_MESSAGE] then begin
		(sender as TTileMap).RegisterTimeEvent(10, 1);
		(sender as TTileMap).MapFlag[0, FLAG_SHOW_HELP_MESSAGE] := TRUE;
	end;
end;

procedure TalkData02(personalId : integer; const question : widestring; const fullInput : wideString = '');
begin
	g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
end;

function EventData02(eventType: TEventType; eventId : integer): boolean;
{
var
	equipment: TItem;
}
begin
	result := TRUE;

	if eventType in [etOn, etSearch, etOpen] then
		g_textArea.Clear();

	case eventType of
		etOn:
		case eventId of
			1:
			begin
				g_textArea.WriteLn('''����� ���� â��� ���� �ִ� ���̴�''', tcMonolog);
				g_textArea.WriteLn('');
			end;
			2:
			begin
				if not g_inventory.Search(ITEM_TV_REMOCON) then begin
					g_textArea.WriteLn('''TV�� ������ �������� �ʿ��ϴ�''', tcMonolog);
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''TV�� ������ �������� ����ؾ� �Ѵ�''', tcMonolog);
					g_textArea.WriteLn('');

					g_statusArea.Clear();
					g_statusArea.WriteLn('[Tutorial]', tcEvent);
					g_statusArea.WriteLn('-- ''Z''Ű�� ������ �������', tcHelp);
					g_statusArea.WriteLn('');
					g_statusArea.WriteLn('TIP: ''Z''Ű�� ������ ���� �տ� �� ������ ������ �� �ִ�.', tcHelp);
				end;

				result := FALSE;
			end;
		end;

		etOpen:
		case eventId of
			1:
			begin
				if not g_tileMap.MapFlag[0, FLAG_TRY_TO_OPEN_DOOR] then begin
					g_textArea.WriteLn('''��.. �̰� ���� �ణ �ٸ� ������''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('���� ������������ ���� ������ ���� ������ �ؾ� ���� ���� �������� �ʾҴ�.');
					g_textArea.WriteLn('');
					g_tileMap.MapFlag[0, FLAG_TRY_TO_OPEN_DOOR] := TRUE;
					result := FALSE;
				end
				else begin
					g_textArea.WriteLn('������ ������ ���� ���� �������� �� �ڴ� �ٽ� ������ ���� �־���.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('�̰��� �������� ���ǰ� ���� �峭�� �ƴ϶�� Ʋ������ ���� ���̴�. ������ ���� �� ���߳� ����. �̷� ���� �ٽ� �ڸ��� ������ ���� ��� �ؾ� ���� �� �𸣰ڴ�.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('�ƹ��� �����ص� �̻��ϴ�. ���� ���� �ƴ϶�� �������µ��ٰ� ���� ���� �ִٴ� �� �̿ܿ��� ��� ���� ���ÿ� �Ȱ���.');

					g_tileMap.Map[6, 9] := BLOCK_W_PITCH * 1;
					g_tileMap.Map[7, 9] := BLOCK_W_PITCH * 1;
					g_tileMap.Map[8, 9] := BLOCK_W_PITCH * 1;
					g_tileMap.RegisterMapEvent(Point(1, 2), etOn, 2, 2);
				end;
			end;
		end;

		etSearch, etSearchQuery:
		case eventId of
			1:
			if not g_tileMap.MapFlag[0, FLAG_GET_REMOCON] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('ħ�� ������ �������� ���δ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''��.. ���� ħ�� ������ TV�� ���ٰ� �������� �׳� ���� �ξ��� ����''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('���� �������� ��� �ָӴϿ� �־���');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[TV ������ +1]', tcEvent);
					g_textArea.WriteLn('');

					g_tileMap.MapFlag[0, FLAG_GET_REMOCON] := TRUE;
					g_inventory.Add(ITEM_TV_REMOCON);
				end;
			end
			else begin
				result := FALSE;
			end;
			2:
			if not g_inventory.Search(ITEM_POSTER, ITEM_POSTER_JR) then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('ĳ��� �ȿ��� ������ó�� ���̴� ���̰� �����ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''�̰��� �ƴ� ������κ��� �޾Ҵ� ���� �����ͱ���.''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('���� �����͸� ��������.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[������ +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_POSTER, ITEM_POSTER_JR);
				end;
			end
			else begin
				result := FALSE;
			end;
			3:
			if not g_tileMap.MapFlag[0, FLAG_GET_MY_MESSAGE] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('å�� ������ � �޸� ������ �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('���� �޸� ��������.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[�޸�+1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_MEMO, ITEM_MEMO_MY_MESSAGE);
					g_tileMap.MapFlag[0, FLAG_GET_MY_MESSAGE] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
		end;

		etAction:
		case eventId of
			1:
			begin
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_DESERT);
				end
				else begin
					g_textArea.WriteLn('''TV�� ������ ������ �ȵȴ�.', tcMonolog);
					g_textArea.WriteLn('�������� ����ϸ� TV�� �� �� ���� �� ������...''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.ReservedClear();
				end;
				result := FALSE;
			end;
			2:
			begin
{
				equipment := g_tileMap.GetPC.Equipment;
				if equipment.itemId > 0 then begin
					g_inventory.Remove(equipment.itemId, equipment.aux1, equipment.aux2);
					//g_backPack.Add(ixEquipment);
				end;
}				
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('���õ� ���۵Ǵ� �ϻ�');
				g_textArea.WriteLn('�Ϸ� �Ϸ� �ٸ� �� ���� ���� �ϻ��� ���۵Ǿ���.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('�޻��� ���νôٴ� ���� ���� ���� �Ͼ�� �� �ؿ������ �ؾ� �Ѵٴ� ���� �ǹ��Ѵ�.');
				g_textArea.WriteLn('');
				g_tileMap.RegisterTimeEvent(60, 2);
			end;
			2:
			begin
				g_textArea.WriteLn('������ ����ġ�� ���� ���̳� ����. �湮�� �� �ͱ����� ��ﳪ�µ�, �� ������ ���� ��ﳪ�� �ʴ´�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('[F1] Ű ���ۿ����� ����', tcHelp);
				g_textArea.WriteLn('');
				g_textArea.ReservedClear();
			end;
		end;
	end;

	if eventType in [etOn, etSearch, etOpen] then
		g_textArea.ReservedClear();
end;

end.

