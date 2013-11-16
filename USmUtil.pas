unit USmUtil;

interface

uses
	Windows;

type
	TKeyEnum = (SM_KEY_LEFT, SM_KEY_RIGHT, SM_KEY_UP, SM_KEY_DOWN, SM_KEY_SHOOT, SM_KEY_CHANGE, SM_KEY_LOCK);
	TKeyList = array[TKeyEnum] of Word;

	PByteArray = ^TByteArray;
	TByteArray = array[0..32767] of byte;

type
	EAvejError = class
	private
		m_message: string;
	public
		constructor Create(s: string);
		property    Message: string read m_message;
	end;

	EAvejD3D = class(EAvejError);

function AllocMem(Size : Cardinal) : Pointer;

function Point(AX, AY: Integer): TPoint;
function Rect(ALeft, ATop, ARight, ABottom : Integer) : TRect;
function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;

function FileExists(const FileName : string) : Boolean;
function LowerCase(const S: string): string;
function ExtractFileExt(const FileName: string): string;

function ToStr(data: integer; width: integer = -1): string;

function IsEqualGUID(const iid1, iid2 : TGUID) : Boolean; stdcall;
function timeGetTime : DWORD; stdcall;

function SmSin(Degree : integer) : Single;
function SmCos(Degree : integer) : Single;
function SmAtan(y, x: Extended): Extended;
function SmSqrt(Value : Single) : Single;

function GetWindowsTempPath(): string;

procedure WriteDebugLog(s: string);

var
	ResourceDLL: HINST;

implementation

function AllocMem(Size : Cardinal) : Pointer;
begin
	GetMem(Result, Size);
	FillChar(Result^, Size, 0);
end;

function Point(AX, AY: Integer): TPoint;
begin
	with Result do begin
		X := AX;
		Y := AY;
	end;
end;

function Rect(ALeft, ATop, ARight, ABottom : Integer) : TRect;
begin
	with Result do begin
		Left   := ALeft;
		Top    := ATop;
		Right  := ARight;
		Bottom := ABottom;
	end;
end;

function Bounds(ALeft, ATop, AWidth, AHeight : Integer) : TRect;
begin
	with Result do begin
		Left   := ALeft;
		Top    := ATop;
		Right  := ALeft + AWidth;
		Bottom := ATop  + AHeight;
	end;
end;

(*
function FileExists(const FileName : string) : Boolean;
var
	f : File;
begin
	AssignFile(f, FileName);
{$I-}
	Reset(f, 1);
{$I+}
	if IOResult = 0 then begin
		CloseFile(f);
		FileExists := TRUE;
	end else begin
		FileExists := FALSE;
	end;
end;
*)
function FileAge(const FileName: string): Integer;
type
	LongRec = packed record
		Lo, Hi: Word;
	end;
var
	Handle: THandle;
	FindData: TWin32FindData;
	LocalFileTime: TFileTime;
begin
	Handle := FindFirstFile(PChar(FileName), FindData);
	if Handle <> INVALID_HANDLE_VALUE then begin
		Windows.FindClose(Handle);
		if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then begin
			FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
			if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi, LongRec(Result).Lo) then
				Exit;
		end;
	end;
	Result := -1;
end;

function FileExists(const FileName: string): Boolean;
begin
	Result := FileAge(FileName) <> -1;
end;

/////////////////////////// SysUtils /////////////////////////

function LowerCase(const S: string): string;
var
	Ch: Char;
	L: Integer;
	Source, Dest: PChar;
begin
	L := Length(S);
	SetLength(Result, L);
	Source := Pointer(S);
	Dest := Pointer(Result);
	while L <> 0 do	begin
		Ch := Source^;
		if (Ch >= 'A') and (Ch <= 'Z') then
			Inc(Ch, 32);
		Dest^ := Ch;
		Inc(Source);
		Inc(Dest);
		Dec(L);
	end;
end;

function StrScan(const Str: PChar; Chr: Char): PChar; assembler;
asm
	PUSH    EDI
	PUSH    EAX
	MOV     EDI,Str
	MOV     ECX,0FFFFFFFFH
	XOR     AL,AL
	REPNE   SCASB
	NOT     ECX
	POP     EDI
	MOV     AL,Chr
	REPNE   SCASB
	MOV     EAX,0
	JNE     @@1
	MOV     EAX,EDI
	DEC     EAX
@@1:POP     EDI
end;

type
	TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

function ByteType(const S: string; Index: Integer): TMbcsByteType;
begin
	Result := mbSingleByte;
end;

function LastDelimiter(const Delimiters, S: string): Integer;
var
	P: PChar;
begin
	Result := Length(S);
	P := PChar(Delimiters);
	while Result > 0 do begin
		if (S[Result] <> #0) and (StrScan(P, S[Result]) <> nil) then
			if (ByteType(S, Result) = mbTrailByte) then
				Dec(Result)
			else
				Exit;
		Dec(Result);
	end;
end;

function ExtractFileExt(const FileName: string): string;
var
	I: Integer;
begin
	I := LastDelimiter('.\:', FileName);
	if (I > 0) and (FileName[I] = '.') then
		Result := Copy(FileName, I, MaxInt)
	else
		Result := '';
end;

function ToStr(data: integer; width: integer): string;
begin
	if (width > 0) then
		str(data: width, result)
	else
		str(data, result)
end;

///////////////////////////////////////////////////////

function IsEqualGUID(const iid1, iid2: TGUID): Boolean; stdcall; external 'ole32.dll' name 'IsEqualGUID';
function timeGetTime; external 'winmm.dll' name 'timeGetTime';

function SmSin(Degree : integer) : Single;
const
	FLOAT_SINE_TABLE : array[0..90] of Single = (
		0.000000, 0.017452, 0.034899, 0.052336, 0.069756,
		0.087156, 0.104528, 0.121869, 0.139173, 0.156434,
		0.173648, 0.190809, 0.207912, 0.224951, 0.241922,
		0.258819, 0.275637, 0.292372, 0.309017, 0.325568,
		0.342020, 0.358368, 0.374607, 0.390731, 0.406737,
		0.422618, 0.438371, 0.453990, 0.469471, 0.484810,
		0.500000, 0.515038, 0.529919, 0.544639, 0.559193,
		0.573576, 0.587785, 0.601815, 0.615661, 0.629320,
		0.642788, 0.656059, 0.669131, 0.681998, 0.694658,
		0.707107, 0.719340, 0.731354, 0.743145, 0.754709,
		0.766044, 0.777146, 0.788011, 0.798635, 0.809017,
		0.819152, 0.829037, 0.838670, 0.848048, 0.857167,
		0.866025, 0.874620, 0.882948, 0.891006, 0.898794,
		0.906308, 0.913545, 0.920505, 0.927184, 0.933580,
		0.939693, 0.945518, 0.951056, 0.956305, 0.961262,
		0.965926, 0.970296, 0.974370, 0.978148, 0.981627,
		0.984808, 0.987688, 0.990268, 0.992546, 0.994522,
		0.996195, 0.997564, 0.998630, 0.999391, 0.999848,
		1.000000
	);
begin
	while (Degree < 0) do
		inc(Degree, 360);

	Degree := Degree mod 360;

	if      (Degree <=  90) then Result :=  FLOAT_SINE_TABLE[ Degree       ]
	else if (Degree <= 180) then Result :=  FLOAT_SINE_TABLE[ 180 - Degree ]
	else if (Degree <= 270) then Result := -FLOAT_SINE_TABLE[ Degree - 180 ]
	else                           Result := -FLOAT_SINE_TABLE[ 360 - Degree ]
end;

function SmCos(Degree : integer) : Single;
begin
	Result := SmSin((degree + 90));
end;

function SmAtan(y, x: Extended): Extended;
asm
	FLD     y
	FLD     x
	FPATAN
	FWAIT
end;

function mborg_isqrt4(val : DWord) : Longint;
var
	temp, g, Count : DWord;
begin
	g := 0;

	if (val >= $40000000) then begin
		g := $8000;
		Dec(val, $40000000);
	end;

	Count := 15;
	while (Count > 1) do begin
		temp := (g shl (Count)) + (1 shl ((Count) * 2 - 2));
		if (val >= temp) then begin
			Inc(g,   1 shl ((Count) - 1));
			Dec(val, temp);
		end;
		Dec(Count);
	end;

	temp := g + g + 1;

	if (val >= temp) then
		Inc(g);

	Result := g;
end;

function SmSqrt(Value : Single) : Single;
var
	Zadkiel   : Single;
	DivFactor : Integer;
begin
	if (Value > 1.0) then	begin
		Result := mborg_isqrt4(Round(Value * 10000)) / 100;
	end
	else if (Value > 0.0000000001) then begin
		Zadkiel   := Value;
		DivFactor := 1;

		while (Zadkiel < 100.0) do begin
			Zadkiel   := Zadkiel   * 100;
			DivFactor := DivFactor * 10;
		end;

		Result := mborg_isqrt4(Round(Zadkiel)) / DivFactor;
	end
	else begin
		Result := 0.0;
	end;
end;

function GetWindowsTempPath(): string;
var
	buffer: array[0..1023] of char;
begin
	SetString(result, buffer, GetTempPath(sizeof(buffer)-1, buffer));
end;

const
	LOG_FILE_NAME = 'runtime.log';

procedure InitDebugLog();
var
	log: TextFile;
begin
	Windows.DeleteFile(LOG_FILE_NAME);
	AssignFile(log, LOG_FILE_NAME);
	{$I-}
	Rewrite(log);
	{$I+}
	if IOResult = 0 then begin
		WriteLn(log, '>> AVEJ system log');
		WriteLn(log, '');
		CloseFile(log);
	end;
end;

procedure WriteDebugLog(s: string);
var
	log: TextFile;
begin
	AssignFile(log, LOG_FILE_NAME);
	{$I-}
	Append(log);
	{$I+}
	if IOResult = 0 then begin
		WriteLn(log, s);
		CloseFile(log);
	end;
end;

///////////////////////////////////////////////////////

constructor EAvejError.Create(s: string);
begin
	m_message := s;
end;

initialization
	InitDebugLog();

end.
