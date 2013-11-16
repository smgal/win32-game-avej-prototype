unit UMapData01;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc01(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData01(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData01(eventType: TEventType; eventId : integer): boolean;

const
	MAP_DATA_01: array[0..24] of string =
	(
		'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++',
		'+                                                             +',
		'++++++++++                                                    +',
		'+v BB+kkk+                                                    +',
		'+    +   +                                                    +',
		'+b   ++8++                                                    +',
		'+        +                                                    +',
		'+       t+                                                    +',
		'+        +                                                    +',
		'+[|]     +                                                    +',
		'+++++++N++=++++N++++=++++N++++=++++N+++++                     +',
		'   +  f       f         f         f     +                     +',
		'   +                                    ++++++++++++<++(++{++<+',
		'   N                                                          *',
		'   +f                                   +++++++++++++++++++++++',
		'   +                                    +                     +',
		'   ++*+<+++<+++++++++++++++++++++++++++++                     +',
		'   +   k+   [|]+                                              +',
		'   +    +-"    +                                              +',
		'   +    #      +                                              +',
		'   +   c+    bv+                                              +',
		'   +    @      +                                              +',
		'   +   t+      +                                              +',
		'   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++',
		'                                                               '
	);

	MAP_EVENT_01: array[0..22] of TMapEventDesc =
	(
		(pos: (x: 62; y: 13); eventType: etOpen; id: 6; flag: 10),
		(pos: (x: 35; y: 10); eventType: etOpen; id: 1; flag: 11),
		(pos: (x: 25; y: 10); eventType: etOpen; id: 2; flag: 12),
		(pos: (x: 15; y: 10); eventType: etOpen; id: 3; flag: 13),
		(pos: (x:  7; y: 10); eventType: etOpen; id: 4; flag: 14),
		(pos: (x:  3; y: 13); eventType: etOpen; id: 5; flag: 15),
		(pos: (x: 44; y: 13); eventType: etOn;   id: 1; flag: 1),
		(pos: (x: 35; y: 11); eventType: etOn;   id: 2; flag: 2),
		(pos: (x: 25; y: 11); eventType: etOn;   id: 3; flag: 3),
		(pos: (x: 15; y: 11); eventType: etOn;   id: 4; flag: 4),
		(pos: (x:  7; y: 11); eventType: etOn;   id: 5; flag: 5),
		(pos: (x:  4; y: 13); eventType: etOn;   id: 6; flag: 6),
		(pos: (x:  5; y: 15); eventType: etOn;   id: 7; flag: 7),
		(pos: (x:  5; y: 17); eventType: etOn;   id: 8; flag: 8),
		(pos: (x:  1; y:  6); eventType: etOn;   id: 9; flag: 9),
		(pos: (x:  2; y:  5); eventType: etOn;   id: 9; flag: 9),
		(pos: (x:  2; y:  4); eventType: etOn;   id: 9; flag: 9),
		(pos: (x: 35; y: 10); eventType: etRead; id: 1; flag: 21),
		(pos: (x: 25; y: 10); eventType: etRead; id: 2; flag: 22),
		(pos: (x: 15; y: 10); eventType: etRead; id: 3; flag: 23),
		(pos: (x:  7; y: 10); eventType: etRead; id: 4; flag: 24),
		(pos: (x:  3; y: 13); eventType: etRead; id: 5; flag: 25),
		(pos: (x:  7; y: 17); eventType: etSearch; id: 1; flag: 100)
	);

	MAP_NPC_01: array[0..2] of TMapNPCDesc =
	(
		(charType: 0; pos: (x: 60; y: 13); name: ''),
//		(charType: 0; pos: (x:  6; y: 17); name: ''),
		(charType: 2; pos: (x:  4; y: 20); name: '�����1'),
		(charType: 3; pos: (x:  6; y: 20); name: '�����2')
	);

implementation

uses
	UGameMain, UTileMap;

const
	TALK_WITH_HELPMAN2 = 2;

procedure G_TEXT(color : integer; s : widestring);
begin
	g_textArea.WriteLn(s);
end;

procedure G_INQUERY(color : integer; complete : widestring; incomplete : widestring);
begin
	g_inputArea.InputQuery(complete + incomplete);
end;

procedure InitProc01(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	(sender as TTileMap).RegisterTimeEvent(100, 1);
end;

procedure TalkData01(personalId : integer; const question : widestring; const fullInput : wideString = '');
begin
	case personalId of
	1:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.Write('�׷� ������ ����');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			if g_tileMap[5,16] = OBJ_DOOR_OPEN then begin
				g_textArea.Clear();
				g_textArea.Write('���� �ڳ�, ���� �� ���� �� �� �ݰ� ��� ����. �� ���� ���� ''A''Ű�� ����Ѵٴ� ������ �˰� ����?');
				g_textArea.WriteLn('');
				g_textArea.ReservedClear();

				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else begin
				g_textArea.Clear();
				g_textArea.Write('�����. ���� ó������? ���� �̸��� �˰�ʹٸ� �Ʒ� �Է� â�� ');
				g_textArea.Write('�̸�', tcMonolog);
				g_textArea.WriteLn('�̶�� ���� enterŰ�� ��������.');
				g_textArea.WriteLn('');
			end;
		end
		else if question = '�̸�' then begin
			g_textArea.Write('�ڳ״� ��� ���� ������ ��ȭ ����� ������ �Ŷ��. ��� ��ȭ�� �ڳװ� �ǳ״� ���� ���� �������. '+
							 '�ڳװ� �ñ����� ���� ���� �̸��̰�, �� ������ ���� ����� ���ڸ� ���� ''�����1''����. '+
							 '�˰� �𸣰� �� ���󿡴� ������ ������ �ִ� ������� ����. ');
			g_textArea.Write('�츮���� ');
			g_textArea.Write('�����', tcMonolog);
			g_textArea.WriteLn('ó��.');
			g_textArea.WriteLn('');
			g_textArea.WriteLn('�׸��� ��ȭ�� ������ ������ �׳� enter Ű�� ������ ��. �ƴϸ� �׳� ����Ű�� �̿��ؼ� �� ������ ������ ������ ����������.');
			g_textArea.WriteLn('');

			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '�����' then begin
			g_textArea.WriteLn('������� Ư���� ���� �ƴϰ� �̷��� ������ ������ �ְ�� �ణ�� �����Ḧ �޴� �����̾�.');
			g_textArea.WriteLn('');
		end
		else if question = '�����1' then begin
			if g_tileMap.NameFlag[personalId] then begin
				g_textArea.WriteLn('��, �� �̸��� �Ҹ��̶� �ִ°հ�?');
			end
			else begin
				g_textArea.WriteLn('�� ����ü �����淡 ������ ������ ���� �� �̸��� �˰� �ִ°���?');
			end;
			g_textArea.WriteLn('');
		end
		else if question = '������' then begin
			g_textArea.WriteLn('�״��� ���� ������� �ƴ����� �׳��� �԰� �츸�� ����.');
			g_textArea.WriteLn('');
		end
		else begin
			case Random(3) of
			0:   G_TEXT(0,'�װ� ���� �ǹ�����? ���� �� �𸣰ڴµ�...');
			1:   G_TEXT(0,'�װ��� ���� �� �𸣴� ���̱�.');
			else G_TEXT(0,'�� �˾� �����. �ٽ� �� �� �̾߱��شٿ�.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	2:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('�׷� ��ſ� ���� �Ǽ���.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end

		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();

			if g_inventory.Search(ITEM_MY_ROOM_KEY) then begin
				g_textArea.WriteLn('��� ���� ���踦 ����ϴ� ���� ������ ���� �ƴϽ���?');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('���� ''Z''Ű�� ������ ��� ���� ���踦 �տ� ��ϴ�. �׸��� ''A''Ű�� �̿��ؼ� ����� ���ϴ� �ൿ�� �ϸ� �Ǵ� ������. ���踦 �տ� ����� ���� �ൿ�̶� ����� ���� ���� ���� ���ϴ� ���Դϴ�.');
				g_textArea.WriteLn('');
			end
			else if g_inventory.Search(ITEM_UNKNOWN_KEY) then begin
				if g_tileMap.MapFlag[0, TALK_WITH_HELPMAN2] then begin
					g_textArea.WriteLn('�� ã�� ���̱���. �� ����� �ٸ� �ƴ� ��� ���� ������ϴ�. ���� ������ ������ ���͵帮�� ���� ����� �ָӴϿ��� ��½������. �׷� ���� ��ȸ�� �� �����ô�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('��.... �쿬�� ã�� ��������? �̸� �̰��� ���� �������� ���� �� �̻� ������ �帱 ���� �����ϴ�.');
					g_textArea.WriteLn('');
				end;
				g_inventory.Remove(ITEM_UNKNOWN_KEY);
				g_inventory.Add(ITEM_MY_ROOM_KEY);
			end
			else begin
				if g_tileMap.MapFlag[0, TALK_WITH_HELPMAN2] then begin
					g_textArea.WriteLn('���� �� ã�ҳ���? �� ������ ĳ����� �˻�(''S''Ű)�Ͻ� �� �װ��� ���� ��(''A''Ű) ������ ���ø� �˴ϴ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('�ȳ��ϼ���. ���� �̸��� �����2�̰� ���� ������ �帱 ���� ������ ã�� ����Դϴ�.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('������ ã�� ������� �� ������ �ֽ��ϴ�. ���� ���� ����� ''S''(search)Ű�� ������ ������ ������ �˻��� �� �����ΰ��� �߰ߵǾ��� �� ''A''(aquire)Ű�� ������ ������ ���Դϴ�.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('�׸��� �� ���� ������δ� ''Q''(quickly look around)�� ��ü�� Ȯ���� �� ''A''(accept)�� ���� �˻��� �ϴ� ���� �ֽ��ϴ�. ���� �˻� �� �� ������ ������ ���� ���� �տ��� ���� �Ͱ� '+
									   '���������� ''A''(aquire)Ű�� ������ ������ �˴ϴ�. ���� �˻��� �Ϸ��� ���� �ٷ� ���� �־�߰���?');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('�׷� �� �� ������ �����? ���� ���� ���ʿ� ĳ����� �˻��ؼ� ã�� � ������ ������ ������ ������.');
					g_textArea.WriteLn('');

					g_tileMap.NameFlag[personalId] := TRUE;

					g_statusArea.Clear();
					g_statusArea.WriteLn('[Tutorial]', tcEvent);
					g_statusArea.WriteLn('-- ''S''Ű�� ������ �˻�����', tcHelp);
					g_statusArea.WriteLn('');
					g_statusArea.WriteLn('TIP: ''S''Ű�� ������ ������ ���ǿ� ���� �˻��� �� �ִ�. � ���� �߰ߵǾ��� �� ''A''Ű�� ���� �װ��� ���� �� �ִ�.', tcHelp);
				end;
			end;

			g_textArea.ReservedClear();

			g_tileMap.MapFlag[0, TALK_WITH_HELPMAN2] := TRUE;

			g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
		end
		else begin
			case Random(3) of
			0: G_TEXT(0,'������ �׷��� ���� ���ŵ�....');
			1: G_TEXT(0,'�� �𸣴� ���̳׿�.');
			else G_TEXT(0,'�� �ٻ۵� �峭ġ�� ���� �ֽǷ���?');
			end;
		end;
	end;
	else begin
		G_TEXT(0, '�� �޽����� ���̸� ����� �������� �Ű��� �ּ���. �����Դϴ�.');
		g_InputArea.HideCaret;
		g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
	end;
	end;

	if question = KEYWORD_BYE then begin
		g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
	end;
end;

function EventData01(eventType: TEventType; eventId : integer): boolean;
begin
	result := TRUE;

	case eventType of
		etOn:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('����� ������� ����Ʈ��. ��Ȯ�ϰԴ� ���뿡 ������.');
				g_textArea.WriteLn('4���� ��� ������ 4���� �� ������� �׷� ����Ʈ������ ���⼭ ��ƿ� 3�Ⱓ�� ���������ʹ� �޵� ���� ���ߴ�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('''�����... ���� �� ����Ʈ ������ ��Ƶ� ���������� 100���� ���ڴ�.''', tcMonolog);
				g_textArea.WriteLn('');
				g_tileMap.RegisterTimeEvent(100, 3);
			end;
			2:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('����� �� ���� �ƴϴ�. 3�Ⱓ ��ƿ��鼭�� �̰��� ������ ���� ���� ����.');
				g_textArea.ReservedClear();
			end;
			3:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('402ȣ�ΰ�? ���⿡�� �̻��� ������ ���� ���ڰ� ��� �ִ�. ' +
								   '������ �� �� ���ڰ� �⸣�� ���� �ϵ� �ò����� ¢��뼭 �� ���ڿ� ���� �ο� ���� �ִµ� �� ���ķ� �ƿ� �󱼵� �������� �ʴ´�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('����� ���� ���ϰ� �ִ�.');
				g_textArea.ReservedClear();
			end;
			4:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('���� ������ ũ�� Ʋ�� ���� ������ ������ ���ʹ� ������ ������ �̿��̴�.');
				g_textArea.ReservedClear();
			end;
			5:
			begin
				g_textArea.Clear();
				if g_inventory.Search(ITEM_MY_ROOM_KEY) then begin
					g_textArea.WriteLn('������ ſ�� ��ġ ���� ����� �Ҿ� ���ȴٰ� ã�� �����̴�. ���� ���� ���� ����߰ڴ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('���� ������ �Դ�. ���踦 ����ؼ� ���� ����߰ڴ�.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('��!!�׷��� �и� �� �ָӴϿ� �־�� �� ���谡 ������ �ʴ´�. ��� �����?');
					g_textArea.WriteLn('');
					result := FALSE;
				end;
				g_textArea.ReservedClear();
			end;
			6:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('405ȣ, �Ա��� �츮 ���� �Ա��� �پ� �ִ�. �̻���� 6���� ���� �Ǿ��µ� ' +
								   '���� ����ĥ �� ���� ��ġ������ �ǿܷ� ����ģ ���� ���� ����. ���� �� ���̼� ���븦 �ϰ� �ִ�.');
				g_textArea.ReservedClear();
			end;
			7:
			begin
				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''A''Ű�� ������ ����', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: �Ϲ� ��Ȳ���� ''A''(action)Ű�� ������, �ڽ��� ���� ���� �տ� �ִ� ��ü�� ���� �ൿ�� ���Ѵ�. '+
									  '���� ��� �� �տ����� ���� ���ų� ���� �� �ִ�.', tcHelp);
			end;
			8:
			begin
				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''W''Ű�� ��ȭ ��븦 ã��', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: ''W''(who)Ű�� ������ �ڱ� �ֺ��� ��ȭ ������ ��븦 ã�´�. �׸��� ��ȭ ��븦 ã�� �� ''A''Ű�� ������ �� ����� ��ȭ�� �� �� �ִ�.', tcHelp);
			end;
			9:
			begin
				g_textArea.Clear();
				g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_MY_ROOM);
				g_inventory.Remove(ITEM_MY_ROOM_KEY);
				g_inventory.Remove(ITEM_UNKNOWN_KEY);
			end;
		end;

		etOpen:
		case eventId of
			1, 2, 3, 5:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('���赵 ���µ� ���� �� ���� �� �� ���� ���� ����.');
				g_textArea.WriteLn('���� �� ���� ���ٰ� �ص� ���� �ҹ� ħ���˿� �ش��Ѵ�.');
				g_textArea.ReservedClear();
				result := FALSE;
			end;
			4:
			begin
				g_textArea.Clear();
				if g_tileMap[7,10] = OBJ_DOOR_NAMED_OPEN then begin
					g_tileMap[7,10] := OBJ_DOOR_NAMED_CLOSE;
				end
				else begin
					if g_inventory.Search(ITEM_MY_ROOM_KEY) then begin
						if g_tileMap.GetPC.Equipment.itemId = ITEM_MY_ROOM_KEY then begin
							g_tileMap[7,10] := OBJ_DOOR_NAMED_OPEN;
						end
						else begin
							g_textArea.WriteLn('���� ��� ������ ���踦 ����ؼ� ����� �Ѵ�.');

							g_statusArea.Clear();
							g_statusArea.WriteLn('[Tutorial]', tcEvent);
							g_statusArea.WriteLn('-- ''Z''Ű�� �տ� �� ������ ��������', tcHelp);
							g_statusArea.WriteLn('');
							g_statusArea.WriteLn('TIP: ''Z''Ű�� ������ ���� ���� ���� �߿� �տ� �� ���� �����Ѵ�. �׷��� ������ ''A''(action)Ű�� ���� ��� �ִ� ������ ����Ѵٴ� �ǹ̰� �ȴ�..', tcHelp);
						end;
					end
					else begin
						g_textArea.WriteLn('���谡 ������ �� ���� ���� ���� ���Ѵ�.');
					end;
					g_textArea.ReservedClear();
					result := FALSE;
				end;
			end;
			6:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('����� ���� ��� �ö�Դ� ����Ա���.');
				g_textArea.WriteLn('����� ������� �ö�Դµ� �ٽ� �������� ������ �ʴ�.');
				g_textArea.ReservedClear();
				result := FALSE;
			end;
		end;

		etReadQuery:
		case eventId of
			1:
			begin
				g_textArea.WriteLn('�� �տ��� 401ȣ��� �����ִ�.');
				g_textArea.WriteLn('');
			end;
			2:
			begin
				g_textArea.WriteLn('�� �տ��� 402ȣ��� �����ִ�.');
				g_textArea.WriteLn('');
			end;
			3:
			begin
				g_textArea.WriteLn('���� ��ƼĿ�� ���� ���� �پ� �ֱ� ������ ������ 403ȣ��� �����ִ�.');
				g_textArea.WriteLn('');
			end;
			4:
			begin
				g_textArea.WriteLn('404ȣ��� �����ִ� ����� �� ������ ���� ���� �Ա���.');
				g_textArea.WriteLn('');
			end;
			5:
			begin
				g_textArea.WriteLn('�� �տ��� 405ȣ��� �����ִ�.');
				g_textArea.WriteLn('');
			end;
		end;

		etSearch, etSearchQuery:
		case eventId of
			1:
			if eventType = etSearchQuery then begin
				g_textArea.WriteLn('ĳ��� �ȿ� ��¦�̴� �ݼ� ������ ���δ�.');
				g_textArea.WriteLn('');
			end
			else begin
				if not (g_inventory.Search(ITEM_UNKNOWN_KEY) or g_inventory.Search(ITEM_MY_ROOM_KEY)) then begin
					g_textArea.Clear();
					g_textArea.WriteLn('''�̰��� �����ΰ�?''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('���� ĳ��� ���� ���踦 ��� �ָӴϿ� �־���');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[�ǹ��� ���� +1]', tcEvent);
					g_textArea.WriteLn('');
					g_textArea.ReservedClear();

					g_inventory.Add(ITEM_UNKNOWN_KEY);
				end
				else begin
					g_textArea.WriteLn('ĳ��� ���� ��� �ִ�.');
					g_textArea.WriteLn('');
				end;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('������ ������ ���� ���̴�.');
				g_textArea.WriteLn('�� �ô����� �����̶��ð� ������� ��� ���� �ְŴ� �ްŴ� �ϴ� �׷� ������ �־���. '+
								   '���� ��ӵǴ� �߱ٿ��ٰ� ���õ��� ������ ���� ���µ� �� ���� �ؼ� �ڸ��� ���ϰ� �;����� '+
								   '�װ��� �� ������� �� ���� �����ϴ�.');
				g_textArea.WriteLn('');
				g_tileMap.RegisterTimeEvent(60, 2);
			end;
			2:
			begin
				g_textArea.WriteLn('�Ȱ� �ִ� ���߿��� ������ ��� ���� ���� �ﷷ�Ÿ��� �ٰ����� �� ���Ұ� ���� �ÿ��ϰ� '+
								   '�Կ����� �׳��� �� �� ������ �� ���� �ٵ� �װ��� ���� ������ �ʾҴ�.');
				g_textArea.ReservedClear();
			end;
			3:
			begin
				g_textArea.WriteLn('������ ���� �Ա��� �ٵ� ����ϴ�. �츮 ���� ã�ƾ� �Ѵ�. ''404ȣ''');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('��� ����� ���󼭴� ��� ���� ��ȣ�� ���� ������ �װ��� �����ϱ� �����̴�. ' +
								   '��� ���� �� �� ��ȣ ���п� ���麸�� �� ������ �� ����Ʈ�� ��� �� �� �־���.');
				g_textArea.WriteLn('');
				g_textArea.ReservedClear();

				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''Q''Ű�� ���� ��ȣ�� Ȯ������', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: ''Q''Ű�� ������ ������ �����ִ� �Ϳ� ���� ������ �� ���� �ִ�. Ű�� ���� ���� �׻� ����Ű�� ���� �Ѵ�.', tcHelp);
			end;
		end;

	end;

end;

end.

	g_textArea.WriteLn('������ ��������Դϴ�. ��ĥ������ �ܿ� �ó������� ��� �����ϴ�. ���� �� ������ �ó����������� �ϼ��� �����̸� 2005�� 2�� 13���� ��ǥ�� �����ϰ� �ֽ��ϴ�. '+
					   '�׳��� ���� ''����������''��� ������ ����� ���� �� 10��° �Ǵ� ���̸� �װ��� ����ϱ� ���ؼ� ����� ���Դϴ�.', tcHelp);
	g_textArea.WriteLn('');
	g_textArea.WriteLn('�Ƹ� ������ http://avej.com/�� ���� ������ ���̸�, ���� ���� Ȩ�������� http://smgal.com/������ ��� �߰� ������ ���� ����� ���� ���Դϴ�.', tcHelp);
	g_textArea.WriteLn('');
	g_textArea.WriteLn('(����� escŰ).');
	g_textArea.WriteLn('');
	g_tileMap.GetPC.Warp(61*28, 22*32);
	g_statusArea.Clear();

