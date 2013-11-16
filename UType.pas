unit UType;

interface

uses
	Windows;

type
	TColor = longword;

	TBound = record
		x1, y1, x2, y2: longint;
	end;

	TVector = record
		dx, dy: longint;
	end;

	TPosDouble = record
		x, y: double;
	end;

	TVectorDouble = record
		dx, dy: double;
	end;

	TPosition = TPoint;

	TFaceDir = (fdDown, fdRight, fdUp, fdLeft, fdNone, fdCW, fdCCW);

	TEventType = (etOn, etOpen, etRead, etReadQuery, etSearch, etSearchQuery, etAction, etTime);
	TEventTypeSet = set of TEventType;

	TMapEventDesc = record
		pos: TPoint;
		eventType: TEventType;
		id: integer;
		flag: integer;
	end;
	PMapEventDescArray = ^TMapEventDescArray;
	TMapEventDescArray = array[0..60000] of TMapEventDesc;

	TMapNPCDesc = record
		charType: integer;
		pos: TPoint;
		name: widestring;
	end;
	PTMapNPCDescArray = ^TTMapNPCDescArray;
	TTMapNPCDescArray = array[0..60000] of TMapNPCDesc;

	TFnTalkProc  = procedure(personalId : integer; const question : wideString; const fullInput : wideString = '');
	TFnEventProc = function(eventType: TEventType; eventId : integer): boolean;

	TFnChar2Map = function(cTemp: char): longword;

	TFnInitProc = procedure(const sender: TObject; prevMapId: integer; prevPos: TPosition);

	TMapDesc = record
		idString: string;
		nMapData: integer;
		pMapData: Pstring;
		nMapDataW: integer;
		pMapDataW: Pwidestring;
		nEventData: integer;
		pEventData: PMapEventDescarray;
		nNPCData: integer;
		pNPCData: PTMapNPCDescArray;
		fnTalkProc: TFnTalkProc;
		fnEventProc: TFnEventProc;
		fnChar2MapProc: TFnChar2Map;
		fnInitProc: TFnInitProc;
		idUpStairs: integer; xOffUpStairs, yOffUpStairs: integer;
		idDownStairs: integer; xOffDownStairs, yOffDownStairs: integer;
	end;

implementation

end.

