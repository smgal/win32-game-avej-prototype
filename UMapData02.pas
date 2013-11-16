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
				g_textArea.WriteLn('''여기는 내가 창고로 쓰고 있는 방이다''', tcMonolog);
				g_textArea.WriteLn('');
			end;
			2:
			begin
				if not g_inventory.Search(ITEM_TV_REMOCON) then begin
					g_textArea.WriteLn('''TV를 보려면 리모콘이 필요하다''', tcMonolog);
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''TV를 보려면 리모콘을 사용해야 한다''', tcMonolog);
					g_textArea.WriteLn('');

					g_statusArea.Clear();
					g_statusArea.WriteLn('[Tutorial]', tcEvent);
					g_statusArea.WriteLn('-- ''Z''키로 물건을 사용하자', tcHelp);
					g_statusArea.WriteLn('');
					g_statusArea.WriteLn('TIP: ''Z''키를 누르면 현재 손에 들 물건을 선택할 수 있다.', tcHelp);
				end;

				result := FALSE;
			end;
		end;

		etOpen:
		case eventId of
			1:
			begin
				if not g_tileMap.MapFlag[0, FLAG_TRY_TO_OPEN_DOOR] then begin
					g_textArea.WriteLn('''음.. 이건 뭔가 약간 다른 느낌이''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('방을 나서려했지만 방을 나가서 내가 무엇을 해야 할지 전혀 떠오르지 않았다.');
					g_textArea.WriteLn('');
					g_tileMap.MapFlag[0, FLAG_TRY_TO_OPEN_DOOR] := TRUE;
					result := FALSE;
				end
				else begin
					g_textArea.WriteLn('밖으로 나가기 위해 문을 열었지만 문 뒤는 다시 벽으로 막혀 있었다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('이것은 누군가의 악의가 섞인 장난이 아니라면 틀림없이 꿈인 것이다. 어제의 술이 좀 과했나 보다. 이럴 때는 다시 자리에 누워야 할지 어떻게 해야 할지 잘 모르겠다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('아무리 생각해도 이상하다. 별로 꿈은 아니라고 느껴지는데다가 벽이 막혀 있다는 것 이외에는 모든 것이 평상시와 똑같다.');

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
					g_textArea.WriteLn('침대 위에는 리모콘이 보인다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''아.. 어제 침대 위에서 TV를 보다가 리모콘은 그냥 여기 두었나 보네''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('나는 리모콘을 집어서 주머니에 넣었다');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[TV 리모콘 +1]', tcEvent);
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
					g_textArea.WriteLn('캐비넷 안에는 포스터처럼 보이는 종이가 말려있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''이것은 아는 사람으로부터 받았던 게임 포스터구나.''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('나는 포스터를 집어들었다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[포스터 +1]', tcEvent);
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
					g_textArea.WriteLn('책상 위에는 어떤 메모가 놓여져 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('나는 메모를 집어들었다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[메모+1]', tcEvent);
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
					g_textArea.WriteLn('''TV를 손으로 때리면 안된다.', tcMonolog);
					g_textArea.WriteLn('리모콘을 사용하면 TV를 켤 수 있을 것 같은데...''', tcMonolog);
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
				g_textArea.WriteLn('오늘도 시작되는 일상');
				g_textArea.WriteLn('하루 하루 다를 것 없는 나의 일상이 시작되었다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('햇살이 눈부시다는 것은 내가 지금 일어나서 늘 해오던대로 해야 한다는 것을 의미한다.');
				g_textArea.WriteLn('');
				g_tileMap.RegisterTimeEvent(60, 2);
			end;
			2:
			begin
				g_textArea.WriteLn('어제는 지나치게 많이 마셨나 보다. 방문을 연 것까지는 기억나는데, 그 이후의 일은 기억나지 않는다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('[F1] 키 조작에대한 도움말', tcHelp);
				g_textArea.WriteLn('');
				g_textArea.ReservedClear();
			end;
		end;
	end;

	if eventType in [etOn, etSearch, etOpen] then
		g_textArea.ReservedClear();
end;

end.

