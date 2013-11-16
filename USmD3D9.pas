unit USmD3D9;

interface

uses
	Windows, Direct3D9,
	USmUtil;

const
	TEXTURE_PIXEL_FORMAT: TD3DFORMAT = D3DFMT_A8R8G8B8;
	ONE_RADIAN = 180 / 3.14159265358979323846;

type
	TBlendingMode =
	(
		bmNormal,
		bmTransparent,
		bmAlpha,
		bmShadow
	);

	TImageOrigin =
	(
		ioLeftTop,
		ioCenter
	);

	TMemoryPool =
	(
		mpManaged,
		mpVideo,
		mpSystem
	);

	PFPoint = ^TFPoint;
	TFPoint = packed record
		x, y         : single;
	end;

	PVertexBase = ^TVertexBase;
	TVertexBase = packed record
		x, y, z, rhw : single;
		color        : longword;
	end;

	PVertex = ^TVertex;
	TVertex = packed record
		x, y, z, rhw : single;
		tu, tv       : single;
	end;

	PVertexTL = ^TVertexTL;
	TVertexTL = packed record
		x, y, z, rhw : single;
		color        : longword;
		tu, tv       : single;
	end;

	TArrayVertexBase  = array[0..3] of TVertexBase;
	TArrayVertex      = array[0..3] of TVertex;
	TArrayVertexTL    = array[0..3] of TVertexTL;

	PTextureInfo = ^TTextureInfo;
	TTextureInfo = record
		wSize: longint;
		hSize: longint;
		wTexture: longint;
		hTexture: longint;
		pixelFormat: TD3DFORMAT;
		pTexture: IDirect3DTexture9;
	end;

	TFnLostDevice = procedure of object;

	TGfxDevice = class
		constructor Create(hWindow: THandle; useAuxAdaptor: boolean = FALSE); virtual; abstract;
		procedure   Free(); virtual; abstract;
		function    IsValid(): boolean; virtual; abstract;
		function    Init(width, height: integer; depth: integer; isFullScreen: boolean): boolean; virtual; abstract;
		function    Done(): boolean; virtual; abstract;
		procedure   SetCallback(fnLostDevice: TFnLostDevice); virtual; abstract;
		procedure   GetBufferInfo(out width, height: integer); virtual; abstract;

		procedure   SetBlendingMode(blendingMode: TBlendingMode); virtual; abstract;
		procedure   SetImageOrigin(imageOrigin: TImageOrigin); virtual; abstract;
		procedure   SetClip(x, y, w, h: integer); virtual; abstract;

		function    GetDC(): HDC; virtual; abstract;
		procedure   ReleaseDC(DC: HDC); virtual; abstract;

		function    CreateImage(width, height: integer; memoryPool: TMemoryPool = mpManaged): integer; virtual; abstract;
		function    DestroyImage(hImage: integer): boolean; virtual; abstract;
		function    AssignImage(hImage: integer; pImage: pointer; width, height, depth, pitch: integer; pPalette: Plongint): boolean; virtual; abstract;
		function    ClearImage(hImage: integer; color: longword): boolean; virtual; abstract;
		function    GetImageInfo(hImage: integer; pWidth: Plongint; pHeight: Plongint): boolean; virtual; abstract;
		function    SetRenderTarget(hImage: integer): boolean; virtual; abstract;

		function    Clear(color: longword): boolean; virtual; abstract;
		function    ClearRect(color: longword; x, y, w, h: integer): boolean; virtual; abstract;
		function    DrawLine(color: longword; x1, y1: integer; x2, y2: integer): boolean; virtual; abstract;
		function    DrawPolygon(color: longword; points: array of TFPoint; n: integer): boolean; virtual; abstract;
		function    FillRect(color: longword; x, y, w, h: integer): boolean; virtual; abstract;

		function    BitBlt(xDest, yDest: integer; const hImage: integer; xSour, ySour, wSour, hSour: integer; color: longword): boolean; virtual; abstract;
		function    DrawTexture(hImage: integer; const vertices: array of TVertex): boolean; overload; virtual; abstract;
		function    DrawTexture(hImage: integer; const vertices: array of TVertexTL): boolean; overload; virtual; abstract;
		function    DrawImage(xDest, yDest: integer; hImage: integer; xSour: integer = 0; ySour: integer = 0; wSour: integer = 0; hSour: integer = 0): boolean; virtual; abstract;
		function    DrawImageEx(xDest, yDest: integer; hImage: integer; xSour: integer; ySour: integer; wSour: integer; hSour: integer;
								opacity: longword = $FF; lighten: longword = $FFFFFF; angle: integer = 0; scale: integer = 100): boolean; virtual; abstract;

		function    BeginScene(): boolean; virtual; abstract;
		function    EndScene(): boolean; virtual; abstract;
		function    Flush(): boolean; virtual; abstract;
	end;

	TD3DDevice = class(TGfxDevice)
	private
		m_hWindow        : THandle;
		m_pD3D           : IDirect3D9;
		m_pD3DDevice     : IDirect3DDevice9;
		m_pRenderTarget  : IDirect3DSurface9;
		m_fnLostDevice   : TFnLostDevice;

		m_displayAdapt   : integer;
		m_d3dPP          : TD3DPresentParameters;
		m_d3dCaps        : TD3DCaps9;
		m_d3dDisplayMode : TD3DDisplayMode;

		m_blendingMode   : TBlendingMode;
		m_imageOrigin    : TImageOrigin;

		function    m_GetAppropriatePixelFormat(depth: integer; isFullScreen: boolean): TD3DFORMAT;
		function    m_CreateDevice(hWindow: THandle; var d3dPP: TD3DPresentParameters): IDirect3DDevice9;

	protected
		t_currentTexture : IDirect3DBaseTexture9;
		procedure   t_SetTexture(stage: integer; texture: IDirect3DBaseTexture9);

	public
		constructor Create(hWindow: THandle; useAuxAdaptor: boolean = FALSE); override;
		procedure   Free(); override;
		function    IsValid(): boolean; override;
		function    Init(width, height: integer; depth: integer; isFullScreen: boolean): boolean; override;
		function    Done(): boolean; override;
		procedure   SetCallback(fnLostDevice: TFnLostDevice); override;
		procedure   GetBufferInfo(out width, height: integer); override;

		procedure   SetBlendingMode(blendingMode: TBlendingMode); override;
		procedure   SetImageOrigin(imageOrigin: TImageOrigin); override;
		procedure   SetClip(x, y, w, h: integer); override;

		function    GetDC(): HDC; override;
		procedure   ReleaseDC(DC: HDC); override;

		function    CreateImage(width, height: integer; memoryPool: TMemoryPool = mpManaged): integer; override;
		function    DestroyImage(hImage: integer): boolean; override;
		function    AssignImage(hImage: integer; pImage: pointer; width, height, depth, pitch: integer; pPalette: Plongint): boolean; override;
		function    ClearImage(hImage: integer; color: longword): boolean; override;
		function    GetImageInfo(hImage: integer; pWidth: Plongint; pHeight: Plongint): boolean; override;
		function    SetRenderTarget(hImage: integer): boolean; override;

		function    Clear(color: longword): boolean; override;
		function    ClearRect(color: longword; x, y, w, h: integer): boolean; override;
		function    DrawLine(color: longword; x1, y1: integer; x2, y2: integer): boolean; override;
		function    DrawPolygon(color: longword; points: array of TFPoint; n: integer): boolean; override;
		function    FillRect(color: longword; x, y, w, h: integer): boolean; override;

		function    BitBlt(xDest, yDest: integer; const hImage: integer; xSour, ySour, wSour, hSour: integer; color: longword): boolean; override;
		function    DrawTexture(hImage: integer; const vertices: array of TVertex): boolean; overload; override;
		function    DrawTexture(hImage: integer; const vertices: array of TVertexTL): boolean; overload; override;
		function    DrawImage(xDest, yDest: integer; hImage: integer; xSour: integer = 0; ySour: integer = 0; wSour: integer = 0; hSour: integer = 0): boolean; override;
		function    DrawImageEx(xDest, yDest: integer; hImage: integer; xSour: integer; ySour: integer; wSour: integer; hSour: integer;
								opacity: longword = $FF; lighten: longword = $FFFFFF; angle: integer = 0; scale: integer = 100): boolean; override;

		function    BeginScene(): boolean; override;
		function    EndScene(): boolean; override;
		function    Flush(): boolean; override;
	end;

const
    c_matrixIdentity: TD3DMatrix = ( m: ((0.0, 1.0, 0.0, 0.0),(0.0, 1.0, 0.0, 0.0),(0.0, 0.0, 1.0, 0.0),(0.0, 0.0, 0.0, 1.0)));
var
	g_d3Device : TD3DDevice = nil;
    m_matrixWorld: TD3DMatrix;
    m_matrixView: TD3DMatrix;
    m_matrixProjection: TD3DMatrix;

implementation



constructor TD3DDevice.Create(hWindow : THandle; useAuxAdaptor: boolean);
var
	mode: TD3DDisplayMode;
	i: integer;
begin
	m_hWindow      := hWindow;
	m_pD3D         := nil;
	m_pD3DDevice   := nil;
	m_fnLostDevice := nil;
	m_blendingMode := bmNormal;
	m_imageOrigin  := ioLeftTop;

	t_currentTexture := nil;

	// fill D3D present parameters with zero
	ZeroMemory(@m_d3dPP, sizeof(m_d3dPP));

	ZeroMemory(@m_d3dCaps, sizeof(m_d3dCaps));
	ZeroMemory(@m_d3dDisplayMode, sizeof(m_d3dDisplayMode));

	// create a instance of Direct3D9
	m_pD3D := Direct3DCreate9(D3D_SDK_VERSION);

	m_displayAdapt := D3DADAPTER_DEFAULT;

	if assigned(m_pD3D) then begin
		if useAuxAdaptor then begin
			m_displayAdapt := m_pD3D.GetAdapterCount() - 1;
		end;
		WriteDebugLog('+-- [ Direct3D attribute ] -----------------');

		for i := 0 to m_pD3D.GetAdapterCount()-1 do begin
			m_pD3D.GetAdapterDisplayMode(i, mode);
			WriteDebugLog('| Adapt ' + ToStr(i));
			WriteDebugLog('|     width = ' + ToStr(mode.Width, 4) + ', height = ' + ToStr(mode.Height, 4) + ', mode = ' + ToStr(mode.Format, 2));
		end;

		WriteDebugLog('+-------------------------------------------');
		WriteDebugLog('+ Direct3D instance is created.')
	end
	else begin
		WriteDebugLog('- Direct3D instance creation fails.');
	end;
end;

procedure TD3DDevice.Free();
begin
	// release a D3D device and an instance
	m_pRenderTarget := nil;
	m_pD3DDevice    := nil;

	m_pD3D          := nil;

	WriteDebugLog('+ Direct3D instance is destroyed.')
end;

function TD3DDevice.m_GetAppropriatePixelFormat(depth: integer; isFullScreen: boolean): TD3DFORMAT;
var
	backBufferFormat : TD3DFORMAT;
	candidateFormat  : TD3DFORMAT;
begin
	result := D3DFMT_UNKNOWN;

	// find an appropriate back-buffer format
	backBufferFormat := D3DFMT_UNKNOWN;
	candidateFormat  := D3DFMT_UNKNOWN;

	if (isFullScreen) then begin
		case depth of
			32:
			begin
				backBufferFormat := D3DFMT_X8R8G8B8;
				candidateFormat  := D3DFMT_A8R8G8B8;
			end;
			16:
			begin
				backBufferFormat := D3DFMT_R5G6B5;
				candidateFormat  := D3DFMT_X1R5G5B5;
			end;
		end;

		// check if an availavle format
		if backBufferFormat <> D3DFMT_UNKNOWN then begin
			if FAILED(m_pD3D.CheckDeviceType(m_displayAdapt, D3DDEVTYPE_HAL, backBufferFormat, backBufferFormat, FALSE)) then begin
				if FAILED(m_pD3D.CheckDeviceType(m_displayAdapt, D3DDEVTYPE_HAL, candidateFormat, candidateFormat, FALSE)) then begin
					exit;
				end;
				backBufferFormat := candidateFormat;
			end;
		end
	end;

	result := backBufferFormat;
end;

function TD3DDevice.m_CreateDevice(hWindow: THandle; var d3dPP: TD3DPresentParameters): IDirect3DDevice9;
var
	pD3DDevice : IDirect3DDevice9;
begin
	result := nil;

	// create a D3D device
	if (FAILED(m_pD3D.CreateDevice(m_displayAdapt, D3DDEVTYPE_HAL, hWindow,
								   D3DCREATE_SOFTWARE_VERTEXPROCESSING,
								   d3dPP, pD3DDevice))) then
		exit;

	result := pD3DDevice;
end;

procedure TD3DDevice.t_SetTexture(stage: integer; texture: IDirect3DBaseTexture9);
begin
	if t_currentTexture = texture then
		exit;

	m_pD3DDevice.SetTexture(stage, texture);
	t_currentTexture := texture;
end;

function TD3DDevice.IsValid(): boolean;
begin
	result := assigned(m_pD3DDevice);
end;

function TD3DDevice.Init(width, height: integer; depth: integer; isFullScreen: boolean): boolean;

	procedure s_AdjustWindowRect(hWindow: THandle; width, height: integer);
	var
		winInfo: TWindowInfo;
		rect: TRect;
	begin
		if not Windows.GetWindowInfo(hWindow, winInfo) then
			exit;

		rect.Left   := 0;
		rect.Top    := 0;
		rect.Right  := width;
		rect.Bottom := height;

		if not Windows.AdjustWindowRect(rect, winInfo.dwStyle, (GetMenu(hWindow) <> 0)) then
			exit;

		Windows.MoveWindow(hWindow, winInfo.rcWindow.Left, winInfo.rcWindow.Top, rect.Right - rect.Left, rect.Bottom - rect.Top, TRUE);
	end;

var
	log: string;
begin
	result := FALSE;

	if not assigned(m_pD3D) then begin
		WriteDebugLog('- [Init] Direct3D instance is not created yet.');
		exit;
	end;

	// adjust window size
	if not isFullScreen then
		s_AdjustWindowRect(m_hWindow, width, height);

	// fill D3D present parameter's fields
	if isFullScreen then
		m_d3dPP.SwapEffect   := D3DSWAPEFFECT_FLIP
	else
		m_d3dPP.SwapEffect   := D3DSWAPEFFECT_COPY;

	m_d3dPP.BackBufferCount  := 1;
	m_d3dPP.Flags            := 0;//D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;
	m_d3dPP.Windowed         := not isFullScreen;
	m_d3dPP.BackBufferFormat := m_GetAppropriatePixelFormat(depth, isFullScreen);
	m_d3dPP.BackBufferWidth  := width;
	m_d3dPP.BackBufferHeight := height;

	m_d3dPP.EnableAutoDepthStencil := TRUE;
	m_d3dPP.AutoDepthStencilFormat := D3DFMT_D16;

	// revise parameters
	if m_d3dPP.BackBufferFormat = D3DFMT_UNKNOWN then
		m_d3dPP.Windowed     := TRUE;

	str(m_d3dPP.BackBufferFormat, log);
	WriteDebugLog('+ [Init] Back buffer format: '+log);

	// create a D3D device
	m_pD3DDevice := m_CreateDevice(m_hWindow, m_d3dPP);
	if not assigned(m_pD3DDevice) then begin
		m_d3dPP.BackBufferWidth  := height;
		m_d3dPP.BackBufferHeight := width;
		m_pD3DDevice := m_CreateDevice(m_hWindow, m_d3dPP);
		if not assigned(m_pD3DDevice) then begin
			WriteDebugLog('- [Init] Direct3D device creation fails.');
			exit;
		end;
		WriteDebugLog('+ [Init] pivot screen is detected.');
	end;

	// get capabilities
	m_pD3DDevice.GetDeviceCaps(m_d3dCaps);

	// get attributes for display mode
	m_pD3DDevice.GetDisplayMode(0, m_d3dDisplayMode);

	// get default render target
	m_pD3DDevice.GetRenderTarget(0, m_pRenderTarget);

{
	material: TD3DMATERIAL9;

	ZeroMemory(@material, sizeof(material));
	material.Diffuse.r := 1; material.Diffuse.g := 1; material.Diffuse.b := 1;
	material.Ambient.r := 1; material.Ambient.g := 1; material.Ambient.b := 1;
	m_pD3DDevice.SetMaterial(material);
	m_pD3DDevice.SetRenderState(D3DRS_AMBIENT, $FFFFFFFF);

	m_pD3DDevice.SetRenderState(D3DRS_ZENABLE, 0);
	m_pD3DDevice.SetRenderState(D3DRS_LIGHTING, 0);
	m_pD3DDevice.SetRenderState(D3DRS_DITHERENABLE, 0);
	m_pD3DDevice.SetRenderState(D3DRS_SPECULARENABLE, 0);
	m_pD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
	m_pD3DDevice.SetRenderState(D3DRS_TEXTUREFACTOR, $FFFFFFFF);
	m_pD3DDevice.SetRenderState(D3DRS_SHADEMODE, D3DSHADE_GOURAUD);
	m_pD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
	m_pD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 0);
}
	m_pD3DDevice.SetRenderState(D3DRS_ZENABLE, 1);

	m_pD3DDevice.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
	m_pD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
	m_pD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
	m_pD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_MODULATE);
	m_pD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
	m_pD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);
	m_pD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_MODULATE);

//	m_pD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
//	m_pD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);

	m_pD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
	m_pD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
	m_pD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);

	m_pD3DDevice.SetRenderState(D3DRS_ALPHAREF, $00);
	m_pD3DDevice.SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_NOTEQUAL);

	m_pD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
//	m_pD3DDevice.SetRenderState(D3DRS_ANTIALIASEDLINEENABLE, 1);

//	m_pD3DDevice.SetRenderState(D3DRS_FILLMODE, D3DFILL_WIREFRAME);


	// set clipping area
	self.SetClip(0, 0, width, height);

	// clear a back-buffer
	Self.Clear($FF000000);
	Self.Flush();

	WriteDebugLog('+ [Init] Direct3D device is created.');

	result := TRUE;
end;

function TD3DDevice.Done(): boolean;
begin
	m_pRenderTarget := nil;
	m_pD3DDevice    := nil;

	WriteDebugLog('+ [Done] Direct3D device is destroyed.');

	result := FALSE;
end;

procedure TD3DDevice.SetCallback(fnLostDevice: TFnLostDevice);
begin
	m_fnLostDevice := fnLostDevice;
end;

procedure TD3DDevice.GetBufferInfo(out width, height: integer);
var
	displayMode: TD3DDisplayMode;
begin
	assert(assigned(m_pD3DDevice));

	m_pD3DDevice.GetDisplayMode(0, displayMode);
	width  := displayMode.Width;
	height := displayMode.Height;
end;

procedure TD3DDevice.SetBlendingMode(blendingMode: TBlendingMode);
begin
	assert(assigned(m_pD3DDevice));

	if m_blendingMode = blendingMode then
		exit;

	case blendingMode of
		bmNormal:
		begin
			m_pD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
			m_pD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 0);
		end;
		bmTransparent:
		begin
			m_pD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
			m_pD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 1);
		end;
		bmAlpha:
		begin
			m_pD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
			m_pD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 0);
			m_pD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
			m_pD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
		end;
		bmShadow:
		begin
			m_pD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
			m_pD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 0);
			m_pD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
			m_pD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
		end;
	end;

	m_blendingMode := blendingMode;
end;

procedure TD3DDevice.SetImageOrigin(imageOrigin: TImageOrigin);
begin
	m_imageOrigin := imageOrigin;
end;

procedure TD3DDevice.SetClip(x, y, w, h: integer);
var
	viewPort: TD3DVIEWPORT9;
begin
	assert(assigned(m_pD3DDevice));

	viewPort.X      := x;
	viewPort.Y      := y;
	viewPort.Width  := w;
	viewPort.Height := h;
	viewPort.MinZ   := 0.0;
	viewPort.MaxZ   := 1.0;
	m_pD3DDevice.SetViewport(viewPort);
end;

function  TD3DDevice.GetDC(): HDC;
var
	DC: HDC;
begin
	m_pRenderTarget.GetDC(DC);
	result := DC;
end;

procedure TD3DDevice.ReleaseDC(DC: HDC);
begin
	m_pRenderTarget.ReleaseDC(DC);
end;

function TD3DDevice.CreateImage(width, height: integer; memoryPool: TMemoryPool = mpManaged): integer;
var
	texInfo: TTextureInfo;
	pTexInfo: PTextureInfo;
	hr: HRESULT;
	ddCaps: TD3DCAPS9;
	realW, realH: integer;
	memPool: TD3DPool;
begin
	result := 0;

	case memoryPool of
		mpManaged : memPool := D3DPOOL_MANAGED;
		mpVideo   : memPool := D3DPOOL_DEFAULT;
		mpSystem  : memPool := D3DPOOL_SYSTEMMEM;
		else        exit;
	end;

	if not assigned(m_pD3DDevice) then begin
		WriteDebugLog('- [CreateImage] Direct3D device is not created yet.');
		exit;
	end;

	hr := m_pD3DDevice.GetDeviceCaps(ddCaps);
	if hr <> D3D_OK then begin
		WriteDebugLog('- [CreateImage] The capability of D3D device cannot retrieved.');
		exit;
	end;

	// Check if a texture size must be power of 2
	if (ddCaps.TextureCaps and D3DPTEXTURECAPS_POW2) > 0 then begin
		realW := 4;
		while width > realW do
			realW := realW shl 1;

		realH := 4;
		while height > realH do
			realH := realH shl 1;
	end
	else begin
		realW := width;
		realH := height;
	end;

	// Check if a texture must be a square
	if (ddCaps.TextureCaps and D3DPTEXTURECAPS_SQUAREONLY) > 0 then begin
		if realW > realH then
			realH := realW
		else
			realW := realH
	end;

	if (memPool = D3DPOOL_DEFAULT) then
		m_pD3DDevice.CreateTexture(realW, realH, 0, D3DUSAGE_RENDERTARGET, TEXTURE_PIXEL_FORMAT, memPool, texInfo.pTexture, nil)
	else
		m_pD3DDevice.CreateTexture(realW, realH, 0, 0, TEXTURE_PIXEL_FORMAT, memPool, texInfo.pTexture, nil);

	texInfo.wSize    := width;
	texInfo.hSize    := height;
	texInfo.wTexture := realW;
	texInfo.hTexture := realH;
	texInfo.pixelFormat := TEXTURE_PIXEL_FORMAT;

	new(pTexInfo);

	pTexInfo^ := texInfo;

	WriteDebugLog('+ [CreateImage] a D3D image is created.');

	result := integer(pTexInfo);
end;

function TD3DDevice.DestroyImage(hImage: integer): boolean;
var
	pTexInfo: PTextureInfo;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	pTexInfo^.pTexture := nil;
	dispose(pTexInfo);

	WriteDebugLog('+ [DestroyImage] a D3D image is destroyed.');

	result := TRUE;
end;

function TD3DDevice.GetImageInfo(hImage: integer; pWidth: Plongint; pHeight: Plongint): boolean;
var
	pTexInfo: PTextureInfo;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	if assigned(pWidth) then
		pWidth^ := pTexInfo.wSize;

	if assigned(pHeight) then
		pHeight^ := pTexInfo.hSize;
end;

function TD3DDevice.AssignImage(hImage: integer; pImage: pointer; width, height, depth, pitch: integer; pPalette: Plongint): boolean;
type
	PDWordArray = ^TDWordArray;
	TDWordArray = array[0..0] of longint;
var
	pTexInfo: PTextureInfo;
	pSour08: Pbyte;
	pSour32: Plongword;
	pDest32: Plongword;
	pSour16: Pword;
	pDest16: Pword;
	lockRect: TD3DLockedRect;
	i, j: integer;
	pPaletteArr: PDWordArray;
	_R, _G, _B, temp: longword;
	wtemp: word;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	if pTexInfo^.pTexture.LockRect(0, lockRect, nil, 0) = D3D_OK then begin

		case pTexInfo.pixelFormat of
			D3DFMT_A8R8G8B8,
			D3DFMT_X8R8G8B8:
			case depth of
				32:
				for j := 0 to pred(height) do begin
					pSour32 := Plongword(longint(pImage) + j * pitch);
					pDest32 := Plongword(longint(lockRect.Bits) + j * lockRect.Pitch);
					for i := 0 to pred(width) do begin
						pDest32^ := pSour32^;
						inc(pSour32);
						inc(pDest32);
					end;
				end;
				24:
				for j := 0 to pred(height) do begin
					pSour08 := Pbyte(longint(pImage) + j * pitch);
					pDest32 := Plongword(longint(lockRect.Bits) + j * lockRect.Pitch);
					for i := 0 to pred(width) do begin
						_B := pSour08^; inc(pSour08);
						_G := pSour08^; inc(pSour08);
						_R := pSour08^; inc(pSour08);
						pDest32^ := $FF000000 or (_R shl 16) or (_G shl 8) or _B;
						inc(pDest32);
					end;
				end;
				16:
				for j := 0 to pred(height) do begin
					pSour16 := Pword(longint(pImage) + j * pitch);
					pDest32 := Plongword(longint(lockRect.Bits) + j * lockRect.Pitch);
					for i := 0 to pred(width) do begin
						_R := longword(pSour16^ and $F800) shl 8;
						_G := longword(pSour16^ and $07E0) shl 5;
						_B := longword(pSour16^ and $001F) shl 3;
						pDest32^ := $FF000000 or _R or _G or _B;
						inc(pSour16);
						inc(pDest32);
					end;
				end;
				15:
				for j := 0 to pred(height) do begin
					pSour16 := Pword(longint(pImage) + j * pitch);
					pDest32 := Plongword(longint(lockRect.Bits) + j * lockRect.Pitch);
					for i := 0 to pred(width) do begin
						_R := longword(pSour16^ and $7C00) shl 9;
						_G := longword(pSour16^ and $03E0) shl 6;
						_B := longword(pSour16^ and $001F) shl 3;
						pDest32^ := $FF000000 or _R or _G or _B;
						inc(pSour16);
						inc(pDest32);
					end;
				end;
				 8:
				if assigned(pPalette) then begin
					pPaletteArr := PDWordArray(pPalette);
					for j := 0 to pred(height) do begin
						pSour08 := Pbyte(longint(pImage) + j * pitch);
						pDest32 := Plongword(longint(lockRect.Bits) + j * lockRect.Pitch);
						for i := 0 to pred(width) do begin
							pDest32^ := pPaletteArr[pSour08^];
							inc(pSour08);
							inc(pDest32);
						end;
					end;
				end;
			end;
			D3DFMT_X1R5G5B5,
			D3DFMT_A1R5G5B5,
			D3DFMT_R5G6B5:
			case depth of
				32:
				for j := 0 to pred(height) do begin
					pSour32 := Plongword(longint(pImage) + j * pitch);
					pDest16 := Pword(longint(lockRect.Bits) + j * lockRect.Pitch);
					for i := 0 to pred(width) do begin
						_R := (pSour32^ shr 8) and $0000F800;
						_G := (pSour32^ shr 5) and $000007E0;
						_B := (pSour32^ shr 3) and $0000001F;
						pDest16^ := _R or _G or _B;
						inc(pSour32);
						inc(pDest16);
					end;
				end;
				15:
				for j := 0 to pred(height) do begin
					pSour16 := Pword(longint(pImage) + j * pitch);
					pDest16 := Pword(longint(lockRect.Bits) + j * lockRect.Pitch);
					for i := 0 to pred(width) do begin
						wtemp := pSour16^;
						wtemp := ((wtemp shl 1) and $FFC0) or (wtemp and $001F);
						pDest16^ := wtemp;
						inc(pSour16);
						inc(pDest16);
					end;
				end;
				 8:
				if assigned(pPalette) then begin
					pPaletteArr := PDWordArray(pPalette);
					for j := 0 to pred(height) do begin
						pSour08 := Pbyte(longint(pImage) + j * pitch);
						pDest16 := Pword(longint(lockRect.Bits) + j * lockRect.Pitch);
						for i := 0 to pred(width) do begin
							temp := pPaletteArr[pSour08^];
							_R := (temp shr 8) and $0000F800;
							_G := (temp shr 5) and $000007E0;
							_B := (temp shr 3) and $0000001F;
							pDest16^ := _R or _G or _B;
							inc(pSour08);
							inc(pDest16);
						end;
					end;
				end;
			end;
			else begin
				// ...
			end;
		end;

		pTexInfo^.pTexture.UnlockRect(0);
	end;

	result := TRUE;
end;

function TD3DDevice.ClearImage(hImage: integer; color: longword): boolean;
var
	pTexInfo: PTextureInfo;
	pSurface: IDirect3DSurface9;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	pTexInfo.pTexture.GetSurfaceLevel(0, pSurface);

	m_pD3DDevice.ColorFill(pSurface, nil, color);

	pSurface := nil;

	result := TRUE;
end;

function TD3DDevice.SetRenderTarget(hImage: integer): boolean;
const
	c_pSurface: IDirect3DSurface9 = nil;
var
	pTexInfo: PTextureInfo;
begin
	result := FALSE;

	if hImage <> 0 then begin
		pTexInfo := PTextureInfo(hImage);

		if FAILED(pTexInfo.pTexture.GetSurfaceLevel(0, c_pSurface)) then begin
			WriteDebugLog('- IDirect3DTexture9::GetSurfaceLevel() fails.');
		end;

		if FAILED(m_pD3DDevice.SetRenderTarget(0, c_pSurface)) then begin
			WriteDebugLog('- IDirect3DDevice9::SetRenderTarget() fails.');
		end;

		m_pD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
		m_pD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
		m_pD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
		m_pD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
	end
	else begin
		assert(assigned(c_pSurface));
		c_pSurface := nil;
		m_pD3DDevice.SetRenderTarget(0, m_pRenderTarget);
	end;
end;

function TD3DDevice.Clear(color: longword): boolean;
begin
	result := (m_pD3DDevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, color, 1.0, 0) = D3D_OK);
end;

function TD3DDevice.ClearRect(color: longword; x, y, w, h: integer): boolean;
var
	rect: TRect;
begin
	rect.Left   := x;
	rect.Top    := y;
	rect.Right  := x + w;
	rect.Bottom := y + h;

	result := (m_pD3DDevice.Clear(1, @rect, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, color, 1.0, 0) = D3D_OK);
end;

function TD3DDevice.DrawLine(color: longword; x1, y1: integer; x2, y2: integer): boolean;
var
	pVertex: array[0..1] of TVertexBase;
	hr: HRESULT;
begin
	pVertex[0].x     := x1 - 0.5;
	pVertex[0].y     := y1 - 0.5;
	pVertex[0].z     := 0.0;
	pVertex[0].rhw   := 1.0;
	pVertex[0].color := color;
	pVertex[1].x     := x2 - 0.5;
	pVertex[1].y     := y2 - 0.5;
	pVertex[1].z     := 0.0;
	pVertex[1].rhw   := 1.0;
	pVertex[1].color := color;

	t_SetTexture(0, nil);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE);
	hr := m_pD3DDevice.DrawPrimitiveUP(D3DPT_LINELIST, 1, @pVertex, sizeof(TVertexBase));

	result := (hr = 0);
end;

function TD3DDevice.DrawPolygon(color: longword; points: array of TFPoint; n: integer): boolean;
var
	i: integer;
	pVertex: array[0..99] of TVertexBase;
	hr: HRESULT;
begin
	for i := 0 to pred(n) do begin
		pVertex[i].x     := points[i].x;
		pVertex[i].y     := points[i].y;
		pVertex[i].z     := 0.0;
		pVertex[i].rhw   := 1.0;
		pVertex[i].color := color;
	end;

	t_SetTexture(0, nil);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE);
	hr := m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, n-2, @pVertex, sizeof(TVertexBase));

	result := (hr = 0);
end;

function TD3DDevice.FillRect(color: longword; x, y, w, h: integer): boolean;
const
	MAX_VERTEX = 4;
var
	i: integer;
	pVertex: array[0..pred(MAX_VERTEX)] of TVertexBase;
	hr: HRESULT;
begin
	pVertex[0].x := x - 0.5;
	pVertex[0].y := y - 0.5;
	pVertex[1].x := pVertex[0].x + w;
	pVertex[1].y := pVertex[0].y;
	pVertex[2].x := pVertex[0].x + w;
	pVertex[2].y := pVertex[0].y + h;
	pVertex[3].x := pVertex[0].x;
	pVertex[3].y := pVertex[0].y + h;

	for i := 0 to pred(MAX_VERTEX) do begin
		pVertex[i].z     := 0.0;
		pVertex[i].rhw   := 1.0;
		pVertex[i].color := color;
	end;

	t_SetTexture(0, nil);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE);
	hr := m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, @pVertex, sizeof(TVertexBase));

	result := (hr = 0);
end;

function TD3DDevice.BitBlt(xDest, yDest: integer; const hImage: integer; xSour, ySour, wSour, hSour: integer; color: longword): boolean;
const
	MAX_VERTEX = 4;
var
	pTexInfo: PTextureInfo;
	x, y, w, h, tu, tv, tw, th: single;
	vertices: array[0..pred(MAX_VERTEX)] of TVertexTL;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	x  := xDest - 0.5;
	y  := yDest - 0.5;
	w  := wSour;
	h  := hSour;

	// 이러면 안되지만... 샘플이니까
	tu := xSour / pTexInfo.wTexture;
	tv := ySour / pTexInfo.hTexture;
	tw := wSour / pTexInfo.wTexture;
	th := hSour / pTexInfo.hTexture;

	// 최적화 해야 함
	vertices[0].x   := x;
	vertices[0].y   := y;
	vertices[0].z   := 0.0;
	vertices[0].rhw := 1.0;
	vertices[0].tu  := tu;
	vertices[0].tv  := tv;

	vertices[1].x   := x + w;
	vertices[1].y   := y;
	vertices[1].z   := 0.0;
	vertices[1].rhw := 1.0;
	vertices[1].tu  := tu + tw;
	vertices[1].tv  := tv;

	vertices[2].x   := x + w;
	vertices[2].y   := y + h;
	vertices[2].z   := 0.0;
	vertices[2].rhw := 1.0;
	vertices[2].tu  := tu + tw;
	vertices[2].tv  := tv + th;

	vertices[3].x   := x;
	vertices[3].y   := y + h;
	vertices[3].z   := 0.0;
	vertices[3].rhw := 1.0;
	vertices[3].tu  := tu;
	vertices[3].tv  := tv + th;

	vertices[0].color := color;
	vertices[1].color := color;
	vertices[2].color := color;
	vertices[3].color := color;


	t_SetTexture(0, pTexInfo.pTexture);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);
	m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, MAX_VERTEX-2, @vertices, sizeof(TVertexTL));

	result := TRUE;
end;

function TD3DDevice.DrawTexture(hImage: integer; const vertices: array of TVertex): boolean;
var
	pTexInfo: PTextureInfo;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	t_SetTexture(0, pTexInfo.pTexture);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_TEX1);
	m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, high(vertices)-1, @vertices, sizeof(TVertex));

	result := TRUE;
end;

function TD3DDevice.DrawTexture(hImage: integer; const vertices: array of TVertexTL): boolean;
var
	pTexInfo: PTextureInfo;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	t_SetTexture(0, pTexInfo.pTexture);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);
	m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, high(vertices)-1, @vertices, sizeof(TVertexTL));

	result := TRUE;
end;

function TD3DDevice.DrawImage(xDest, yDest: integer; hImage: integer; xSour, ySour, wSour, hSour: integer): boolean;
const
	MAX_VERTEX = 4;
var
	pTexInfo: PTextureInfo;
	x, y, w, h, tu, tv, tw, th: single;
	vertices: array[0..pred(MAX_VERTEX)] of TVertex;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	if (wSour <= 0) or (hSour <= 0) then
		exit;

	pTexInfo := PTextureInfo(hImage);

	if wSour = 0 then
		wSour := pTexInfo.wSize;
	if hSour = 0 then
		hSour := pTexInfo.hSize;

	x := xDest - 0.5;
	y := yDest - 0.5;
	w  := wSour;
	h  := hSour;
	tu := xSour / pTexInfo.wTexture;
	tv := ySour / pTexInfo.hTexture;
	tw := wSour / pTexInfo.wTexture;
	th := hSour / pTexInfo.hTexture;

	if m_imageOrigin = ioCenter then begin
		x := x - w / 2;
		y := y - h / 2;
	end;

	vertices[0].x   := x;
	vertices[0].y   := y;
	vertices[0].z   := 0.0;
	vertices[0].rhw := 1.0;
	vertices[0].tu  := tu;
	vertices[0].tv  := tv;

	vertices[1].x   := x + w;
	vertices[1].y   := y;
	vertices[1].z   := 0.0;
	vertices[1].rhw := 1.0;
	vertices[1].tu  := tu + tw;
	vertices[1].tv  := tv;

	vertices[2].x   := x + w;
	vertices[2].y   := y + h;
	vertices[2].z   := 0.0;
	vertices[2].rhw := 1.0;
	vertices[2].tu  := tu + tw;
	vertices[2].tv  := tv + th;

	vertices[3].x   := x;
	vertices[3].y   := y + h;
	vertices[3].z   := 0.0;
	vertices[3].rhw := 1.0;
	vertices[3].tu  := tu;
	vertices[3].tv  := tv + th;

	t_SetTexture(0, pTexInfo.pTexture);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_TEX1);
	m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, MAX_VERTEX-2, @vertices, sizeof(TVertex));

	result := TRUE;
end;

function TD3DDevice.DrawImageEx(xDest, yDest: integer; hImage: integer; xSour: integer; ySour: integer; wSour: integer; hSour: integer;
								opacity: longword = $FF; lighten: longword = $FFFFFF; angle: integer = 0; scale: integer = 100): boolean;
const
	MAX_VERTEX = 4;
	OBLIQUE: single = 1.0;
var
	pTexInfo: PTextureInfo;
	x, y, w, h, tu, tv, tw, th: single;
	vertices: array[0..pred(MAX_VERTEX)] of TVertexTL;

	angle2: integer;
	radius: single;
begin
	result := FALSE;

	if hImage = 0 then
		exit;

	pTexInfo := PTextureInfo(hImage);

	if wSour = 0 then
		wSour := pTexInfo.wSize;
	if hSour = 0 then
		hSour := pTexInfo.hSize;

	x  := xDest - 0.5;
	y  := yDest - 0.5;
	w  := wSour;
	h  := hSour;
	tu := xSour / pTexInfo.wTexture;
	tv := ySour / pTexInfo.hTexture;
	tw := wSour / pTexInfo.wTexture;
	th := hSour / pTexInfo.hTexture;

//	opacity := (opacity shl 24) or (lighten shl 16) or (lighten shl 8) or (lighten);
	opacity := (opacity shl 24) or lighten;

	case m_imageOrigin of
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
				radius := round(SmSqrt(w * w + h * h));
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

	vertices[0].z     := 0.0;
	vertices[0].rhw   := 1.0;
	vertices[0].color := opacity;
	vertices[0].tu    := tu;
	vertices[0].tv    := tv;

	vertices[1].z     := 0.0;
	vertices[1].rhw   := 1.0;
	vertices[1].color := opacity;
	vertices[1].tu    := tu + tw;
	vertices[1].tv    := tv;

	vertices[2].z     := 0.0;
	vertices[2].rhw   := 1.0;
	vertices[2].color := opacity;
	vertices[2].tu    := tu + tw;
	vertices[2].tv    := tv + th;

	vertices[3].z     := 0.0;
	vertices[3].rhw   := 1.0;
	vertices[3].color := opacity;
	vertices[3].tu    := tu;
	vertices[3].tv    := tv + th;

	t_SetTexture(0, pTexInfo.pTexture);
	m_pD3DDevice.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);
	m_pD3DDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, MAX_VERTEX-2, @vertices, sizeof(TVertexTL));

	result := TRUE;
end;

function TD3DDevice.BeginScene(): boolean;
begin
	result := (m_pD3DDevice.BeginScene() = D3D_OK);
end;

function TD3DDevice.EndScene(): boolean;
begin
	result := (m_pD3DDevice.EndScene() = D3D_OK);
end;

function TD3DDevice.Flush(): boolean;
var
	hr: HRESULT;
begin
	hr := m_pD3DDevice.Present(nil, nil, m_hWindow, nil);

	if FAILED(hr) then begin
		case hr of
			D3DERR_DEVICELOST: // 디바이스를 소실했고, 복구가 불가능 상태
			begin
				if assigned(m_fnLostDevice) then
					m_fnLostDevice();
//				m_pD3DDevice := nil;
//				m_pD3DDevice := m_CreateDevice(m_hWindow, 640, 480, D3DFMT_R5G6B5, FALSE);
			end;
			D3DERR_DEVICENOTRESET: // 디바이스를 소실했지만, 복구가 가능한경우.
			begin
				if assigned(m_fnLostDevice) then
					m_fnLostDevice();
			end;
		end;
	end;

	result := (hr = D3D_OK);
end;

end.

