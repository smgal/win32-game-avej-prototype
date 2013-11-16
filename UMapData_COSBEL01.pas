unit UMapData_COSBEL01;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc_COSBEL01(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData_COSBEL01(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData_COSBEL01(eventType: TEventType; eventId : integer): boolean;
function  Char2MapProc_COSBEL01(cTemp: char): longword;

const
	MAP_DATA_COSBEL01W: array[0..31] of widestring =
	(
'�ššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˢˢˢˢˢˢˢˢˢˢˢˢˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢơ������ˡ����������������ˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢơ������ˡ����������������ˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ����ˡ����������������ˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ����ˢˢˢˢˢˢˢˢˢˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ����ǡ����������ǡ����ˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢơ������ǡ����������ǡ����ˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢơ������ǢǢǢǢǢǢǡ����ˡššššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ������������������������Ƣơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ������������������������Ƣơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ����������������������ˢƢơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ����������������������ˢƢơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˡ����������������������ˢƢơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢƢƢˢˢˡ����ǡ��ǡ����ˢˢˢƢơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢââââââââââââââââơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢââââââââââââââââơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢââåȥȡ�ȥȢ��ȡ�ȥȢâââơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢââåȥȥȥȥȥȥȥȥȥȢâââơššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššššŢââá�Ȣ����ȥȢ����ȡ�âââˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˢˡšššš�',
'�ˢˢˢˢˢˢˢââåȥȥȥȥȥȥȥȥȥȢâââˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�šššššŢˢââåȥȡ�Ȣ��ȥȡ�ȥȢâââˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�šššššŢˢââââââââââââââââˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššššŢˢˢââââââââââââââââˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�šššŢˢˢâââââášŢˢˡ�ˢˣ��ˡ�ˢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ššŢˢˢâââáššššŢ˥ååååååéˢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�šŢˢˢâââˢˡššššŢ˥ååååååéˢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ŢˢˢâââˢˢˡššššŢ˩˥åååååèˢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ˢˢâââˢˡŢˡššššŢ˩˨˩˨˩˩˨˩ˢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ˢâââˢˡšŢˡššššŢˢˢˢˢˢˢˢˢˢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ˡϢâˢˡššŢˡšššššššššššššŢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�',
'�ˢˢˢˡšššŢˡšššššššššššššŢˡššššššššššššššššššššššššššššššššššššššššššššššššššš�'

	);

	MAP_EVENT_COSBEL01: array[0..0] of TMapEventDesc =
	(
		(pos: (x:  1; y: high(MAP_DATA_COSBEL01W)-1); eventType: etAction; id: 1; flag: 1)
	);

	MAP_NPC_COSBEL01: array[0..1] of TMapNPCDesc =
	(
		(charType: $00; pos: (x:  2; y: high(MAP_DATA_COSBEL01W)-2); name: ''),
		(charType: $40+00; pos: (x:  9; y: 23); name: '1')
	);

implementation

uses
	UGameMain, UTileMap;

const
	FLAG_GET_PYRO_BOMB = 1;

procedure InitProc_COSBEL01(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
end;

function  Char2MapProc_COSBEL01(cTemp: char): longword;
begin
	result := high(longword);
end;

procedure TalkData_COSBEL01(personalId : integer; const question : widestring; const fullInput : wideString = '');
begin
	g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
end;

function EventData_COSBEL01(eventType: TEventType; eventId : integer): boolean;
begin
	result := TRUE;

	case eventType of
		etOn:
		case eventId of
			1:
			begin
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
			begin
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
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_AVEJ_WEST_LV0);
				end;
				result := FALSE;
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

