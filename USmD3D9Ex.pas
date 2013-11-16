unit USmD3D9Ex;

{ $DEFINE USE_GRAPHICS}
{ $DEFINE USE_JPEG}

interface

uses
	Windows,
{$IFDEF USE_GRAPHICS}
	Graphics,
{$ENDIF}
{$IFDEF USE_JPEG}
	Jpeg,
{$ELSE}
	USmJpeg,
{$ENDIF}
	USmResManager,
	USmD3D9, USmUtil, UConfig;

function LoadD3DJpeg(const d3Device: TGfxDevice; fileName: string): integer;
function LoadD3DJpegFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer): integer;
function LoadD3DBitmap(const d3Device: TGfxDevice; fileName: string): integer;
function LoadD3DBitmapFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer): integer;
function LoadD3DBitmapEx(const d3Device: TGfxDevice; fileName: string; colorKey: longword): integer;
function LoadD3DBitmapExFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer; colorKey: longword): integer;
function LoadTile(const d3Device: TGfxDevice; fileName: string): integer;
function LoadTileFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer): integer;
{$IFDEF USE_GRAPHICS}
function LoadD3DImage(const d3Device: TGfxDevice; fileName: string): integer;
function LoadD3DImageEx(const d3Device: TGfxDevice; fileName: string; colorKey: longword): integer;
{$ENDIF}

function InitVertex(hImage: integer; xSour, ySour, wSour, hSour: integer; out vertices: array of TVertex): boolean;
function MoveVertex(hImage: integer; xDest, yDest: integer; out vertices: array of TVertex; imageOrigin: TImageOrigin = ioLeftTop): boolean;

function InitVertexTL(hImage: integer; xSour, ySour, wSour, hSour: integer; out vertices: array of TVertexTL;
					opacity: integer = 255; lighten: integer = 255): boolean;
function MoveVertexTL(xDest, yDest: integer; wDest, hDest: integer; var vertices: array of TVertexTL;
					  angle: integer = 0; scale: integer = 100; imageOrigin: TImageOrigin = ioLeftTop): boolean;

function ShadowVertexTL(xDest, yDest: integer; wDest, hDest: integer; var vertices: array of TVertexTL;
					  angle: integer = 0; scale: integer = 100; imageOrigin: TImageOrigin = ioLeftTop): boolean;

procedure MakeShadow(chara_x, chara_y: integer; block_x1, block_y1, block_x2, block_y2: single; out vertices: array of TfPoint);

implementation

{$IFDEF USE_GRAPHICS}
function GetPixelDepth(ABitmap: TBitmap): integer;
var
	DIB: TDIBSection;
	depth: integer;
begin
	GetObject(ABitmap.handle, sizeof(DIB), @DIB);
	depth := DIB.dsBmih.biBitCount;

	if (depth = 16) and (DIB.dsBitfields[0] = $7C00) then
		depth := 15;

	result := depth;
end;

function LoadD3DImageSub(const d3Device: TGfxDevice; fileName: string; useColorKey: boolean; colorKey: longword = 0): integer;
var
	i, j: integer;
	depth: integer;
	ExtString: string;
	hImage: integer;
	bitmap: TBitmap;
{$IFDEF USE_JPEG}
	jpgImage: TJPEGImage;
{$ENDIF}
	pDest32: Plongword;
	temp, _R, _B: longword;
	paletteEntry: array[0..255] of longword;
	pPalette: Plongint;
begin
	result := 0;
	pPalette := nil;
	depth := 32;

	if not FileExists(fileName) then
		exit;

	bitmap := TBitmap.Create();

	try
		ExtString := LowerCase(ExtractFileExt(fileName));

{$IFDEF USE_JPEG}
		if ExtString = '.jpg' then begin
			jpgImage := TJPEGImage.Create();
			jpgImage.LoadFromFile(fileName);
			bitmap.Assign(jpgImage);
			jpgImage.Free;
		end
		else
{$ENDIF}
		begin
			bitmap.LoadFromFile(fileName);
		end;

		if useColorKey then begin
			bitmap.PixelFormat := pf32Bit;

			colorKey := colorKey and $00FFFFFF;
			for j := 0 to pred(bitmap.Height) do begin
				pDest32 := bitmap.ScanLine[j];
				for i := 0 to pred(bitmap.Width) do begin
					if (pDest32^ and $00FFFFFF) <> colorKey then
						pDest32^ := pDest32^ or $FF000000
					else
						pDest32^ := pDest32^ and $00FFFFFF;

					inc(pDest32);
				end;
			end;
		end
		else begin
			depth := GetPixelDepth(bitmap);

			if depth = 8 then begin
				GetPaletteEntries(bitmap.Palette, 0, 256, paletteEntry);
				for i := 0 to 255 do begin
					temp := paletteEntry[i] or $FF000000;
					_R := (temp and $000000FF) shl 16;
					_B := (temp and $00FF0000) shr 16;
					paletteEntry[i] := (temp and $FF00FF00) or _R or _B;
				end;
				pPalette := @paletteEntry;
			end;
		end;

		hImage := d3Device.CreateImage(bitmap.Width, bitmap.Height);

		if hImage = 0 then
			exit;

		d3Device.AssignImage(hImage, bitmap.ScanLine[0], bitmap.Width, bitmap.Height, depth, integer(bitmap.ScanLine[1]) - integer(bitmap.ScanLine[0]), pPalette);

	finally
		bitmap.Free;

	end;

	result := hImage;
end;

function LoadD3DImage(const d3Device: TGfxDevice; fileName: string): integer;
begin
	result := LoadD3DImageSub(d3Device, fileName, FALSE);
end;

function LoadD3DImageEx(const d3Device: TGfxDevice; fileName: string; colorKey: longword): integer;
begin
	result := LoadD3DImageSub(d3Device, fileName, TRUE, colorKey);
end;
{$ENDIF}

function InitVertex(hImage: integer; xSour, ySour, wSour, hSour: integer; out vertices: array of TVertex): boolean;
const
	MAX_VERTEX = 4;
var
	pTexInfo: PTextureInfo;
	x, y, w, h, tu, tv, tw, th: single;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	if wSour = 0 then
		wSour := pTexInfo.wSize;
	if hSour = 0 then
		hSour := pTexInfo.hSize;

	x  := - 0.5;
	y  := - 0.5;
	w  := wSour;
	h  := hSour;
	tu := xSour / pTexInfo.wTexture;
	tv := ySour / pTexInfo.hTexture;
	tw := wSour / pTexInfo.wTexture;
	th := hSour / pTexInfo.hTexture;

	vertices[0].x := x;
	vertices[0].y := y;
	vertices[0].z := 1.0;
	vertices[0].rhw := 1.0;
	vertices[0].tu := tu;
	vertices[0].tv := tv;

	vertices[1].x := x + w;
	vertices[1].y := y;
	vertices[1].z := 1.0;
	vertices[1].rhw := 1.0;
	vertices[1].tu := tu + tw;
	vertices[1].tv := tv;

	vertices[2].x := x + w;
	vertices[2].y := y + h;
	vertices[2].z := 1.0;
	vertices[2].rhw := 1.0;
	vertices[2].tu := tu + tw;
	vertices[2].tv := tv + th;

	vertices[3].x := x;
	vertices[3].y := y + h;
	vertices[3].z := 1.0;
	vertices[3].rhw := 1.0;
	vertices[3].tu := tu;
	vertices[3].tv := tv + th;

	result := TRUE;
end;

function MoveVertex(hImage: integer; xDest, yDest: integer; out vertices: array of TVertex; imageOrigin: TImageOrigin = ioLeftTop): boolean;
var
	pTexInfo: PTextureInfo;
	x, y, w, h: single;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	x := xDest - 0.5;
	y := yDest - 0.5;
	w := pTexInfo.wSize;
	h := pTexInfo.hSize;

	if imageOrigin = ioCenter then begin
		x := x - w / 2;
		y := y - h / 2;
	end;

	vertices[0].x := x;
	vertices[0].y := y;
	vertices[1].x := x + w;
	vertices[1].y := y;
	vertices[2].x := x + w;
	vertices[2].y := y + h;
	vertices[3].x := x;
	vertices[3].y := y + h;


	result := TRUE;
end;

function InitVertexTL(hImage: integer; xSour, ySour, wSour, hSour: integer; out vertices: array of TVertexTL;
					  opacity: integer = 255; lighten: integer = 255): boolean;
var
	pTexInfo: PTextureInfo;
	x, y, w, h, tu, tv, tw, th: single;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	if wSour = 0 then
		wSour := pTexInfo.wSize;
	if hSour = 0 then
		hSour := pTexInfo.hSize;

	x  := - 0.5;
	y  := - 0.5;
	w  := wSour;
	h  := hSour;
	tu := xSour / pTexInfo.wTexture;
	tv := ySour / pTexInfo.hTexture;
	tw := wSour / pTexInfo.wTexture;
	th := hSour / pTexInfo.hTexture;

	opacity := (opacity shl 24) or (lighten shl 16) or (lighten shl 8) or (lighten);

	vertices[0].x := x;
	vertices[0].y := y;
	vertices[1].x := x + w;
	vertices[1].y := y;
	vertices[2].x := x + w;
	vertices[2].y := y + h;
	vertices[3].x := x;
	vertices[3].y := y + h;

	vertices[0].z := 0.0;
	vertices[0].rhw := 1.0;
	vertices[0].color := opacity;
	vertices[0].tu := tu;
	vertices[0].tv := tv;

	vertices[1].z := 0.0;
	vertices[1].rhw := 1.0;
	vertices[1].color := opacity;
	vertices[1].tu := tu + tw;
	vertices[1].tv := tv;

	vertices[2].z := 0.0;
	vertices[2].rhw := 1.0;
	vertices[2].color := opacity;
	vertices[2].tu := tu + tw;
	vertices[2].tv := tv + th;

	vertices[3].z := 0.0;
	vertices[3].rhw := 1.0;
	vertices[3].color := opacity;
	vertices[3].tu := tu;
	vertices[3].tv := tv + th;

	result := TRUE;
end;

function MoveVertexTL(xDest, yDest: integer; wDest, hDest: integer; var vertices: array of TVertexTL;
					  angle: integer = 0; scale: integer = 100; imageOrigin: TImageOrigin = ioLeftTop): boolean;
const
	MAX_VERTEX = 4;
	OBLIQUE: single = 1.0;
var
	x, y, w, h: single;
	angle2: integer;
	radius: single;
begin
	x  := xDest - 0.5;
	y  := yDest - 0.5;
	w  := wDest;
	h  := hDest;

	case imageOrigin of
	ioLeftTop:
		if angle = 0 then begin
			w := w * scale / 100;
			h := h * scale / 100;
			vertices[0].x := x;
			vertices[0].y := y;
			vertices[1].x := x + w;
			vertices[1].y := y;
			vertices[2].x := x + w;
			vertices[2].y := y + h;
			vertices[3].x := x;
			vertices[3].y := y + h;
		end
		else begin
			w := w * scale / 100;
			h := h * scale / 100;
			radius := round(sqrt(w * w + h * h));
			angle2 := round(SmAtan(-h, w)*ONE_RADIAN);

			vertices[0].x := x;
			vertices[0].y := y;
			vertices[1].x := x + w * SmCos(angle);
			vertices[1].y := y - w * SmSin(angle) * OBLIQUE;
			vertices[2].x := x + radius * SmCos(angle+angle2);
			vertices[2].y := y - radius * SmSin(angle+angle2) * OBLIQUE;
			vertices[3].x := x + h * SmCos(angle-90);
			vertices[3].y := y - h * SmSin(angle-90) * OBLIQUE;
		end;
	ioCenter:
		if angle = 0 then begin
			w := w * scale / 100;
			h := h * scale / 100;
			x := x - w / 2;
			y := y - h / 2;
			vertices[0].x := x;
			vertices[0].y := y;
			vertices[1].x := x + w;
			vertices[1].y := y;
			vertices[2].x := x + w;
			vertices[2].y := y + h;
			vertices[3].x := x;
			vertices[3].y := y + h;
		end
		else begin
			w := w / 2;
			h := h / 2;
			radius := round(SmSqrt(w * w + h * h)) * scale / 100;

			angle2 := round(SmAtan(h, -w)*ONE_RADIAN);
			vertices[0].x := x + SmCos(angle + angle2) * radius;
			vertices[0].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
			angle2 := round(SmAtan(h, w)*ONE_RADIAN);
			vertices[1].x := x + SmCos(angle + angle2) * radius;
			vertices[1].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
			angle2 := round(SmAtan(-h, w)*ONE_RADIAN);
			vertices[2].x := x + SmCos(angle + angle2) * radius;
			vertices[2].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
			angle2 := round(SmAtan(-h, -w)*ONE_RADIAN);
			vertices[3].x := x + SmCos(angle + angle2) * radius;
			vertices[3].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
		end;
	end;

	result := TRUE;
end;

function ShadowVertexTL(xDest, yDest: integer; wDest, hDest: integer; var vertices: array of TVertexTL;
					  angle: integer = 0; scale: integer = 100; imageOrigin: TImageOrigin = ioLeftTop): boolean;
const
	MAX_VERTEX = 4;
	OBLIQUE: single = 1.0;
var
	x, y, w, h: single;
	angle2: integer;
	radius: single;
begin
	x  := xDest - 0.5;
	y  := yDest - 0.5;
	w  := wDest;
	h  := hDest;

	case imageOrigin of
		ioLeftTop:
			if angle = 0 then begin
				w := w * scale / 100;
				h := h * scale / 100;
				vertices[0].x := x - w / 2;
				vertices[0].y := y + h / 2;
				vertices[1].x := x + w - w / 2;
				vertices[1].y := y + h / 2;
				vertices[2].x := x + w;
				vertices[2].y := y + h;
				vertices[3].x := x;
				vertices[3].y := y + h;
			end
			else begin
				w := w * scale / 100;
				h := h * scale / 100;
				radius := round(sqrt(w * w + h * h));
				angle2 := round(SmAtan(-h, w)*ONE_RADIAN);

				vertices[0].x := x;
				vertices[0].y := y;
				vertices[1].x := x + w * SmCos(angle);
				vertices[1].y := y - w * SmSin(angle) * OBLIQUE;
				vertices[2].x := x + radius * SmCos(angle+angle2);
				vertices[2].y := y - radius * SmSin(angle+angle2) * OBLIQUE;
				vertices[3].x := x + h * SmCos(angle-90);
				vertices[3].y := y - h * SmSin(angle-90) * OBLIQUE;
			end;
		ioCenter:
			if angle = 0 then begin
				w := w * scale / 100;
				h := h * scale / 100;
				x := x - w / 2;
				y := y - h / 2;
				vertices[0].x := x;
				vertices[0].y := y;
				vertices[1].x := x + w;
				vertices[1].y := y;
				vertices[2].x := x + w;
				vertices[2].y := y + h;
				vertices[3].x := x;
				vertices[3].y := y + h;
			end
			else begin
				w := w / 2;
				h := h / 2;
				radius := round(SmSqrt(w * w + h * h)) * scale / 100;

				angle2 := round(SmAtan(h, -w)*ONE_RADIAN);
				vertices[0].x := x + SmCos(angle + angle2) * radius;
				vertices[0].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
				angle2 := round(SmAtan(h, w)*ONE_RADIAN);
				vertices[1].x := x + SmCos(angle + angle2) * radius;
				vertices[1].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
				angle2 := round(SmAtan(-h, w)*ONE_RADIAN);
				vertices[2].x := x + SmCos(angle + angle2) * radius;
				vertices[2].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
				angle2 := round(SmAtan(-h, -w)*ONE_RADIAN);
				vertices[3].x := x + SmCos(angle + angle2) * radius;
				vertices[3].y := y - SmSin(angle + angle2) * radius * OBLIQUE;
			end;
	end;

	result := TRUE;
end;

procedure MakeShadow(chara_x, chara_y: integer; block_x1, block_y1, block_x2, block_y2: single; out vertices: array of TfPoint);
var
	status: integer;
	x, y: single;
begin
	if chara_x > block_x2 then
		status := 0
	else if chara_x < block_x1 then
		status := 2
	else
		status := 1;

	if chara_y > block_y2 then
		status := status + 0 * 3
	else if chara_y < block_y1 then
		status := status + 2 * 3
	else
		status := status + 1 * 3;

	case status of
		0:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y2;
			vertices[3].x := block_x2;
			vertices[3].y := block_y1;
		end;
		1:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y2;
			vertices[3].x := block_x2;
			vertices[3].y := block_y2;
		end;
		2:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y1;
			vertices[3].x := block_x2;
			vertices[3].y := block_y2;
		end;
		3:
		begin
			vertices[0].x := block_x2;
			vertices[0].y := block_y1;
			vertices[3].x := block_x2;
			vertices[3].y := block_y2;
		end;
		5:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y1;
			vertices[3].x := block_x1;
			vertices[3].y := block_y2;
		end;
		6:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y1;
			vertices[3].x := block_x2;
			vertices[3].y := block_y2;
		end;
		7:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y1;
			vertices[3].x := block_x2;
			vertices[3].y := block_y1;
		end;
		8:
		begin
			vertices[0].x := block_x1;
			vertices[0].y := block_y2;
			vertices[3].x := block_x2;
			vertices[3].y := block_y1;
		end;
	end;

	x := chara_x;
	y := chara_y;

	vertices[1].x := x + (vertices[0].x - x) * 1500;
	vertices[1].y := y + (vertices[0].y - y) * 1500;
	vertices[2].x := x + (vertices[3].x - x) * 1500;
	vertices[2].y := y + (vertices[3].y - y) * 1500;
end;

function LoadD3DBitmapSub(const d3Device: TGfxDevice; inStream: TSmStream; useColorKey: boolean; colorKey: longword = 0): integer;
var
	width, height: longint;
	depth: longint;
	sourBPL, destBPL: longint;

	BH: TBitmapFileHeader;
	BI: TBitmapInfoHeader;

	x, y: integer;

	pSourBuffer: PByteArray;
	color: longword;
	pDestBuffer: PByte;
	pDest32: Plongword;
	hImage: integer;
begin
	result      := 0;

	if not inStream.IsAvailable then
		exit;

	inStream.Read(BH, sizeof(BH));
	inStream.Read(BI, sizeof(BI));
	inStream.Seek(BH.bfOffBits, soFromBeginning);

	width       := BI.biWidth;
	height      := BI.biHeight;
	depth       := BI.biBitCount;
	sourBPL     := (width * depth + 7) div 8;
	destBPL     := width * sizeof(longword);

	pSourBuffer := AllocMem(sourBPL);
	pDestBuffer := AllocMem(destBPL * height);

	case depth of
		1:
		begin
			for y := 0 to pred(height) do begin
				inStream.Read(pSourBuffer^, sourBPL);
				pDest32 := Plongword(pDestBuffer);
				inc(pDest32, destBPL * (pred(height)-y) div sizeof(longword));
				for x := 0 to pred(width) do begin
					if (pSourBuffer[x div 8] and ($80 shr (x mod 8))) > 0 then
						pDest32^ := $FFFFFFFF
					else
						pDest32^ := $00000000;
					inc(pDest32);
				end;
			end;
		end;
		24:
		if useColorKey then begin
			colorKey := colorKey and $00FFFFFF;
			for y := 0 to pred(height) do begin
				inStream.Read(pSourBuffer^, sourBPL);
				pDest32 := Plongword(pDestBuffer);
				inc(pDest32, destBPL * (pred(height)-y) div sizeof(longword));
				for x := 0 to pred(width) do begin
					color := pSourBuffer[3*x+0];
					color := color or (longword(pSourBuffer[3*x+1]) shl 8);
					color := color or (longword(pSourBuffer[3*x+2]) shl 16);
					if color <> colorKey then
						pDest32^ := $FF000000 or color
					else
						pDest32^ := color;
					inc(pDest32);
				end;
			end;
		end;
	end;

	FreeMem(pSourBuffer);

	try
		hImage := d3Device.CreateImage(width, height);
		if hImage = 0 then
			exit;

		d3Device.AssignImage(hImage, pDestBuffer, width, height, 32, destBPL, nil);

	finally
		FreeMem(pDestBuffer);

	end;

	result := hImage;
end;

function LoadD3DBitmap(const d3Device: TGfxDevice; fileName: string): integer;
var
	inFile: TSmReadFileStream;
begin
	inFile := TSmReadFileStream.Create(fileName);
	result := LoadD3DBitmapSub(d3Device, inFile, FALSE);
	inFile.Free;
end;

function LoadD3DBitmapEx(const d3Device: TGfxDevice; fileName: string; colorKey: longword): integer;
var
	inFile: TSmReadFileStream;
begin
	inFile := TSmReadFileStream.Create(fileName);
	result := LoadD3DBitmapSub(d3Device, inFile, TRUE, colorKey);
	inFile.Free;
end;

function LoadD3DBitmapFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer): integer;
var
	inMemory: TSmMemoryStream;
begin
	if size > 0 then
		inMemory := TSmMemoryStream.Create(pMemory, size)
	else
		inMemory := TSmMemoryStream.Create(pMemory, PBitmapFileHeader(pMemory).bfSize);

	result := LoadD3DBitmapSub(d3Device, inMemory, FALSE);
	inMemory.Free;
end;

function LoadD3DBitmapExFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer; colorKey: longword): integer;
var
	inMemory: TSmMemoryStream;
begin
	if size > 0 then
		inMemory := TSmMemoryStream.Create(pMemory, size)
	else
		inMemory := TSmMemoryStream.Create(pMemory, PBitmapFileHeader(pMemory).bfSize);

	result := LoadD3DBitmapSub(d3Device, inMemory, TRUE, colorKey);
	inMemory.Free;
end;

function LoadBitmapFromFile(inStream: TSmStream; out bitmap: TBitmap): boolean;
var
	width, height: longint;

	function GetBitmap(x, y: integer; pDest: Plongword; pitch: longint): boolean;

		function ValidRegion(dx, dy: integer): boolean;
		var
			_x, _y: integer;
			pDest32: Plongword;
		begin
			result := TRUE;
			
			_x := x + dx;
			_y := y + dy;

			if ((_x+14) div 14 = (x+14) div 14) and ((_y+16) div 16 = (y+16) div 16) then begin
				pDest32 := pDest;
				if (dx <> 0) then
					inc(pDest32, dx);
				if (dy <> 0) then
					inc(pDest32, pitch*dy);

				if pDest32^ = $FFFFFFFF then
					result := FALSE;
			end;
		end;

	begin
		result := FALSE;

		if ValidRegion(-1,  0) and
		   ValidRegion(+1,  0) and
		   ValidRegion( 0, -1) and
		   ValidRegion( 0, +1) and
		   ValidRegion(-1, -1) and
		   ValidRegion(+1, -1) and
		   ValidRegion(+1, +1) and
		   ValidRegion(-1, +1) then
			result := TRUE;
	end;

var
	depth: longint;
	pitch: longint;
	sourBPL, destBPL: longint;

	BH: TBitmapFileHeader;
	BI: TBitmapInfoHeader;

	x, y: integer;
	pSourBuffer: PByteArray;
	pDestBuffer: PByte;
	pDest32: Plongword;
begin
	result := FALSE;

	if not inStream.IsAvailable then
		exit;

	inStream.Read(BH, sizeof(BH));
	inStream.Read(BI, sizeof(BI));
	inStream.Seek(BH.bfOffBits, soFromBeginning);

	if BI.biBitCount <> 1 then
		exit;

	width       := BI.biWidth;
	height      := BI.biHeight;
	depth       := BI.biBitCount;
	sourBPL     := (width * depth + 7) div 8;
	destBPL     := width * sizeof(longword);

	pSourBuffer := AllocMem(sourBPL);
	pDestBuffer := AllocMem(destBPL * height);

	for y := 0 to pred(height) do begin
		inStream.Read(pSourBuffer^, sourBPL);
		pDest32 := Plongword(pDestBuffer);
		inc(pDest32, destBPL * (pred(height)-y) div sizeof(longword));
		for x := 0 to pred(width) do begin
			if (pSourBuffer[x div 8] and ($80 shr (x mod 8))) > 0 then
				pDest32^ := $FFFFFFFF
			else
				pDest32^ := $00000000;
			inc(pDest32);
		end;
	end;

	FreeMem(pSourBuffer);

	pitch := destBPL div sizeof(longword);
	for y := 0 to pred(16*3) do begin
		pDest32 := Plongword(pDestBuffer);
		inc(pDest32, (16 * 5 + y) * pitch);
		for x := 0 to pred(width) do begin
			if pDest32^ = $00000000 then begin
				if GetBitmap(x, y, pDest32, pitch) then
					pDest32^ := $000000FF
				else
					pDest32^ := $FF000000
			end;
			inc(pDest32);
		end;
	end;

	with bitmap do begin
		bmType       := 0;
		bmWidth      := width;
		bmHeight     := height;
		bmWidthBytes := destBPL;
		bmPlanes     := 1;
		bmBitsPixel  := 32;
		bmBits       := pDestBuffer;
	end;

	result := TRUE;
end;

procedure DestroyBitmap(var bitmap: TBitmap);
begin
	if assigned(bitmap.bmBits) then begin
		FreeMem(bitmap.bmBits);
		bitmap.bmBits := nil;
	end;
end;

function ConvertScanLine(const d3Device: TGfxDevice; const sBitmap: TBitmap): integer;
var
	hImage: integer;
	dBitmap: TBitmap;
	x, y: integer;
	pSour32: Plongword;
	pDest32: Plongword;
	pDest33: Plongword;
begin
	result := 0;

	dBitmap := sBitmap;

	dBitmap.bmWidth      := dBitmap.bmWidth  * 2;
	dBitmap.bmHeight     := dBitmap.bmHeight * 2;
	dBitmap.bmWidthBytes := dBitmap.bmWidthBytes * 2;
	dBitmap.bmBits       := AllocMem(dBitmap.bmWidthBytes * dBitmap.bmHeight);

	for y := 0 to pred(sBitmap.bmHeight) do begin
		pSour32 := sBitmap.bmBits;
		inc(pSour32, (sBitmap.bmWidthBytes div sizeof(longword)) * y);
		pDest32 := dBitmap.bmBits;
		inc(pDest32, (dBitmap.bmWidthBytes div sizeof(longword)) * y * 2);
		pDest33 := dBitmap.bmBits;
		inc(pDest33, (dBitmap.bmWidthBytes div sizeof(longword)) * (y * 2 + 1));
		for x := 0 to pred(sBitmap.bmWidth) do begin
			if (pSour32^ and $FF000000) = $FF000000 then begin
//			if pSour32^ <> $000000FF then begin
				pDest32^ := pSour32^; inc(pDest32);
				pDest32^ := pSour32^; inc(pDest32);
				inc(pSour32);

				pDest33^ := 0; inc(pDest33);
				pDest33^ := 0; inc(pDest33);

				continue;
			end
			else begin
				pDest32^ := 0; inc(pDest32);
				pDest32^ := 0; inc(pDest32);
				pDest33^ := 0; inc(pDest33);
				pDest33^ := 0; inc(pDest33);
				inc(pSour32);
			end;
{
			inc(pDest32);
			inc(pDest32);
			inc(pSour32);
			inc(pDest33);
			inc(pDest33);
}
		end;
	end;

	try
		hImage := d3Device.CreateImage(dBitmap.bmWidth, dBitmap.bmHeight);
		if hImage = 0 then
			exit;

		d3Device.AssignImage(hImage, dBitmap.bmBits, dBitmap.bmWidth, dBitmap.bmHeight, 32, dBitmap.bmWidthBytes, nil);

	finally
		FreeMem(dBitmap.bmBits);

	end;

	result := hImage;
end;

function LoadTileFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer): integer;
var
	inMemory: TSmMemoryStream;
	bitmap: TBitmap;
begin
	result := 0;

	inMemory := TSmMemoryStream.Create(pMemory, size);
	if not inMemory.IsAvailable then
		exit;

	LoadBitmapFromFile(inMemory, bitmap);
	inMemory.Free;

	result := ConvertScanLine(d3Device, bitmap);

	DestroyBitmap(bitmap);
end;

function LoadTile(const d3Device: TGfxDevice; fileName: string): integer;
var
	inFile: TSmReadFileStream;
	bitmap: TBitmap;
begin
	result := 0;

	inFile := TSmReadFileStream.Create(fileName);
	if not inFile.IsAvailable then
		exit;

	LoadBitmapFromFile(inFile, bitmap);
	inFile.Free;

	result := ConvertScanLine(d3Device, bitmap);

	DestroyBitmap(bitmap);
end;

function LoadD3DJpeg(const d3Device: TGfxDevice; fileName: string): integer;
var
	SmJpeg : TSmJpeg;
	width  : integer;
	height : integer;
	bpl    : integer;
	pBuffer: pointer;
begin
	SmJpeg := TSmJpeg.Create;

	SmJpeg.LoadJPG(fileName);

	width  := SmJpeg.GetWidth();
	height := SmJpeg.GetHeight();
	bpl    := width * 4;

	pBuffer := AllocMem(bpl * height);

	SmJpeg.GetBitmap(pBuffer, bpl, nil, 32);
	SmJpeg.Free;

	try
		result := d3Device.CreateImage(width, height);
		if result = 0 then
			exit;

		d3Device.AssignImage(result, pBuffer, width, height, 32, bpl, nil);

	finally
		FreeMem(pBuffer);

	end;
end;

//?? 위쪽 함수와 공통 부분이 있으므로 합쳐야 함
function LoadD3DJpegFromMemory(const d3Device: TGfxDevice; pMemory: Pbyte; size: integer): integer;
var
	SmJpeg : TSmJpeg;
	width  : integer;
	height : integer;
	bpl    : integer;
	pBuffer: pointer;
begin
	SmJpeg := TSmJpeg.Create;

	SmJpeg.LoadJPG(pMemory, size);

	width  := SmJpeg.GetWidth();
	height := SmJpeg.GetHeight();
	bpl    := width * 4;

	pBuffer := AllocMem(bpl * height);

	SmJpeg.GetBitmap(pBuffer, bpl, nil, 32);
	SmJpeg.Free;

	try
		result := d3Device.CreateImage(width, height);
		if result = 0 then
			exit;

		d3Device.AssignImage(result, pBuffer, width, height, 32, bpl, nil);

	finally
		FreeMem(pBuffer);

	end;
end;

end.

