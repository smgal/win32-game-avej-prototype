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
		(charType: 2; pos: (x:  4; y: 20); name: '도움맨1'),
		(charType: 3; pos: (x:  6; y: 20); name: '도움맨2')
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
			g_textArea.Write('그래 다음에 봅세');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			if g_tileMap[5,16] = OBJ_DOOR_OPEN then begin
				g_textArea.Clear();
				g_textArea.Write('어이 자네, 들어올 땐 제발 문 좀 닫고 들어 오게. 문 닫을 때도 ''A''키를 사용한다는 것쯤은 알고 있지?');
				g_textArea.WriteLn('');
				g_textArea.ReservedClear();

				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else begin
				g_textArea.Clear();
				g_textArea.Write('어서오게. 여기 처음이지? 나의 이름이 알고싶다면 아래 입력 창에 ');
				g_textArea.Write('이름', tcMonolog);
				g_textArea.WriteLn('이라고 쓰고 enter키를 눌러보게.');
				g_textArea.WriteLn('');
			end;
		end
		else if question = '이름' then begin
			g_textArea.Write('자네는 방금 가장 간단한 대화 방식을 깨달은 거라네. 모든 대화는 자네가 건네는 말에 따라 진행되지. '+
							 '자네가 궁금해한 것은 나의 이름이고, 그 질문에 대한 대답을 하자면 나는 ''도움맨1''이지. '+
							 '알게 모르게 이 세상에는 남에게 도움을 주는 사람들이 많아. ');
			g_textArea.Write('우리같은 ');
			g_textArea.Write('도움맨', tcMonolog);
			g_textArea.WriteLn('처럼.');
			g_textArea.WriteLn('');
			g_textArea.WriteLn('그리고 대화를 끝내고 싶으면 그냥 enter 키를 누르면 돼. 아니면 그냥 방향키를 이용해서 딴 곳으로 움직여 버려도 마찬가지야.');
			g_textArea.WriteLn('');

			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '도움맨' then begin
			g_textArea.WriteLn('도움맨은 특별한 것은 아니고 이렇게 남에게 도움을 주고는 약간의 수수료를 받는 직업이야.');
			g_textArea.WriteLn('');
		end
		else if question = '도움맨1' then begin
			if g_tileMap.NameFlag[personalId] then begin
				g_textArea.WriteLn('뭐, 내 이름에 불만이라도 있는겐가?');
			end
			else begin
				g_textArea.WriteLn('넌 도대체 누구길래 가르쳐 주지도 않은 내 이름을 알고 있는거지?');
			end;
			g_textArea.WriteLn('');
		end
		else if question = '수수료' then begin
			g_textArea.WriteLn('그다지 많은 수수료는 아니지만 그나마 먹고 살만은 하지.');
			g_textArea.WriteLn('');
		end
		else begin
			case Random(3) of
			0:   G_TEXT(0,'그건 무슨 의미이지? 뜻을 잘 모르겠는데...');
			1:   G_TEXT(0,'그것은 내가 잘 모르는 것이군.');
			else G_TEXT(0,'못 알아 들었어. 다시 한 번 이야기해다오.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	2:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('그럼 즐거운 게임 되세요.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end

		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();

			if g_inventory.Search(ITEM_MY_ROOM_KEY) then begin
				g_textArea.WriteLn('당신 방의 열쇠를 사용하는 법을 잊으신 것은 아니시죠?');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('먼저 ''Z''키를 눌러서 당신 방의 열쇠를 손에 듭니다. 그리고 ''A''키를 이용해서 당신이 원하는 행동을 하면 되는 것이죠. 열쇠를 손에 들었을 때의 행동이란 열쇠로 문을 여는 것을 말하는 것입니다.');
				g_textArea.WriteLn('');
			end
			else if g_inventory.Search(ITEM_UNKNOWN_KEY) then begin
				if g_tileMap.MapFlag[0, TALK_WITH_HELPMAN2] then begin
					g_textArea.WriteLn('잘 찾아 오셨군요. 이 열쇠는 다름 아닌 당신 집의 열쇠랍니다. 제가 게임의 진행을 도와드리기 위해 당신의 주머니에서 슬쩍했지요. 그럼 다음 기회에 또 만납시다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('음.... 우연히 찾은 것이지요? 미리 이것을 가져 오셨으니 제가 더 이상 가르쳐 드릴 것이 없습니다.');
					g_textArea.WriteLn('');
				end;
				g_inventory.Remove(ITEM_UNKNOWN_KEY);
				g_inventory.Add(ITEM_MY_ROOM_KEY);
			end
			else begin
				if g_tileMap.MapFlag[0, TALK_WITH_HELPMAN2] then begin
					g_textArea.WriteLn('아직 못 찾았나요? 제 위쪽의 캐비넷을 검색(''S''키)하신 후 그것을 가진 후(''A''키) 저에게 오시면 됩니다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('안녕하세요. 저의 이름은 도움맨2이고 제가 도움을 드릴 것은 물건을 찾는 방법입니다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('물건을 찾는 방법에는 몇 가지가 있습니다. 가장 쉬운 방법은 ''S''(search)키를 눌러서 주위의 물건을 검색할 후 무엇인가가 발견되었을 때 ''A''(aquire)키를 눌러서 가지는 것입니다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('그리고 그 다음 방법으로는 ''Q''(quickly look around)로 물체를 확인할 후 ''A''(accept)를 눌러 검색을 하는 것이 있습니다. 물론 검색 후 그 물건을 가지고 싶을 때는 앞에서 말한 것과 '+
									   '마찬가지로 ''A''(aquire)키를 눌러서 가지면 됩니다. 물론 검색을 하려면 물건 바로 옆에 있어야겠죠?');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('그럼 한 번 시험해 볼까요? 지금 저의 위쪽에 캐비넷을 검색해서 찾은 어떤 물건을 나에게 가져와 보세요.');
					g_textArea.WriteLn('');

					g_tileMap.NameFlag[personalId] := TRUE;

					g_statusArea.Clear();
					g_statusArea.WriteLn('[Tutorial]', tcEvent);
					g_statusArea.WriteLn('-- ''S''키로 물건을 검색하자', tcHelp);
					g_statusArea.WriteLn('');
					g_statusArea.WriteLn('TIP: ''S''키를 누르면 주위의 물건에 대해 검색할 수 있다. 어떤 것이 발견되었을 때 ''A''키를 통해 그것을 가질 수 있다.', tcHelp);
				end;
			end;

			g_textArea.ReservedClear();

			g_tileMap.MapFlag[0, TALK_WITH_HELPMAN2] := TRUE;

			g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
		end
		else begin
			case Random(3) of
			0: G_TEXT(0,'저에게 그런걸 물어 보셔도....');
			1: G_TEXT(0,'잘 모르는 말이네요.');
			else G_TEXT(0,'전 바쁜데 장난치지 말아 주실래요?');
			end;
		end;
	end;
	else begin
		G_TEXT(0, '이 메시지가 보이면 가까운 경찰서로 신고해 주세요. 버그입니다.');
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
				g_textArea.WriteLn('여기는 내가사는 아파트다. 정확하게는 원룸에 가깝다.');
				g_textArea.WriteLn('4층에 살고 있지만 4층이 맨 꼭대기인 그런 아파트인지라 여기서 살아온 3년간은 엘리베이터는 꿈도 꾸지 못했다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('''제기랄... 내가 낸 아파트 관리비만 모아도 엘리베이터 100개는 놨겠다.''', tcMonolog);
				g_textArea.WriteLn('');
				g_tileMap.RegisterTimeEvent(100, 3);
			end;
			2:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('여기는 내 집이 아니다. 3년간 살아오면서도 이곳의 주인을 만난 적이 없다.');
				g_textArea.ReservedClear();
			end;
			3:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('402호인가? 여기에는 이상한 성격을 가진 여자가 살고 있다. ' +
								   '예전에 이 집 여자가 기르던 개가 하도 시끄럽게 짖어대서 이 여자와 대판 싸운 적이 있는데 그 이후로 아예 얼굴도 마주하지 않는다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('사실은 내가 피하고 있다.');
				g_textArea.ReservedClear();
			end;
			4:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('조금 음악을 크게 틀어 놓는 경향이 있지만 나와는 무난히 지내는 이웃이다.');
				g_textArea.ReservedClear();
			end;
			5:
			begin
				g_textArea.Clear();
				if g_inventory.Search(ITEM_MY_ROOM_KEY) then begin
					g_textArea.WriteLn('과음한 탓에 마치 내가 열쇠는 잃어 버렸다가 찾은 느낌이다. 빨리 집에 들어가서 쉬어야겠다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('드디어 내집에 왔다. 열쇠를 사용해서 문을 열어야겠다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('헉!!그런데 분명 내 주머니에 있어야 할 열쇠가 보이지 않는다. 어디서 흘렸지?');
					g_textArea.WriteLn('');
					result := FALSE;
				end;
				g_textArea.ReservedClear();
			end;
			6:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('405호, 입구가 우리 집의 입구와 붙어 있다. 이사온지 6개월 정도 되었는데 ' +
								   '자주 마주칠 것 같은 위치이지만 의외로 마주친 적은 거의 없다. 여자 두 명이서 자취를 하고 있다.');
				g_textArea.ReservedClear();
			end;
			7:
			begin
				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''A''키로 동작을 하자', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: 일반 상황에서 ''A''(action)키를 누르면, 자신이 향한 방향 앞에 있는 물체에 대한 행동을 취한다. '+
									  '예를 들어 문 앞에서는 문을 열거나 닫을 수 있다.', tcHelp);
			end;
			8:
			begin
				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''W''키로 대화 상대를 찾자', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: ''W''(who)키를 누르면 자기 주변에 대화 가능한 상대를 찾는다. 그리고 대화 상대를 찾은 후 ''A''키를 누르면 그 사람과 대화를 할 수 있다.', tcHelp);
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
				g_textArea.WriteLn('열쇠도 없는데 내가 이 문을 열 수 있을 리가 없다.');
				g_textArea.WriteLn('만약 이 문을 연다고 해도 나는 불법 침입죄에 해당한다.');
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
							g_textArea.WriteLn('문이 잠겨 있으니 열쇠를 사용해서 열어야 한다.');

							g_statusArea.Clear();
							g_statusArea.WriteLn('[Tutorial]', tcEvent);
							g_statusArea.WriteLn('-- ''Z''키로 손에 들 물건을 선택하자', tcHelp);
							g_statusArea.WriteLn('');
							g_statusArea.WriteLn('TIP: ''Z''키를 누르면 현재 지닌 물건 중에 손에 들 것을 선택한다. 그러면 이후의 ''A''(action)키는 현재 들고 있는 물건을 사용한다는 의미가 된다..', tcHelp);
						end;
					end
					else begin
						g_textArea.WriteLn('열쇠가 없으니 내 방의 문도 열지 못한다.');
					end;
					g_textArea.ReservedClear();
					result := FALSE;
				end;
			end;
			6:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('여기는 내가 방금 올라왔던 계단입구다.');
				g_textArea.WriteLn('힘들게 여기까지 올라왔는데 다시 내려가고 싶지는 않다.');
				g_textArea.ReservedClear();
				result := FALSE;
			end;
		end;

		etReadQuery:
		case eventId of
			1:
			begin
				g_textArea.WriteLn('문 앞에는 401호라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
			2:
			begin
				g_textArea.WriteLn('문 앞에는 402호라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
			3:
			begin
				g_textArea.WriteLn('광고 스티커가 덕지 덕지 붙어 있긴 하지만 문에는 403호라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
			4:
			begin
				g_textArea.WriteLn('404호라고 적혀있는 여기는 내 방으로 들어가기 위한 입구다.');
				g_textArea.WriteLn('');
			end;
			5:
			begin
				g_textArea.WriteLn('문 앞에는 405호라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
		end;

		etSearch, etSearchQuery:
		case eventId of
			1:
			if eventType = etSearchQuery then begin
				g_textArea.WriteLn('캐비넷 안에 반짝이는 금속 조각이 보인다.');
				g_textArea.WriteLn('');
			end
			else begin
				if not (g_inventory.Search(ITEM_UNKNOWN_KEY) or g_inventory.Search(ITEM_MY_ROOM_KEY)) then begin
					g_textArea.Clear();
					g_textArea.WriteLn('''이것은 열쇠인가?''', tcMonolog);
					g_textArea.WriteLn('');
					g_textArea.WriteLn('나는 캐비넷 위의 열쇠를 집어서 주머니에 넣었다');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[의문의 열쇠 +1]', tcEvent);
					g_textArea.WriteLn('');
					g_textArea.ReservedClear();

					g_inventory.Add(ITEM_UNKNOWN_KEY);
				end
				else begin
					g_textArea.WriteLn('캐비넷 안은 비어 있다.');
					g_textArea.WriteLn('');
				end;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
				g_textArea.Clear();
				g_textArea.WriteLn('오늘은 유난히 많이 마셨다.');
				g_textArea.WriteLn('별 시답잖은 연말이랍시고 사람들을 모아 놓고 주거니 받거니 하는 그런 모임이 있었다. '+
								   '연일 계속되는 야근에다가 오늘따라 유난히 몸의 상태도 안 좋고 해서 자리를 피하고 싶었지만 '+
								   '그것이 내 마음대로 될 리는 만무하다.');
				g_textArea.WriteLn('');
				g_tileMap.RegisterTimeEvent(60, 2);
			end;
			2:
			begin
				g_textArea.WriteLn('걷고 있는 와중에도 세상은 계속 나를 향해 울렁거리며 다가오는 것 같았고 차라리 시원하게 '+
								   '게워내면 그나마 좀 더 편해질 수 있을 텐데 그것이 뜻대로 되지는 않았다.');
				g_textArea.ReservedClear();
			end;
			3:
			begin
				g_textArea.WriteLn('집으로 들어가는 입구는 다들 비슷하다. 우리 집을 찾아야 한다. ''404호''');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('듣는 사람에 따라서는 기분 나쁠 번호일 수도 있지만 그것은 생각하기 나름이다. ' +
								   '적어도 나는 이 방 번호 덕분에 남들보다 싼 값으로 이 아파트에 들어 올 수 있었다.');
				g_textArea.WriteLn('');
				g_textArea.ReservedClear();

				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''Q''키로 문의 번호를 확인하자', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: ''Q''키를 누르면 주위에 관심있는 것에 대한 설명을 볼 수가 있다. 키를 누를 때는 항상 방향키를 떼야 한다.', tcHelp);
			end;
		end;

	end;

end;

end.

	g_textArea.WriteLn('게임은 여기까지입니다. 며칠전부터 겨우 시나리오에 들어 갔습니다. 현재 이 게임은 시나리오까지는 완성된 상태이며 2005년 2월 13일을 목표로 제작하고 있습니다. '+
					   '그날은 제가 ''비전속으로''라는 게임을 만들어 낸지 딱 10년째 되는 날이며 그것을 기념하기 위해서 만드는 것입니다.', tcHelp);
	g_textArea.WriteLn('');
	g_textArea.WriteLn('아마 게임은 http://avej.com/을 통해 공개될 것이며, 저의 개인 홈페이지인 http://smgal.com/에서는 계속 중간 과정에 대한 언급이 있을 것입니다.', tcHelp);
	g_textArea.WriteLn('');
	g_textArea.WriteLn('(종료는 esc키).');
	g_textArea.WriteLn('');
	g_tileMap.GetPC.Warp(61*28, 22*32);
	g_statusArea.Clear();

