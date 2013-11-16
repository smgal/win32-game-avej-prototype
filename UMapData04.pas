unit UMapData04;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc04(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData04(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData04(eventType: TEventType; eventId : integer): boolean;
function  Char2MapProc04(cTemp: char): longword;

const
	MAP_DATA_04W: array[0..70] of widestring =
	(
		'�ˢˢˢˢˢˢˢˢˢˢˡšŢˢˢˢˢˢˢ�',
		'�ˡޡޢƢƢƢƢ����ƢˡšŢˡޡޡޢˢ٢�',
		'�ˢ��ƢƢƢƢƢƢƢƢˢˢˢˡ������ˣ���', //�آ�
		'�ˢƢƢƢƢƢƢƢƢƣ�������������������', //�ע٢�
		'�ˡϢƢƢƢƢƢƢƢƢˢˢˢˡ�����������', // �̢ˢǢ� ��
		'�ˢƢƢƢƢƨ��ߡߡߢˡšŢˢ��������Ӣ�', // ���� �ӡ̡�
		'�ˢˢˢˢˢˢˢˢˢˢˢ��Ţˢˢˣ΢ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢ�',
		'�ˢââââââââââââââââââââââââââââââââââââ��âââââââˢƣ����������������٢ˡ��������٢ˢ�',
		'�ˢ��ââââââââââââââââââââââ��ââââââââââââââââââââˢƢˢˢˢˢˢˢˢˢˢˡ����������ˢ�',
		'�ˢ������âââââââââââââââââââââââââââââââââââââââââˢƣ��ơߢˢƢƢƢƢƣ������������Ȣ�',
		'�ˢˢˢˢˢˢˢˢˢˢˢˡ�ˢˢˢˢˢˢˢˢˣ΢ˢˢˡ�ˢˢˢˢˢˢâââˢˢˡ�ˢˣ΢ˢˢˣ��ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢȢˢˢˢˢˢˢˢ�',
		'�ˡޡެᥱ�������Ȣ��ޢƢƢơӢƢˡ������������������������ӡ��ߢˢâââˢ����ƢƢƢƢƥ��ߢƢˡޡޡޡޡޡޡޡޡޡޡޡޡߢȡߡ���������������',
		'�ˡޡ������������ȢƢƢƢơ��Ƣˡ������������������������ӡ��ߢˢâââˢƢƢƢƢƢƢƥ��ƢƢˢƢƢƢƢƢƢƢƢƢƢơޢƢǢǢǢǢǢǢǢǣ���',
		'�ˡޡ������͡������ƢƢƢƢƢƢƢˡ������������������������ӡ��ߢˢââã΢ƢƢƢƢƢƢƥ��ƢƢˢƢƢǢǢǢǢǢǢǢǢǢǢǢǢ�����������������',
		'�ˡޡ����롲�����ȢƢƢƢƢƢƢơࡡ�����������������������ӡ��ߢˢâââˢƢƢƢƢƢƢƢƢƢƢˡ��������������������������ˡ�����������������',
		'�ˢȢȢȢȢȢȢȢȢȢȢȢƢƢƢƢˡ������롲�ԡ����ԡ�������������ââá�ƢƢƢƢƢƢƢƢƢƢˡ��������������������������ˡ����������ӡ��ߢ�',
		'�ˢء������������ȢآƢƢƢƢƢƣ������������ᡡ���ᡡ�����������ˢâ��âˢƢƢƢ����ƢƢƢƢƢˢ������������������������Ӣˡ����������ӡ��ߢ�',
		'�ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢâââˢˢˢˢˡ���ˢˢˢˢˢˡ�ˢˢˣ΢ˢˢˡ�ˢˢˢˣ΢ˢˢˢˢˢˢ�',
		'�ˡ������������������������������˥��ȥȥȢˢââââââââ��ââââââââââââââââââââââ��âââââââââââ�',
		'�ˡ������������������������������˥ȡ�ȥȢˢââ��ââââââââââââââââââââââââââââ��ââââ��ââââââ�',
		'�ˡ������������������������������˥��ȥȥ��ˢ��ââââââââââââââââââ��âââââââââââ��âââââââââââ�',
		'�ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢâââ�',
		'�ˡ����������������������������������������ˡ��������������������������������������������ˡ������������������������������ߢˢâ��â�',
		'�ˡ����������������������������������������ˡ��������������������������������������������ˡ������������������������������ߢˢâââ�',
		'�ˡ����������������������������������������ˡ��������������������������������������������ˡ��������������������������������ˢâââ�',
		'�ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˡ��������������������������������������������ˡ����������Ǣǣ����ǢǢ����������ˢâââ�',
		'�ˡšššššššššššššššššššŢˡ��������������������������������������������ˡ��������ǢǢ��ƢƢ��Ǣǡ��������ˢâââ�',
		'�ˡšššššššššššššššššššŢˡ��������������������������������������������ˡ��������Ǣ��ƢƢƢƢ��ǡ��������ˢâââ�',
		'�ˡšššššššššššššššššššŢˡ��������������������������������������������ˡޡޡޡޢǢƢƢƢƢƢƢǡ��������ˢââ���',
		'�ˡšššššššššššššššššššŢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˣΣ΢ˢˢˢˢˢˢˢˢâââˢˢˢˢˢˢ�',
		'�ˡšššššššššššššššššššŢââ��âââââââââââââââââââââââââââââââââââââââââââââââ�',
		'�ˡšššššššššššššššššššŢâââââââââââââââââââââââââââââââââââââ��ââââââââââââ�',
		'�ˡšššššššššššššššššššŢââââââââââââ��ââââââ��ââââââââââââââââââââââââââââââ�',
		'�ˡššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššŢâââ�',
		'�ˡššššššššššššššššššššššššššššššššŢ��ššššššššššššššššššŢ��ššššššššššššŢâââ�',
		'�ˡšššššššššššššššššššššššššššššššššššŢˢˢˢˢˢˢˡšššššššššššššŢˢˢˢˢˢˢˢ��šŢ��ââ�',
		'�ˡšššššššššššššššššššššššššššššššššššŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâââ�',
		'�ˡšššššššššššššššššššššššššššššššššššŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâââ�',
		'�ˡšššššššššššššššššššššššššššššŢ��ššššŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâââ�',
		'�ˡšššššššššššššššššššššššššššššššššššŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâââ�',
		'�ˡššššššššššššššššššššššššššššššššššššŢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢơšššŢâââ�',
		'�ˢâââââââââââââââââââââââââââââââââáššŢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢơšššŢâââ�',
		'�ˢâââââââââââââââââ��âââââââââââââââášŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâââ�',
		'�ˢââââââââââââââââââââââââââââââ��ââášŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâ��â�',
		'�ˢˢˢˢˣ��ˢˢˢˢˢˢˢˢˣ��ˢˢˢˢˢˢˢˢˣ��ˢˢˢˢˢˢââášŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡŢ��Ţâââ�',
		'�ˡ������������������ˡ����������������ˡ����������������������ˢââášŢˢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢƢˡššŢâââ�',
		'�ˡ������������������ˡ����������������ˡ�����������������������ââ��šŢˢˢˢˢˢˢˡšššššššššššššŢˢˢˢˢˢˢˡššŢâââ�',
		'�ˡ������������������ˡ����������������ˡ����������������������ˢââášššššššššŢ��šššššššššššššššššššššŢâââ�',
		'�ˡ������������������ˡ����������������ˡ������������������������ââáššššššššššššššššššššššššššššššššŢâââˢˢ�',
		'�ˡ������������������ˡ����������������ˡ����������������������ˢââášššššŢ��šššššššŢ��ššššššŢ��ššššššššŢâââââ�',
		'�ˡ������������������ˡ����������������ˡ����������������������ˢââáššššššššššššššššššššššššššššššššŢâââââ�',
		'�ˢˢˢˢˣ��ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢââáššššššššššŢ��ššššŢ��ššššššŢ��ššššŢ��Ţâââââ�',
		'�ˡšššššššššššššŢˡ����������ˡ������������������ˢââáššššššššššššššššššššššššššššššššŢââášš�',
		'�ˡšššššššššššššŢˡ��������������������������������ââââââââââââââ��âââââââââââââââââââââââášš�',
		'�ˡšššššššššššššŢˡ����������ˡ������������������ˢââââââââââââââââââââââââââââââââââ��âââášš�',
		'�ˡšššššššššššššţ������������ˢˢˢˢˢˢˢˢˢˢˢâââ��ââââââââââââââââââââââââââââââââââášš�',
		'�ˡšššššššššššššŢˢˢˢˣ��ˢˡ������������������ˢââˢˢˢˢˣ��ˢˢˢˢˢˢˢˣ��ˢˢˢˢˢˢˢˢˢˣ��ˢˢˢˢˡšššššššš�',
		'�ˡšššššššššššššŢˡ��������������ˡ��������������ˢââˡ����������������ˡ������������������ˡ��������������������ˡšššššššš�',
		'�ˡšššššššššššššŢˡ��������������ˡ��������������ˢââˡ����������������ˡ������������������ˡ��������������������ˡšššššššš�',
		'�ˡšššššššššššššŢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢââˡ����������������ˡ������������������ˡ���������������������šššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢâáࡡ���������������ˡ������������������ˡ���������������������šššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢ��âˡ����������������ˡ������������������ˡ���������������������šššŢ��ššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢââˡ����������������ˡ������������������ˢˢˣ��ˢˢˡ��������ˡšššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢââˡ����������������ˢˢˣ��ˢˢˢˢˢˢˡ����������ˢˢˢˢˢˡšššššššš�',
		'�ˡšššššššššššššţ����������������������������������ââˡ����������������ˡ������������ˡ����ˡ��������������������ˡšššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢââˡ����������������ˡ������������������ˡ����������ˡ��������ˡšššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢââˡ����������������ˡ������������ˡ����ˡ����������ˡ��������ˡšššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢââˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˣ��ˢˢˢˢˡ����ˡšššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢâââââââââââââââ��âââââââââââââˡ����ˡšššššššš�',
		'�ˡšššššššššššššŢˡ������������������������������ˢâ��âââââââââââââââ��ââââââââ��ââˡ����ˡšššššššš�',
		'�ˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢ�'
	);

	MAP_EVENT_04: array[0..13] of TMapEventDesc =
	(
		(pos: (x:  1; y:  4); eventType: etAction; id: 1; flag:  1),
		(pos: (x: 17; y: 18); eventType: etAction; id: 2; flag:  2),
		(pos: (x: 16; y:  6); eventType: etRead;   id: 1; flag: 31),
		(pos: (x: 22; y: 10); eventType: etRead;   id: 2; flag: 32),
		(pos: (x: 36; y: 13); eventType: etRead;   id: 3; flag: 33),
		(pos: (x: 42; y: 10); eventType: etRead;   id: 3; flag: 34),
		(pos: (x: 53; y:  7); eventType: etOn;     id: 1; flag: 41),
		(pos: (x: 18; y: 18); eventType: etOn;     id: 2; flag: 42),
		(pos: (x: 10; y: 11); eventType: etSearch; id: 1; flag: 100),
		(pos: (x:  7; y: 16); eventType: etSearch; id: 2; flag: 101),
		(pos: (x:  4; y: 14); eventType: etSearch; id: 3; flag: 102), // note
		(pos: (x:  1; y: 13); eventType: etSearch; id: 4; flag: 103), // orz's diary
		(pos: (x: 17; y: 20); eventType: etSearch; id: 5; flag: 104), // air gun & manual
		(pos: (x: 20; y: 20); eventType: etSearch; id: 6; flag: 105)
	);

	MAP_NPC_04: array[0..13] of TMapNPCDesc =
	(
		(charType: 0; pos: (x:  2; y:  4); name: ''),
		(charType: 5; pos: (x:  6; y:  2); name: '������'),
		(charType: 1; pos: (x: 29; y: 12); name: '��ϼ� ����'),
		(charType: 4; pos: (x: 29; y: 14); name: '��ϼ� ����'),
		(charType: 6; pos: (x: 13; y: 11); name: '����'),
		(charType: 2; pos: (x:  2; y: 13); name: '�缭'), // ������ ��
		(charType: 1; pos: (x: 45; y: 12); name: '��ȩ'),
		(charType: 4; pos: (x: 46; y: 13); name: '�������� ����'),
		(charType: 1; pos: (x: 39; y: 14); name: '�������� �մ�'),
		(charType: 3; pos: (x: 22; y: 18); name: '����'),
		(charType: 1; pos: (x: 57; y: 14); name: ''),
		(charType: 1; pos: (x: 67; y: 15); name: ''),
		(charType: 1; pos: (x: 46; y: 23); name: ''),
		(charType: 1; pos: (x: 59; y: 27); name: '')
	);

implementation

uses
	Windows,
	UPlayer, UGameMain, UTileMap;

const
	FLAG_REGISTERED_ON_AVEJ     = 1;
	FLAG_NEED_TO_GUARANTEE      = 2;
	FLAG_NEED_TO_INTERVIEW      = 3;
	FLAG_END_OF_GUARANTEE       = 4;
	FLAG_NEED_DEAD_BOOK         = 5;
	FLAG_TALK_ABOUT_ORZ_DIARY   = 6;
	FLAG_GIVE_WISKEY            = 7;
	FLAG_TALK_ABOUT_HIDDEN_DOOR = 8;
	FLAG_GET_DEAD_BOOK        = 10;
	FLAG_GET_LIBRARY_KEY      = 11;
	FLAG_GET_LIBRARY_NOTE     = 12;
	FLAG_GET_ORZ_DIARY        = 13;
	FLAG_GET_ORZ_KEY          = 14;
	FLAG_GET_AIR_GUN          = 15;

procedure InitProc04(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	if prevMapId in [SCRIPT_AVEJ_WEST_LV0, SCRIPT_AVEJ_WEST_LV2] then begin
		if (prevPos.x >= 0) and (prevPos.y >= 0) then begin
			(sender as TTileMap).GetPC.WarpOnTile(prevPos.x div BLOCK_W_SIZE, prevPos.y div BLOCK_H_SIZE);
		end;
	end;

	if (sender as TTileMap).MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
		(sender as TTileMap)[21, 19] := OBJ_DOOR_CLOSE;
	end;
end;

function  Char2MapProc04(cTemp: char): longword;
begin
	case cTemp of
		chr(255): result := 3;
		else result := high(longword);
	end;
end;

function GetOriginalPos(personalId : integer): TPoint;
var
	i: integer;
	player: TPlayer;
begin
	player := g_tileMap.GetPlayer(personalId);

	for i := low(MAP_NPC_04) to high(MAP_NPC_04) do begin
		if MAP_NPC_04[i].name = player.m_name then begin
			result := MAP_NPC_04[i].pos;
			exit;
		end;
	end;

	// cannot find the specified event
	result.x := 0;
	result.y := 0;
end;

procedure TalkData04(personalId : integer; const question : widestring; const fullInput : wideString = '');
const
	REQUIRE_MY_NAME : boolean = FALSE;
	REQUIRE_ANSWER  : boolean = FALSE;
	RESERVED_NAME   : widestring = '';

	function KeyWordIs(const strList: array of string): boolean;
	var
		index: integer;
	begin
		result := TRUE;

		index := low(strList);
		while (index <= high(strList)) do begin
			if question = strList[index] then begin
				exit;
			end;
			inc(index);
		end;

		result := FALSE;
	end;

var
	i: integer;
	pos: TPoint;
	player: TPlayer;
begin
	case personalId of
	1:
	//?? �ι� ° ��ȭ������ �ֹ� ��Ͽ� ���� �̾߱⸦ �ؾ� ��
	begin
		if question = KEYWORD_BYE then begin
			if REQUIRE_MY_NAME then begin
				g_textArea.Write('�������� �� �̸��� ������ �ְԳ�.');
			end
			else begin
				g_textArea.Write('�߰���.');
			end;
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
			REQUIRE_ANSWER := FALSE;
			RESERVED_NAME  := '';
		end
		else if REQUIRE_ANSWER then begin
			if question = '��' then begin


				g_textArea.WriteLn('{"��..���� �����? �׸��� ����� �����Ű���?"}');
				g_textArea.WriteLn();
				g_textArea.WriteLn('��, ��.. ���ݵ� ���� �����̷α�. �� ���� �ϳ����� ����.');
				g_textArea.WriteLn('���Ⱑ ���� ���� �� ��������. ������ ������ ����ִ� �ΰ����� �̰��� ���ļ����� �θ��⵵ �Ѵ���.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('{"���ļ���?!"}');
				g_textArea.WriteLn();
				g_textArea.WriteLn('���ļ���� ���� �Ŀ� ��� �̾����� ���踦 ���ϴ� ������. �ڳ״� �̰��� ���� �� ���� ���� �� ����.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('<space Ű�� �����ʽÿ�>', tcHelp);
				g_textArea.WriteLn();
				g_GameMain.PressAnyKey();

				g_textArea.WriteLn('{"���ļ���� �������� �ʾƿ�. �̹� ����� �׾��µ� �̷��� �����ϰ� �̾߱� �Ѵٴ� ���� ������ݾƿ�."}');
				g_textArea.WriteLn();
				g_textArea.WriteLn('������ �� ������ ������. ����, �̰��� ó�� ���� ������� �ڽ��� �׾��ٴ� ���� �������� �������� ����. '+
									'���ļ���� �̹� ���п����� ��� ���� �����ϰ� �ִ� �κ��̾�. ������ �׾��ٰ� ��Ƴ� ������� ���� ���迡 '+
									'���� ������� ���ȭ �� ���� ���� ���ߴ°�?');
				g_textArea.WriteLn();

				g_textArea.Write('{"�׷� ���� �� ��������, �װ� ��κ� ���� �� ���� 3�� �����̿���. �׵��� ���� ���谡 �ִٰ� �Ͼ��� ���� '+
									'��� �׷��� ������ �߱� ������ �ƴѰ���? ��� ���� ����� ������ �ִ� ���ȿ� ���� ');
				g_textArea.Write('�ϻ�ȭź��', tcHelp);
				g_textArea.Write('{�� ���������� �׷� ȯ���� ������ �ͻ��̶󱸿�."}');
				g_textArea.WriteLn();
				g_textArea.WriteLn();
				g_textArea.WriteLn('����.. �׷� �׷�.. ������ �ڳ׵� �� �̰��� �����ϰ� �ɰɽ�. �̷��� �� �տ� ������ �ִ� �̷� ���踦 '+
									'�����Ѵٴ� ��ü�� ���� ����̶�� �������� �ʴ°�?');
				g_textArea.WriteLn();

				g_textArea.WriteLn('{"��..�װ� �׷�����..."}');
				g_textArea.WriteLn();

				g_textArea.WriteLn('��ݵ� ���� �������� �ڳ�ó�� TV�� ���� ���� ������ �ϴ� ����� ���� �������̾�. ���� �� ���迡 �������� �� �Ǿ����� �׸� ���� ���� �ƴϰŵ�. �� ���� �� ���迡 ���� �̾߱���� �ؾ� �ϳ�?');
				g_textArea.WriteLn();

				g_tileMap.GetPC.m_name := RESERVED_NAME;
				REQUIRE_MY_NAME := FALSE;

				g_gameMain.UpdateStatus();
			end
			else begin
				g_textArea.WriteLn('�׷�? ���� �߸� ���� �� ����.');
				g_textArea.WriteLn('�ڳ� �̸��� �����ΰ�?');
				g_textArea.WriteLn();
			end;
			REQUIRE_ANSWER := FALSE;
			RESERVED_NAME  := '';
		end
		else if REQUIRE_MY_NAME then begin
			if question = KEYWORD_GREETING then begin
				g_textArea.Clear();
				g_textArea.Write('���� �̸��� ');
				g_textArea.Write('������', tcMonolog);
				g_textArea.Write('��� �ϳ׸�,');
				g_textArea.WriteLn();
				g_textArea.WriteLn('�ڳ��� �̸��� ����?');
				g_textArea.WriteLn();
			end
			else begin
				//?? ���� ���� �̻��� �Ǹ� �ȵ�
				if fullInput = '������' then begin
					g_textArea.WriteLn('�װ��� ���� �̸����� �ڳ��� �̸��� �ƴϾ�. �ٽ� �̸��� ���� ���Գ�.');
					g_textArea.WriteLn();
				end
				else if length(fullInput) > 16 then begin
					g_textArea.WriteLn('�̷� �̷�.. ���� �ܿ�⿡ �̸��� �ʹ� ��� ���̳�. �ٽ� �ǹڶǹ� ���� ���� �ʰڳ�?');
					g_textArea.WriteLn();
				end
				else begin
					g_textArea.Write('�ڳ��� �̸��� ');
					g_textArea.Write(fullInput, tcMonolog);
					g_textArea.WriteLn('�ΰ�?');
					g_textArea.WriteLn();

					g_textArea.Write('[');
					g_textArea.Write('��', tcHelp);
					g_textArea.Write(' �Ǵ� ');
					g_textArea.Write('�ƴϿ�', tcHelp);
					g_textArea.Write('�� ���]');
					g_textArea.WriteLn();

					g_textArea.WriteLn();

					REQUIRE_ANSWER := TRUE;
					RESERVED_NAME  := fullInput;
				end;
			end;
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.NameFlag[personalId] then begin
				g_textArea.WriteLn('�ڳ�ó�� TV�� ���� ���� ������ �ϴ� ����� ���� �������̾�. ���� �� ���迡 �������� �� �Ǿ����� �׸� ���� ���� �ƴϰŵ�.');
				g_textArea.WriteLn();
			end
			else begin
				g_textArea.WriteLn('�ڳ� ��� TV�� ���� ���۵� ��ó�� ���̴µ�.. ���� ��Ȯ�ϰ� �� ���ΰ�? ' +
								   '�Ƹ��� TV�� ��ü�� ������ ������ ����� 200�� ���� ó�� ���� �� ����.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('�ڳ״� �̰��� ó���ΰ�? �ݰ���, ���� �̸��� ''������''��. �ڳװ� �� ����� ���ڸ��� ���� ������ �� ���� ū ����ϼ�. '+
								   '�׷��� �ڳ��� �̸��� ����?');
				g_textArea.WriteLn();

				g_tileMap.NameFlag[personalId] := TRUE;
				REQUIRE_MY_NAME := TRUE;
			end;
		end
		else if question = '������' then begin
			g_textArea.WriteLn('�װ��� ���� �̸��̾�. �� ����� �� �� ���� ���迡 ���� �����ϰ� ����ϰ� �ִ� ���� ���� ��������.');
			g_textArea.WriteLn();
		end
		else if question = '�ϻ�ȭź' then begin
			g_textArea.WriteLn('������... ������ ���̶�� �����ϴ� �հ�?');
			g_textArea.WriteLn();
		end
		else if (question = '����') or (question = '��������') then begin
			g_textArea.WriteLn('�����̶�� ���� �� ���迡�� ������ �̵��ϴ� ��� �߿� �ϳ���. ������ �׷� ��ü ���̵� �������� ������ ������ �̵��ϴ� ���� ���������� �� ���迡 ���� �ʺ����� ���� � ��ü�� ���ؼ��� �׷� ���� ��������. ' +
							   '���� ���, �뷡�� �θ� �� ������ ���ڸ� ���߾������ ����� �θ��ٰ� ���߿��� �׳� �뷡�� �θ� �� �ִ� �Ͱ� ���� ��ġ��');
			g_textArea.WriteLn();
		end
		else if question = '��ü' then begin
			g_textArea.WriteLn('��ü�� ���ؼ��� ���޵ȴٰ� �������� ������ ������ ��ü�� ���ؼ� �Ǵ� ���� �ƴϰ� ��ü�� ���ؼ��� ������ �����ϴٰ� ������ ������ ' +
							   '��������ó�� �׷��� ���������� �ϴ� ������. �Ƹ��� �ڳװ� TV�� ���� ������ �ȴٰ� �����ϴ� ���� �ڳ� �տ� ����� �� ���������� ' +
							   'ä���� ��ȭ��Ű�� ���� ������ ���ϴ� �Ͱ� ���� ���̶� �ν��ϱ� �����̶�� �����ǳ�. �Ƹ��� �ڳ״� TV�� ���� ��Ȱ�� �����ϰ� �־��� ����.');
			g_textArea.WriteLn();
		end
		else if question = '������' then begin
			g_textArea.WriteLn('�ڳ� �տ� �� �װ��� ���ϴ� ���̶��.');
			g_textArea.WriteLn();
		end
		else if question = '�̼���' then begin
			g_textArea.WriteLn('�� ���迡 ���� �ǹ��� ������ �ֳ�? �� ����� �Ƹ��� �ڳװ� ���� ���¿� �־��� ���� �̰��� ���ļ����� �ҷ������� �𸣰ڱ�.');
			g_textArea.WriteLn();
		end
		else if (question = '��������') or (question = '����') then begin
			g_textArea.WriteLn('���� ���´� ��� ���� ���� ���ϴ� ������.');
			g_textArea.WriteLn('�ٽ� ���� ��ȥ�� ��ü�� ��ӵǾ� �ִ� ���¸� ���ϴ� ���̾�. '+
							   '���� ������ �� �� ���� �ٽ� ������� �и��Ǿ��ִ� ������.');
			g_textArea.WriteLn();
		end
		else if question = '��ȥ' then begin
			g_textArea.WriteLn('������ ��������. �����⿡�� ������ �ξ� �����ο� ������ ���� �ʴ°�? �Դٰ� ��ü�� ���� ���� ���� ���� �ƴϱ� ������ �� ���� �հ� �ڸ� �� �� �� ����. '+
							   '���� �����ֱ� �������� �ڳװ� �ڳ��� �հ� �ڸ� �� �� �� �ִٴ� ����� ���ݱⰡ ��������ž�. ����� �׳� �ڿ����� �翬�� ��ó�� ������ ������ �״ϱ�.');
			g_textArea.WriteLn();
		end
		else if question = '��ü' then begin
			g_textArea.WriteLn('�ƽ��Ե� �ڳ��� ��ü�� �ٽ� �����ϱ�� �����ɼ�.');
			g_textArea.WriteLn();
		end
		else if question = '��������' then begin
			g_textArea.WriteLn('��ü�� ��ȥ�� �����ϴ� �����.');
			g_textArea.WriteLn();
		end
		else if question = '���ļ���' then begin
			g_textArea.WriteLn('���� ������ ���迡���� ��� ������ ��ü�� �������� �ϱ� ������ ��ü�� �״� ���� �ڽ��� �״� ���̶�� �����ϱ� ������ �װ��� ���ļ����� �ҷ�����. '+
							   '������ ���? �ڳ״� �̷��� ��ü�� �������� ��ȥ������ �̷��� ��� ���� ������? '+
							   '�ϴ� �� ���迡 ��� �� ����� �ٽ� ��ü�� �����ϴ� ����� ���ư� ���� �����ϱ� �׵鿡�� ������ �˷��ַ��� �ص� �װ� ���� ����. '+
							   '�Ƹ� �׵��� ���簡 ������ �׶������� �̰��� ���ļ����� �θ��� �� ���翡 ���� ������ ���Ӿ��� �ϰ���.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['���̷���', '���̷�', '����ź']) then begin
			if not g_tileMap.MapFlag[0, FLAG_GET_ORZ_KEY] then begin
				g_textArea.WriteLn('�ڳװ� ��� �׷� ���� �˰� �ֳ�? �ű��ϱ�. ��� ���� �ϳ� ������ �־�. �װ� ������ �� ������ ���̶� ����� �۵��ϴ� ������ �𸣰ڱ�. '+
								   '���� â�� �α� �ߴµ� ��� �� �Ѱ� ��ġ�ص� ���̶� ��Ȯ�ϰ� ��� �ִ��� �𸣰ڱ�. �ʿ��ϴٸ� ��������. ������ ����� ü�����δ� �������� �ʴ� �����̴� '+
								   '����ġ��� ������ ������ ������. ��, �̰��� ���� â�� �����. ���� �� �� ã�� ���Գ�.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[���� +1]', tcEvent);
				g_inventory.Add(ITEM_KEY, 18, 2);
				g_tileMap.MapFlag[0, FLAG_GET_ORZ_KEY] := TRUE;
			end
			else begin
				g_textArea.WriteLn('���� ���� �� �� ���� ���ٳ�. �װ��� �߸��� ����� �׽����� ����ε� �� ������ ���� ���� ��� �ֳ�. �� ���� �ִ� ���� �� ������ ���� ���̴ϱ� �Ƹ��� �׸� ã������ �ϳ� �ָ� ���� �Ұɼ�.');
				g_textArea.WriteLn();
			end;
		end
		else if question = '�ڼ���' then begin
			g_textArea.WriteLn('���� ���� ������ ���� �ʿ�(���� ���� �ȵ�)', tcEvent);
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['��ĵ����', '�Ѿ��']) then begin
			g_textArea.WriteLn('���� ���� ������ ���� �ʿ�(���� ���� �ȵ�)', tcEvent);
			g_textArea.WriteLn();
		end
		else if question = '�׽���' then begin
			g_textArea.WriteLn('�װ� �̰��� �� ���� ������ �������. ��ü�� ��� �ִ� ���迡���� �ϳ� �ɷ��ִ� ���ڿ��� �� ������ ���⼭�� ������Ż�� �ο�� ���⸦ ���� ������� �� �� �˷��� ����. '+
							   '�״� ���⸦ �ٷ�� �ɷ��� Ź���ؼ� ��� ������ ���� ���⸦ ���� �����ϰ� �ذ��Ϸ�����. ������ �װ� ���� ���迡 ���� �̷��� ������ �ִٸ�, '+
							   '�״� �и��� �̰��� ��ü�� ���������� �ؼ��ϰ� �׷��� �̰��� ���������� ����� ã�� ���� ������ ����ϰ� ���� ���̶� �����ǳ�. '+
							   '�״� �� ������ ���ʿ� ��� �ִµ�, ���� �׸� �������� ������ �� �ʳ��� �Ǿ��ٳ�.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['������Ż', '������Ż']) then begin
			g_textArea.WriteLn('���� ���� ������ ���� �ʿ�(���� ���� �ȵ�)', tcEvent);
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['����', '������']) then begin
			g_textArea.WriteLn('�׷� ���� �׽��� ������ �̾߱� �ϰ�.');
			g_textArea.WriteLn();
		end
		else if (not g_tileMap.MapFlag[0, FLAG_END_OF_GUARANTEE]) and g_tileMap.MapFlag[0, FLAG_NEED_TO_GUARANTEE] and KeyWordIs(['Ȯ������', '������']) then begin
			if g_inventory.Search(ITEM_GUARANTEE) then begin
				g_textArea.WriteLn('���� �̹� ���� ������. �ڳ׿���.');
			end
			else begin
				g_textArea.WriteLn('����ϴµ� �׷� ���� �ʿ��ϴ���? �׷��ٸ� ���� �������� �Ǿ� �� ���ۿ� ���ڱ�. ������ �ڳ״� ���⿡ �ƴ� ����� ���� �װ�.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[�������� ������ ���� +1]', tcEvent);
				g_inventory.Add(ITEM_GUARANTEE);
			end;
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('�װ� ���� �ǹ����� �� �𸣰ڱ�...');
			1:   g_textArea.WriteLn('����� �� �ƴ� ���� �ƴ���. �ٸ� ���� ���� ���Գ�.');
			else g_textArea.WriteLn('��.... �ٽ� �� �� �̾߱��� �ֽð�.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	2:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('�ȳ��� ���ʽÿ�.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			g_textArea.WriteLn('����ʽÿ�. ����� AVEJ �ֹ� ��ϼ��Դϴ�. ������ ���͵帱���?');
			g_textArea.WriteLn();
			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '�ֹ�' then begin
			g_textArea.WriteLn('AVEJ�� �����ϰ� �Ǵ� ��� ��ȥ���� �ֹ��� �� �Ǹ��� ������ �ֽ��ϴ�.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['�ֹε��', '��ϼ�', '���']) then begin
			g_textArea.WriteLn('�ֹ��� ���� ������ ���� ���� ��ȣ�� ���� ���� �����ϴ�. ���� �ֹ��� �Ǹ� �� �Ǹ��� ������ �ǹ��� �־����ϴ�. �׸��� �ֹ��� �Ƿ��� ���⼭ {�������}�� ���ľ� �մϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '��ȥ' then begin
			g_textArea.WriteLn('�츮 ��θ� �̾߱� �ϴ� ���Դϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '�Ǹ�' then begin
			g_textArea.WriteLn('�ֹ����� ��ϵǸ� ��� �Ǹ��� ����� �� �ֽ��ϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '�ǹ�' then begin
			g_textArea.WriteLn('�ǹ��� ������ �ǹ��� ���� �켱�Դϴ�. �ֹ��� ���� ���ݿ� ���ؼ� AVEJ�� ��˴ϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '����' then begin
			g_textArea.WriteLn('������ ���ٴ� �ǹ��Դϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '����' then begin
			g_textArea.WriteLn('���� �ٻ޴ϴ�. ��� ������ ��� �峭�� �Ͻðڽ��ϱ�?');
			g_textArea.WriteLn();
		end
		else if question = 'avej' then begin
			g_textArea.WriteLn('AVEJ�� �� õ ���̻� ��ӵǾ�� ��ġ���Դϴ�. �̸��� ��Ȯ�� ����� �� �� ������ Avenue J�� ��ģ ���ط� ���� ��ȥ���� �̰����� �Ͻÿ� �귯 ��� �԰� �� ������� ���ʷ� �� ��ġ���� ��ô�� �����߽��ϴ�. �׵��� ������� ���� �̰��� AVEJ��� �θ��ϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '�ٸ�����' then begin
			g_textArea.WriteLn('�ٸ� ���δ� �ױ� ������ ��������.');
			g_textArea.WriteLn();
		end
		else if question = '�������' then begin
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('����� �̹� ����ϼ̱� ������ ������ ��� ������ �ʿ� �����ϴ�.');
			end
			else if g_inventory.Search(ITEM_REG_FORM_MT) or g_inventory.Search(ITEM_REG_FORM) then begin
				g_textArea.WriteLn('���� ������ ��� �ֹ� ��� ������ ���� ������� ������ �ֽʽÿ�.');
			end
			else begin
				g_textArea.WriteLn('����� �ϱ� ���ؼ��� ���� �ڽ��� �̹� �׾� �ִٴ� ������ �ؾ� �մϴ�. �� ��ϼ��� ��ĭ�� ä��ð� �� ���� �п��� �� ������ �����Ͻʽÿ�. �׿��� {�������}�� ���� ���ø� ���� �� ���Դϴ�.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[�� �ֹ� ��� ���� +1]', tcEvent);
				g_inventory.Add(ITEM_REG_FORM_MT);
			end;
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('�װ� ���� �ǹ����� �� �𸣰ڽ��ϴ�.');
			1:   g_textArea.WriteLn('�ٸ� ������ �����ϱ�?');
			else g_textArea.WriteLn('����� �� �˾� ���� �� �����ϴ�. �ٽ� ������ �ֽʽÿ�.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	3:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('�ȳ��� ���ʽÿ�.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('�� �̻� ���� ���� �帱 ���� �����ϴ�.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else if g_tileMap.MapFlag[0, FLAG_NEED_TO_INTERVIEW] then begin
				g_textArea.WriteLn('���� �濡 ��ô� ���δ԰� ����� �Ͻʽÿ�. �׺��� ���������� �ֹ����� �޾� �������� �����Ͻô� ���Դϴ�.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else begin
				if g_inventory.Search(ITEM_REG_FORM) or g_inventory.Search(ITEM_GUARANTEE) then begin
					g_textArea.WriteLn('����ʽÿ�, ������ ���͵帱���? ��� ������ �غ��ϼ̳���?');
					g_textArea.WriteLn();
					if g_inventory.Search(ITEM_GUARANTEE) then begin
						g_textArea.WriteLn('��. �������� ������ �ּ���. �׸��� ���� �濡 ��ô� ���δ԰� ����� �Ͻʽÿ�. �׺��� ���������� �ֹ����� �޾� �������� �����Ͻô� ���Դϴ�.');
						g_inventory.Remove(ITEM_REG_FORM);
						g_inventory.Remove(ITEM_GUARANTEE);
						g_tileMap.MapFlag[0, FLAG_NEED_TO_INTERVIEW] := TRUE;
						g_tileMap.MapFlag[0, FLAG_END_OF_GUARANTEE]  := TRUE;
						g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
					end
					else begin
						if g_tileMap.MapFlag[0, FLAG_NEED_TO_GUARANTEE] then
							g_textArea.WriteLn('���� �������� �� ã���̳� ���׿�.')
						else
							g_textArea.WriteLn('������ ������ �ֳ׿�. �ڽ��� �̹� �׾� �ִٴ� ���� �����ϱ� ���� {Ȯ������}�� ������ ���ž� �մϴ�')
					end;
				end
				else begin
					g_textArea.WriteLn('����ʽÿ�. ����� AVEJ �ֹ� ��ϼ��Դϴ�. ������ ���͵帱���?');
				end;
			end;
			g_textArea.WriteLn();
			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '��ϼ���' then begin
			if g_inventory.Search(ITEM_REG_FORM_MT) or g_inventory.Search(ITEM_REG_FORM) then begin
				g_textArea.WriteLn('����� �տ� ����ִ� �װ��Դϴ�.');
			end
			else begin
				g_textArea.WriteLn('�ֹ����� ����ϱ� ���� �ۼ��ϴ� �����Դϴ�. �� ���� �п��� �޾� ������.');
			end;
			g_textArea.WriteLn();
		end
		else if question = '�������' then begin
			if g_inventory.Search(ITEM_REG_FORM) then begin
				g_textArea.WriteLn('��, ���� ������ �� ä��̱���. �׷��� �ʿ��� ���� �ϳ� �� �ֽ��ϴ�. �ڽ��� �̹� �׾� �ִٴ� ���� �����ϱ� ���� {Ȯ������}�� ������ ���ž� �մϴ�.');
			end
			else if g_inventory.Search(ITEM_REG_FORM_MT) then begin
				g_textArea.WriteLn('��� ������ ��� ��ĭ���� ���� �ֽ��ϴ�. ������ ä���� �����Ͻʽÿ�.');
			end
			else begin
				g_textArea.WriteLn('���� {��� ����}�� ������ ������.');
			end;
			g_textArea.WriteLn();
		end
		else if question = 'Ȯ������' then begin
			g_textArea.WriteLn('����� ������ Ȯ���ϴ� ����� ���������� ����� �͵� �����մϴ�.');
			g_textArea.WriteLn();
			g_tileMap.MapFlag[0, FLAG_NEED_TO_GUARANTEE] := TRUE;
		end
		else if question = '������' then begin
			g_textArea.WriteLn('�����α��� ���� ã�� �帮�� ���� ����մϴ�.');
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('��.. �� �𸣰ڳ׿�.');
			1:   g_textArea.WriteLn('�ٸ� �������� ���ֽʽÿ�.');
			else g_textArea.WriteLn('�ٽ� ������ �ֽðڽ��ϱ�?');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	4: // ����
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('������ ����.');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('����ð�. ������ ���� �� ���̶� �ִ°հ�?');
				g_textArea.WriteLn();
			end
			else if g_inventory.Search(ITEM_BOOK, ITEM_BOOK_DEAD_WORLD) and g_tileMap.MapFlag[0, FLAG_NEED_DEAD_BOOK] then begin
				g_textArea.WriteLn('�� ã�� �Ա�. �׷� �ٷ� �� å�ϼ�. �� å�� ����������� �� ����� ������ ������ ������ ���� ������ ��� �ִ� å����. �����ϳ�. �ڳ׵� ���� AVEJ�� �ֹ��� �Ǿ���. �𸣴� �κ��� �� å�� ���ؼ� ã�ƺ��Գ�.');
				g_textArea.WriteLn();

				g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] := TRUE;
				g_tileMap.MapFlag[0, FLAG_NEED_DEAD_BOOK]     := FALSE;
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else begin
				g_textArea.WriteLn('����ð�. ���� AVEJ�� ���������� �����߾��� ������ ������� ���� ���ζ�� Ī�Ѵٳ�.');
				g_textArea.WriteLn();
				g_tileMap.NameFlag[personalId] := TRUE;
				if g_tileMap.MapFlag[0, FLAG_NEED_TO_INTERVIEW] then begin
					//?? ���� �ڿ� ��ħǥ�� ��¾ȵǴ� �� ����
					g_textArea.WriteLn('�ڳװ� �̹��� ���� �̰����� �� �� ģ���α�. �� ���� �̰��� �Ϸ翡 �� �� ������ ���� ���� �־����� �������� ���� ���ο� ������� ������ �ʴ´ٳ�.');
					g_textArea.WriteLn('�Ƹ��� �̰��� �̽��� ���踦 ������ �ִ� ������ ������ �������� ���� �� ����. �츮���� �װ��� �������� ã�ƺ��� ������ ���� �Ǹ����� �� ��� �ִ� ���̾�. �ڳ״� ��� ��ü�� ���ؼ� �̰��� �귯 ��� �� �� �ְ� �Ǿ���?');
					g_textArea.WriteLn();
				end
				else begin
					g_textArea.WriteLn('�׷��� ó������ ģ���α�. ���� �ٻڴ� ������ ã�� ���ð�.');
					g_textArea.WriteLn();
					g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
				end;
			end;
		end
		else if question = 'avej' then begin
			g_textArea.WriteLn('��Ͽ��� ���� ���� �ִ���? �̰��� �̸��̶��.');
			g_textArea.WriteLn();
		end
		else if question = '��ü' then begin
			g_textArea.WriteLn('��ü�� ���� �̾߱��� �� �ǹ� ���ʿ� �ִ� �������� �� ���� �ɼ�.');
			g_textArea.WriteLn();
		end
		else if (question = '����') or (question = '��������') then begin
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('�ڳ״� �̹� �����߱� ������ ���ٸ� ������ �� �̻� �ʿ� ����.');
			end
			else begin
				g_textArea.WriteLn('���� ���� �߿� �������� ������ �������.');
			end;
			g_textArea.WriteLn();
		end
		else if question = '�̽�' then begin
			g_textArea.WriteLn('�ڳװ� �� �������� �ص� ��� �װ��� ���ϴ� ���̶��.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['tv', 'tele', '�ڷ�����', '�ڷ�����', '�׷���', '�ڷ���', 'Ƽ��', 'Ƽ����']) then begin
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('�ڳװ� ���۵� �� ��ü�� ����� �װ� �̾߱��ΰ�? {��Ʈ} ����ŭ Ư���� ��ü��.');
			end
			else begin
				g_textArea.WriteLn('��ȣ.. ������ ������ ��ü�α���. �ϱ� �� �ʳ� ������ �ڵ��Ǹű⸦ ���ؼ� ���۵� ģ���� �־���.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('�Ƹ� ���� ��򰡿��� ���Ը� �ϰ� �ִ� {��Ʈ}��� ģ������. �� ģ���� ������ �̻��� ȣ����� ���Ƽ� �ڵ��ǸűⰡ ������ �������� �ٲپ� �ִ� ����� �����߾��ٳ�... '+
								   '�Ƹ��� � ���� �׷� ȣ����� ��ȥ�� ���εǾ �� ģ���� �ڵ��Ǹű⸦ ���� ������ �����ߴ� ���̰���. �׷��ٸ� �ڳ״� TV �ߵ����� �־��� �Էα���.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('�ϴ� �ڳ׿��Դ� �� ���迡 ���� ���ذ� �ʿ��ϴ� ���ʿ� �ִ� å�忡�� {���ļ��� �Թ���}�� ������ ���Գ�.');
				g_tileMap.MapFlag[0, FLAG_NEED_DEAD_BOOK] := TRUE;
			end;
			g_textArea.WriteLn();
		end
		else if (question = '�ڵ��Ǹ�') or (question = '���Ǳ�') then begin
			g_textArea.WriteLn('�׳� ���� ���Դ� �׷� �ڵ��Ǹű��. �̰��� �ڳװ� ��� ����ʹ� �ð��� ������ �޶� �� ��������� TV�� �ڵ��ǸűⰡ ���޵Ǿ� �ִٳ�.');
			g_textArea.WriteLn();
		end
		else if question = '������' then begin
			g_textArea.WriteLn('�������� �� ���� ������ �̰��� ��ƿ� �ι�����. ó������ �̰����� �� ���� �ƴϰ� �ܺ��� �ٸ� ���ÿ��� ��ٰ� �̰����� ���� �Ǿ���. �״� �� �ǹ��� ���ʿ� �ִ� ���� ��� �ִٳ�.');
			g_textArea.WriteLn();
		end
		else if question = '��Ʈ' then begin
			g_textArea.WriteLn('�� �ǹ��� �������� ���� �������� �ִ� ������ ��������. �� ���Ҷ��ϱ� ������ ����ʿ��� �ڽ��� ģ�����.');
			g_textArea.WriteLn();
		end
		else if question = '����' then begin
			g_textArea.WriteLn('��ȥ �ӿ� ���Ǵ� ������ ���� ��ü�� ����ϴ� ���� �ܱ����̶�� ��� ��ȥ�� ����ϴ� ���� ������̶�� ����.');
			g_textArea.WriteLn();
		end
		else if question = '����' then begin
			g_textArea.WriteLn('�����ϱ� �� �������� �̰��� ��ü�� ���� ���̱� ������ ���������ε� � ��ġ�� ���� �� ����. {''�ڽ��� ���� ��� ���� �����Ѵ�''}��� ���� �� ������ ������ �߿� �ϳ����.');
			g_textArea.WriteLn();
		end
		else if question = '�ߵ���' then begin
			g_textArea.WriteLn('TV �ߵ����� �ƴ϶� TV�� ���� ��ۿ� ���� ���ذ� ���ٰ� �ϸ� �ڽ��� ���İ� �� ������ �ν��ϰ� �ָ����� ���۽�ų �� �־��� �������� ����.');
			g_textArea.WriteLn();
		end
		else if (question = '���ļ���') or (question = '�Թ���') then begin
			g_textArea.WriteLn('{���ļ��� �Թ���}�� ���� ���⿡ ���� ������ ����� �����ؼ� �� �ʳⰣ ���� å�̶��. ��κ��� ���� ��ȥ���� �� å�� ���ؼ� �� ���迡 ���� ���� ������ ��������.');
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('�� �𸣴� �κ��̱�...');
			1:   g_textArea.WriteLn('�ٸ� ���� ���� ���ðԳ�.');
			else g_textArea.WriteLn('���� ����� ������ ���߳� ����. �ٽ� �� �� �̾߱��� �ֽð�.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	5: // �缭
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('������ ���ô�.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('���� �̰��� �缭�Դϴ�. ����� �Ժη� ������ �ȵǴ� ���Դϴ�.');
				g_tileMap.NameFlag[personalId] := TRUE;
			end
			else begin
				g_textArea.WriteLn('����� �Ժη� ������ �ȵǴ� ���Դϴ�. Ư�� �̰��� �ֹ��� �ƴ� ����� ���� �� �����ϴ�.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end;
			g_textArea.WriteLn();
		end
		else if question = '�缭' then begin
			g_textArea.WriteLn('�ֹε�ϼҿ��� ��ϴ� �������� �缭�Դϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '������' then begin
			g_textArea.WriteLn('AVEJ�� ����� �� �Ŀ� ���� ó�� ���� �������� �����Դϴ�. ������ �߾ӿ� ū �������� ����鼭 �̰��� �Ϲ��ο��Դ� ������� �ʴ� ������ �ٲ�����ϴ�.');
			g_textArea.WriteLn();
		end
		else if question = '�ֹε�ϼ�' then begin
			g_textArea.WriteLn('�� �ǹ��� �ֹε�ϼ� �ǹ��Դϴ�.');
			g_textArea.WriteLn();
		end
		else if question = 'avej' then begin
			g_textArea.WriteLn('�̰��� ���ϴ� ��������. ���� ���� ���� ���� �ƴ�����?');
			g_textArea.WriteLn();
		end
		else if question = 'å��' then begin
			g_textArea.WriteLn('å���� ���� �ִ� ���� �ƴ����� ������� AVEJ������ �ϳ� ���� �ڷ�� ��޵ȴ�ϴ�.');
			g_textArea.WriteLn();
		end
		else if g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_NOTE] then begin
			if g_inventory.Search(ITEM_BOOK, ITEM_BOOK_LIBRARY_NOTE) then begin
				g_textArea.WriteLn('��.. �տ� ��� �ִ� �װ���..');
				g_textArea.WriteLn('�̷� ���� �Ժη� ������ ����մϴ�. �̰��� �� �������� ����鼭���� ��� ��� ������ ����������. �̰��� ������ �缭�� ��������� ���̼���.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[������ ���� -1]', tcEvent);
				g_textArea.WriteLn('');
				g_inventory.Remove(ITEM_BOOK, ITEM_BOOK_LIBRARY_NOTE);
			end
			else if question = '������' then begin
				g_textArea.WriteLn('�׺��� ������ �缭���� ���� ������ ���� �˾����� �ֱٿ� ����ִ� ���� �߰��߾��. '+
								   '�׺��� �̰��� ó�� �缭�� �����鼭 ��� �ϱ��ε� ���� �ִ� å�忡 �ȾƵ� ä�� �ؾ���ȳ� ���ϴ�. ���� �̹��� å�� �����ϸ鼭 ã�Ƴ°ŵ��. ���� �ٷ� �ڿ� �ִ� å���� �ڼ��� ���� ������.');
				g_textArea.WriteLn();
				g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_ORZ_DIARY] := TRUE;
			end
			else begin
				case Random(3) of
					0:   g_textArea.WriteLn('�̾������� �� �𸣰ڽ��ϴ�.');
					1:   g_textArea.WriteLn('�װ͸��� �ٸ� ������ �����ϱ�?');
					else g_textArea.WriteLn('������ �ϼ���?');
				end;
				g_textArea.WriteLn('');
			end;
		end
		else if question = '������' then begin
			g_textArea.WriteLn('�� �ǹ��� ������ �ٷ� �� �ǳ� �ǹ��� ��� ���̽���.');
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('�̾������� �� �𸣰ڽ��ϴ�.');
				1:   g_textArea.WriteLn('�װ͸��� �ٸ� ������ �����ϱ�?');
				else g_textArea.WriteLn('������ �ϼ���?');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	6: // ������ ����
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('������ �� ��� �ּ���.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.NameFlag[personalId] then begin
				g_textArea.WriteLn('����ʽÿ�. �ʿ��� ������ ������ ������ �ֽʽÿ�.');
			end
			else begin
				g_textArea.WriteLn('����ʽÿ�. ����� ''��ȩ�� ������''�Դϴ�.');
				g_tileMap.NameFlag[personalId] := TRUE;
			end;
			g_textArea.WriteLn();
		end
		else if question = '��ȩ' then begin
			g_textArea.WriteLn('���� �̸��Դϴ�.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['���̷���', '���̷�', '����ź']) then begin
			g_textArea.WriteLn('�׷��� ������ ���� ���� ã���� �ʿ䰡...');
			g_textArea.WriteLn();
		end
		else if (question = '����') or (question = '������') then begin
			g_textArea.WriteLn('���� ���� ������ ���� �ʿ�(���� ���� �ȵ�)', tcEvent);
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('� ���� �����̽Ű���?');
				1:   g_textArea.WriteLn('�˼��մϴ�. �� �𸣰ڱ���.');
				else g_textArea.WriteLn('�����Ͻ� ���� �����ϴٸ�...');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	7: // ������ ����
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			g_textArea.WriteLn('�ȳ��ϼ���. ���� ���� ���� ���� ���� �ְ� �ִ� �����Դϴ�.');
			g_textArea.WriteLn();
			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '����' then begin
			g_textArea.WriteLn('����� �������Դϴ�. �������� ��Ȱ�� �ʿ��� �͵��� �Ȱ� �־��.');
			g_textArea.WriteLn();
		end
		else if question = '����' then begin
			g_textArea.WriteLn('��� ������ ����̱� ������ �̰��� ������ �� �ʳ��� �Ǿ���ϴ�.');
			g_textArea.WriteLn();
		end
		else if (question = '����') or (question = '������') then begin
			g_textArea.WriteLn('������ ���� ���� ���� ��ȩ �������� �����ϼ���.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['���̷���', '���̷�', '����ź']) then begin
			player := g_tileMap.GetPlayer(personalId);
			if assigned(player) then begin
				pos := GetOriginalPos(personalId);
				if (pos.x = player.GetTilePos.x) and (pos.y = player.GetTilePos.y) then begin
					g_textArea.WriteLn('�Ƹ��� ���� �� ���� �մϴٸ� �� �� ã�� ������.');
					g_textArea.WriteLn();

					// move to the cargo
					for i := 1 to (2*BLOCK_H_SIZE) div (2*PLAYER_MOVE_INC) do begin
						player.Move(2*PLAYER_MOVE_INC, -2*PLAYER_MOVE_INC);
						g_GameMain.UpdateDisplay();
					end;
					player.TurnFace(fdUp);
					g_tileMap[player.GetTilePos.x+player.GetFacedVector.dx, player.GetTilePos.y+player.GetFacedVector.dy] := OBJ_DOOR_OPEN;
					for i := 1 to (2*BLOCK_H_SIZE) div (2*PLAYER_MOVE_INC) do begin
						player.Move(2*PLAYER_MOVE_INC, -2*PLAYER_MOVE_INC);
						g_GameMain.UpdateDisplay();
					end;
					player.TurnFace(fdRight);
					g_tileMap[player.GetTilePos.x+player.GetFacedVector.dx, player.GetTilePos.y+player.GetFacedVector.dy] := OBJ_DOOR_OPEN;
					for i := 1 to (2*BLOCK_W_SIZE) div (2*PLAYER_MOVE_INC) do begin
						player.Move(2*PLAYER_MOVE_INC, -2*PLAYER_MOVE_INC);
						g_GameMain.UpdateDisplay();
					end;
				end
				else begin
					g_textArea.WriteLn('���� ã�� �ִ� ���Դϴ�.');
					g_textArea.WriteLn();
				end;
			end;
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('�˼��մϴ�. ���� �ɺθ��� �ϴ� �����̶� �� �𸣰ڳ׿�.');
				1:   g_textArea.WriteLn('�� �𸣴� �����̶�...');
				else g_textArea.WriteLn('�ʿ��� ������ �����ø� ���� ��ȩ �������� �����ϼ���.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	8: // ������ �մ�
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('�� ���Գ�.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.NameFlag[personalId] then begin
				if g_inventory.Search(ITEM_PYRO_BOMB) then begin
					g_textArea.WriteLn('�ڳװ� ��� �ִ� �װ� ''���̷� ����ź''�̷α�. �� ��� ���� �ص� ������Ż�� ������ ��Ƽ� ���� �װ� ����ؼ� ������ �ϰ� �ߴµ� ���̾�. �������� �� ���� �Ǵ� ��ȸ�� ���ӱ�. �Ƹ� �� ���Կ��� �� ���� ���� ���� ������ �����ǳ׸�.');
				end
				else begin
					g_textArea.WriteLn('�� �������� AVEJ������ �������� ���ε� ������ �̷��� �ʶ��� ���԰� �Ǿ� ���ȴٳ�. �� ���Դ� �� ������ ������ �� �� ����. ������ ���� ���ǵ��� ������ ���� ���� ������ �����ǳ׸�.');
				end;
			end
			else begin
				g_textArea.WriteLn('���⼭�� ó�� ���� ���̷α���. �ڳ� �����ΰ�? ���� �������̱�, �� ���ÿ� ���ο� ��ȥ�� ���� ��.');
				g_tileMap.NameFlag[personalId] := TRUE;
			end;
			g_textArea.WriteLn('');
			g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
		end
	end;
	9: // ����
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('... ...');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();

			REQUIRE_ANSWER := FALSE;
		end
		else if REQUIRE_ANSWER then begin
			if question = '��' then begin
				g_textArea.Write('������ ����. �󸶸��� ������ ���� ������ �𸣰ڱ���. ');
				g_textArea.Write('���� ������ �𸣴� �׷� �߹��� ����� �ƴϾ�. ���� ���� ������� ');
				g_textArea.Write('���� ����', tcMonolog);
				g_textArea.Write('�� �ϳ� �˷� ����.');
				g_textArea.WriteLn();
				g_textArea.WriteLn();
				g_textArea.WriteLn('[����� ���̴� �� -1]', tcEvent);

				g_inventory.Remove(ITEM_WISKEY);
				g_tileMap.MapFlag[0, FLAG_GIVE_WISKEY] := TRUE;
			end
			else begin
				g_textArea.WriteLn('������ ����. �ڳװ� ���⼭ ��ư��µ� ���� ������ �˷� �ַ��� �ߴµ�.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end;
			g_textArea.WriteLn();
			REQUIRE_ANSWER := FALSE;
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
				g_textArea.Write('�������� ���� ��������� �۽�... ... ���� ���ε鿡�� ');
				g_textArea.Write('������ ��', tcMonolog);
				g_textArea.Write('�̶�� ��� �ٽ� �������� ���� �� �ۿ� ���ڳ� �׷�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('');
			end
			else if g_tileMap.MapFlag[0, FLAG_GIVE_WISKEY] then begin
				g_textArea.WriteLn('���� ������ {���� ����}�� �ʿ��ϴٸ� �˷� ����');
				g_textArea.WriteLn('');
			end
			else begin
				if not g_tileMap.NameFlag[personalId] then begin
					g_textArea.WriteLn('������ ó������? �� �׷� ǥ���̾�!');
					g_textArea.WriteLn('');
					g_tileMap.NameFlag[personalId] := TRUE;
				end;

				if g_inventory.Search(ITEM_WISKEY) then begin
					g_textArea.WriteLn('�׳����� �տ� ��� �ִ� �װ�. ������ ���� �ʰڳ�? �� ��� ���� �ƴ� �� ������...');
					g_textArea.WriteLn('');

					g_textArea.Write('[');
					g_textArea.Write('��', tcHelp);
					g_textArea.Write(' �Ǵ� ');
					g_textArea.Write('�ƴϿ�', tcHelp);
					g_textArea.Write('�� ���]');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('');

					REQUIRE_ANSWER := TRUE;
				end;
			end;
		end
		else if question = '�����δ�' then begin
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
				g_textArea.WriteLn('�װ� ������ ���� ���� ���ε鿡�Գ� �����.');
			end
			else begin
				g_textArea.WriteLn('�˰� �ʹٸ� {���� ����}�� ������ ��.');
			end;
			g_textArea.WriteLn('');
		end
		else if question = '��������' then begin
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
				g_textArea.WriteLn('���� ������ �� �� �ִ� ���� �װ� �پ�. ���� ���� �� �شٰ� �ص� ���� �� �̻� �ƴ� ���� ����.');
			end
			else begin
				if g_tileMap.MapFlag[0, FLAG_GIVE_WISKEY] then begin
					g_textArea.WriteLn('��ȥ�� ���𰡰� �ܺο��� �������� ���� ������ ������ �����ϱ� ����� �κе��� ����. '+
										'���� �⺻���� ���� �ڽ��� �׾��ٴ� ����̰�, �� �̿ܿ��� ���� �͵��� �־�. '+
										'���� ����� �� �ִ� ���� ���� �ִٰ� �����ϳ�? ���� �ƴ϶�� ������ ���ɼ��� ũ����. '+
										'�� ���� ��ȥ�� �����δ� ���� ã�� ���� ���� �������� ���� ���̰ŵ�. '+
										'���� �� �Ÿ����� ��� ���� ������� �� ���� �߰��� ���� �ֱ��� ���̾�. '+
										'�װ͵� �� �ɷ����� ã�Ҵٱ⺸�ٴ� �쿬�� �������.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('�ٽ� ���� �߰� ���� ����. �? ���� ���� ���̳�?');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('<space Ű�� �����ʽÿ�>', tcHelp);
					g_GameMain.PressAnyKey();

					g_tileMap[21, 19] := OBJ_DOOR_OPEN;
					g_GameMain.UpdateDisplay();

					g_textArea.WriteLn('');
					g_textArea.WriteLn('���� ��� �ٷ� ���� ���� �ΰ� �� �ڽ��� ������ ���� ������ �������μ��� ���ذ� �� ��. '+
										'������ ���⿡ ���� �ִٴ� ���� �˱� ������ ������ ���� ���ٰ� ������ ���� �ٽ� ���ư����� ������. '+
										'�Ƹ� �ڳ׵� ���⿡ ���� �ִٴ� ���� ��ȥ�� ���������� �Ƹ� ������ �׻� �� ���� ���ϰɼ�.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('�̷� ���� ���̰� �ϴ� ������� �� ������ �־�. '+
										'���� ��ſ��� ���� ���� ��ó�� �ܺ��� �������� ���ݰ� �Ǵ� �Ͱ�, �ڽ��� ������ ���� ������� '+
										'������ �� ���� ã�� �� �ֵ��� �ϴ� ������.');
					g_textArea.WriteLn('');

					g_textArea.Write('�������� ���� ��������� �۽�... ... ���� ���ε鿡�� ');
					g_textArea.Write('������ ��', tcMonolog);
					g_textArea.Write('�̶�� ��� �ٽ� �������� ���� �� �ۿ� ���ڳ� �׷�.');
					g_textArea.WriteLn('');

					g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] := TRUE;
				end
				else begin
					g_textArea.WriteLn('���Կ��� �ȵ���. ������ ���� �شٸ� ����.');
				end;
			end;
			g_textArea.WriteLn('');
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('��ȥ�� ���󿡴� ���� ���ڰ� ���� ����.');
				1:   g_textArea.WriteLn('���� �߾� �Ÿ����� �� �𸣰ڱ�.');
				else g_textArea.WriteLn('��ȩ�� ���Կ��� �������� ���� �ȾҾ��µ�...');
			end;
			g_textArea.WriteLn('');
		end;
	end
	else begin
		g_textArea.WriteLn('�� �޽����� ���̸� ����� �������� �Ű��� �ּ���. �����Դϴ�.');
		g_textArea.WriteLn();
		g_InputArea.HideCaret;
		g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
	end;
	end;

	if question = KEYWORD_BYE then begin
		g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
	end;
end;

function EventData04(eventType: TEventType; eventId : integer): boolean;
var
	player: TPlayer;
	equipment: TItem;
begin
	result := TRUE;

	case eventType of
		etOn:
		case eventId of
			1:
			begin
				player := g_tileMap.GetPlayer('�������� ����');
				if assigned(player) then begin
					player.WarpOnTile(48, 9);
					g_tileMap[player.GetTilePos.x-1, player.GetTilePos.y+0] := OBJ_DOOR_OPEN;
					g_tileMap[player.GetTilePos.x-2, player.GetTilePos.y+1] := OBJ_DOOR_OPEN;
				end;
			end;
			2:
			begin
				g_textArea.WriteLn('�� �տ��� �� ���ڰ� ���δ�.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('''����� ��κ��� ������� ��� �� �� ���� ���̴� ����ٰ� ������ ������ �θ� �ǰڴ�.''', tcMonolog);
				g_textArea.ReservedClear();

				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''A''Ű�� �������� �������', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: ���� �� ���� �տ��� ''A''Ű�� ������ �������� ����� �̿��� �� �ִ�.', tcHelp);
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
			if not g_tileMap.MapFlag[0, FLAG_GET_DEAD_BOOK] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('å�忡�� ���� ��� å�� �� �� �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('���� å�忡�� å�� ��������. å�� ������ {���ļ��� �Թ���}�̴�.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[���ļ��� �Թ��� +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_BOOK, ITEM_BOOK_DEAD_WORLD);
					g_tileMap.MapFlag[0, FLAG_GET_DEAD_BOOK] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			2:
			if not g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_KEY] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('å�� �������� ���� �ϳ��� ��� �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('[���� +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_KEY, 8, 13);
					g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_KEY] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			3:
			if not g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_NOTE] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('å�� ������ ��Ʈ �� ���� �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('[��Ʈ +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_BOOK, ITEM_BOOK_LIBRARY_NOTE);
					g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_NOTE] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			4:
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_ORZ_DIARY] and (not g_tileMap.MapFlag[0, FLAG_GET_ORZ_DIARY]) then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('ã��� �� �������� å���� å �߿��� �Ϲ� å���� �ٸ� ��Ʈ�� �ϳ� �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('[å +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_BOOK, ITEM_BOOK_ORZ_DIARY);
					g_tileMap.MapFlag[0, FLAG_GET_ORZ_DIARY] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			5: // FLAG_GET_AIR_GUN
			if not g_tileMap.MapFlag[0, FLAG_GET_AIR_GUN] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('�ڽ� �ȿ��� ������ ���� �Ѱ� ���� ���� ���� ��� �ִ�.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('���� �峭�� ��ó�� ���̴� ���� ���� �����.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[���� �� +1]', tcEvent);
					g_textArea.WriteLn('[���� �� �Ŵ��� +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_AIR_GUN);
					g_inventory.Add(ITEM_MEMO, ITEM_MEMO_AIR_GUN_MANUAL);
					g_tileMap.MapFlag[0, FLAG_GET_AIR_GUN] := TRUE;

				end;
			end
			else begin
				result := FALSE;
			end;
			6:
			if not TRUE then begin
			end
			else begin
				result := FALSE;
			end;
		end;

		etReadQuery:
		case eventId of
			1:
			begin
				g_textArea.WriteLn('������ ''������ �繫��''��� �����ִ�.');
				g_textArea.WriteLn('');
			end;
			2:
			begin
				g_textArea.WriteLn('������ ''�ֹ� ��� �繫��''��� �����ִ�.');
				g_textArea.WriteLn('');
			end;
			3:
			begin
				g_textArea.WriteLn('������ ''��ȩ�� ������''�̶�� �����ִ�.');
				g_textArea.WriteLn('');
			end;
		end;

		etAction:
		case eventId of
			1:
			begin
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_DESERT);
				end;
				result := FALSE;
			end;
			2:
			begin
				equipment := g_tileMap.GetPC.Equipment;
				if equipment.itemId > 0 then begin
					g_inventory.Remove(equipment.itemId, equipment.aux1, equipment.aux2);
					//g_backPack.Add(ixEquipment);
				end;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
			end;
		end;
	end;
end;

end.


'�ڼ���'
�ڼ���? ���� ��� �� ���ϸ鼭�� �� �𸣰ڱ���.
else (�ϱ⸦ �����ش�)
��.. �¾� �� ����� �̸��� �ڼ�������. ���� �ѵ��� ���� �̸��� �������� �ʾ� ���ο� �߾��ŵ�. ���� ��ĥ �ȵǾ �����ع����� �ٸ� �Ͽ� ���� �߾���.
else ('��ĵ����'���� ����)
�״� �� ���ÿ� ��� ����� �ƴϾ�. ��� �׸� ��� ���� ���ķ� �ٽ� �������� ����. ���ζ�� �Ҹ��� �̰��� ������ ���� �� ����鿡�� ���� ���� �Ƹ��� �׿� ���� �Ǹ����� ã�� �� �������� �𸣰ڱ�. �̰����� ���ζ�� �Ҹ����� ����� '@1', '@2', '@3', '@4' ������ 4������. ��, �ڳװ� ������ �ֹε�ϼ��� �׺е� ���� ���� �� �������.

'��ĵ����', '�Ѿ��'
��.. ����� ������ ���� �������� ������ �� ��� ���� �ϵ��� �� ����� �ȳ��ٳ�.
else (�ϱ⸦ �����ش�)
(�ڽ��� �ϱ⸦ �а� ����) ��.. �׷��� �װ��� ������ �ǹ��ϴ� ���� �𸣰ڳ�. ��� �� ���迡���� ������ ���� ���̰ŵ�. ��κ��� ������� �ڽ��� ���� ���迡�� ������ �ߴ��� � ����̾������� ���ؼ� ���� ����� ���ϰŵ�? �ƹ����� �ڼ����� ã�Ƽ� ������� �ڱ�.

'@1'
�׺��� �׳��� ���� ���� ������ ����̶��. ������ AVEJ�� �߾� ���� �߿� ��θӸ�����. ������ �߾ӿ� �ִ� �߾����߱��� ���� �׸� ���� �� �����ɼ�.
'@2'
'@3'
'@4'

'�߾����߱�'
AVEJ�� �߽ɺο� �ִ� �ǹ�����.

>> ����
'@1'�� ��ϼ��� ���ο� ���̰� ���� ����. �׷��� �׿ʹ� �հ��� �ִ� ��ϼҸ� ����
'@4'�� ���� ���� ��� �� ö�а�

