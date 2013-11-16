unit UTextArea;

interface

uses
	Windows,
	USmD3D9, USmHangul, USmUtil,
	UConfig;

type
	TSmString = widestring;

	TExtent = record
		w, h: integer;
	end;

	TArea = record
		x, y, w, h: integer;
	end;

	TTextArea = class
	public
		constructor Create(x, y, w, h : integer; const attachedCanvas : integer);
		procedure   Free();

	private
		m_attached  : integer;
		m_offset    : TPoint;
		m_extent    : TExtent;
		m_cursor    : TPoint;
		m_display   : integer;
		m_textColor : longword;
		m_fillColor : longword;
		m_isScroll  : boolean;
		m_reservedFill  : boolean;
		m_reservedClear : boolean;
		m_isReversed    : boolean;

		procedure t_processReserved();
		function  m_isValid(): boolean;
		procedure m_write(s : TSmString; useAutoFit: boolean);
		procedure m_writeln(s : TSmString);
		procedure m_scrollUp();

	protected
		procedure t_SetTextColor(textColor: TTextColor);
		procedure t_BeginText();
		procedure t_EndText();

	public
		function  IsValid(): boolean;
		procedure Write(s : TSmString; textColor: TTextColor = tcNormal);
		procedure WriteLn(s : TSmString = ''; textColor: TTextColor = tcNormal); virtual;
		procedure RandomWriteLn(strList : array of TSmString; strAux: TSmString = ''; textColor: TTextColor = tcNormal);
		procedure DrawText(x, y: integer; s : TSmString; color: longword);
		procedure DrawImage(x, y: integer; image: integer; xSour, ySour, wSour, hSour: integer);
		procedure Clear();
		procedure ReservedClear();
		procedure Refresh();
		procedure Flush(); virtual;

		property  TextColor: longword read m_textColor  write m_textColor;
		property  IsReversed: boolean read m_isReversed write m_isReversed;
		property  LocateX: integer    read m_cursor.x   write m_cursor.x;
		property  LocateY: integer    read m_cursor.y   write m_cursor.y;
	end;

	TInputArea = class(TTextArea)
	private
		m_fCaretView : boolean;
		m_completeString : TSmString;
		m_incompleteString : TSmString;
	public
		constructor Create(x, y, w, h : integer; const attachedCanvas : integer);
		procedure   Free();

		procedure InputQuery(complete: TSmString; incomplete: TSmString = '');
		procedure WriteLn(s: TSmString = ''; textColor: TTextColor = tcNormal); override;
		procedure Flush(); override;

		procedure ToggleCaret();
		procedure ShowCaret();
		procedure HideCaret();
	end;

implementation

uses
	UGameMain;

const
	FONT_XSIZE   = 8;
	FONT_YSIZE   = 16;
	INPUT_PROMPT = '> ';

function CheckPair(const s : widestring; ch1, ch2: wchar) : boolean;
var
	i: integer;
	count: integer;
begin
	count := 0;
	for i := 1 to Length(s) do begin
		if s[i] = ch1 then
			inc(count);
		if s[i] = ch2 then
			dec(count);
	end;

	result := (count = 0);
end;

constructor TTextArea.Create(x, y, w, h : integer; const attachedCanvas : integer);
begin
	w := ((w+FONT_XSIZE-1) div FONT_XSIZE) * FONT_XSIZE;
	h := ((h+FONT_YSIZE-1) div FONT_YSIZE) * FONT_YSIZE;

	m_attached  := attachedCanvas;
	m_offset.x  := x;
	m_offset.y  := y;
	m_extent.w  := w;
	m_extent.h  := h;
	m_cursor.x  := 0;
	m_cursor.y  := 2;
	m_textColor := g_textColor[tcNormal];
	m_fillColor := g_textBgColor;
	m_isScroll  := FALSE;
	m_reservedFill  := FALSE;
	m_reservedClear := FALSE;
	m_isReversed    := FALSE;

	m_display   := g_d3Device.CreateImage(w, h, mpVideo);

	self.Clear();
end;

procedure TTextArea.Free();
begin
	if not m_isValid() then
		exit;

	g_d3Device.DestroyImage(m_display);
end;

procedure DxBitBlt(xDest, yDest: integer; width, height: integer; xSour, ySour: integer; color: longword); stdcall;
begin
	g_d3Device.BitBlt(xDest, yDest, g_fontImage, xSour, ySour, width, height, color);
end;

procedure TTextArea.t_processReserved();
begin
	if m_reservedFill then begin
		g_d3Device.FillRect(m_fillColor, 0, m_cursor.y * FONT_YSIZE, m_extent.w, FONT_YSIZE);
		m_reservedFill := FALSE;
	end;

	if m_reservedClear then begin
		g_d3Device.Clear(m_fillColor);
		m_cursor.y := 0;
		m_isScroll := FALSE;
		m_reservedClear := FALSE;
	end;
end;

function  TTextArea.m_isValid(): boolean;
begin
	result := (m_display <> 0);
end;

procedure TTextArea.m_write(s : TSmString; useAutoFit: boolean);
begin
	t_processReserved();

	if useAutoFit then
		SmDrawTextFit(m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, s, m_textColor, g_textColor[tcMonolog], DxBitBlt, m_extent.w - m_cursor.x * FONT_XSIZE)
	else
		SmDrawText(m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, s, m_textColor, g_textColor[tcMonolog], DxBitBlt);

	inc(m_cursor.x, RealLength(s));
end;

procedure TTextArea.m_writeln(s : TSmString);
var
	auxStr   : TSmString;
	ixStr    : integer;
	ixAdd    : integer;
	oldColor : longword;
begin
	t_processReserved();

	if m_isReversed then begin
		oldColor    := m_textColor;
		m_textColor := $FF000000;
		g_d3Device.FillRect(oldColor, m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, RealLength(s) * FONT_XSIZE, FONT_YSIZE);
	end;

	while RealLength(s) > 0 do begin
		if (m_cursor.x + RealLength(s)) * FONT_XSIZE <= m_extent.w then begin
			auxStr := s;
			s := '';
		end
		else begin
			auxStr := '';
			ixStr  := 0;
			ixAdd  := 0;
			//-- begin 2005.04.14
			// [OLD] while (TRUE) do begin
			//--
			while (Length(s) > ixStr) do begin
			//-- end
				inc(ixStr);

				if ord(s[ixStr]) >= $100 then begin
					if (m_cursor.x + (ixStr+1+ixAdd)) * FONT_XSIZE > m_extent.w then
						break;
					inc(ixAdd);
				end
				else begin
					if (m_cursor.x + (ixStr+0)) * FONT_XSIZE > m_extent.w then
						break;
				end;
			end;

			auxStr := Copy(s, 1, ixStr-1);
			s := Copy(s, ixStr, 60000);
		end;

		// 앞쪽 공백 제거
		if m_cursor.x = 0 then
		while (auxStr <> '') and (auxStr[1] = ' ') do begin
			auxStr := Copy(auxStr, 2, RealLength(auxStr)-1);
		end;

		if s <> '' then begin
			// 뒤쪽 공백 제거
			while (auxStr <> '') and (auxStr[Length(auxStr)] = ' ') do begin
				auxStr := Copy(auxStr, 1, Length(auxStr)-1);
			end;

			m_write(auxStr, TRUE);

			// 키워드 문자에서 개행되었을 때
			if not CheckPair(auxStr, KEYWORD_BEGIN, KEYWORD_END) then
				s := KEYWORD_BEGIN + s;
		end
		else begin
			m_write(auxStr, FALSE);
		end;

		if s <>'' then
			m_scrollUp;
	end;

	if m_isReversed then begin
		m_textColor := oldColor;
	end;
end;

procedure TTextArea.m_scrollUp();
begin
	m_cursor.x := 0;

	inc(m_cursor.y);
	if (m_cursor.y * FONT_YSIZE >= m_extent.h) then begin
		m_cursor.y := m_cursor.y - m_extent.h div FONT_YSIZE;
		m_isScroll := TRUE;
	end;

	m_reservedFill := TRUE;
end;

procedure TTextArea.t_SetTextColor(textColor: TTextColor);
begin
	m_textColor := g_textColor[textColor];
end;

procedure TTextArea.t_BeginText();
begin
	g_d3Device.SetRenderTarget(m_display);
end;

procedure TTextArea.t_EndText();
begin
	g_d3Device.SetRenderTarget(0);
end;

function  TTextArea.IsValid(): boolean;
begin
	result := m_isValid();
end;

procedure TTextArea.Write(s : TSmString; textColor: TTextColor = tcNormal);
begin
	if not m_isValid() then
		exit;

	t_SetTextColor(textColor);

	t_BeginText();
	begin
		m_writeln(s);
	end;
	t_EndText();
end;

procedure TTextArea.DrawText(x, y: integer; s : TSmString; color: longword);
begin
	if not m_isValid() then
		exit;

	t_BeginText();
	SmDrawText(x, y, s, color, $FFFF4060, DxBitBlt);
	t_EndText();
end;

procedure TTextArea.DrawImage(x, y: integer; image: integer; xSour, ySour, wSour, hSour: integer);
begin
	if not m_isValid() then
		exit;

	t_BeginText();
	begin
		g_d3Device.DrawImage(x, y, image, xSour, ySour, wSour, hSour);
	end;
	t_EndText();
end;

procedure TTextArea.RandomWriteLn(strList : array of TSmString; strAux: TSmString = ''; textColor: TTextColor = tcNormal);
var
	index: integer;
	ixInsert: integer;
	s: TSmString;
begin
	if not m_isValid() then
		exit;

	index := Random(high(strList) + 1);

	t_SetTextColor(textColor);

	t_BeginText();
	begin
		if strAux = '' then begin
			m_writeln(strList[index]);
		end
		else begin
			ixInsert := pos('%s', strList[index]);
			assert(ixInsert > 0);

			s := strList[index];
			Delete(s, ixInsert, 2);
			Insert(strAux, s, ixInsert);

			m_writeln(s);
		end;
		m_scrollUp;
	end;
	t_EndText();
end;

procedure TTextArea.WriteLn(s : TSmString = ''; textColor: TTextColor = tcNormal);
begin
	if not m_isValid() then
		exit;

	t_SetTextColor(textColor);

	t_BeginText();
	begin
		if s <> '' then
			m_writeln(s)
		else
			t_processReserved();

		m_scrollUp;
	end;
	t_EndText();
end;

procedure TTextArea.ReservedClear();
begin
	m_reservedClear := TRUE;
	m_reservedFill  := FALSE;
end;

procedure TTextArea.Refresh();
begin
	m_textColor := g_textColor[tcNormal];
	m_fillColor := g_textBgColor;

	self.Clear();
end;

procedure TTextArea.Clear();
begin
	if not m_isValid() then
		exit;

	t_BeginText();
	begin
		m_fillColor := g_textBgColor;
		g_d3Device.Clear(m_fillColor);
		m_cursor.y := 0;
		m_isScroll := FALSE;
	end;
	t_EndText();
end;

procedure TTextArea.Flush();
begin
	if not m_isValid() then
		exit;

	if m_isScroll then begin
		g_d3Device.DrawImage(m_offset.x, m_offset.y, m_display,
							 0, m_cursor.y * FONT_YSIZE, m_extent.w, (m_extent.h - m_cursor.y * FONT_YSIZE));
		g_d3Device.DrawImage(m_offset.x, m_offset.y + (m_extent.h - m_cursor.y * FONT_YSIZE), m_display,
							 0, 0, m_extent.w, m_cursor.y * FONT_YSIZE);
	end
	else begin
		g_d3Device.DrawImage(m_offset.x, m_offset.y, m_display, 0, 0, m_extent.w, m_extent.h);
	end;
end;

///////////////////////////////////

constructor TInputArea.Create(x, y, w, h : integer; const attachedCanvas : integer);
begin
	inherited;

	m_fCaretView       := FALSE;
	m_completeString   := '';
	m_incompleteString := '';

	self.Write(INPUT_PROMPT);
end;

procedure TInputArea.Free();
begin
	inherited;
end;

procedure TInputArea.InputQuery(complete: TSmString; incomplete: TSmString = '');
begin
	m_completeString   := complete;
	m_incompleteString := incomplete;
end;

procedure TInputArea.WriteLn(s: TSmString = ''; textColor: TTextColor = tcNormal);
begin
	if not m_isValid() then
		exit;

	t_BeginText();
	begin
		g_d3Device.FillRect(m_fillColor, m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_extent.w, FONT_YSIZE);

		if m_completeString <> '' then
			SmDrawText(m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_completeString, m_textColor, g_textColor[tcMonolog], DxBitBlt);

		if m_incompleteString <> '' then begin
			SmDrawText((m_cursor.x+RealLength(m_completeString)) * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_incompleteString, m_textColor, g_textColor[tcMonolog], DxBitBlt);
		end
		else begin
		end;
	end;
	t_EndText();

	HideCaret();

	inherited WriteLn(s);

	if s = '' then begin
		m_completeString := '';
		m_incompleteString := '';
	end;

	self.Write(INPUT_PROMPT);
end;

procedure TInputArea.Flush();
var
	yCursor: integer;
begin
	if not m_isValid() then
		exit;

	t_BeginText();
	begin
		g_d3Device.FillRect(m_fillColor, m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_extent.w, FONT_YSIZE);

		if m_completeString <> '' then
			SmDrawText(m_cursor.x * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_completeString, m_textColor, g_textColor[tcMonolog], DxBitBlt);

		if m_fCaretView then begin
			if m_incompleteString <> '' then begin
				g_d3Device.FillRect(m_textColor, (m_cursor.x+RealLength(m_completeString)) * FONT_XSIZE, m_cursor.y * FONT_YSIZE, RealLength(m_incompleteString) * FONT_XSIZE, FONT_YSIZE);
				SmDrawText((m_cursor.x+RealLength(m_completeString)) * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_incompleteString, $FF000000, g_textColor[tcMonolog], DxBitBlt);
			end
			else begin
				g_d3Device.FillRect(m_textColor, (m_cursor.x+RealLength(m_completeString)) * FONT_XSIZE, m_cursor.y * FONT_YSIZE, FONT_XSIZE, FONT_YSIZE);
			end;

		end
		else begin
			if m_incompleteString <> '' then
				SmDrawText((m_cursor.x+RealLength(m_completeString)) * FONT_XSIZE, m_cursor.y * FONT_YSIZE, m_incompleteString, m_textColor, g_textColor[tcMonolog], DxBitBlt);
		end;
	end;
	t_EndText();

	yCursor := m_cursor.y + 1;

	if yCursor * FONT_YSIZE >= m_extent.h then
		yCursor := 0;

	g_d3Device.DrawImage(m_offset.x, m_offset.y, m_display, 0, yCursor * FONT_YSIZE, m_extent.w, (m_extent.h - yCursor * FONT_YSIZE));
	g_d3Device.DrawImage(m_offset.x, m_offset.y + (m_extent.h - yCursor * FONT_YSIZE), m_display, 0, 0, m_extent.w, yCursor * FONT_YSIZE);
end;

procedure TInputArea.ToggleCaret();
begin
	if m_fCaretView then
		HideCaret
	else
		ShowCaret;
end;

procedure TInputArea.ShowCaret();
begin
	m_fCaretView := TRUE;
end;

procedure TInputArea.HideCaret();
begin
	m_fCaretView := FALSE;
end;

end.

