unit USmIme;

interface

uses
	Windows;

type
	TShiftState = set of (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble);
	TInputMode  = (INPUTMODE_ENG, INPUTMODE_HAN);

	TSmIme = class
	public
		constructor Create();
		procedure   Free();

	private
		m_inputMode: TInputMode;
		m_nativeStr: string;
		m_resultStr: widestring;
		m_currStr  : widestring;

	public

		procedure ProcKeyUp(key: word; Shift: TShiftState);
		procedure Reset();

		property  InputMode: TInputMode read m_inputMode write m_inputMode;
		property  wComplete: widestring read m_resultStr write m_resultStr;
		property  wComposite: widestring read m_currStr write m_currStr;

	end;

implementation

constructor TSmIme.Create();
begin
	Reset();
end;

procedure   TSmIme.Free();
begin
end;

procedure TSmIme.Reset();
begin
	m_resultStr := '';
	m_currStr   := '';
	m_nativeStr := '';
	m_inputMode := INPUTMODE_HAN;
end;

function MAKE_UNICODE(SM1, SM2, SM3: integer): widechar;
begin
	result := widechar($AC00 + SM1*(28*21) + SM2*28 + SM3);
end;

const
KEY_MAPPING: array[0..25, 0..3] of integer =
(
	(  6,  6, 16, 16), //a
	( -1, -1, 17, 17), //b
	( 14, 14, 23, 23), //c
	( 11, 11, 21, 21), //d
	(  3,  4,  7,  7), //e *
	(  5,  5,  8,  8), //f
	( 18, 18, 27, 27), //g
	( -1, -1,  8,  8), //h
	( -1, -1,  2,  2), //i
	( -1, -1,  4,  4), //j
	( -1, -1,  0,  0), //k
	( -1, -1, 20, 20), //l
	( -1, -1, 18, 18), //m
	( -1, -1, 13, 13), //n
	( -1, -1,  1,  3), //o &
	( -1, -1,  5,  7), //p &
	(  7,  8, 17, 17), //q *
	(  0,  1,  1,  2), //r *
	(  2,  2,  4,  4), //s
	(  9, 10, 19, 20), //t *
	( -1, -1,  6,  6), //u
	( 17, 17, 26, 26), //v
	( 12, 13, 22, 22), //w *
	( 16, 16, 25, 25), //x
	( -1, -1, 12, 12), //y
	( 15, 15, 24, 24)  //z
);

EM_MAPPING: array [0..18] of word =
(
	$3131, $3132, $3134, $3137, $3138,
	$3139, $3141, $3142, $3143, $3145,
	$3146, $3147, $3148, $3149, $314A,
	$314B, $314C, $314D, $314E
);

function ConvToIndex(ch: char; var OX1, OX2: integer): boolean;
begin
	result := FALSE;

	ch := char(byte(ch) and $7F);

	if (ch >= 'a') and  (ch <= 'z') then begin
		OX1 := integer(ch) - integer('a');
		OX2 := 0;
	end
	else if (ch >= 'A') and  (ch <= 'Z') then begin
		OX1 := integer(ch) - integer('A');
		OX2 := 1;
	end
	else begin
		OX1 := -1;
		exit;
	end;

	result := TRUE;
end;

function GetEm(OX1, OX2: integer): widechar;
begin
	if (KEY_MAPPING[OX1][OX2] >= 0) then begin
		result := widechar(EM_MAPPING[KEY_MAPPING[OX1][OX2]]);
	end
	else begin
		result := widechar(KEY_MAPPING[OX1][OX2+2] + $314F);
	end;
end;

function IsAscii(ch: char): boolean;
begin
	result := ((byte(ch) and $80) = 0);
end;

function IsConsonant(ch: char): boolean;
var
	OX1, OX2: integer;
begin
	result := FALSE;

	if not ConvToIndex(ch, OX1, OX2) then
		exit;

	result := (KEY_MAPPING[OX1][OX2] >= 0);
end;

function IsVowel(ch: char): boolean;
var
	OX1, OX2: integer;
begin
	result := FALSE;

	if not ConvToIndex(ch, OX1, OX2) then
		exit;

	if KEY_MAPPING[OX1][OX2] >= 0 then
		exit;

	result := (KEY_MAPPING[OX1][OX2+2] >= 0);
end;

const UNI_NOT_COMPLETE = 0;
const UNI_SEPARATE     = 0;
const UNI_ASCII        = 1;
const UNI_COMPLETE     = 2;


function MakeUniHan(pSeq: pchar; var pCode: integer): wchar;
var
	SM1, SM2, SM3, SM4: integer;
	OX1, OX2: integer;
	seq: integer;
begin
	result := wchar(0);

	pCode := 0;

	if not assigned(pSeq) then
		exit;

	SM3 := 0;
	seq := 0;

	if IsAscii(pSeq[seq]) then begin
		pCode := UNI_ASCII;
		result := wchar(pSeq[seq]);
		exit;
	end;

	if not ConvToIndex(pSeq[seq], OX1, OX2) then begin
		pCode := UNI_ASCII;
		result := wchar(pSeq[seq]);
		exit;
	end;

	SM1 := KEY_MAPPING[OX1][OX2];
	if SM1 < 0 then begin
		pCode := UNI_ASCII;
		result := GetEm(OX1, OX2);
		exit;
	end;

	inc(seq);

	if not ConvToIndex(pSeq[seq], OX1, OX2) then begin
		pCode := UNI_ASCII;

		ConvToIndex(pSeq[seq-1], OX1, OX2);

		result := GetEm(OX1, OX2);
		exit;
	end;

	if KEY_MAPPING[OX1][OX2] >= 0 then begin
		pCode := UNI_ASCII;

		ConvToIndex(pSeq[seq-1], OX1, OX2);

		result := GetEm(OX1, OX2);
		exit;
	end;

	SM2 := KEY_MAPPING[OX1][OX2+2];
	if SM2 < 0 then
		exit;

	inc(seq);

	repeat
		if pSeq[seq] = char(0) then
			break;

		if not ConvToIndex(pSeq[seq], OX1, OX2) then
			exit;

		if KEY_MAPPING[OX1][OX2] < 0 then begin
			SM3 := KEY_MAPPING[OX1][OX2+2];
			if SM2 = 8 then begin
				case SM3 of
					 0: SM2 :=  9;
					 1: SM2 := 10;
					20: SM2 := 11;
					else exit;
				end;
			end
			else if SM2 = 13 then begin
				case SM3 of
						 4: SM2 := 14;
						 5: SM2 := 15;
						20: SM2 := 16;
					else exit;
				end;
			end
			else if (SM2 = 18) and (SM3 = 20) then begin
				SM2 := 19;
			end
			else begin
				exit;
			end;

			if not ConvToIndex(pSeq[seq+1], OX1, OX2) then begin
				if ord(pSeq[seq+1]) > 0 then begin
					if not IsConsonant(pSeq[seq+1]) then
						exit;
				end;
				SM3 := 0;
				break;
			end;

			inc(seq);
		end;

		SM3 := KEY_MAPPING[OX1][OX2+2];
		if SM3 < 0 then
			exit;

		inc(seq);

		if pSeq[seq] = char(0) then
			break;

		if not ConvToIndex(pSeq[seq], OX1, OX2) then
			exit;

		SM4 := KEY_MAPPING[OX1][OX2];
		if SM4 < 0 then
			exit;

		if (SM3 = 1) and  (SM4 = 9) then begin
			SM3 := 3;
		end
		else if SM3 = 4 then begin
			case SM4 of
				12: SM3 :=  5;
				18: SM3 :=  6;
				else exit;
			end;
		end
		else if SM3 = 8 then begin
			case SM4 of
				 0: SM3 :=  9;
				 6: SM3 := 10;
				 7: SM3 := 11;
				 9: SM3 := 12;
				16: SM3 := 13;
				17: SM3 := 14;
				18: SM3 := 15;
				else exit;
			end;
		end
		else if (SM3 = 17) and  (SM4 = 9) then begin
			SM3 := 18;
		end
		else begin
			exit;
		end;

		inc(seq);
		if (pSeq[seq] <> char(0)) then
			exit;

	until TRUE;

	result := MAKE_UNICODE(SM1, SM2, SM3);
end;

function SIME_KeyboardToUnicode(szText: pchar; var szResult: widestring): boolean;
var
	szTemp: array[0..255] of char;
	ixHead: integer;
	ixLen: integer;

	ret: wchar;
	ixResult: integer;

	code: integer;
	fExit: boolean;

	procedure CHARGE_STRING;
	begin
		ixLen := 0;
		szTemp[0] := szText[ixHead+ixLen]; inc(ixLen);
		szTemp[1] := szText[ixHead+ixLen]; inc(ixLen);
		szTemp[2] := char(0);
	end;

begin
	result := FALSE;

	if szText = nil then
		exit;

	if szText[0] = char(0) then begin
		SetLength(szResult, 0);
		result := TRUE;
		exit;
	end;

	if szText[1] = char(0) then begin
		SetLength(szResult, 1);
		szResult[1] := MakeUniHan(szText, code);
		result := TRUE;
		exit;
	end;

	ixHead := 0;
	ixResult := 1;
	SetLength(szResult, 256);

	CHARGE_STRING;

	while TRUE do begin
		fExit := (szText[ixHead+ixLen] = char(0));

		ret := MakeUniHan(szTemp, code);

		if (ret <> wchar(0)) then begin
			case code of
				0:
				if not fExit then begin
					szTemp[ixLen] := szText[ixHead+ixLen];
					inc(ixLen);
					szTemp[ixLen] := char(0);
				end;

				UNI_ASCII:
				begin
					inc(ixHead);
					szResult[ixResult] := ret;
					inc(ixResult);
					CHARGE_STRING;
				end;

				UNI_COMPLETE:
				begin
					ixHead := ixHead + ixLen;
					szResult[ixResult] := ret;
					inc(ixResult);
					CHARGE_STRING;
				end;
			end;
		end
		else begin
			if IsVowel(szTemp[ixLen-1]) and IsConsonant(szTemp[ixLen-2]) then
				dec(ixLen, 2)
			else
				dec(ixLen, 1);

			szTemp[ixLen] := char(0);
			ret := MakeUniHan(szTemp, code);

			ixHead := ixHead + ixLen;
			szResult[ixResult] := ret;
			inc(ixResult);

			CHARGE_STRING;
		end;

		if fExit then begin
			ret := MakeUniHan(szTemp, code);
			szResult[ixResult] := ret;
			inc(ixResult);
			break;
		end;
	end;

	szResult[ixResult] := wchar(0);
	SetLength(szResult, ixResult-1);

	result := true;
end;

procedure TSmIme.ProcKeyUp(key: word; Shift: TShiftState);
var
	inputMode: TInputMode;
begin
	if key = VK_BACK then begin
		if m_nativeStr <> '' then begin
			m_nativeStr := Copy(m_nativeStr, 1, Length(m_nativeStr) - 1);
			SIME_KeyboardToUnicode(PChar(m_nativeStr), m_currStr)
		end
		else if m_resultStr <> '' then begin
			m_resultStr := Copy(m_resultStr, 1, Length(m_resultStr) - 1);
		end;
		exit;
	end;

	inputMode := m_inputMode;
	if not (char(key) in ['A'..'Z', 'a'..'z']) then
		inputMode := INPUTMODE_ENG;

	case inputMode of
		INPUTMODE_ENG:
		begin
			m_resultStr := m_resultStr + m_currStr;
			SetLength(m_nativeStr, 1);
			m_nativeStr[1] := char(key);
			if SIME_KeyboardToUnicode(PChar(m_nativeStr), m_currStr) then
				m_resultStr := m_resultStr + m_currStr[1];
			m_nativeStr := '';
			m_currStr := '';
		end;
		INPUTMODE_HAN:
		begin
			SetLength(m_nativeStr, Length(m_nativeStr)+1);
			m_nativeStr[Length(m_nativeStr)] := char(key or $80);
			if SIME_KeyboardToUnicode(PChar(m_nativeStr), m_currStr) then begin
				if Length(m_currStr) > 1 then begin
					m_resultStr := m_resultStr + m_currStr[1];
					if m_currStr[2] < wchar($AC00) then begin
						m_nativeStr := Copy(m_nativeStr, Length(m_nativeStr), 1);
					end
					else begin
						m_nativeStr := Copy(m_nativeStr, Length(m_nativeStr)-1, 2);
					end;
				end;
			end;

			SIME_KeyboardToUnicode(PChar(m_nativeStr), m_currStr);
		end;
	end;
end;

end.

