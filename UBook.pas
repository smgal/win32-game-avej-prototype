unit UBook;

interface

uses
	Windows, UResString, UInventory, UType;

type
	TItemBookType = (btBook, btMemo);

	TItemBook = class
	protected
		m_name: string;
		m_type: TItemBookType;
		m_page_begin: integer;
		m_page_end: integer;
		m_page_current: integer;
		m_line_current: integer;

		procedure   m_SetPage(page: integer);
		function    m_GetPage(): integer;
		function    m_GetString(const strSet: TWideStringSet; var s: Pwidestring): boolean;

	public
		constructor Create();
		procedure   Free();

		procedure   Reset();
		function    GetString(var s: Pwidestring): boolean; virtual; abstract;

		property    BookType: TItemBookType read m_type;
		property    Page: integer read m_GetPage write m_SetPage;
		property    MaxPage: integer read m_page_end;
		property    Name: string read m_name;
	end;

	TItemMemo = TItemBook;

function  TItemBookCreator(book: longword): TItemBook;
function  TItemMemoCreator(memo: longword): TItemMemo;

implementation

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBook
////////////////////////////////////////////////////////////////////////////////
constructor TItemBook.Create();
begin
	inherited;
	m_name := '';
	m_type := btBook;
	m_page_begin   := 0;
	m_page_end     := 0;
	m_page_current := 0;
	m_line_current := 0;
end;

procedure   TItemBook.Free();
begin
	inherited;
end;

procedure   TItemBook.m_SetPage(page: integer);
begin
	if page < m_page_begin then
		page := m_page_begin;
	if page > m_page_end then
		page := m_page_end;

	m_page_current := page;
end;

function    TItemBook.m_GetPage(): integer;
begin
	result := m_page_current;
end;

function    TItemBook.m_GetString(const strSet: TWideStringSet; var s: Pwidestring): boolean;
var
	i: integer;
	pwString: Pwidestring;
begin
	result := FALSE;

	if m_line_current > strSet.wstrLen then
		exit;

	pwString := strSet.wstrData;
	for i := 0 to strSet.wstrLen do begin
		if i = m_line_current then begin
			s := pwString;
			result := TRUE;
			break;
		end;
		inc(pwString);
	end;

	inc(m_line_current);
end;

procedure   TItemBook.Reset();
begin
	m_line_current := 0;
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TITItemBookDeadWorldtemBook
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookDeadWorld = class(TItemBook)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookDeadWorld
////////////////////////////////////////////////////////////////////////////////
constructor TItemBookDeadWorld.Create();
begin
	inherited;

	m_name         := '사후 세계 입문서';
	m_type         := btBook;
	m_page_begin   := low(RES_STRING_DEAD_WORLD_PAGE);
	m_page_end     := high(RES_STRING_DEAD_WORLD_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookDeadWorld.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_DEAD_WORLD[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookOrzDiary
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookOrzDiary = class(TItemBook)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookOrzDiary
////////////////////////////////////////////////////////////////////////////////
constructor TItemBookOrzDiary.Create();
begin
	inherited;

	m_name         := '오르츠의 일기';
	m_type         := btBook;
	m_page_begin   := low(RES_STRING_ORZ_DIARY_PAGE);
	m_page_end     := high(RES_STRING_ORZ_DIARY_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookOrzDiary.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_ORZ_DIARY[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookLibraryNote
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookLibraryNote = class(TItemBook)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookLibraryNote
////////////////////////////////////////////////////////////////////////////////
constructor TItemBookLibraryNote.Create();
begin
	inherited;

	m_name         := '도서관 일지';
	m_type         := btMemo;
	m_page_begin   := low(RES_STRING_LIBRARY_NOTE_PAGE);
	m_page_end     := high(RES_STRING_LIBRARY_NOTE_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookLibraryNote.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_LIBRARY_NOTE[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookRenderz
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookRenderz = class(TItemBook)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookRenderz
////////////////////////////////////////////////////////////////////////////////
constructor TItemBookRenderz.Create();
begin
	inherited;

	m_name         := 'Corexis elm Hydios';
	m_type         := btBook;
	m_page_begin   := low(RES_STRING_RENDERZ_PAGE);
	m_page_end     := high(RES_STRING_RENDERZ_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookRenderz.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_RENDERZ[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookDERIKUS
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookDERIKUS = class(TItemBook)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookDERIKUS
////////////////////////////////////////////////////////////////////////////////
constructor TItemBookDERIKUS.Create();
begin
	inherited;

	m_name         := 'DERIKUS';
	m_type         := btBook;
	m_page_begin   := low(RES_STRING_DERIKUS_PAGE);
	m_page_end     := high(RES_STRING_DERIKUS_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookDERIKUS.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_DERIKUS[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookAlbireo
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookAlbireo = class(TItemBook)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookAlbireo
////////////////////////////////////////////////////////////////////////////////
constructor TItemBookAlbireo.Create();
begin
	inherited;

	m_name         := 'Albireo the Timewalker';
	m_type         := btBook;
	m_page_begin   := low(RES_STRING_ALBIREO_PAGE);
	m_page_end     := high(RES_STRING_ALBIREO_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookAlbireo.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_ALBIREO[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemBookCreator
////////////////////////////////////////////////////////////////////////////////
function  TItemBookCreator(book: longword): TItemBook;
var
	itemBook: TItemBook;
begin
	itemBook := nil;

	case book of
		ITEM_BOOK_DEAD_WORLD:
			itemBook := TItemBookDeadWorld.Create();
		ITEM_BOOK_ORZ_DIARY:
			itemBook := TItemBookOrzDiary.Create();
		ITEM_BOOK_LIBRARY_NOTE:
			itemBook := TItemBookLibraryNote.Create();
		ITEM_BOOK_RENDERZ:
			itemBook := TItemBookRenderz.Create();
		ITEM_BOOK_DERIKUS:
			itemBook := TItemBookDERIKUS.Create();
		ITEM_BOOK_ALBIREO:
			itemBook := TItemBookAlbireo.Create();
		else
			ASSERT(FALSE);
	end;

	result := itemBook;
end;





////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookStartMessage
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookStartMessage = class(TItemMemo)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

constructor TItemBookStartMessage.Create();
begin
	inherited;

	m_name         := '';
	m_type         := btMemo;
	m_page_begin   := low(RES_STRING_START_MESSAGE_PAGE);
	m_page_end     := high(RES_STRING_START_MESSAGE_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookStartMessage.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_START_MESSAGE[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookHelpMessage
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookHelpMessage = class(TItemMemo)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

constructor TItemBookHelpMessage.Create();
begin
	inherited;

	m_name         := '';
	m_type         := btMemo;
	m_page_begin   := low(RES_STRING_HELP_MESSAGE_PAGE);
	m_page_end     := high(RES_STRING_HELP_MESSAGE_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookHelpMessage.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_HELP_MESSAGE[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookMyMessage
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookMyMessage = class(TItemMemo)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

constructor TItemBookMyMessage.Create();
begin
	inherited;

	m_name         := '';
	m_type         := btMemo;
	m_page_begin   := low(RES_STRING_MY_MESSAGE_PAGE);
	m_page_end     := high(RES_STRING_MY_MESSAGE_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookMyMessage.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_MY_MESSAGE[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookAirGunManual
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookAirGunManual = class(TItemMemo)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

constructor TItemBookAirGunManual.Create();
begin
	inherited;

	m_name         := '';
	m_type         := btMemo;
	m_page_begin   := low(RES_STRING_AIR_GUN_MANUAL_PAGE);
	m_page_end     := high(RES_STRING_AIR_GUN_MANUAL_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookAirGunManual.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_AIR_GUN_MANUAL[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Interface of TItemBookPROCRETE
////////////////////////////////////////////////////////////////////////////////
type
	TItemBookPROCRETE = class(TItemMemo)
	public
		constructor Create();
		function    GetString(var s: Pwidestring): boolean; override;
	end;

constructor TItemBookPROCRETE.Create();
begin
	inherited;

	m_name         := '';
	m_type         := btMemo;
	m_page_begin   := low(RES_STRING_PROCRETE_PAGE);
	m_page_end     := high(RES_STRING_PROCRETE_PAGE);
	m_page_current := m_page_begin;
end;

function    TItemBookPROCRETE.GetString(var s: Pwidestring): boolean;
begin
	result := m_GetString(RES_STRING_PROCRETE[m_page_current], s);
end;

////////////////////////////////////////////////////////////////////////////////
// Implementation of TItemMemoCreator
////////////////////////////////////////////////////////////////////////////////
function  TItemMemoCreator(memo: longword): TItemMemo;
var
	itemMemo: TItemMemo;
begin
	itemMemo := nil;

	case memo of
		ITEM_MEMO_START_MESSAGE:
			itemMemo := TItemBookStartMessage.Create();
		ITEM_MEMO_HELP_MESSAGE:
			itemMemo := TItemBookHelpMessage.Create();
		ITEM_MEMO_MY_MESSAGE:
			itemMemo := TItemBookMyMessage.Create();
		ITEM_MEMO_AIR_GUN_MANUAL:
			itemMemo := TItemBookAirGunManual.Create();
		ITEM_MEMO_PROCRETE:
			itemMemo := TItemBookPROCRETE.Create();
		else
			ASSERT(FALSE);
	end;

	result := itemMemo;
end;

end.
