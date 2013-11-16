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
					g_textArea.WriteLn('''TV를 손으로 때리면 안된다.', tcMonolog);
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
					g_textArea.WriteLn('''TV를 손으로 때리면 안된다.', tcMonolog);
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
				g_textArea.WriteLn('''이...이것은 무엇인가가 이상하다.''', tcMonolog);
				g_textArea.WriteLn('');
				g_textArea.WriteLn('단지 TV 리모콘으로 TV 채널을 바꾸었을 뿐인데 주위의 모습이 변해 버렸다. 주위의 모습이 변했다기 보다는 마치 내가 다른 곳으로 이동해 온 것만 같다. 채널을 바꾸는 것은 단지 TV가 동조하는 주파수를 변경한다는 것일 뿐 더 이상의 아무런 의미가 없어야 하는 것이다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('눈 앞에 펼쳐진 믿기지 않는 이 변화는 그냥 꿈으로 치부해버리기에는 너무 생생하다.');
				g_textArea.WriteLn('');
			end;
		end;
	end;
end;

end.

