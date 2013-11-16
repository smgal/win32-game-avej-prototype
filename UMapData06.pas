unit UMapData06;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc06(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData06(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData06(eventType: TEventType; eventId : integer): boolean;
function  Char2MapProc06(cTemp: char): longword;

const
	MAP_DATA_06W: array[0..7] of widestring =
	(
		'¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç',
		'¢Ç¥ª¥ª¥ª¥¹¥ª¥ª¡¡£ª¡¡¡ß¡ß¡ß¡ß¡ß¡ß¢Ç',
		'¢Ç¡¡¡¡¡¡¡¡¡¡¡¡¡¡¢Ç¡¡¡¡¡¡¡¡¡¡¡¡¡¡¢Ç',
		'¢Ç¡Ì¡¡¡¡¡¡¡¡¡¡¡¡¢Ç¡¡¡Þ¡Þ¡Þ¡Þ¡Þ¡Þ¢Ç',
		'¢Ç¡¡¡¡¡¡¡¡¡¡¡¡¡¡¢Ç¡¡¡¡¡¡¡¡¡¡¡¡¡¡¢Ç',
		'¢Ç¢Ç¢Ç¢Ç£ª¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¡¡¢Ç',
		'¢Ç¢×¡¡¡¡¡¡¡¡¡¡¡¡¢Ç¢×¡¡¡¡¡¡¡¡¡¡¡¡¢Ç',
		'¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç¢Ç'
	);

	MAP_EVENT_06: array[0..0] of TMapEventDesc =
	(
		(pos: (x:  7; y: 16); eventType: etSearch; id: 1; flag: 100)
	);

	MAP_NPC_06: array[0..0] of TMapNPCDesc =
	(
		(charType: 0; pos: (x:  2; y:  9); name: '')
	);

implementation

uses
	UGameMain, UTileMap;

const
	FLAG_TEST = 1;

procedure InitProc06(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	if prevMapId = SCRIPT_AVEJ_WEST_LV1 then begin
		if (prevPos.x >= 0) and (prevPos.y >= 0) then begin
			(sender as TTileMap).GetPC.WarpOnTile(prevPos.x div BLOCK_W_SIZE, prevPos.y div BLOCK_H_SIZE);
		end;
	end;
end;

function  Char2MapProc06(cTemp: char): longword;
begin
	case cTemp of
		chr(255): result := 3;
		else result := high(longword);
	end;
end;

procedure TalkData06(personalId : integer; const question : widestring; const fullInput : wideString = '');
begin
	g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
end;

function EventData06(eventType: TEventType; eventId : integer): boolean;
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

