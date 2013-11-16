unit USmResManager;

interface

uses
	Windows;

const
	soFromBeginning = 0;
	soFromCurrent   = 1;
	soFromEnd       = 2;
type

	TSmStream = class
	private
	public
		IsAvailable : Boolean;

		function Read( var Buffer; Count : Longint ) : Longint; virtual; abstract;
		function Seek( Offset : Longint; Origin : Word) : Longint; virtual; abstract;
		function Position: Longint; virtual; abstract;
	end;

	TSmReadFileStream = class( TSmStream )
	protected
		FFile      : file;
	public
		constructor Create( const FileName : string );
		destructor  Destroy; override;
		function    Read( var Buffer; Count : Longint ) : Longint; override;
		function    Seek( Offset : Longint; Origin : Word) : Longint; override;
		function    Position: Longint; override;
	end;

	TSmWriteFileStream = class( TSmReadFileStream )
	public
		constructor Create( const FileName : string );
		function    Write( var Buffer; Count : Longint ) : Longint;
	end;

	TSmResourceStream = class( TSmStream )
	private
		FMemory    : Pointer;
		FSize      : Longint;
		FPosition  : Longint;
		HResInfo   : HRSRC;
		HGlobal    : THandle;
		procedure   Initialize( Instance : THandle; Name, ResType : PChar );
	public
		constructor Create( Instance : THandle; const ResName : string; ResType : PChar );
		destructor  Destroy; override;
		function    Read( var Buffer; Count : Longint ) : Longint; override;
		function    Seek( Offset : Longint; Origin : Word) : Longint; override;
		function    Position: Longint; override;
	end;

	TSmMemoryStream = class( TSmResourceStream )
	public
		constructor Create(pMemory: pointer; size: integer);
		destructor  Destroy; override;
	end;

implementation

{ TSmMemoryStream }

constructor TSmMemoryStream.Create(pMemory: pointer; size: integer);
begin
	FMemory := pMemory;
	FSize   := size;
	FPosition  := 0;

	IsAvailable := TRUE;
end;

destructor  TSmMemoryStream.Destroy;
begin
	inherited Destroy;
end;

{ TSmResourceStream }

constructor TSmResourceStream.Create( Instance : THandle; const ResName : string; ResType : PChar );
begin
	inherited Create;

	IsAvailable := FALSE;

	Initialize( Instance, PChar( ResName ), ResType );
end;

procedure TSmResourceStream.Initialize( Instance : THandle; Name, ResType : PChar );
begin
	HResInfo   := FindResource( Instance, Name, ResType );
	if HResInfo = 0 then
		Exit;

	HGlobal    := LoadResource( Instance, HResInfo );
	if HGlobal = 0 then
		Exit;

	FMemory    := LockResource( HGlobal );
	FSize      := SizeOfResource( Instance, HResInfo );
	FPosition  := 0;

	IsAvailable := TRUE;
end;

destructor TSmResourceStream.Destroy;
begin
	if ( HGlobal <> 0 ) then begin
		UnlockResource( HGlobal );
		FreeResource( HGlobal );
	end;

	inherited Destroy;
end;

function TSmResourceStream.Read( var Buffer; Count : Longint) : Longint;
begin
	if not IsAvailable then begin
		Result := 0;
		Exit;
	end;

	if ( FPosition >= 0 ) and ( Count >= 0 ) then begin
		Result := FSize - FPosition;
		if Result > 0 then begin
			if Result > Count then
				Result := Count;
			Move( Pointer( Longint( FMemory ) + FPosition )^, Buffer, Result );
			Inc( FPosition, Result );
			Exit;
		end;
	end;
	Result := 0;
end;

function TSmResourceStream.Seek( Offset : Longint; Origin : Word) : Longint;
begin
	if not IsAvailable then begin
		Result := 0;
		Exit;
	end;

	case Origin of
		soFromBeginning : FPosition := Offset;
		soFromCurrent   : Inc(FPosition, Offset);
		soFromEnd       : FPosition := FSize + Offset;
	end;
	Result := FPosition;
end;

function TSmResourceStream.Position: Longint;
begin
	if not IsAvailable then begin
		Result := 0;
		Exit;
	end;

	Result := FPosition;
end;

{ TSmReadFileStream }

constructor TSmReadFileStream.Create( const FileName : string );
begin
	AssignFile( FFile, FileName );
 {$I-}
	Reset( FFile, 1 );
 {$I+}
	IsAvailable := ( IOResult = 0 );
end;

destructor TSmReadFileStream.Destroy;
begin
	if IsAvailable then
		CloseFile( FFile );
end;

function TSmReadFileStream.Read( var Buffer; Count : Integer ) : Longint;
var
	ActualRead : Longint;
begin
	if (not IsAvailable) or (Count <= 0) then begin
		Result := 0;
		Exit;
	end;

	BlockRead( FFile, Buffer, Count, ActualRead );

	Result := ActualRead;
end;

function TSmReadFileStream.Seek( Offset : Integer; Origin : Word) : Longint;
begin
	if not IsAvailable then begin
		Result := 0;
		Exit;
	end;

	case Origin of
		soFromCurrent : Offset := System.FilePos( FFile ) + Offset;
		soFromEnd     : Offset := System.FileSize( FFile ) + Offset;
	end;

	System.Seek( FFile, Offset );

	Result := Offset;
end;

function TSmReadFileStream.Position: Longint;
begin
	if not IsAvailable then begin
		Result := 0;
		Exit;
	end;

	Result := System.FilePos( FFile );
end;

{ TSmWriteFileStream }

constructor TSmWriteFileStream.Create( const FileName : string );
begin
	AssignFile( FFile, FileName );
 {$I-}
	Rewrite( FFile, 1 );
 {$I+}
	IsAvailable := ( IOResult = 0 );
end;

function TSmWriteFileStream.Write( var Buffer; Count : Integer ) : Longint;
var
	ActualWrite : Longint;
begin
	if (not IsAvailable) or (Count <= 0) then begin
		Result := 0;
		Exit;
	end;

	BlockWrite( FFile, Buffer, Count, ActualWrite );

	Result := ActualWrite;
end;

end.
