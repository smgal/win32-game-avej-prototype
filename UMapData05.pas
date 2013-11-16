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
		'▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦',
		'▦▦▒＊▒▒▒▒▒▒▒▒▒▒▦　　　　▦',
		'▦▦▒▦▒▒▒▒▒▒▒▒▒▒▦　　　　▦',
		'▦▦▒▦▒▒▒▒▒▒▒▒▒▒▦　　　　▦',
		'▦▦▒▦▒▒▒▒▒▒▒▒▒▒▦　　　　▦',
		'▦▦▒▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦',
		'▦▒◇▒▒∏∏♧♧▒▦∴∴▦♧♧♧▦↗▦',
		'▦∏▒▒▒▒▒▒▒▒▦▦▦▦　　　▦＊▦',
		'▦▒▒▒▒▒▒▒▒▒８　　＃　　　　　▦',
		'▦▒▒▒▒▒▒▒▒▒▦▦▦▦　　　　　▦',
		'▦∏∂▒▒▒▒▒◆◆▦∴∴▦♧　　　　▦',
		'▦▦▦▦▦▦▦▦▦▦▦∴∴▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦',
		'▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▦▤◇▒〓〓▒♧♧▦↗▤▒Œ♀▒↗▦',
		'▦⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▦▒▒▒▒▒▒▒▒▒▒□▒▒▒▒▒▦',
		'▦⊙⊙⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▦♧♧▒▒▒▒▒▒▒▒▤▒▒▒▒♧▦',
		'▦▦▦▦▦▦▦▦▦▦▦▦□▦▦▦▦▦▦▦▦▦Ｎ▦▦▦□▦▦▦▦▦▦▣▣▣▦▦▦▦▦▦▦▦▦▦▦▦▦＊▦▦▦▦▦▦▦▦▦＊▦▦▦▦▦▦▦▦▦▦▦',
		'▦◇◇пⅡ　　　▥♧◇▒▒▒∂▒▦　　♧♧　　　　　　　Ⅱ∂　◆▦▣▣▣▦▒▒▒▒▒▒▒▒▒▒▦※※◆◆◆◆◆◆◆◆※※※▤▤　　　　　　　▦',
		'▦◇　　　　　　▥▒▒▒▒〓〓▒▦　　　　　　　　　　　Ⅱ∂　◆▦▣▣▣▦▒▒▒▒▒▒▒▒▒▒▦※※※※※※※※※※※※※▤▤　　　　　　　▦',
		'▦◇　　　￥　　！▒▒▒▒▒▒▒▦　　　　　　　　　　　Ⅱ∂　◆▦▣▣▣▦▒▒▒▒▒▒▒▒▒▒▦※ⅹ※ⅹ※ⅹ※ⅹ※ⅹ※ⅹ※▤▤　　　　　　　▦',
		'▦◇　　〓〔〕　▥▒▒▒▒▒▒▒□　　　　　　　　　　　Ⅱ∂　◆▦▣▣▣▦▒▒▒▒▒▒▒▒▒▒▦※ⅹ※ⅹ※ⅹ※Ⅹ※ⅹ※ⅹ※▤▤　　　　　　　▦',
		'▦▥▥▥▥▥▥▥▥▥▥▥▒▒▒▒▦　　　〓〔‡〕〔‡〕　　　　　□▣▣▣▦▒▒▒▒▒▒▒▒▒▒▦※ⅹ※Ⅹ※ⅹ※ⅹ※ⅹ※ⅹ※▤▤　　　　　　　▦',
		'▦↖　　　　　Ⅱ▥↖▒▒▒▒▒▒＊　　　　　п　　п　　　　♧♧▦▣⊙▣▦▒▒▒▒▒▒▒▒▒▒▦※ⅹ※ⅹ※ⅹ※ⅹ※ⅹ※ⅹ※▤▤　　　　　　　▦',
		'▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▣▣▣▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦'
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
					g_textArea.WriteLn('캐비넷에는 절연지로 싸여 있는 무언가가 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''이것이 오르츠가 말하던 파이로전기탄인가보네.''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[파이로전기탄 +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_PYRO_BOMB);
					g_tileMap.MapFlag[0, FLAG_GET_PYRO_BOMB] := TRUE;
				end;
			end;
			2:
			if not g_tileMap.MapFlag[0, FLAG_GET_WISKEY] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('열려진 상자 안에는 어떤 병이 보인다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('''그다지 비싸 보이지는 않는 술이로군.''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[평범해 보이는 술 +1]', tcEvent);
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
					g_textArea.WriteLn('책장을 밀 수 있도록 아래에 레일이 깔려 있었고, 힘을 주어 옆으로 밀자 책장은 삐걱 삐걱 소리를 내며 레일 위를 움직였다.');
					g_textArea.WriteLn('');
					g_tileMap[1, 6] := g_tileMap[2, 6];
					g_tileMap[2, 6] := g_tileMap[3, 6];
					result := TRUE;
				end
				else begin
					g_textArea.WriteLn('책장을 밀 수 있도록 아래에 레일이 깔려 있지만 오랫동안 사용하지 않은 탓인지 나의 힘으로는 밀리지 않았다.');
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
					g_textArea.WriteLn('문 손잡이의 잠금을 해제했다.');
					g_textArea.WriteLn('');
					g_tileMap.MapFlag[0, FLAG_OPEN_BACK_LOCKED_DOOR] := TRUE;
				end
				else begin
					g_textArea.WriteLn('문의 손잡이가 돌아가지 않는다. 아마도 안쪽으로 잠긴듯 하다.');
					g_textArea.WriteLn('');
				end;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('약간은 역겨운 곰팡이 냄새가 나는 지하실이다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('그다지 자주는 사용하는 것 같지는 않지만 바닥은 세월 흔적이 그대로 묻어 있었고 전체적으로 오래전에 만든 곳임을 알 수 있었다. 아마도 지금은 이 가게의 창고로 쓰이고 있는 것 같다.');
				g_textArea.WriteLn('');
			end;
			2:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('잘 정리되어 있는 박스가 나열되어 있는 방이다. 아마도 이 가게에서 판매하고 있는 물건들이 들어 있는 것 같다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('''혹시 여기에서 물건을 가져가면 절도죄가 되나?''', tcMonolog);
				g_textArea.WriteLn('');
			end;
		end;
	end;
end;

end.

