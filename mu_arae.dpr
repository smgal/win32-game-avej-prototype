program mu_arae;
// 테레비를 볼 때는 방을 밝게하고 떨어져서 보세요
uses
	Windows,
	Messages,
	USmUtil,
	UGameMain,
	UConfig;

const
	CLASS_NAME : PChar = '__MU_ARAE__';
	TITLE_NAME : PChar = 'AVEJ 1부 (2005/02/13 버전)';

var
	hWindow      : HWnd = 0;
	WaitingEvent : THandle;

{$R netoneto.res}

function ImmAssociateContext(hWnd: HWND; hImc: longint): longint; stdcall; external 'imm32.dll' name 'ImmAssociateContext';

function WindowProc(hWindow : HWnd; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT; stdcall;
begin
	WindowProc := 0;

	case uMsg of
		WM_CREATE :
		begin
		end;
		WM_SHOWWINDOW :
		begin
		end;
		WM_DESTROY :
		begin
			PostQuitMessage(0);
			Exit;
		end;
		WM_CHAR :
		begin
			g_GameMain.ProcKeyDown(LoWord(wParam));
		end;
		WM_KEYDOWN :
		begin
			if wParam = VK_HANGUL then
				g_GameMain.ProcKeyDown(LoWord(wParam));
		end;
		WM_KEYUP :
		begin
			if wParam <> VK_HANGUL then
				g_GameMain.ProcKeyUp(LoWord(wParam));

		end;
		WM_GAME_COMMAND :
		begin
			if wParam = GAME_COMMAND_EXIT_GAME then begin
				if USE_FULLSCREEN then begin
					MoveWindow(hWindow, 10000, 0, 0, 0, TRUE);
					ShowCursor(TRUE);
				end;

				DestroyWindow(hWindow);
				//PostMessage(m_hWindow, WM_CLOSE, 0, 0);
			end;
			g_GameMain.ProcGameCommand(wParam, lParam);
		end;
		WM_ACTIVATEAPP:
		begin
			g_isActivate := (wParam > 0);
		end;
		WM_IDLE :
		begin
			GetCursorPos(g_gameCursor);
			if not USE_FULLSCREEN then begin
				ScreenToClient(hWindow, g_gameCursor);
			end;

			WaitForSingleObject(WaitingEvent, 10);

			g_GameMain.Run();
		end;
	end;

	WindowProc := DefWindowProc(hWindow, uMsg, wParam, lParam);
end;

function MyRegisterClass(hInstance : HINST) : ATOM;
var
	WinClass : TWNDCLASS;
begin
	FillChar(WinClass, sizeof(WinClass), 0);

	WinClass.style         := CS_HREDRAW or CS_VREDRAW;
	WinClass.lpfnWndProc   := @WindowProc;
	WinClass.cbClsExtra    := 0;
	WinClass.cbWndExtra    := 0;
	WinClass.hInstance     := hInstance;
	WinClass.hIcon         := LoadIcon(hInstance, 'smgal');
	WinClass.hCursor       := LoadCursor(0, IDC_ARROW);
	WinClass.hbrBackground := GetStockObject(LTGRAY_BRUSH);
	WinClass.lpszMenuName  := CLASS_NAME;
	WinClass.lpszClassName := CLASS_NAME;

	Result := RegisterClass(WinClass);
end;

function  WinMain : Integer;
var
	uMsg       : TMsg;
	WindowRect : TRect;
	ClientRect : TRect;
begin

	if HPrevInst = 0 then begin
		if MyRegisterClass(HInstance) = 0 then
			Halt;
	end;

	if USE_FULLSCREEN then begin
		hWindow := CreateWindow(CLASS_NAME, TITLE_NAME,
								 WS_POPUP,
								 0, 0,
								 SCREEN_WIDTH,
								 SCREEN_HEIGHT,
								 0, 0, hInstance, nil);
//		ShowCursor(FALSE);
	end
	else begin
		hWindow := CreateWindow(CLASS_NAME, TITLE_NAME,
								 WS_OVERLAPPEDWINDOW,
								 Integer(CW_USEDEFAULT), Integer(CW_USEDEFAULT),
								 SCREEN_WIDTH,
								 SCREEN_HEIGHT,
								 0, 0, hInstance, nil);

		GetWindowRect(hWindow, WindowRect);
		Dec(WindowRect.Right, WindowRect.Left);
		Dec(WindowRect.Bottom, WindowRect.Top);

		GetClientRect(hWindow, ClientRect);

		MoveWindow(hWindow, WindowRect.Left, WindowRect.Top,
					SCREEN_WIDTH + WindowRect.Right - ClientRect.Right, SCREEN_HEIGHT + WindowRect.Bottom - ClientRect.Bottom, FALSE);
	end;

	if hWindow = 0 then
		Halt;

	ShowWindow(hWindow, CmdShow);
	UpdateWindow(hWindow);

	ImmAssociateContext(hWindow, 0);

	g_GameMain := TGameMain.Create();
	g_GameMain.Init(hWindow, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_DEPTH, USE_FULLSCREEN);

	while (TRUE) do begin
		if PeekMessage(uMsg, 0, 0, 0, PM_NOREMOVE) then begin
			if not GetMessage(uMsg, 0, 0, 0) then
				break;
			TranslateMessage(uMsg);
			DispatchMessage(uMsg);
		end
		else begin
			if g_isActivate then begin
				PostMessage(hWindow, WM_IDLE, 0, 0);
			end;
			WaitMessage();
		end;
	end;

	g_GameMain.Done();
	g_GameMain.Free();

	DestroyWindow(hWindow);
	UnregisterClass(CLASS_NAME, HInstance);

	Result := uMsg.wParam;
end;

var
	ReturnValue  : Integer = 0;
begin
	WaitingEvent := CreateEvent(nil, TRUE, FALSE, CLASS_NAME);

	try
		ReturnValue := WinMain;
	except
		on e: EAvejD3D do begin
			if assigned(g_GameMain) then begin
				if assigned(g_GameMain) then begin
					g_GameMain.Done();
					g_GameMain.Free();
				end;
				{
				if (hWindow <> 0) then begin
					DestroyWindow(hWindow);
					UnregisterClass(CLASS_NAME, HInstance);
				end;
				}
			end;
			MessageBox(0, PChar(e.Message), 'AVEJ error', MB_OK or MB_SYSTEMMODAL);
		end;
	end;

	CloseHandle(WaitingEvent);

	Halt(ReturnValue);
end.

