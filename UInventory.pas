unit UInventory;

interface

uses
	Windows, USmResManager;

const
	ITEM_INVALID     = 0;
	ITEM_NONE        = 0;
	ITEM_TV_REMOCON  = 1;
	ITEM_MY_ROOM_KEY = 2;
	ITEM_UNKNOWN_KEY = 3;
	ITEM_REG_FORM_MT = 4;
	ITEM_REG_FORM    = 5;
	ITEM_GUARANTEE   = 6;
	ITEM_KEY         = 7;
	ITEM_BOOK        = 8;
	ITEM_POSTER      = 9;
	ITEM_MEMO        = 10;
	ITEM_PYRO_BOMB   = 11;
	ITEM_WISKEY      = 12;
	ITEM_AIR_GUN     = 13;
	ITEM_MAX         = ITEM_AIR_GUN;

	ITEM_BOOK_DEAD_WORLD   = 1;
	ITEM_BOOK_LIBRARY_NOTE = 2;
	ITEM_BOOK_ORZ_DIARY    = 3;
	ITEM_BOOK_RENDERZ      = 4;
	ITEM_BOOK_DERIKUS      = 5;
	ITEM_BOOK_ALBIREO      = 6;
	ITEM_BOOK_MAX          = 6;

	ITEM_POSTER_JR       = 1;
	ITEM_POSTER_MAX      = 1;

	ITEM_MEMO_MY_MESSAGE     = 1;
	ITEM_MEMO_AIR_GUN_MANUAL = 2;
	ITEM_MEMO_PROCRETE       = 3;
	ITEM_MEMO_MAX            = 3;

	ITEM_MEMO_START_MESSAGE = $10000001;
	ITEM_MEMO_HELP_MESSAGE = $10000002;

	MAX_NUMOF_ITEM   = 50;
	MAX_COUNTOF_ITEM = 100;

type
	TItem = record
		itemId, aux1, aux2: longword;
	end;

	TInventoryItem = record
		entry: TItem;
		count: integer;
	end;

	TInventory = class
	private
		m_isModified: boolean;
		m_nItem: integer;
		m_itemList: array[0..pred(MAX_NUMOF_ITEM)] of TInventoryItem;

		procedure   m_Pack();
		procedure   m_AssignItem(out items: TInventoryItem; item: byte; aux1: byte = 0; aux2: byte = 0);
		function    m_GetItemName(item: longword; aux1: longword; aux2: longword): widestring;
	public
		constructor Create();
		function    Add(item: byte; aux1: byte = 0; aux2: byte = 0; count: smallint = 1): boolean;
		function    Remove(item: byte; aux1: byte = 0; aux2: byte = 0): boolean;
		function    Search(item: byte; aux1: byte = 0; aux2: byte = 0): boolean; overload;
		function    Search(item: TItem): boolean; overload;
		function    GetItemName(out nameList: array of widestring; out countList: array of TInventoryItem): integer;

		property    IsModified: boolean read m_isModified write m_isModified;

		function    LoadData(var inFile: TSmReadFileStream): boolean; virtual;
		function    SaveData(var outFile: TSmWriteFileStream): boolean; virtual;
	end;

function IsIdenticalItem(const a, b: TItem): boolean;

implementation

function IsIdenticalItem(const a, b: TItem): boolean;
begin
	result := (a.itemId = b.itemId) and (a.aux1 = b.aux1) and (a.aux2 = b.aux2);
end;

type
	VALID_ITEM_SET   = ITEM_NONE..ITEM_MAX;
const
	VALID_ITEM_TABLE = [low(VALID_ITEM_SET)..High(VALID_ITEM_SET)];
	ITEM_NAME_TABLE: array[VALID_ITEM_SET] of widestring =
	(
		'맨손',
		'TV 리모콘',
		'내 방의 열쇠',
		'의문의 열쇠',
		'빈 주민 등록 서류',
		'주민 등록 서류',
		'오르츠의 보증 서류',
		'열쇠',
		'책',//'사후세계 입문서'
		'포스터',
		'메모',
		'파이로전기탄',
		'평범해 보이는 술',
		'에어 건'
	);

type
	VALID_BOOK_SET   = ITEM_NONE+1..ITEM_BOOK_MAX;
const
	VALID_BOOK_TABLE = [low(VALID_BOOK_SET)..High(VALID_BOOK_SET)];
	BOOK_NAME_TABLE: array[VALID_BOOK_SET] of widestring =
	(
		'사후세계 입문서',
		'도서관 일지',
		'오르츠의 일기',
		'Corexis elm Hydios',
		'DERIKUS',
		'Albireo the Timewalker'
	);

type
	VALID_POSTER_SET   = ITEM_NONE+1..ITEM_POSTER_MAX;
const
	VALID_POSTER_TABLE = [low(VALID_POSTER_SET)..High(VALID_POSTER_SET)];
	POSTER_NAME_TABLE: array[VALID_POSTER_SET] of widestring =
	(
		'점프 레볼루션'
	);

type
	VALID_MEMO_SET   = ITEM_NONE+1..ITEM_MEMO_MAX;
const
	VALID_MEMO_TABLE = [low(VALID_MEMO_SET)..High(VALID_MEMO_SET)];
	MEMO_NAME_TABLE: array[VALID_MEMO_SET] of widestring =
	(
		'제작자로부터',
		'에어 건 메뉴얼',
		'PROCRETE'
	);

constructor TInventory.Create();
begin
	m_nItem := 0;
	m_isModified := TRUE;
	ZeroMemory(@m_itemList, sizeof(m_itemList));
end;

procedure TInventory.m_Pack();
var
	i: integer;
	index: integer;
begin
	assert(m_nItem >= 0);
	assert(m_nItem <= MAX_NUMOF_ITEM);

	index := 0;
	while (index < m_nItem) do begin
		if m_itemList[index].count = 0 then begin
			for i := index+1 to m_nItem do begin
				m_itemList[i-1] := m_itemList[i];
			end;
			dec(m_nItem);
		end;
		inc(index);
	end;
end;

procedure TInventory.m_AssignItem(out items: TInventoryItem; item: byte; aux1: byte = 0; aux2: byte = 0);
begin
	items.count        := 0;
	items.entry.itemId := item;
	items.entry.aux1   := aux1;
	items.entry.aux2   := aux2;
end;

function AxisToHex(a1, a2: byte): widestring;
const
	HEX_TABLE: widestring = 'QWERTYUIOPASDFGH';
var
	s: widestring;
begin
	SetLength(s, 4);
	s[1] := HEX_TABLE[a1 div 16 + 1];
	s[2] := HEX_TABLE[a1 mod 16 + 1];
	s[3] := HEX_TABLE[a2 div 16 + 1];
	s[4] := HEX_TABLE[a2 mod 16 + 1];

	result := s;
end;

function TInventory.m_GetItemName(item: longword; aux1: longword; aux2: longword): widestring;
begin
	if item in VALID_ITEM_TABLE then begin
		result := ITEM_NAME_TABLE[item];
		case item of
			ITEM_KEY:
				result := result + '<' + AxisToHex(aux1, aux2) + '>';
			ITEM_BOOK:
			if aux1 in VALID_BOOK_TABLE then begin
				result := result + '<' + BOOK_NAME_TABLE[aux1] + '>';
			end;
			ITEM_POSTER:
			if aux1 in VALID_POSTER_TABLE then begin
				result := result + '<' + POSTER_NAME_TABLE[aux1] + '>';
			end;
			ITEM_MEMO:
			if aux1 in VALID_MEMO_TABLE then begin
				result := result + '<' + MEMO_NAME_TABLE[aux1] + '>';
			end;
		end;
	end
	else begin
		result := 'no name';
	end;
end;

function TInventory.Add(item: byte; aux1: byte = 0; aux2: byte = 0; count: smallint = 1): boolean;
var
	i: integer;
	itemId: TInventoryItem;
begin
	result := FALSE;

	if item = 0 then
		exit;

	m_AssignItem(itemId, item, aux1, aux2);

	for i := 0 to pred(m_nItem) do begin
		if m_itemList[i].count = 0 then
			break;

		if IsIdenticalItem(m_itemList[i].entry, itemId.Entry) then begin
			if m_itemList[i].count < MAX_COUNTOF_ITEM then begin
				inc(m_itemList[i].count, count);
				if m_itemList[i].count <= MAX_COUNTOF_ITEM then begin
					m_isModified := TRUE;
					result := TRUE;
					exit;
				end
				else begin
					// item overflow
					count := m_itemList[i].count - MAX_COUNTOF_ITEM;
					m_itemList[i].count := MAX_COUNTOF_ITEM;
					break;
				end;
			end;
		end;
	end;

	if m_nItem >= MAX_NUMOF_ITEM then
		exit;

	itemId.count := count;
	m_itemList[m_nItem] := itemId;

	inc(m_nItem);

	m_isModified := TRUE;
	result := TRUE;
end;

function TInventory.Remove(item: byte; aux1: byte = 0; aux2: byte = 0): boolean;
var
	i: integer;
	itemId: TInventoryItem;
begin
	result := FALSE;

	if item = 0 then
		exit;

	m_AssignItem(itemId, item, aux1, aux2);

	for i := pred(m_nItem) downto 0 do begin
		if m_itemList[i].count = 0 then
			continue;

		if IsIdenticalItem(m_itemList[i].entry, itemId.Entry) then begin
			assert(m_itemList[i].count > 0);

			dec(m_itemList[i].count);
			if (m_itemList[i].count = 0) then
				m_Pack();

			m_isModified := TRUE;
			result := TRUE;
			exit;
		end;
	end;
end;

function TInventory.Search(item: TItem): boolean;
begin
	result := self.Search(item.itemId, item.aux1, item.aux2);
end;

function TInventory.Search(item: byte; aux1: byte = 0; aux2: byte = 0): boolean;
var
	i: integer;
	itemId: TInventoryItem;
begin
	result := FALSE;

	if item = 0 then
		exit;

	m_AssignItem(itemId, item, aux1, aux2);

	for i := 0 to pred(m_nItem) do begin
		if m_itemList[i].count = 0 then
			break;

		if IsIdenticalItem(m_itemList[i].entry, itemId.Entry) then begin
			assert(m_itemList[i].count > 0);
			result := TRUE;
			exit;
		end;
	end;
end;

function TInventory.GetItemName(out nameList: array of widestring; out countList: array of TInventoryItem): integer;
var
	i: integer;
begin
	result := 0;

	nameList[result] := m_GetItemName(0, 0, 0);
	countList[result].count        := 1;
	countList[result].entry.itemId := 0;
	countList[result].entry.aux1   := 0;
	countList[result].entry.aux2   := 0;

	inc(result);

	for i := 0 to pred(m_nItem) do begin
		if m_itemList[i].count = 0 then
			break;

		if result <= high(nameList) then begin
			with m_itemList[i].entry do
				nameList[result] := m_GetItemName(itemId, aux1, aux2);

			if result <= high(countList) then
				countList[result] := m_itemList[i];

			inc(result);
		end;
	end;
end;

function TInventory.LoadData(var inFile: TSmReadFileStream): boolean;
begin
	inFile.Read(m_isModified, sizeof(m_isModified));
	inFile.Read(m_nItem, sizeof(m_nItem));
	inFile.Read(m_itemList, sizeof(m_itemList[0]) * m_nItem);

	result := TRUE;
end;

function TInventory.SaveData(var outFile: TSmWriteFileStream): boolean;
begin
	outFile.Write(m_isModified, sizeof(m_isModified));
	outFile.Write(m_nItem, sizeof(m_nItem));
	outFile.Write(m_itemList, sizeof(m_itemList[0]) * m_nItem);

	result := TRUE;
end;

end.

