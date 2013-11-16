unit USmJPEG;

interface

uses
	Windows;

type
	SMBYTE  = type byte;
	SMWORD  = type word;
	SMINT   = type integer;
	SMBOOL  = type boolean;
	SMSHORT = type smallint;
	SMDWORD = type longint;
	SMFLOAT = type single;

	PSMBYTE    = ^SMBYTE;
	PByteArray = ^TByteArray;
	TByteArray = array[0..30000] of SMBYTE;

	PWordArray = ^TWordArray;
	TWordArray = array[0..30000] of SMWORD;

	SMJPEG_SET = record
		C : array[0..2] of SMBYTE;  (* Y, Cb, Cr ���� *)
	end;

	PSMJPEG_SET = ^ASMJPEG_SET;
	ASMJPEG_SET = array[0..0] of SMJPEG_SET;

	SMJPEG_DQT = record
		Q : array[0..63] of SMBYTE; (* Qantization Table �� *)
	end;

	SMJPEG_DHT = record
		Flag        : SMBOOL;                 (* ���Ǿ����� ���θ� ��Ÿ���� �÷��� *)
		Num         : SMINT ;                 (* ������ �ڵ��� �� *)
		HUFFCODE    : PWordArray;             (* ������ �ڵ� *)
		HUFFSIZE    : PByteArray;             (* ������ �ڵ��� ���� *)
		HUFFVAL     : PByteArray;             (* ������ �ڵ尡 ��Ÿ���� �� *)
		MAXCODE     : array[0..16] of SMWORD; (* �ش� ���̿��� ���� ū �ڵ� *)
		MINCODE     : array[0..16] of SMWORD; (* �ش� ���̿��� ���� ���� �ڵ� *)
		VALPTR      : array[0..16] of SMINT ; (* �ش� ������ �ڵ尡 ���۵Ǵ� �ε��� *)
		PT          : ^SMINT                  (* VALUE�� INDEX�� ������ ã�� ���� ������ *)
	end;

	SMJPEG_FRAMEHEADER = record
		Y           : SMWORD;                 (* �̹����� ���� *)
		X           : SMWORD;                 (* �̹����� ���� *)
		Nf          : SMBYTE;                 (* ������Ʈ �� *)
		C           : array[0..2] of SMBYTE;  (* ������Ʈ ���̵� *)
		H           : array[0..2] of SMBYTE;  (* ������Ʈ�� Horizontal Sampling Factor *)
		V           : array[0..2] of SMBYTE;  (* ������Ʈ�� Vertical Sampling Factor *)
		Tq          : array[0..2] of SMBYTE;  (* �ش� ������Ʈ�� ���Ǵ� ����ȭ���̺� ��ȣ *)
	end;

	SMJPEG_SCANHEADER = record
		Ns          : SMBYTE;                 (* ������Ʈ �� *)
		Cs          : array[0..2] of SMBYTE;  (* ������Ʈ ���̵� *)
		Td          : array[0..2] of SMBYTE;  (* ������Ʈ�� DC Huffman Table ��ȣ *)
		Ta          : array[0..2] of SMBYTE;  (* ������Ʈ�� AC Huffman Table ��ȣ *)
		Ss          : SMBYTE;
		Se          : SMBYTE;
		Ah          : SMBYTE;
		Al          : SMBYTE;
	end;

	TSmJpeg = class

	public
		constructor Create;
		procedure   Free;

	private
		Ri          : SMWORD;                 (* Restart DZINTerval *)
		m_rWidth    : SMINT;                  (* �̹����� �������� ���� *)
		m_rHeight   : SMINT;                  (* �̹����� �������� ���� *)
		pByte       : PByteArray;             (* NextByte()�Լ����� ���� *)

		cnt         : SMINT;                  (* ��Ʈ������ ������ �� ���̴� ī���� *)

		Hmax        : SMBYTE;                 (* Maximum Horizontal Sampling Factor *)
		Vmax        : SMBYTE;                 (* Maximum Vertical Sampling Factor *)

		m_pBuf      : PByteArray;             (* ���� *)
		m_Index     : SMINT;                  (* ������ ��ġ�� ��Ÿ���� �ε��� *)
		ZZ          : array[0..63] of SMSHORT;    (* 8x8 Block ������ ��� �迭 *)
		PrevDC      : array[0.. 2] of SMSHORT;    (* DC ������ Predictor *)

		MCU         : PSMJPEG_SET;                (* MCU ������ �� *)

		TbQ         : array[0..19] of SMJPEG_DQT; (* Quantization Table *)
		TbH         : array[0..19] of SMJPEG_DHT; (* Huffman Table *)
		FrameHeader : SMJPEG_FRAMEHEADER;         (* FrameHeader ����ü *)
		ScanHeader  : SMJPEG_SCANHEADER;          (* ScanHeader ����ü *)

		procedure Initialize;
		procedure Finalize;

		procedure FindSOI;                     (* Start of Image ��Ŀ�� ã�� �Լ� *)
		procedure FindDQT;                     (* Quantization Table�� ã�� ����ü�� �����ϴ� �Լ� *)
		procedure FindDHT;                     (* Huffman Table�� ã�� ����ü�� �����ϴ� �Լ� *)
		procedure FindSOF;                     (* Frame Header�� ã�� ����ü�� �����ϴ� �Լ� *)
		procedure FindSOS;                     (* Scan Header�� ã�� ����ü�� �����ϴ� �Լ� *)
		procedure FindETC;                     (* DRI(Define Restart DZINTerval) �ε� *)
		procedure Decode;                      (* ���ڵ带 ���� ������ �����ϰ� ���ڵ带 ���� *)
		procedure DecodeMCU( mx : SMINT; my : SMINT ); (* MCU���� ���ڵ��ϴ� �Լ� *)
		procedure DecodeDU( N : SMINT ) ;      (* 8x8 Data Unit�� ���ڵ��ϴ� �Լ� *)
		procedure IDCT;                        (* Inverse DCT�� �ϴ� �Լ� *)
		procedure Zigzag;                      (* Zigzag������ �Ǿ��ִ� DU�� ���󺹱ͽ�Ű�� �Լ� *)
		procedure DecodeAC( Th : SMINT );      (* DU��, AC������ ���ڵ��ϴ� �Լ� *)
		procedure DecodeDC( Th : SMINT );      (* DU��, DC������ ���ڵ��ϴ� �Լ� *)
		function  Extend( V : SMWORD; T : SMBYTE ) : SMSHORT; (* V�� ī�װ� T�� �µ��� Ȯ�� *)
		function  Receive( SSSS : SMBYTE ) : SMWORD; (* ���ۿ��� SSSS��Ʈ��ŭ �о���� �Լ� *)
		function  hDecode( Th : SMINT ) : SMBYTE; (* ������ ��ȣ�� ���ڵ��ϴ� �κ� *)
		function  NextByte : SMBYTE;           (* ���ۿ��� ���� 1 ����Ʈ�� �о���� �Լ� *)
		function  NextBit : SMWORD;            (* ���ۿ��� ���� 1 ��Ʈ�� �о���� �Լ� *)
		procedure ConvertYUV2RGB;              (* ���ڵ�� �����͸� �÷����� �ٲް� ���ÿ� *)

	public

		m_pData     : PByteArray;              (* �̹��� ���� *)

		function  LoadJPG( FileName : String ) : Boolean; overload; (* JPEG File�� Load�ϴ� �Լ�	 *)
		function  LoadJPG( pMemory: Pbyte; size: integer ) : Boolean; overload;
		function  GetHeight : SMINT;           (* �̹����� ���̸� ��ȯ�ϴ� �Լ� *)
		function  GetWidth  : SMINT;           (* �̹����� ���̸� ��ȯ�ϴ� �Լ� *)
		function  GetBitmap( pSurface : Pointer; DestBPL : Integer; Palette : Pointer; Depth : Integer ) : Boolean;

	end;

implementation

constructor TSmJpeg.Create;
begin
	Initialize( );
end;

procedure   TSmJpeg.Free;
begin
	Finalize( );
end;

procedure TSmJpeg.Initialize( );
var
	i : Integer;
begin
	m_pData := nil;

	for  i := 0 to 19 do
		TbH[i].Flag := FALSE;
end;

procedure TSmJpeg.Finalize( );
var
	i : Integer;
begin
	if Assigned( m_pData ) then
		FreeMem( m_pData );

	for i := 0 to 19 do	begin
		if ( TbH[i].Flag ) then begin
			FreeMem( TbH[i].HUFFCODE );
			FreeMem( TbH[i].HUFFSIZE );
			FreeMem( TbH[i].HUFFVAL  );
		end;
	end;
end;

function TSmJpeg.LoadJPG( FileName : String ) : Boolean;
var
	pf       : File;
	FileSize : SMINT;
	Count    : SMINT;
begin
	Result := FALSE;

	Count  := 0;

	AssignFile( pf, FileName );
{$I-}
	Reset( pf, 1);
{$I+}
	if IOResult <> 0 then
		Exit;

	FileSize := System.FileSize( pf );

	GetMem( m_pBuf, FileSize );

	if not Assigned( m_pBuf ) then begin
		CloseFile( pf );
		Exit;
	end;

	BlockRead( pf, m_pBuf^, FileSize );

	CloseFile( pf );

	m_Index := 0;

	FindSOI( );

	pByte := Addr( m_pBuf[m_Index] );

	while ( TRUE ) do begin
		FindETC( ); (* DRI(Define Restart DZINTerval) *)
		FindDHT( ); (* Huffman Table Loading          *)
		FindDQT( ); (* Quantization Table Loading     *)
		FindSOF( ); (* Frame Header Loading           *)
		FindSOS( ); (* Scan Header Loading & Decoding *)

		if ( ( pByte[0] = $FF ) and ( pByte[1] = $D9 ) ) then (* ���� ������ �� *)
			break;

		Inc( Count );

		if ( Count > 50 ) then (* Loop�� ���� ���ɼ��� ���� ���� �� *)
			break;
	end;

	FreeMem( m_pBuf );

	Result := TRUE;
end;

function TSmJpeg.LoadJPG( pMemory: Pbyte; size: integer ) : Boolean;
var
	Count    : SMINT;
begin
	Result := FALSE;

	if (not assigned(pMemory)) or (size <= 0) then
		exit;

	Count  := 0;

	GetMem( m_pBuf, size );

	if not Assigned( m_pBuf ) then
		Exit;

	move(pMemory^, m_pBuf^, size);

	m_Index := 0;

	FindSOI( );

	pByte := Addr( m_pBuf[m_Index] );

	while ( TRUE ) do begin
		FindETC( ); (* DRI(Define Restart DZINTerval) *)
		FindDHT( ); (* Huffman Table Loading          *)
		FindDQT( ); (* Quantization Table Loading     *)
		FindSOF( ); (* Frame Header Loading           *)
		FindSOS( ); (* Scan Header Loading & Decoding *)

		if ( ( pByte[0] = $FF ) and ( pByte[1] = $D9 ) ) then (* ���� ������ �� *)
			break;

		Inc( Count );

		if ( Count > 50 ) then (* Loop�� ���� ���ɼ��� ���� ���� �� *)
			break;
	end;

	FreeMem( m_pBuf );

	Result := TRUE;
end;

procedure TSmJpeg.FindSOI( );
begin
	while ( not ( ( m_pBuf[m_Index] = $FF ) and ( m_pBuf[m_Index+1] = $D8 ) ) ) do
		Inc( m_Index );

	Inc( m_Index, 2 );		
end;


procedure TSmJpeg.FindDHT( );
var
	SegSize  : SMWORD;
	p        : ^SMBYTE;
	CODE     : SMWORD;
	SI       : SMBYTE;

	i, j, k  : SMINT;
	Num      : SMINT;
	BITS     : array[0..16] of SMBYTE;
	Th       : SMBYTE; (* Table Number *)
begin
	if ( ( m_pBuf[m_Index] = $FF ) and ( m_pBuf[m_Index+1] = $C4 ) ) then begin
		SegSize := m_pBuf[m_Index+2] * 256 + m_pBuf[m_Index+3];
		(* ������ ���� ��ġ�� �����ͷ� �����Ѵ�. *)
		p       := Addr( m_pBuf[m_Index+4] );

		Num     := 0;
		Th      := p^;
		repeat

			Move( p^, BITS[0], 17 );
			Inc( p, 17 );
			(* 17���� ���� ��� ���ؼ� Num�� ���� *)
			for i := 1 to 16 do
				Num := Num + BITS[i];

			TbH[Th].Flag := TRUE;

			GetMem( TbH[Th].HUFFCODE, ( Num+1 ) * sizeof( SMWORD ) );
			GetMem( TbH[Th].HUFFSIZE, ( Num+1 ) * sizeof( SMBYTE ) );
			GetMem( TbH[Th].HUFFVAL , ( Num+1 ) * sizeof( SMBYTE ) );

			(* Huffman Value ���� Numũ�⸸ŭ p���� �д´�. *)
			Move( p^, TbH[Th].HUFFVAL^, Num );
			(* p�� ���� *)
			Inc( p, Num );


			(* Generation of table of Huffman code sizes *)
			i := 1; j := 1; k := 0;
			while ( i <= 16 ) do begin
				while ( j <= BITS[i] ) do begin
					TbH[Th].HUFFSIZE[k] := SMBYTE( i );
					Inc( k );
					Inc( j );
				end;

				Inc( i );
				j := 1;
			end;
			TbH[Th].HUFFSIZE[k] := 0;

			(* Generation of table of Huffman codes *)
			k    := 0;
			CODE := 0;
			SI   := TbH[Th].HUFFSIZE[0];

			while ( TRUE ) do begin
				repeat
					TbH[Th].HUFFCODE[k] := CODE;
					Inc( CODE );
					Inc( k );
				until ( TbH[Th].HUFFSIZE[k] <> SI );

				if ( TbH[Th].HUFFSIZE[k] = 0 ) then
					break;

				repeat
					CODE := CODE shl 1;
					Inc( SI );
				until ( TbH[Th].HUFFSIZE[k] = SI );
			end;

			(* Decoder table generation *)
			i := 0; j := 0;
			while ( TRUE ) do begin
				repeat
					Inc( i );
					if ( i > 16 ) then
						break;
					if ( BITS[i] = 0 ) then
						TbH[Th].MAXCODE[i] := SMWORD( -1 );
				until ( BITS[i] <> 0 );

				if ( i > 16 ) then
					break;

				TbH[Th].VALPTR[i]  := j;
				TbH[Th].MINCODE[i] := TbH[Th].HUFFCODE[j];
				Inc( j, BITS[i] - 1 );
				TbH[Th].MAXCODE[i] := TbH[Th].HUFFCODE[j];
				Inc( j );
			end;

			TbH[Th].Num := Num;

		until ( p^ = $FF );

		Inc( m_Index, SegSize + 2 );
	end;
end;

procedure TSmJpeg.FindDQT( );
var
	SegSize : SMWORD;
	p       : ^SMBYTE;
	Tq      : SMBYTE;
begin
	if ( ( m_pBuf[m_Index] = $FF ) and ( m_pBuf[m_Index+1] = $DB ) ) then begin
		SegSize :=  m_pBuf[m_Index+2] * 256 + m_pBuf[m_Index+3];
		p       :=  Addr( m_pBuf[m_Index+4] );

		repeat
			Tq := p^ and $0F; (* Table Number *)
			Inc( p );
			Move( m_pBuf[m_Index+5], TbQ[Tq].Q[0], 64 );
			Inc( p, 64 );
		until ( p^ = $FF );

		Inc( m_Index, SegSize + 2 );
	end;
end;

procedure TSmJpeg.FindSOF( );
var
	i       : SMINT;
	SegSize : SMWORD;
begin
	if ( ( m_pBuf[m_Index] = $FF ) and ( m_pBuf[m_Index + 1] = $C0 ) ) then begin
		SegSize        := m_pBuf[m_Index + 2] * 256 + m_pBuf[m_Index + 3];

		FrameHeader.Y  := m_pBuf[m_Index + 5] * 256 + m_pBuf[m_Index + 6];
		FrameHeader.X  := m_pBuf[m_Index + 7] * 256 + m_pBuf[m_Index + 8];
		FrameHeader.Nf := m_pBuf[m_Index + 9];

		for i := 0 to Pred( FrameHeader.Nf ) do begin
			FrameHeader.C[i]  := m_pBuf[m_Index + 10 + 3*i];
			FrameHeader.H[i]  := m_pBuf[m_Index + 11 + 3*i] shr 4;
			FrameHeader.V[i]  := m_pBuf[m_Index + 11 + 3*i] and $0F;
			FrameHeader.Tq[i] := m_pBuf[m_Index + 12 + 3*i];
		end;

		Inc( m_Index, SegSize + 2 );
	end;
end;

procedure TSmJpeg.FindETC( );
var
	SegSize : SMWORD;
begin
	if ( ( m_pBuf[m_Index] = $FF ) and ( ( ( m_pBuf[m_Index + 1] and $F0 ) = $E0 ) or ( ( m_pBuf[m_Index + 1] and $F0 ) = $F0 ) ) ) then begin
		SegSize := m_pBuf[m_Index + 2] * 256 + m_pBuf[m_Index + 3];
		Inc( m_Index, SegSize + 2 );
	end;

	(* DRI(Define Restart DZINTerval *)
	if ( ( m_pBuf[m_Index] = $FF ) and ( m_pBuf[m_Index+1] = $DD ) ) then begin
		Ri := m_pBuf[m_Index+4] * 256 + m_pBuf[m_Index+5];
		Inc( m_Index, 6 );
	end;
end;

procedure TSmJpeg.FindSOS( );
var
	i       : SMINT;
	SegSize : SMWORD;
begin
	if ( ( m_pBuf[m_Index] = $FF ) and ( m_pBuf[m_Index + 1] = $DA ) ) then begin
		SegSize := m_pBuf[m_Index + 2] * 256 + m_pBuf[m_Index + 3];

		ScanHeader.Ns := m_pBuf[m_Index + 4];

		for i := 0 to Pred( ScanHeader.Ns ) do begin
			ScanHeader.Cs[i] := m_pBuf[m_Index + 5 + i*2];
			ScanHeader.Td[i] := m_pBuf[m_Index + 6 + i*2] shr 4;
			ScanHeader.Ta[i] := m_pBuf[m_Index + 6 + i*2] and $0F;
		end;

		ScanHeader.Ss := m_pBuf[m_Index + 5 + 2 * ScanHeader.Ns];
		ScanHeader.Se := m_pBuf[m_Index + 6 + 2 * ScanHeader.Ns];
		ScanHeader.Ah := m_pBuf[m_Index + 7 + 2 * ScanHeader.Ns] shr 4;
		ScanHeader.Al := m_pBuf[m_Index + 7 + 2 * ScanHeader.Ns] and $0F;

		Inc( m_Index, SegSize + 2 );

		(* �ִ� Sampling Factor ���� *)
		Hmax := 0;
		Vmax := 0;
		for i := 0 to Pred( FrameHeader.Nf ) do begin
			if ( FrameHeader.H[i] > Hmax ) then
				Hmax := FrameHeader.H[i];
			if ( FrameHeader.V[i] > Vmax ) then
				Vmax := FrameHeader.V[i];
		end;

		(* ���� �̹��� ������ ���� *)
		m_rWidth  := FrameHeader.X;
		m_rHeight := FrameHeader.Y;

		(* �̹��� ����� MCU ũ�⿡ �¾� ���������� �ٽ� ��� *)
		if ( ( FrameHeader.X mod ( 8 * Hmax ) ) <> 0 ) then
			FrameHeader.X := ( FrameHeader.X div ( 8 * Hmax ) + 1 ) * ( 8 * Hmax );
		if ( ( FrameHeader.Y mod ( 8 * Vmax ) ) <> 0 ) then
			FrameHeader.Y := ( FrameHeader.Y div ( 8 * Vmax ) + 1 ) * ( 8 * Vmax );
		
		Decode( );
	end;
end;

function  TSmJpeg.NextBit( ) : SMWORD;
const
	B   : SMBYTE = 0;
var
	Bit : SMWORD;
begin

	while ( cnt = 0 ) do begin
		B   := NextByte( );
		cnt := 8;

		if ( B = $FF ) then
			NextByte( );
	end;

	Bit := B shr 7;
	Dec( cnt );
	B   := B shl 1;

	Result := Bit;
end;

function  TSmJpeg.NextByte( ) : SMBYTE;
begin
	Result := pByte[0];
	Inc( Longint( pByte ) );
end;

function  TSmJpeg.hDecode( Th : SMINT ) : SMBYTE;
var
	i, j  : SMINT;
	CODE  : SMWORD;
	Value : SMBYTE;
begin
	i     := 1;
	CODE  := NextBit( );

	while ( ( CODE > TbH[Th].MAXCODE[i] ) or ( TbH[Th].MAXCODE[i] = $FFFF ) ) do begin
		Inc( i );
		CODE := ( CODE shl 1 ) + NextBit( );
	end;

	j     := TbH[Th].VALPTR[i];
	Inc( j, CODE - TbH[Th].MINCODE[i] );

	Value := TbH[Th].HUFFVAL[j];

	Result :=  Value;
end;

function  TSmJpeg.Receive( SSSS : SMBYTE ) : SMWORD;
var
	i : SMBYTE;
	V : SMWORD;
begin
	i := 0;
	V := 0;

	while ( i <> SSSS ) do begin
		inc( i );
		V := ( V shl 1 ) + NextBit( );
	end;

	Result := V;
end;

function  TSmJpeg.Extend( V : SMWORD; T : SMBYTE ) : SMSHORT;
var
	Vt : SMWORD;
begin
	Vt := 1 shl ( T - 1 );

	if ( V < Vt ) then begin
		Vt := ( -1 shl T ) + 1;
		V  := V + Vt;
	end;

	Result := SMSHORT( V );
end;

procedure TSmJpeg.DecodeDC( Th : SMINT );
var
	T : SMBYTE;
begin
	T := hDecode( Th );

	ZZ[0] := Extend( Receive( T ), T );
end;

procedure TSmJpeg.DecodeAC( Th : SMINT );
var
	k                 : SMINT;
	RS, SSSS, RRRR, R : SMBYTE;
begin
	k := 1;
	(* RRRR : ZZ���� 0 �� �ƴ� �� �����κ����� ������� ��ġ *)
	(* SSSS : 0�� �ƴ� ���� ����(category) *)

	FillChar( ZZ[1], 63 * sizeof( SMSHORT ), 0 );

	while ( TRUE ) do begin
		RS   := hDecode( Th );
		SSSS := RS mod 16;
		RRRR := RS shr 4;
		R    := RRRR;
		if ( SSSS = 0 ) then begin
			if ( R = 15 ) then
				Inc( k, 16 )
			else
				break;
		end
		else begin
			Inc( k, R );
			ZZ[k] := Extend( Receive( SSSS ), SSSS );
			if ( k = 63 ) then
				break
			else
				Inc( k );
		end;
	end;
end;

procedure TSmJpeg.DecodeDU( N : SMINT ); (* N = Component ID 0/1/2 *)
var
	i   : SMINT;
	pos : ^SMSHORT;
begin
	DecodeDC( ScanHeader.Td[N] );
	DecodeAC( ScanHeader.Ta[N] + 16 );

	(* Differential DC Restoration *)
	Inc( ZZ[0], PrevDC[N] );
	PrevDC[N] := ZZ[0];

	(* Dequantization *)
	pos := Addr( ZZ[0] );
	for i := 0 to 63 do begin
		pos^ := pos^ * TbQ[FrameHeader.Tq[N]].Q[i];
		Inc( pos );
	end;

	(* Undo Zigzag Order *)
	Zigzag( );

	(* Inverce Discrete Cosine Transform *)
	IDCT( );
	
	(* Level Shifting  & Correct Error *)
	pos := Addr( ZZ[0] );

	for i := 0 to 63 do begin
		Inc( pos^, 128 );

		if ( pos^ < 0 ) then
			pos^ := 0
		else if ( pos^ > 255 ) then
			pos^ := 255;

		Inc( pos );
	end;
end;

procedure TSmJpeg.Zigzag( );
const
	Index : array[0..63] of SMINT = (
	 0,  1,  5,  6,  14, 15, 27, 28,
	 2,  4,  7,  13, 16, 26, 29, 42,
	 3,  8,  12, 17, 25, 30, 41, 43,
	 9,  11, 18, 24, 31, 40, 44, 53,
	 10, 19, 23, 32, 39, 45, 52, 54,
	 20, 22, 33, 38, 46, 51, 55, 60,
	 21, 34, 37, 47, 50, 56, 59, 61,
	 35, 36, 48, 49, 57, 58, 62, 63
	);
var
	Temp      : array[0..63] of SMSHORT;
	i, j, idx : SMINT;
begin
	Move( ZZ[0], Temp[0], 64 * sizeof( SMSHORT ) );

	for i := 0 to 7 do begin
		for j := 0 to 7 do begin
			idx     := ( i shl 3 ) + j;
			ZZ[idx] := Temp[Index[idx]];
		end;
	end;
end;

procedure TSmJpeg.IDCT( );
const
	dct_coeff : array[0..7,0..7] of SMFLOAT = (
		( +0.7071, +0.7071, +0.7071, +0.7071, +0.7071, +0.7071, +0.7071, +0.7071 ),
		( +0.9808, +0.8315, +0.5556, +0.1951, -0.1951, -0.5556, -0.8315, -0.9808 ),
		( +0.9239, +0.3827, -0.3827, -0.9239, -0.9239, -0.3827, +0.3827, +0.9239 ),
		( +0.8315, -0.1951, -0.9808, -0.5556, +0.5556, +0.9808, +0.1951, -0.8315 ),
		( +0.7071, -0.7071, -0.7071, +0.7071, +0.7071, -0.7071, -0.7071, +0.7071 ),
		( +0.5556, -0.9808, +0.1951, +0.8315, -0.8315, -0.1951, +0.9808, -0.5556 ),
		( +0.3827, -0.9239, +0.9239, -0.3827, -0.3827, +0.9239, -0.9239, +0.3827 ),
		( +0.1951, -0.5556, +0.8315, -0.9808, +0.9808, -0.8315, +0.5556, -0.1951 )
	);
var
	x, y, index, coeff, idx : SMINT;
	tmp1 : array[0..7,0..7] of SMFLOAT;
	tmp2 : array[0..7,0..7] of SMFLOAT;
begin
	for y := 0 to 7 do begin
		for x := 0 to 7 do begin
			tmp2[y][x] := ZZ[( y shl 3 ) + x];
		end;
	end;

	for x := 0 to 7 do begin (* 1-D column IDCT *)
		for coeff := 0 to 7 do begin
			tmp1[coeff][x] := 0.;
			for index := 0 to 7 do begin
				tmp1[coeff][x] := tmp1[coeff][x] + tmp2[index][x] * dct_coeff[index][coeff];
			end;
		end;
	end;

	for y := 0 to 7 do begin (* 1-D row IDCT *)
		for coeff := 0 to 7 do begin
			tmp2[y][coeff] := 0.;
			for index := 0 to 7 do begin
				tmp2[y][coeff] := tmp2[y][coeff] + tmp1[y][index] * dct_coeff[index][coeff];
			end;
			idx     := ( y shl 3) + coeff;
			ZZ[idx] := Trunc( tmp2[y][coeff] / 4.0 );
		end;
	end;

end;

procedure TSmJpeg.DecodeMCU( mx : SMINT; my : SMINT );
var
	i, j, k, l, m, n, o : SMINT;
	Ns                  : SMINT;
	H, V, Rh, Rv        : SMINT;
	mWidth, mHeight     : SMINT;
	bWidth              : SMINT;
	idx1, idx2, idx3    : SMINT;
begin
	Ns      := ScanHeader.Ns;
	mWidth  := Hmax * 8;
	mHeight := Vmax * 8;

	bWidth  := FrameHeader.X * Ns;
//	bHeight := FrameHeader.Y;

	for k := 0 to pred( Ns ) do begin
		H  := FrameHeader.H[k];
		V  := FrameHeader.V[k];
		Rh := Hmax div H;
		Rv := Vmax div V;

		for l := 0 to Pred( V ) do begin
			for m := 0 to Pred( H ) do begin
				DecodeDU( k );
				for i := 0 to 7 do begin
					for j := 0 to 7 do begin
						idx1 := ( ( l shl 3 ) + i ) * Rv;
						idx2 := ( ( m shl 3 ) + j ) * Rh;
						for n := 0 to Pred( Rv ) do begin
							for o := 0 to Pred( Rh ) do begin
								MCU[(idx1+n) * mWidth + (idx2+o)].C[k] := ZZ[( i shl 3 ) + j];
							end;
						end;
					end;
				end;
			end;
		end;

		for i := 0 to Pred( mHeight ) do begin
			for j := 0 to Pred( mWidth ) do begin
				idx1 := my * mHeight + i;
				idx2 := mx * mWidth  + j;
				idx3 := i  * mWidth  + j;
				for n := 0 to Pred( Ns ) do
					m_pData[(idx1)*bWidth+((idx2)*Ns + n)] := MCU[idx3].C[n];
			end;
		end;
	end;
end;

procedure TSmJpeg.Decode( );
var
	Ns       : SMINT;
	mx       : SMINT;
	my       : SMINT;
	i, j, k  : SMINT;
	Count    : SMINT;
begin
	Ns  := ScanHeader.Ns;
	mx  := FrameHeader.X div 8 div Hmax;
	my  := FrameHeader.Y div 8 div Vmax;

	cnt := 0;

	if Assigned( m_pData ) then
		FreeMem( m_pData );

	GetMem( m_pData, ( FrameHeader.X * FrameHeader.Y * 3 )  * sizeof( SMBYTE ) );

	for i := 0 to Pred( Ns ) do
		PrevDC[i] := 0;

	GetMem( MCU, ( Vmax * Hmax * 64 ) * sizeof( SMJPEG_SET ) );

	(* NextByte �Լ��� ���� ������ ���� *)
	pByte := Addr( m_pBuf[m_Index] );

	(* �������� Decoding Procedure *)
	Count := 0;

	for i := 0 to Pred( my ) do begin
		for j := 0 to Pred( mx ) do begin
			DecodeMCU( j, i );
			Inc( Count );
			if ( Count = Ri ) then begin (* Restart Marker Decode *)
				Count := 0;
				if ( ( pByte[0] = $FF ) and ( ( pByte[1] and $F0 ) = $D0 ) ) then begin
					cnt := 0;
					Inc( Longint( pByte ), 2 );
					for k := 0 to 2 do
						PrevDC[k] := 0;
				end;
			end;
		end;
	end;

	Freemem( MCU );

	(* RGB �� �ٲ� *)
	ConvertYUV2RGB( );
end;

function  TSmJpeg.GetWidth( ) : SMINT;
begin
	Result := FrameHeader.X;
end;

function  TSmJpeg.GetHeight( ) : SMINT;
begin
	Result := FrameHeader.Y;
end;

procedure TSmJpeg.ConvertYUV2RGB( );
var
	i, j         : SMINT;
	Width        : SMINT;
	Height       : SMINT;
	Size         : SMINT;
	Y, Cb, Cr    : SMFLOAT;
	R, G, B      : SMFLOAT;
	pTemp        : ^SMBYTE;
	pBuf         : ^SMBYTE;
	pos          : ^SMBYTE;
	RealBMPWidth : SMINT;
	pBuf2        : PByteArray;
begin
	Width   := GetWidth( );
	Height  := GetHeight( );
	Size    := Width * Height * ScanHeader.Ns;
	pTemp   := Addr( m_pData[0] );

	GetMem( pBuf, Size * sizeof( SMBYTE ) );
	pos     := Addr( pBuf^ );

	Move( pTemp^, pos^, Size );

	for i := 0 to pred( Height ) do begin
		for j := 0 to Pred( Width ) do begin
			Y := pos^;
			Inc( pos );

			if ( ScanHeader.Ns = 3 ) then begin
				Cb := pos^; Inc( pos );
				Cr := pos^; Inc( pos );

				R  := Y + 1.40200 * (Cr-128);
				G  := Y - 0.34414 * (Cb-128) - 0.71414 * (Cr-128);
				B  := Y + 1.77200 * (Cb-128);

				if ( R > 255 ) then R := 255; if ( R < 0 ) then R := 0;
				if ( G > 255 ) then G := 255; if ( G < 0 ) then G := 0;
				if ( B > 255 ) then B := 255; if ( B < 0 ) then B := 0;

				pTemp^ := Trunc( B ); Inc( pTemp );
				pTemp^ := Trunc( G ); Inc( pTemp );
				pTemp^ := Trunc( R ); Inc( pTemp );
			end
			else if ( ScanHeader.Ns = 1 ) then begin
				pTemp^ := Trunc( Y ); Inc( pTemp );
				pTemp^ := Trunc( Y ); Inc( pTemp );
				pTemp^ := Trunc( Y ); Inc( pTemp );
			end;
		end;
	end;

	FreeMem( pBuf );

	(* Clipping Useless Region *)
	RealBMPWidth := ( m_rWidth * 3 + 3 ) div 4 * 4;

	if ( ( Width <> m_rWidth ) or ( Height <> m_rHeight ) ) then begin
		GetMem( pBuf2, ( RealBMPWidth * m_rHeight ) * sizeof( SMBYTE ) );

		for i := 0 to Pred( m_rHeight ) do begin
			Move( m_pData[i*Width*3], pBuf2[i*RealBMPWidth], RealBMPWidth );
		end;

		FreeMem( m_pData );
		m_pData := pBuf2;

		(* ������ �̹��� ������� ���� *)
		FrameHeader.X := m_rWidth;
		FrameHeader.Y := m_rHeight;
	end;
end;

function  TSmJpeg.GetBitmap( pSurface : Pointer; DestBPL : Integer; Palette : Pointer; Depth : Integer ) : Boolean;
type
	PBYTE  = ^byte;
	PWORD  = ^word;
	PDWORD = ^SMDWORD;

	TRGBQUAD = record
		rgbBlue     : SMBYTE;
		rgbGreen    : SMBYTE;
		rgbRed      : SMBYTE;
		rgbReserved : SMBYTE;
	end;

	PRGBQUAD = ^ARGBQUAD;
	ARGBQUAD = array[0..255] of TRGBQUAD;
var
	x, y    : Integer;
	SourBPL : Integer;
	pSour24 : PBYTE;
	pDest08 : PBYTE;
	pDest16 : PWORD;
	pDest24 : PBYTE;
	pDest32 : PDWORD;

	i, j    : Integer;
	CLUT    : PRGBQUAD;
	R, G, B : SMBYTE;
	Index   : Integer;
	Distance: Integer;
begin
	Result := TRUE;

	SourBPL := ( FrameHeader.X * 3 + 3 ) div 4 * 4;

	case ( Depth ) of
		32 :
		begin
			for y := 0 to Pred( FrameHeader.Y ) do begin
				pSour24 := PBYTE ( SMDWORD( m_pData )  + y * SourBPL );
				pDest32 := PDWORD( SMDWORD( pSurface ) + y * DestBPL );
				for x := 0 to Pred( FrameHeader.X ) do begin
					pDest32^ := ( SMDWORD( pSour24^ ) ); Inc( pSour24 );
					pDest32^ := pDest32^ or ( SMDWORD( pSour24^ ) shl  8 ); Inc( pSour24 );
					pDest32^ := pDest32^ or ( SMDWORD( pSour24^ ) shl 16 ); Inc( pSour24 );
					pDest32^ := pDest32^ or SMDWORD( $FF000000 );
					Inc( pDest32 );
				end;
			end;
		end;
		24 :
		begin
			for y := 0 to Pred( FrameHeader.Y ) do begin
				pSour24 := PBYTE( SMDWORD( m_pData )  + y * SourBPL );
				pDest24 := PBYTE( SMDWORD( pSurface ) + y * DestBPL );
				Move( pSour24^, pDest24^, FrameHeader.X * 3 )
			end;
		end;
		16 :
		begin
			for y := 0 to Pred( FrameHeader.Y ) do begin
				pSour24 := PBYTE( SMDWORD( m_pData )  + y * SourBPL );
				pDest16 := PWORD( SMDWORD( pSurface ) + y * DestBPL );
				for x := 0 to Pred( FrameHeader.X ) do begin
					pDest16^ := ( SMWORD( pSour24^ ) shr 3 ); Inc( pSour24 );
					pDest16^ := pDest16^ or ( ( SMDWORD( pSour24^ ) shl 3 ) and $07E0 ); Inc( pSour24 );
					pDest16^ := pDest16^ or ( ( SMDWORD( pSour24^ ) shl 8 ) and $F800 ); Inc( pSour24 );
					Inc( pDest16 );
				end;
			end;
		end;
		15 :
		begin
			for y := 0 to Pred( FrameHeader.Y ) do begin
				pSour24 := PBYTE( SMDWORD( m_pData )  + y * SourBPL );
				pDest16 := PWORD( SMDWORD( pSurface ) + y * DestBPL );
				for x := 0 to Pred( FrameHeader.X ) do begin
					pDest16^ := ( SMWORD( pSour24^ ) shr 3 ); Inc( pSour24 );
					pDest16^ := pDest16^ or ( ( SMDWORD( pSour24^ ) shl 2 ) and $03E0 ); Inc( pSour24 );
					pDest16^ := pDest16^ or ( ( SMDWORD( pSour24^ ) shl 7 ) and $7C00 ); Inc( pSour24 );
					Inc( pDest16 );
				end;
			end;
		end;
		 8 :
		begin
			CLUT     := PRGBQUAD( Palette );
			for y := 0 to Pred( FrameHeader.Y ) do begin
				pSour24 := PBYTE( SMDWORD( m_pData )  + y * SourBPL );
				pDest08 := PBYTE( SMDWORD( pSurface ) + y * DestBPL );
				for x := 0 to Pred( FrameHeader.X ) do begin
					B := pSour24^; Inc( pSour24 );
					G := pSour24^; Inc( pSour24 );
					R := pSour24^; Inc( pSour24 );
					Index    := -1;
					Distance := 256*256*256;
					for i := 0 to 255 do begin
						j := Abs( R - CLUT[i].rgbRed ) + Abs( G - CLUT[i].rgbGreen ) + Abs( B - CLUT[i].rgbBlue );
						if j < Distance then begin
							Distance := j;
							Index    := i;
							if Distance < 24 then
								Break;
						end;
					end;
					pDest08^ := Index;
					Inc( pDest08 );
				end;
			end;
		end;
		else begin
			Result := FALSE;
		end;
	end;
end;

end.
