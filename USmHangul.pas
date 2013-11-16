unit USmHangul;

interface

const
	// ÄÜ¼Ö Å°¿öµå¿ë ¿¹¾à¾î
	KEYWORD_BEGIN  = '{';
	KEYWORD_END    = '}';

type
	TFnBitBlt = procedure(xDest, yDest: integer; width, height: integer; xSour, ySour: integer; color: longword); stdcall;

function  RealLength(const s : widestring) : integer;
procedure SmDrawText(xDest, yDest: integer; const szText: widestring; color: longword; auxColor: longword; fnBitBlt: TFnBitBlt);
procedure SmDrawTextFit(xDest, yDest: integer; const szText: widestring; color: longword; auxColor: longword; fnBitBlt: TFnBitBlt; fitWidth: integer);

function  SmGetHangulO(const s : widestring) : widestring;
function  SmGetHangulRo(const s : widestring) : widestring;

implementation

type
	TGlyphRect = record
		nRect: integer;
		rect: array[0..2] of
		record
			x1, y1, x2, y2: integer;
		end;
	end;

const
	W_BUFFER: integer = 512;
	H_BUFFER: integer = 256;

procedure ConvertUnicodeToJohap(const widecode: widechar; var johap: longword);
const
	MAX_SM1 = 19;
	MAX_SM2 = 21;
	MAX_SM3 = 28;

	JH_UNI_TABLE: array[0..2, 0..31] of integer =
	(
		(-1,-2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
		(-1,-1,-2, 0, 1, 2, 3, 4,-1,-1, 5, 6, 7, 8, 9,10,-1,-1,11,12,13,14,15,16,-1,-1,17,18,19,20,-1,-1),
		(-1,-2, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,-1,17,18,19,20,21,22,23,24,25,26,27,-1,-1)
	);

	UNI_JH_TABLE: array[0..2, 0..31] of integer =
	(
		( 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
		( 3, 4, 5, 6, 7,10,11,12,13,14,15,18,19,20,21,22,23,26,27,28,29,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
		( 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,-1,-1,-1,-1)
	);

	INCOMPLETE_TABLE: array[$3131..$3163] of integer =
	(
		// CONSONANT
		$8800, $8C00, $8444, $9000, $8446, $8447, $9400, $9800, $9C00, $844A,
		$844B, $844C, $844D, $844E, $844F, $8450, $A000, $A400, $A800, $8454,
		$AC00, $B000, $B400, $B800, $BC00, $C000, $C400, $C800, $CC00, $D000,
		// VOWEL
		$8461, $8481, $84A1, $84C1, $84E1, $8541, $8561, $8581, $85A1, $85C1,
		$85E1, $8641, $8661, $8681, $86A1, $86C1, $86E1, $8741, $8761, $8781,
		$87A1
	);

var
	unicode : integer;
	SM1     : integer;
	SM2     : integer;
	SM3     : integer;
	temp16  : word;
begin
	johap   := 0;
	unicode := integer(widecode);

	if (unicode < $0080) then begin
		johap := unicode;
	end
	else if ((unicode >= $AC00) and (unicode <= $D7A3)) then begin
		dec(unicode, $AC00);

		SM1 :=  unicode div (MAX_SM2 * MAX_SM3);
		SM2 := (unicode - SM1 * (MAX_SM2 * MAX_SM3)) div MAX_SM3;
		SM3 :=  unicode - SM1 * (MAX_SM2 * MAX_SM3) - SM2 * MAX_SM3;

		SM1 := UNI_JH_TABLE[0][SM1];
		SM2 := UNI_JH_TABLE[1][SM2];
		SM3 := UNI_JH_TABLE[2][SM3];

		johap := $8000 or (SM1 shl 10) or (SM2 shl 5) or SM3;
	end
	else if ((unicode >= $3131) and (unicode <= $3163)) then begin
		temp16 := INCOMPLETE_TABLE[unicode];
		if temp16 > 0 then begin
			johap := temp16;
		end;
	end;
end;

function  GlyphIndex(chCode : longword) : longint;
const
	CONVERT_TABLE: array[0..2, 0..30] of byte =
	(
		( 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		( 0, 0, 0, 1, 2, 3, 4, 5, 0, 0, 6, 7, 8, 9,10,11, 0, 0,12,13,14,15,16,17, 0, 0,18,19,20,21, 0),
		( 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16, 0,17,18,19,20,21,22,23,24,25,26,27, 0)
	);
var
	i: integer;
	jamo: array[0..2] of longword;
	johap: longword;
begin
	ConvertUnicodeToJohap(widechar(chCode), johap);

	if ((johap and $8000) = 0) or (johap > $FFFF) then begin
		result := -1;
		exit;
	end;

	jamo[0] := (johap shr 10) and $1F;
	jamo[1] := (johap shr  5) and $1F;
	jamo[2] := (johap shr  0) and $1F;

	result := 0;
	for i := 0 to 2 do begin
		result := result shl 8;
		if jamo[i] < $20 then
			result := result or longint(CONVERT_TABLE[i, jamo[i]]);
	end;
end;

function GetGlyph(index: longword; out jamoIndex: array of integer): boolean;
var
	jamo: array[1..3] of longint;
	face: array[1..3] of longint;
begin
	result := FALSE;

	if index = $FFFFFFFF then
		exit;

	jamo[1] := (index shr 16) and $000000FF;
	jamo[2] := (index shr  8) and $000000FF;
	jamo[3] := (index shr  0) and $000000FF;

	face[1] := 0;
	face[2] := 0;
	face[3] := 0;

	if jamo[3] > 0 then begin
		if jamo[2] in [1..8,21]            then face[1] := 95;
		if jamo[2] in [9,13,14,18,19]      then face[1] := 114;
		if jamo[2] in [10..12,15..17,20]   then face[1] := 133;
		if jamo[1] in [1,16]               then face[2] := 194;
		if jamo[1] in [2..15,17..19]       then face[2] := 215;
		if jamo[2] in [1,3,10]             then face[3] := 236;
		if jamo[2] in [5,7,12,15,17,20,21] then face[3] := 263;
		if jamo[2] in [2,4,6,8,11,16]      then face[3] := 290;
		if jamo[2] in [9,13,14,18,19]      then face[3] := 317;

		if (jamo[1] = 0) and (jamo[2] = 0) then
			face[3] := 236;

	end else begin
		if jamo[2] in [1..8,21]            then face[1] := 0;
		if jamo[2] in [9,13,19]            then face[1] := 19;
		if jamo[2] in [14,18]              then face[1] := 38;
		if jamo[2] in [10..12,20]          then face[1] := 57;
		if jamo[2] in [15..17]             then face[1] := 76;
		if jamo[1] in [0,1,16]             then face[2] := 152;
		if jamo[1] in [2..15,17..19]       then face[2] := 173;

		if jamo[1] = 0 then
			face[1] := 0;
	end;

	jamoIndex[0] := face[1] + jamo[1] - 1;

	if (jamo[2] > 0) then
		jamoIndex[1] := face[2] + jamo[2] - 1
	else
		jamoIndex[1] := -1;

	if ((jamo[3] > 0) and (face[3] > 0)) then
		jamoIndex[2] := face[3] + jamo[3] - 1
	else
		jamoIndex[2] := -1;

	result := TRUE;
end;

function GetGlyphRect(index: longword; out glyphRect: TGlyphRect): boolean;
const
	HANJA_DATA: widestring = 'ìíêÅûýâ©ÙÊÐÝ÷Ïá¢'; // ôé
	X_HANJA = 384;
	Y_HANJA = 224;
var
	i: integer;
	wExtent: integer;
	hExtent: integer;
	pitch: integer;
	jamoIndex: array[0..2] of integer;
begin
	if (integer(index) >= $0080) then begin
		wExtent := 16;
		hExtent := 16;
		pitch   := W_BUFFER div wExtent;

		if GetGlyph(GlyphIndex(index), jamoIndex) then begin
			glyphRect.nRect := 0;
			for i := 0 to 2 do begin
				if (jamoIndex[i] < 0) then
					break;

				index := W_BUFFER * 4 div wExtent + jamoIndex[i];

				glyphRect.rect[i].x1 := (integer(index) mod pitch) * wExtent;
				glyphRect.rect[i].y1 := (integer(index) div pitch) * hExtent;
				glyphRect.rect[i].x2 := glyphRect.rect[i].x1 + wExtent;
				glyphRect.rect[i].y2 := glyphRect.rect[i].y1 + hExtent;

				inc(glyphRect.nRect);
			end;
		end
		else begin
			glyphRect.nRect := 0;
			for i := 1 to Length(HANJA_DATA) do begin
				if index = longword(HANJA_DATA[i]) then begin
					glyphRect.nRect := 1;
					glyphRect.rect[0].x1 := X_HANJA + wExtent * (i-1);
					glyphRect.rect[0].y1 := Y_HANJA;
					glyphRect.rect[0].x2 := glyphRect.rect[0].x1 + wExtent;
					glyphRect.rect[0].y2 := glyphRect.rect[0].y1 + hExtent;
					break;
				end;
			end;
		end;
	end
	else begin
		wExtent := 8;
		hExtent := 16;
		pitch   := W_BUFFER div wExtent;

		index   := longword(W_BUFFER * 2 div wExtent) + index;

		glyphRect.rect[0].x1 := (integer(index) mod pitch) * wExtent;
		glyphRect.rect[0].y1 := (integer(index) div pitch) * hExtent;
		glyphRect.rect[0].x2 := glyphRect.rect[0].x1 + wExtent;
		glyphRect.rect[0].y2 := glyphRect.rect[0].y1 + hExtent;

		glyphRect.nRect := 1;
	end;

	result := TRUE;
end;

function RealLength(const s : widestring) : integer;
var
	i, return: integer;
	chTemp: char;
begin
	return := 0;

	for i := 1 to Length(s) do begin
		if word(s[i]) >= $0100 then begin
			inc(return, 2);
		end
		else begin
			chTemp := char(s[i]);
			if not (chTemp in [KEYWORD_BEGIN, KEYWORD_END]) then
				inc(return);
		end;
	end;

	result := return;
end;

function RealWLength(const s : widestring) : integer;
var
	i, return: integer;
	chTemp: char;
begin
	return := 0;

	for i := 1 to Length(s) do begin
		if word(s[i]) > $0100 then begin
			inc(return, 2);
		end
		else begin
			chTemp := char(s[i]);
			if not (chTemp in [KEYWORD_BEGIN, KEYWORD_END]) then
				inc(return);
		end;
	end;

	result := return;
end;

procedure SmDrawText(xDest, yDest: integer; const szText: widestring; color: longword; auxColor: longword; fnBitBlt: TFnBitBlt);
var
	i, j, w, h: integer;
	appliedColor: longword;
	glyphRect: TGlyphRect;
begin
	appliedColor := color;

	for j := 0 to pred(length(szText)) do begin
		if szText[j+1] = KEYWORD_BEGIN then begin
			appliedColor := auxColor;
			continue;
		end;
		if szText[j+1] = KEYWORD_END then begin
			appliedColor := color;
			continue;
		end;

		GetGlyphRect(integer(szText[j+1]), glyphRect);

		w := glyphRect.rect[0].x2 - glyphRect.rect[0].x1;
		h := glyphRect.rect[0].y2 - glyphRect.rect[0].y1;

		for i := 0 to pred(glyphRect.nRect) do begin
			fnBitBlt(xDest, yDest, w, h, glyphRect.rect[i].x1, glyphRect.rect[i].y1, appliedColor);
		end;
		inc(xDest, glyphRect.rect[0].x2 - glyphRect.rect[0].x1);
	end;
end;

procedure SmDrawTextFit(xDest, yDest: integer; const szText: widestring; color: longword; auxColor: longword; fnBitBlt: TFnBitBlt; fitWidth: integer);
var
	i, j, x, y, w, h: integer;
	appliedColor: longword;
	glyphRect: TGlyphRect;
	realCount, realLen: integer;
	add: integer;
begin
	realLen      := RealWLength(szText);
	realCount    := 0;
	appliedColor := color;

	for j := 0 to pred(length(szText)) do begin
		if szText[j+1] = KEYWORD_BEGIN then begin
			appliedColor := auxColor;
			continue;
		end;
		if szText[j+1] = KEYWORD_END then begin
			appliedColor := color;
			continue;
		end;

		GetGlyphRect(integer(szText[j+1]), glyphRect);

		w := glyphRect.rect[0].x2 - glyphRect.rect[0].x1;
		h := glyphRect.rect[0].y2 - glyphRect.rect[0].y1;

		if j < Length(szText) then begin
			add := realCount * fitWidth div realLen;
			x   := xDest + add;
			y   := yDest;
			for i := 0 to pred(glyphRect.nRect) do begin
				fnBitBlt(x, y, w, h, glyphRect.rect[i].x1, glyphRect.rect[i].y1, appliedColor);
			end;
			inc(realCount, (glyphRect.rect[0].x2 - glyphRect.rect[0].x1) div 8);
		end
		else begin
			x   := fitWidth - (glyphRect.rect[0].x2 - glyphRect.rect[0].x1);
			y   := yDest;
			for i := 0 to pred(glyphRect.nRect) do begin
				fnBitBlt(x, y, w, h, glyphRect.rect[i].x1, glyphRect.rect[i].y1, appliedColor);
			end;
		end;
	end;
end;

////////////////////////////////////////////////////////////////////////////////

function SmGetHangulO(const s : widestring) : widestring;
var
	johap: longword;
begin
	ConvertUnicodeToJohap(s[Length(s)], johap);
	if (johap and $1F) > 1 then begin
		result := 'À»';
	end else begin
		result := '¸¦';
	end;
end;

function SmGetHangulRo(const s : widestring) : widestring;
var
	johap: longword;
begin
	ConvertUnicodeToJohap(s[Length(s)], johap);
	johap := johap and $1F;
	// ¹ÞÄ§ÀÌ ÀÖÁö¸¸ ±× ¹ÞÄ§ÀÌ ¤© ÀÌ ¾Æ´Ï¸é
	if (johap > 1) and (johap <> 9) then begin
		result := 'À»';
	end else begin
		result := '¸¦';
	end;
end;

////////////////////////////////////////////////////////////////////////////////

end.
