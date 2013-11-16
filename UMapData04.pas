unit UMapData04;

interface

uses
	USmUtil,
	UInventory, UType, UConfig;

procedure InitProc04(const sender: TObject; prevMapId: integer; prevPos: TPosition);
procedure TalkData04(personalId : integer; const question : widestring; const fullInput : wideString = '');
function  EventData04(eventType: TEventType; eventId : integer): boolean;
function  Char2MapProc04(cTemp: char): longword;

const
	MAP_DATA_04W: array[0..70] of widestring =
	(
		'▦▦▦▦▦▦▦▦▦▦▦∴∴▦▦▦▦▦▦▦',
		'▦◇◇▒▒▒▒♧♧▒▦∴∴▦◇◇◇▦↘▦',
		'▦∏▒▒▒▒▒▒▒▒▦▦▦▦　　　▦！▦', //↖↗
		'▦▒▒▒▒▒▒▒▒▒＊　　＃　　　　　▦', //↙↘♠
		'▦♀▒▒▒▒▒▒▒▒▦▦▦▦　　　　∏▦', // ▩▦▤▥ ♣
		'▦▒▒▒▒▒Œ◆◆◆▦∴∴▦♧　　　∂▦', // ⅹⅩ ∂￡￥
		'▦▦▦▦▦▦▦▦▦▦▦♣∴▦▦▦Ｎ▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦',
		'▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▦▒＃　　　　　　　↘▦　　　　↘▦▦',
		'▦⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▦▒▦▦▦▦▦▦▦▦▦▦　　　　　▦▦',
		'▦⊙⊙⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▦▒＊▒◆▦▒▒▒▒▒＃　　　　　▥▦',
		'▦▦▦▦▦▦▦▦▦▦▦▦□▦▦▦▦▦▦▦▦▦Ｎ▦▦▦□▦▦▦▦▦▦▣▣▣▦▦▦□▦▦Ｎ▦▦▦＊▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▥▦▦▦▦▦▦▦▦',
		'▦◇◇пⅡ　　　▥♧◇▒▒▒∂▒▦　　♧♧　　　　　　　Ⅱ∂　◆▦▣▣▣▦♧♧▒▒▒▒▒Ⅱ◆▒▦◇◇◇◇◇◇◇◇◇◇◇◇◆▥◆　　　　　　　▦',
		'▦◇　　　　　　▥▒▒▒▒〓〓▒▦　　　　　　　　　　　Ⅱ∂　◆▦▣▣▣▦▒▒▒▒▒▒▒Ⅱ▒▒▦▒▒▒▒▒▒▒▒▒▒▒◇▒▤▤▤▤▤▤▤▤！▦',
		'▦◇　　　￥　　！▒▒▒▒▒▒▒▦　　　　　　　　　　　Ⅱ∂　◆▦▣▣▣Ｎ▒▒▒▒▒▒▒Ⅱ▒▒▦▒▒▤▤▤▤▤▤▤▤▤▤▤▤♧♧　　　　　　▦',
		'▦◇　　〓〔〕　▥▒▒▒▒▒▒▒□　　　　　　　　　　　Ⅱ∂　◆▦▣▣▣▦▒▒▒▒▒▒▒▒▒▒▦　　　　　　　　　　　　　▦　　　　Ⅱ　　　▦',
		'▦▥▥▥▥▥▥▥▥▥▥▥▒▒▒▒▦　　　〓〔‡〕〔‡〕　　　　　□▣▣▣□▒▒▒▒▒▒▒▒▒▒▦　　　　　　　　　　　　♧▦　　　　Ⅱ∂　◆▦',
		'▦↖　　　　　Ⅱ▥↖▒▒▒▒▒▒＊　　　　　п　　п　　　　♧♧▦▣⊙▣▦▒▒▒♧♧▒▒▒▒▒▦♧♧　　　　　　　　　　∂▦　　　　Ⅱ∂　◆▦',
		'▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▣▣▣▦▦▦▦▦□□□▦▦▦▦▦▦□▦▦▦Ｎ▦▦▦□▦▦▦▦Ｎ▦▦▦▦▦▦▦',
		'▦　　　　　　　　　　　　　　　▦ⅩΘΘΘ▦▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣♧▣▣▣▣▣▣▣▣▣▣▣▦',
		'▦　　　　　　　　　　　　　　　▦Θ▲ΘΘ▦▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣♧▣▣▣▣⊙▣▣▣▣▣▣▦',
		'▦　　　　　　　　　　　　　　　▦ⅩΘΘⅩ▦⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣♧▣▣▣▣▣▣▣▣▣▣▣▦',
		'▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▣▣▣▦',
		'▦　　　　　　　　　　　　　　　　　　　　▦　　　　　　　　　　　　　　　　　　　　　　▦　　Ⅱ　　　　　　　　　　　　◆▦▣⊙▣▦',
		'▦　　　　　　　　　　　　　　　　　　　　▦　　　　　　　　　　　　　　　　　　　　　　▦　　Ⅱ　　　　　　　　　　　　◆▦▣▣▣▦',
		'▦　　　　　　　　　　　　　　　　　　　　▦　　　　　　　　　　　　　　　　　　　　　　▦　　　　　　　　　　　　　　　　▦▣▣▣▦',
		'▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦　　　　　　　　　　　　　　　　　　　　　　▦　　　　♧▤▤＃＃▤▤♧　　　　▦▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　　　　　　　　▦　　　　▤▤♧▒▒♧▤▤　　　　▦▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　　　　　　　　▦　　　　▤♧▒▒▒▒♧▤　　　　▦▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　　　　　　　　▦◇◇◇◇▤▒▒▒▒▒▒▤　　　　▦▣▣⊙▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦ＮＮ▦▦▦▦▦▦▦▦▣▣▣▦▦▦▦▦▦▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴♠∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴♠∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▦▦▦▦▦▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▦▦▦▦▦▦♣∴∴⊙▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴♠∴∴∴∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣▣▣▦',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒∴∴∴∴▣▣▣▦',
		'▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣∴∴∴▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒∴∴∴∴▣▣▣▦',
		'▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣▣▣▦',
		'▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣⊙▣▦',
		'▦▦▦▦▦＃▦▦▦▦▦▦▦▦▦＃▦▦▦▦▦▦▦▦▦＃▦▦▦▦▦▦▣▣▣∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴♠∴▣▣▣▦',
		'▦　　　　　　　　　▦　　　　　　　　▦　　　　　　　　　　　▦▣▣▣∴∴▦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▦∴∴∴▣▣▣▦',
		'▦　　　　　　　　　▦　　　　　　　　▦　　　　　　　　　　　□▣▣⊙∴∴▦▦▦▦▦▦▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▦▦▦▦▦▦∴∴∴▣▣▣▦',
		'▦　　　　　　　　　▦　　　　　　　　▦　　　　　　　　　　　▦▣▣▣∴∴∴∴∴∴∴∴∴∴♠∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▦',
		'▦　　　　　　　　　▦　　　　　　　　▦　　　　　　　　　　　＃▣▣▣∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▦▦▦',
		'▦　　　　　　　　　▦　　　　　　　　▦　　　　　　　　　　　▦▣▣▣∴∴∴∴∴∴♣∴∴∴∴∴∴∴∴♠∴∴∴∴∴∴∴♣∴∴∴∴∴∴∴∴∴▣▣▣▣▣▣',
		'▦　　　　　　　　　▦　　　　　　　　▦　　　　　　　　　　　▦▣▣▣∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣▣▣▣',
		'▦▦▦▦▦＊▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▣▣▣∴∴∴∴∴∴∴∴∴∴∴♣∴∴∴∴∴♣∴∴∴∴∴∴∴♠∴∴∴∴∴♣∴▣▣▣▣▣▣',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　▦　　　　　　　　　▦▣▣▣∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴∴▣▣▣∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　＊　　　　　　　　　＃▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　▦　　　　　　　　　▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴＊　　　　　▦▦▦▦▦▦▦▦▦▦▦▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▦▦▦＊▦▦　＊　　　　　　　▦▣▣▦▦▦▦▦＃▦▦▦▦▦▦▦▦＃▦▦▦▦▦▦▦▦▦▦＃▦▦▦▦▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　▦　　　　　　　▦▣▣▦　　　　　　　　▦　　　　　　　　　▦　　　　　　　　　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　▦　　　　　　　▦▣▣▦　　　　　　　　▦　　　　　　　　　▦　　　　　　　　　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▣▣▦　　　　　　　　▦　　　　　　　　　▦　　　　　　　　　　□∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣□　　　　　　　　▦　　　　　　　　　▦　　　　　　　　　　□∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦⊙▣▦　　　　　　　　▦　　　　　　　　　▦　　　　　　　　　　□∴∴∴∴♠∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣▦　　　　　　　　▦　　　　　　　　　▦▦▦！▦▦▦　　　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣▦　　　　　　　　▦▦▦！▦▦▦▦▦▦▦　　　　　▦▦▦▦▦▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴＊　　　　　　　　　　　　　　　＊▣▣▦　　　　　　　　▦　　　　　　▦　　▦　　　　　！　　　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣▦　　　　　　　　▦　　　　　　＊　　▦　　　　　▦　　　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣▦　　　　　　　　▦　　　　　　▦　　▦　　　　　▦　　　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦＊▦▦▦▦▦　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▦　　▦∴∴∴∴∴∴∴∴∴',
		'▦∴∴∴∴∴∴∴∴∴∴∴∴∴∴▦　　　　　　　　　　　　　　　▦▣⊙▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣⊙▣▣▣▣▣▣▣▣⊙▣▣▦　　▦∴∴∴∴∴∴∴∴∴',
		'▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦'
	);

	MAP_EVENT_04: array[0..13] of TMapEventDesc =
	(
		(pos: (x:  1; y:  4); eventType: etAction; id: 1; flag:  1),
		(pos: (x: 17; y: 18); eventType: etAction; id: 2; flag:  2),
		(pos: (x: 16; y:  6); eventType: etRead;   id: 1; flag: 31),
		(pos: (x: 22; y: 10); eventType: etRead;   id: 2; flag: 32),
		(pos: (x: 36; y: 13); eventType: etRead;   id: 3; flag: 33),
		(pos: (x: 42; y: 10); eventType: etRead;   id: 3; flag: 34),
		(pos: (x: 53; y:  7); eventType: etOn;     id: 1; flag: 41),
		(pos: (x: 18; y: 18); eventType: etOn;     id: 2; flag: 42),
		(pos: (x: 10; y: 11); eventType: etSearch; id: 1; flag: 100),
		(pos: (x:  7; y: 16); eventType: etSearch; id: 2; flag: 101),
		(pos: (x:  4; y: 14); eventType: etSearch; id: 3; flag: 102), // note
		(pos: (x:  1; y: 13); eventType: etSearch; id: 4; flag: 103), // orz's diary
		(pos: (x: 17; y: 20); eventType: etSearch; id: 5; flag: 104), // air gun & manual
		(pos: (x: 20; y: 20); eventType: etSearch; id: 6; flag: 105)
	);

	MAP_NPC_04: array[0..13] of TMapNPCDesc =
	(
		(charType: 0; pos: (x:  2; y:  4); name: ''),
		(charType: 5; pos: (x:  6; y:  2); name: '오르츠'),
		(charType: 1; pos: (x: 29; y: 12); name: '등록소 직원'),
		(charType: 4; pos: (x: 29; y: 14); name: '등록소 직원'),
		(charType: 6; pos: (x: 13; y: 11); name: '원로'),
		(charType: 2; pos: (x:  2; y: 13); name: '사서'), // 도서관 안
		(charType: 1; pos: (x: 45; y: 12); name: '리홉'),
		(charType: 4; pos: (x: 46; y: 13); name: '도구점의 꼬마'),
		(charType: 1; pos: (x: 39; y: 14); name: '도구점의 손님'),
		(charType: 3; pos: (x: 22; y: 18); name: '걸인'),
		(charType: 1; pos: (x: 57; y: 14); name: ''),
		(charType: 1; pos: (x: 67; y: 15); name: ''),
		(charType: 1; pos: (x: 46; y: 23); name: ''),
		(charType: 1; pos: (x: 59; y: 27); name: '')
	);

implementation

uses
	Windows,
	UPlayer, UGameMain, UTileMap;

const
	FLAG_REGISTERED_ON_AVEJ     = 1;
	FLAG_NEED_TO_GUARANTEE      = 2;
	FLAG_NEED_TO_INTERVIEW      = 3;
	FLAG_END_OF_GUARANTEE       = 4;
	FLAG_NEED_DEAD_BOOK         = 5;
	FLAG_TALK_ABOUT_ORZ_DIARY   = 6;
	FLAG_GIVE_WISKEY            = 7;
	FLAG_TALK_ABOUT_HIDDEN_DOOR = 8;
	FLAG_GET_DEAD_BOOK        = 10;
	FLAG_GET_LIBRARY_KEY      = 11;
	FLAG_GET_LIBRARY_NOTE     = 12;
	FLAG_GET_ORZ_DIARY        = 13;
	FLAG_GET_ORZ_KEY          = 14;
	FLAG_GET_AIR_GUN          = 15;

procedure InitProc04(const sender: TObject; prevMapId: integer; prevPos: TPosition);
begin
	if prevMapId in [SCRIPT_AVEJ_WEST_LV0, SCRIPT_AVEJ_WEST_LV2] then begin
		if (prevPos.x >= 0) and (prevPos.y >= 0) then begin
			(sender as TTileMap).GetPC.WarpOnTile(prevPos.x div BLOCK_W_SIZE, prevPos.y div BLOCK_H_SIZE);
		end;
	end;

	if (sender as TTileMap).MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
		(sender as TTileMap)[21, 19] := OBJ_DOOR_CLOSE;
	end;
end;

function  Char2MapProc04(cTemp: char): longword;
begin
	case cTemp of
		chr(255): result := 3;
		else result := high(longword);
	end;
end;

function GetOriginalPos(personalId : integer): TPoint;
var
	i: integer;
	player: TPlayer;
begin
	player := g_tileMap.GetPlayer(personalId);

	for i := low(MAP_NPC_04) to high(MAP_NPC_04) do begin
		if MAP_NPC_04[i].name = player.m_name then begin
			result := MAP_NPC_04[i].pos;
			exit;
		end;
	end;

	// cannot find the specified event
	result.x := 0;
	result.y := 0;
end;

procedure TalkData04(personalId : integer; const question : widestring; const fullInput : wideString = '');
const
	REQUIRE_MY_NAME : boolean = FALSE;
	REQUIRE_ANSWER  : boolean = FALSE;
	RESERVED_NAME   : widestring = '';

	function KeyWordIs(const strList: array of string): boolean;
	var
		index: integer;
	begin
		result := TRUE;

		index := low(strList);
		while (index <= high(strList)) do begin
			if question = strList[index] then begin
				exit;
			end;
			inc(index);
		end;

		result := FALSE;
	end;

var
	i: integer;
	pos: TPoint;
	player: TPlayer;
begin
	case personalId of
	1:
	//?? 두번 째 대화에서는 주민 등록에 대한 이야기를 해야 함
	begin
		if question = KEYWORD_BYE then begin
			if REQUIRE_MY_NAME then begin
				g_textArea.Write('다음에는 꼭 이름을 가르쳐 주게나.');
			end
			else begin
				g_textArea.Write('잘가게.');
			end;
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
			REQUIRE_ANSWER := FALSE;
			RESERVED_NAME  := '';
		end
		else if REQUIRE_ANSWER then begin
			if question = '예' then begin


				g_textArea.WriteLn('{"이..곳은 어디죠? 그리고 당신은 누구신가요?"}');
				g_textArea.WriteLn();
				g_textArea.WriteLn('허, 참.. 성격도 급한 젊은이로군. 한 번에 하나씩만 묻게.');
				g_textArea.WriteLn('여기가 어디긴 어디야 이 세상이지. 하지만 육신이 살아있는 인간들은 이곳을 사후세계라고 부르기도 한다지.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('{"사후세계?!"}');
				g_textArea.WriteLn();
				g_textArea.WriteLn('사후세계란 죽은 후에 계속 이어지는 세계를 말하는 것이지. 자네는 이곳에 온지 얼마 되지 않은 것 같군.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('<space 키를 누르십시오>', tcHelp);
				g_textArea.WriteLn();
				g_GameMain.PressAnyKey();

				g_textArea.WriteLn('{"사후세계는 존재하지 않아요. 이미 사람이 죽었는데 이렇게 생각하고 이야기 한다는 것이 모순이잖아요."}');
				g_textArea.WriteLn();
				g_textArea.WriteLn('믿음을 좀 가지게 젊은이. 보통, 이곳에 처음 오는 사람들은 자신이 죽었다는 것을 인정하지 않으려고 하지. '+
									'사후세계는 이미 의학에서도 어느 정도 인정하고 있는 부분이야. 가끔씩 죽었다가 살아난 사람들이 사후 세계에 '+
									'대한 경험담을 기사화 한 것을 보지 못했는가?');
				g_textArea.WriteLn();

				g_textArea.Write('{"그런 기사는 본 적있지만, 그건 대부분 믿을 수 없는 3류 기사들이에요. 그들이 사후 세계가 있다고 믿었던 것은 '+
									'모두 그렇게 착각을 했기 때문이 아닌가요? 잠시 몸의 기관이 정지해 있는 동안에 뇌에 ');
				g_textArea.Write('일산화탄소', tcHelp);
				g_textArea.Write('{가 부족해져서 그런 환각을 느끼는 것뿐이라구요."}');
				g_textArea.WriteLn();
				g_textArea.WriteLn();
				g_textArea.WriteLn('허허.. 그래 그래.. 하지만 자네도 곧 이곳을 인정하게 될걸쎄. 이렇게 눈 앞에 펼쳐져 있는 이런 세계를 '+
									'부정한다는 자체가 벌써 모순이라고 생각하지 않는가?');
				g_textArea.WriteLn();

				g_textArea.WriteLn('{"그..그건 그렇지만..."}');
				g_textArea.WriteLn();

				g_textArea.WriteLn('방금도 내가 말했지만 자네처럼 TV를 통해 공간 전송을 하는 사람은 정말 오랜만이야. 내가 이 세계에 들어온지가 꽤 되었지만 그리 흔한 일은 아니거든. 아 먼저 이 세계에 대한 이야기부터 해야 하나?');
				g_textArea.WriteLn();

				g_tileMap.GetPC.m_name := RESERVED_NAME;
				REQUIRE_MY_NAME := FALSE;

				g_gameMain.UpdateStatus();
			end
			else begin
				g_textArea.WriteLn('그래? 내가 잘못 들은 것 같군.');
				g_textArea.WriteLn('자네 이름은 무엇인가?');
				g_textArea.WriteLn();
			end;
			REQUIRE_ANSWER := FALSE;
			RESERVED_NAME  := '';
		end
		else if REQUIRE_MY_NAME then begin
			if question = KEYWORD_GREETING then begin
				g_textArea.Clear();
				g_textArea.Write('나의 이름은 ');
				g_textArea.Write('오르츠', tcMonolog);
				g_textArea.Write('라고 하네만,');
				g_textArea.WriteLn();
				g_textArea.WriteLn('자네의 이름은 뭔가?');
				g_textArea.WriteLn();
			end
			else begin
				//?? 일정 길이 이상은 되면 안됨
				if fullInput = '오르츠' then begin
					g_textArea.WriteLn('그것은 나의 이름이지 자네의 이름이 아니야. 다시 이름을 말해 보게나.');
					g_textArea.WriteLn();
				end
				else if length(fullInput) > 16 then begin
					g_textArea.WriteLn('이런 이런.. 내가 외우기에 이름이 너무 길어 보이네. 다시 또박또박 말해 주지 않겠나?');
					g_textArea.WriteLn();
				end
				else begin
					g_textArea.Write('자네의 이름은 ');
					g_textArea.Write(fullInput, tcMonolog);
					g_textArea.WriteLn('인가?');
					g_textArea.WriteLn();

					g_textArea.Write('[');
					g_textArea.Write('예', tcHelp);
					g_textArea.Write(' 또는 ');
					g_textArea.Write('아니오', tcHelp);
					g_textArea.Write('로 대답]');
					g_textArea.WriteLn();

					g_textArea.WriteLn();

					REQUIRE_ANSWER := TRUE;
					RESERVED_NAME  := fullInput;
				end;
			end;
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.NameFlag[personalId] then begin
				g_textArea.WriteLn('자네처럼 TV를 통해 공간 전송을 하는 사람은 정말 오랜만이야. 내가 이 세계에 들어온지가 꽤 되었지만 그리 흔한 일은 아니거든.');
				g_textArea.WriteLn();
			end
			else begin
				g_textArea.WriteLn('자네 방금 TV를 통해 전송된 것처럼 보이는데.. 내가 정확하게 본 것인가? ' +
								   '아마도 TV를 매체로 전송이 가능한 사람은 200년 만에 처음 보는 것 같네.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('자네는 이곳이 처음인가? 반갑네, 나의 이름은 ''오르츠''야. 자네가 이 세계로 오자마자 나를 만나게 된 것은 큰 행운일세. '+
								   '그런데 자네의 이름은 뭔가?');
				g_textArea.WriteLn();

				g_tileMap.NameFlag[personalId] := TRUE;
				REQUIRE_MY_NAME := TRUE;
			end;
		end
		else if question = '오르츠' then begin
			g_textArea.WriteLn('그것은 나의 이름이야. 이 세계로 온 후 이전 세계에 대해 유일하게 기억하고 있는 것이 나의 본명이지.');
			g_textArea.WriteLn();
		end
		else if question = '일산화탄' then begin
			g_textArea.WriteLn('허허허... 아직도 꿈이라고 생각하는 겐가?');
			g_textArea.WriteLn();
		end
		else if (question = '전송') or (question = '공간전송') then begin
			g_textArea.WriteLn('전송이라는 것은 이 세계에서 지역을 이동하는 방법 중에 하나야. 원래는 그런 매체 없이도 스스로의 의지로 공간을 이동하는 것이 가능하지만 이 세계에 들어온 초보들은 보통 어떤 매체를 통해서만 그런 것이 가능하지. ' +
							   '예를 들어, 노래를 부를 때 손으로 박자를 맞추어야지만 제대로 부르다가 나중에는 그냥 노래를 부를 수 있는 것과 같은 이치야');
			g_textArea.WriteLn();
		end
		else if question = '매체' then begin
			g_textArea.WriteLn('매체를 통해서만 전달된다고 생각할지 모르지만 실제로 매체를 통해서 되는 것은 아니고 매체를 통해서만 전송이 가능하다고 느끼기 때문에 ' +
							   '고정관념처럼 그렇게 습관적으로 하는 것이지. 아마도 자네가 TV를 통해 전송이 된다고 생각하는 것은 자네 손에 쥐어진 그 리모콘으로 ' +
							   '채널을 변화시키는 것을 공간이 변하는 것과 같은 것이라 인식하기 때문이라고 생각되네. 아마도 자네는 TV에 많은 생활을 의존하고 있었나 보군.');
			g_textArea.WriteLn();
		end
		else if question = '리모콘' then begin
			g_textArea.WriteLn('자네 손에 든 그것을 말하는 것이라네.');
			g_textArea.WriteLn();
		end
		else if question = '이세계' then begin
			g_textArea.WriteLn('이 세계에 대해 의문을 가지고 있나? 이 세계는 아마도 자네가 이전 상태에 있었을 때는 이곳을 사후세계라고 불렀을지도 모르겠군.');
			g_textArea.WriteLn();
		end
		else if (question = '이전상태') or (question = '상태') then begin
			g_textArea.WriteLn('이전 상태는 살아 있을 때를 말하는 것이지.');
			g_textArea.WriteLn('다시 말해 영혼과 육체가 결속되어 있던 상태를 말하는 것이야. '+
							   '물론 지금은 그 두 개가 다시 원래대로 분리되어있는 상태지.');
			g_textArea.WriteLn();
		end
		else if question = '영혼' then begin
			g_textArea.WriteLn('현재의 상태이지. 느끼기에도 지금이 훨씬 자유로운 느낌이 들지 않는가? 게다가 육체의 눈을 통해 보는 것이 아니기 때문에 한 번에 앞과 뒤를 다 볼 수 있지. '+
							   '내가 말해주기 전까지는 자네가 자네의 앞과 뒤를 다 볼 수 있다는 사실을 깨닫기가 어려웠을거야. 어찌보면 그냥 자연스레 당연한 것처럼 느껴져 버렸을 테니까.');
			g_textArea.WriteLn();
		end
		else if question = '육체' then begin
			g_textArea.WriteLn('아쉽게도 자네의 육체와 다시 결합하기는 어려울걸세.');
			g_textArea.WriteLn();
		end
		else if question = '이전세계' then begin
			g_textArea.WriteLn('육체와 영혼이 공존하는 세계야.');
			g_textArea.WriteLn();
		end
		else if question = '사후세계' then begin
			g_textArea.WriteLn('이전 상태의 세계에서는 모든 생각을 육체를 기준으로 하기 때문에 육체가 죽는 것은 자신이 죽는 것이라고 생각하기 때문에 그것을 사후세계라고 불렀었지. '+
							   '하지만 어떤가? 자네는 이렇게 육체는 없어져도 영혼만으로 이렇게 살아 있지 않은가? '+
							   '일단 이 세계에 들어 온 사람은 다시 육체가 존재하는 세계로 돌아갈 수가 없으니까 그들에게 진실을 알려주려고 해도 그게 쉽지 않지. '+
							   '아마 그들은 역사가 끝나는 그때까지도 이곳을 사후세계라고 부르며 그 존재에 대한 논쟁을 끊임없이 하겠지.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['파이로전', '파이로', '전기탄']) then begin
			if not g_tileMap.MapFlag[0, FLAG_GET_ORZ_KEY] then begin
				g_textArea.WriteLn('자네가 어떻게 그런 것을 알고 있나? 신기하군. 사실 나도 하나 가지고 있어. 그게 말이지 좀 오래된 것이라 제대로 작동하는 것인지 모르겠군. '+
								   '지하 창고에 두긴 했는데 몇백 년 넘게 방치해둔 것이라 정확하게 어디 있는지 모르겠군. 필요하다면 가져가게. 어차피 사람의 체온으로는 기폭되지 않는 물건이니 '+
								   '무기치고는 굉장히 안전한 것이지. 자, 이것은 지하 창고 열쇠야. 가서 한 번 찾아 보게나.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[열쇠 +1]', tcEvent);
				g_inventory.Add(ITEM_KEY, 18, 2);
				g_tileMap.MapFlag[0, FLAG_GET_ORZ_KEY] := TRUE;
			end
			else begin
				g_textArea.WriteLn('내가 직접 써 본 일은 없다네. 그것을 발명한 사람은 테슬라라는 사람인데 이 도시의 동쪽 끝에 살고 있네. 이 집이 있는 곳이 이 도시의 서쪽 끝이니까 아마도 그를 찾으려면 꽤나 멀리 가야 할걸세.');
				g_textArea.WriteLn();
			end;
		end
		else if question = '코세르' then begin
			g_textArea.WriteLn('이후 게임 진행을 위해 필요(현재 진행 안됨)', tcEvent);
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['스캔라인', '넘어선자']) then begin
			g_textArea.WriteLn('이후 게임 진행을 위해 필요(현재 진행 안됨)', tcEvent);
			g_textArea.WriteLn();
		end
		else if question = '테슬라' then begin
			g_textArea.WriteLn('그가 이곳에 온 것은 나보다 먼저라네. 육체가 살아 있던 세계에서는 꽤나 능력있는 학자였던 것 같지만 여기서는 엘리멘탈과 싸우는 무기를 만든 사람으로 더 잘 알려져 있지. '+
							   '그는 전기를 다루는 능력이 탁월해서 모든 문제에 대해 전기를 통해 설명하고 해결하려들지. 아직도 그가 이전 세계에 대한 미련을 가지고 있다면, '+
							   '그는 분명히 이곳의 실체를 전기적으로 해석하고 그래서 이곳을 빠져나가는 방법을 찾기 위해 아직도 노력하고 있을 것이라 생각되네. '+
							   '그는 이 도시의 동쪽에 살고 있는데, 나도 그를 만나보지 못한지 몇 십년은 되었다네.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['엘리멘탈', '엘레멘탈']) then begin
			g_textArea.WriteLn('이후 게임 진행을 위해 필요(현재 진행 안됨)', tcEvent);
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['전기', '전기적']) then begin
			g_textArea.WriteLn('그런 것은 테슬라를 만나서 이야기 하게.');
			g_textArea.WriteLn();
		end
		else if (not g_tileMap.MapFlag[0, FLAG_END_OF_GUARANTEE]) and g_tileMap.MapFlag[0, FLAG_NEED_TO_GUARANTEE] and KeyWordIs(['확인증거', '보증인']) then begin
			if g_inventory.Search(ITEM_GUARANTEE) then begin
				g_textArea.WriteLn('내가 이미 줬지 않은가. 자네에게.');
			end
			else begin
				g_textArea.WriteLn('등록하는데 그런 것이 필요하던가? 그렇다면 내가 보증인이 되어 줄 수밖에 없겠군. 어차피 자네는 여기에 아는 사람도 없을 테고.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[오르츠의 보증인 서명 +1]', tcEvent);
				g_inventory.Add(ITEM_GUARANTEE);
			end;
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('그건 무슨 의미인지 잘 모르겠군...');
			1:   g_textArea.WriteLn('나라고 다 아는 것은 아니지. 다른 것을 물어 보게나.');
			else g_textArea.WriteLn('음.... 다시 한 번 이야기해 주시게.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	2:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('안녕히 가십시오.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			g_textArea.WriteLn('어서오십시오. 여기는 AVEJ 주민 등록소입니다. 무엇을 도와드릴까요?');
			g_textArea.WriteLn();
			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '주민' then begin
			g_textArea.WriteLn('AVEJ에 거주하게 되는 모든 영혼들은 주민이 될 권리를 가지고 있습니다.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['주민등록', '등록소', '등록']) then begin
			g_textArea.WriteLn('주민이 되지 않으면 법에 의한 보호를 받을 수가 없습니다. 또한 주민이 되면 그 권리에 따르는 의무가 주어집니다. 그리고 주민이 되려면 여기서 {등록절차}를 마쳐야 합니다.');
			g_textArea.WriteLn();
		end
		else if question = '영혼' then begin
			g_textArea.WriteLn('우리 모두를 이야기 하는 것입니다.');
			g_textArea.WriteLn();
		end
		else if question = '권리' then begin
			g_textArea.WriteLn('주민으로 등록되면 모든 권리를 행사할 수 있습니다.');
			g_textArea.WriteLn();
		end
		else if question = '의무' then begin
			g_textArea.WriteLn('의무는 납세의 의무가 가장 우선입니다. 주민이 내는 세금에 의해서 AVEJ가 운영됩니다.');
			g_textArea.WriteLn();
		end
		else if question = '납세' then begin
			g_textArea.WriteLn('세금을 낸다는 의미입니다.');
			g_textArea.WriteLn();
		end
		else if question = '세금' then begin
			g_textArea.WriteLn('저는 바쁩니다. 계속 말꼬리 잡는 장난을 하시겠습니까?');
			g_textArea.WriteLn();
		end
		else if question = 'avej' then begin
			g_textArea.WriteLn('AVEJ는 몇 천 년이상 계속되어온 자치구입니다. 이름의 정확한 기원은 알 수 없으나 Avenue J에 닥친 재해로 많은 영혼들이 이곳으로 일시에 흘러 들어 왔고 그 사람들이 최초로 이 자치구의 개척을 시작했습니다. 그들의 출신지를 빌어 이곳을 AVEJ라고 부릅니다.');
			g_textArea.WriteLn();
		end
		else if question = '다른세계' then begin
			g_textArea.WriteLn('다른 말로는 죽기 이전의 세계지요.');
			g_textArea.WriteLn();
		end
		else if question = '등록절차' then begin
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('당신은 이미 등록하셨기 때문에 별도의 등록 절차가 필요 없습니다.');
			end
			else if g_inventory.Search(ITEM_REG_FORM_MT) or g_inventory.Search(ITEM_REG_FORM) then begin
				g_textArea.WriteLn('지금 가지고 계신 주민 등록 서류를 옆의 사람에게 제출해 주십시오.');
			end
			else begin
				g_textArea.WriteLn('등록을 하기 위해서는 먼저 자신이 이미 죽어 있다는 증명을 해야 합니다. 이 등록서의 빈칸을 채우시고 제 옆의 분에게 이 서류를 제출하십시오. 그에게 {등록절차}를 물어 보시면 도와 줄 것입니다.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[빈 주민 등록 서류 +1]', tcEvent);
				g_inventory.Add(ITEM_REG_FORM_MT);
			end;
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('그건 무슨 의미인지 잘 모르겠습니다.');
			1:   g_textArea.WriteLn('다른 질문은 없습니까?');
			else g_textArea.WriteLn('제대로 못 알아 들은 것 같습니다. 다시 말씀해 주십시오.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	3:
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('안녕히 가십시오.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('더 이상 제가 도와 드릴 일은 없습니다.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else if g_tileMap.MapFlag[0, FLAG_NEED_TO_INTERVIEW] then begin
				g_textArea.WriteLn('안쪽 방에 계시는 원로님과 면담을 하십시오. 그분이 최종적으로 주민으로 받아 들일지를 결정하시는 분입니다.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else begin
				if g_inventory.Search(ITEM_REG_FORM) or g_inventory.Search(ITEM_GUARANTEE) then begin
					g_textArea.WriteLn('어서오십시오, 무엇을 도와드릴까요? 등록 서류는 준비하셨나요?');
					g_textArea.WriteLn();
					if g_inventory.Search(ITEM_GUARANTEE) then begin
						g_textArea.WriteLn('네. 이쪽으로 제출해 주세요. 그리고 안쪽 방에 계시는 원로님과 면담을 하십시오. 그분이 최종적으로 주민으로 받아 들일지를 결정하시는 분입니다.');
						g_inventory.Remove(ITEM_REG_FORM);
						g_inventory.Remove(ITEM_GUARANTEE);
						g_tileMap.MapFlag[0, FLAG_NEED_TO_INTERVIEW] := TRUE;
						g_tileMap.MapFlag[0, FLAG_END_OF_GUARANTEE]  := TRUE;
						g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
					end
					else begin
						if g_tileMap.MapFlag[0, FLAG_NEED_TO_GUARANTEE] then
							g_textArea.WriteLn('아직 보증인은 못 찾으셨나 보네요.')
						else
							g_textArea.WriteLn('부족한 서류가 있네요. 자신이 이미 죽어 있다는 것을 증명하기 위한 {확인증거}를 가지고 오셔야 합니다')
					end;
				end
				else begin
					g_textArea.WriteLn('어서오십시오. 여기는 AVEJ 주민 등록소입니다. 무엇을 도와드릴까요?');
				end;
			end;
			g_textArea.WriteLn();
			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '등록서류' then begin
			if g_inventory.Search(ITEM_REG_FORM_MT) or g_inventory.Search(ITEM_REG_FORM) then begin
				g_textArea.WriteLn('당신의 손에 들고있는 그것입니다.');
			end
			else begin
				g_textArea.WriteLn('주민으로 등록하기 위해 작성하는 서류입니다. 제 옆의 분에게 받아 오세요.');
			end;
			g_textArea.WriteLn();
		end
		else if question = '등록절차' then begin
			if g_inventory.Search(ITEM_REG_FORM) then begin
				g_textArea.WriteLn('네, 서류 내용은 다 채우셨군요. 그런데 필요한 것이 하나 더 있습니다. 자신이 이미 죽어 있다는 것을 증명하기 위한 {확인증거}를 가지고 오셔야 합니다.');
			end
			else if g_inventory.Search(ITEM_REG_FORM_MT) then begin
				g_textArea.WriteLn('등록 서류가 모두 빈칸으로 남아 있습니다. 내용을 채워서 제출하십시오.');
			end
			else begin
				g_textArea.WriteLn('먼저 {등록 서류}를 가지고 오세요.');
			end;
			g_textArea.WriteLn();
		end
		else if question = '확인증거' then begin
			g_textArea.WriteLn('당신의 죽음을 확신하는 사람을 보증인으로 세우는 것도 가능합니다.');
			g_textArea.WriteLn();
			g_tileMap.MapFlag[0, FLAG_NEED_TO_GUARANTEE] := TRUE;
		end
		else if question = '보증인' then begin
			g_textArea.WriteLn('보증인까지 저희가 찾아 드리는 것은 곤란합니다.');
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('음.. 잘 모르겠네요.');
			1:   g_textArea.WriteLn('다른 질문으로 해주십시오.');
			else g_textArea.WriteLn('다시 말씀해 주시겠습니까?');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	4: // 원로
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('다음에 봅세.');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('어서오시게. 나에게 무슨 볼 일이라도 있는겐가?');
				g_textArea.WriteLn();
			end
			else if g_inventory.Search(ITEM_BOOK, ITEM_BOOK_DEAD_WORLD) and g_tileMap.MapFlag[0, FLAG_NEED_DEAD_BOOK] then begin
				g_textArea.WriteLn('잘 찾아 왔군. 그래 바로 이 책일세. 이 책은 만들어진지가 몇 백년이 지나긴 했지만 여전히 좋은 내용을 담고 있는 책이지. 축하하네. 자네도 이젠 AVEJ의 주민이 되었네. 모르는 부분은 이 책을 통해서 찾아보게나.');
				g_textArea.WriteLn();

				g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] := TRUE;
				g_tileMap.MapFlag[0, FLAG_NEED_DEAD_BOOK]     := FALSE;
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end
			else begin
				g_textArea.WriteLn('어서오시게. 나는 AVEJ에 오래전부터 거주했었기 때문에 사람들은 나를 원로라고 칭한다네.');
				g_textArea.WriteLn();
				g_tileMap.NameFlag[personalId] := TRUE;
				if g_tileMap.MapFlag[0, FLAG_NEED_TO_INTERVIEW] then begin
					//?? 제일 뒤에 마침표가 출력안되는 것 같음
					g_textArea.WriteLn('자네가 이번에 새로 이곳으로 온 그 친구로군. 한 때는 이곳도 하루에 몇 명씩 전입해 들어올 때가 있었지만 요즈음은 도통 새로운 사람들이 들어오지 않는다네.');
					g_textArea.WriteLn('아마도 이곳과 이승의 세계를 연결해 주는 무언가의 연결이 순조롭지 않은 것 같네. 우리들은 그것이 무엇인지 찾아보려 했지만 전혀 실마리를 못 잡고 있단 말이야. 자네는 어떠한 매체를 통해서 이곳에 흘러 들어 올 수 있게 되었나?');
					g_textArea.WriteLn();
				end
				else begin
					g_textArea.WriteLn('그런데 처음보는 친구로군. 나는 바쁘니 다음에 찾아 오시게.');
					g_textArea.WriteLn();
					g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
				end;
			end;
		end
		else if question = 'avej' then begin
			g_textArea.WriteLn('등록원이 설명 안해 주던가? 이곳의 이름이라네.');
			g_textArea.WriteLn();
		end
		else if question = '매체' then begin
			g_textArea.WriteLn('매체에 대한 이야기라면 이 건물 북쪽에 있는 오르츠가 잘 해줄 걸세.');
			g_textArea.WriteLn();
		end
		else if (question = '전입') or (question = '전입절차') then begin
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('자네는 이미 전입했기 때문에 별다른 절차가 더 이상 필요 없네.');
			end
			else begin
				g_textArea.WriteLn('전입 절차 중에 마지막이 나와의 면담이지.');
			end;
			g_textArea.WriteLn();
		end
		else if question = '이승' then begin
			g_textArea.WriteLn('자네가 얼마 전까지만 해도 살던 그곳을 말하는 것이라네.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['tv', 'tele', '텔레비젼', '텔레비전', '테레비', '텔레비', '티븨', '티브이']) then begin
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('자네가 전송될 때 매체로 사용한 그것 이야기인가? {멜트} 때만큼 특이한 매체지.');
			end
			else begin
				g_textArea.WriteLn('오호.. 참으로 엉뚱한 매체로구만. 하긴 몇 십년 전에는 자동판매기를 통해서 전송된 친구도 있었지.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('아마 남쪽 어딘가에서 가게를 하고 있는 {멜트}라는 친구였지. 그 친구는 생전에 이상한 호기심이 많아서 자동판매기가 동전을 물건으로 바꾸어 주는 기계라고 생각했었다나... '+
								   '아마도 어릴 때의 그런 호기심이 영혼에 각인되어서 그 친구는 자동판매기를 통해 전송이 가능했던 것이겠지. 그렇다면 자네는 TV 중독증이 있었던 게로구만.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('일단 자네에게는 이 세계에 대한 이해가 필요하니 왼쪽에 있는 책장에서 {사후세계 입문서}를 가지고 오게나.');
				g_tileMap.MapFlag[0, FLAG_NEED_DEAD_BOOK] := TRUE;
			end;
			g_textArea.WriteLn();
		end
		else if (question = '자동판매') or (question = '자판기') then begin
			g_textArea.WriteLn('그냥 흔히 봐왔던 그런 자동판매기야. 이곳은 자네가 살던 세계와는 시간의 개념이 달라서 몇 백년전부터 TV와 자동판매기가 보급되어 있다네.');
			g_textArea.WriteLn();
		end
		else if question = '오르츠' then begin
			g_textArea.WriteLn('오르츠는 꽤 오래 전부터 이곳에 살아온 인물이지. 처음부터 이곳에서 산 것은 아니고 외부의 다른 도시에서 살다가 이곳으로 오게 되었지. 그는 이 건물의 북쪽에 있는 집에 살고 있다네.');
			g_textArea.WriteLn();
		end
		else if question = '멜트' then begin
			g_textArea.WriteLn('이 건물의 남쪽으로 한참 내려가면 있는 가게의 주인이지. 좀 무뚝뚝하긴 하지만 기계쪽에는 박식한 친구라네.');
			g_textArea.WriteLn();
		end
		else if question = '각인' then begin
			g_textArea.WriteLn('영혼 속에 기억되는 것이지 보통 육체가 기억하는 것은 단기기억이라고 라고 영혼이 기억하는 것을 장기기억이라고 하지.');
			g_textArea.WriteLn();
		end
		else if question = '전송' then begin
			g_textArea.WriteLn('설명하긴 좀 힘들지만 이곳은 육체가 없는 곳이기 때문에 생각만으로도 어떤 위치에 있을 수 있지. {''자신은 세상 모든 곳에 존재한다''}라는 것이 이 세계의 대전제 중에 하나라네.');
			g_textArea.WriteLn();
		end
		else if question = '중독증' then begin
			g_textArea.WriteLn('TV 중독증이 아니라도 TV의 전파 방송에 대한 이해가 높다고 하면 자신이 전파가 된 것으로 인식하고 멀리까지 전송시킬 수 있었던 것일지도 몰라.');
			g_textArea.WriteLn();
		end
		else if (question = '사후세계') or (question = '입문서') then begin
			g_textArea.WriteLn('{사후세계 입문서}는 내가 여기에 왔을 때부터 만들기 시작해서 몇 십년간 만든 책이라네. 대부분의 신입 영혼들은 이 책을 통해서 이 세계에 대한 빠른 지식을 습득하지.');
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
			0:   g_textArea.WriteLn('잘 모르는 부분이군...');
			1:   g_textArea.WriteLn('다른 것을 물어 보시게나.');
			else g_textArea.WriteLn('내가 제대로 듣지를 못했나 보오. 다시 한 번 이야기해 주시게.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	5: // 사서
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('다음에 봅시다.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_REGISTERED_ON_AVEJ] then begin
				g_textArea.WriteLn('저는 이곳의 사서입니다. 여기는 함부로 들어오면 안되는 곳입니다.');
				g_tileMap.NameFlag[personalId] := TRUE;
			end
			else begin
				g_textArea.WriteLn('여기는 함부로 들어오면 안되는 곳입니다. 특히 이곳의 주민이 아닌 사람은 들어올 수 없습니다.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end;
			g_textArea.WriteLn();
		end
		else if question = '사서' then begin
			g_textArea.WriteLn('주민등록소에서 운영하는 도서관의 사서입니다.');
			g_textArea.WriteLn();
		end
		else if question = '도서관' then begin
			g_textArea.WriteLn('AVEJ가 생기고 난 후에 제일 처음 생긴 도서관이 여기입니다. 지금은 중앙에 큰 도서관이 생기면서 이곳은 일반인에게는 개방되지 않는 곳으로 바뀌었습니다.');
			g_textArea.WriteLn();
		end
		else if question = '주민등록소' then begin
			g_textArea.WriteLn('이 건물이 주민등록소 건물입니다.');
			g_textArea.WriteLn();
		end
		else if question = 'avej' then begin
			g_textArea.WriteLn('이곳을 말하는 것이지요. 설마 몰라서 묻는 것은 아니지요?');
			g_textArea.WriteLn();
		end
		else if question = '책장' then begin
			g_textArea.WriteLn('책장이 많이 있는 것은 아니지만 나름대로 AVEJ에서는 꽤나 귀한 자료로 취급된답니다.');
			g_textArea.WriteLn();
		end
		else if g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_NOTE] then begin
			if g_inventory.Search(ITEM_BOOK, ITEM_BOOK_LIBRARY_NOTE) then begin
				g_textArea.WriteLn('아.. 손에 들고 있는 그것은..');
				g_textArea.WriteLn('이런 것을 함부로 만지면 곤란합니다. 이것은 이 도서관이 생기면서부터 계속 써온 도서관 일지이지요. 이곳의 최초의 사서는 오르츠라는 분이셨죠.');
				g_textArea.WriteLn();
				g_textArea.WriteLn('[도서관 일지 -1]', tcEvent);
				g_textArea.WriteLn('');
				g_inventory.Remove(ITEM_BOOK, ITEM_BOOK_LIBRARY_NOTE);
			end
			else if question = '오르츠' then begin
				g_textArea.WriteLn('그분이 최초의 사서였던 것은 일지를 통해 알았지만 최근에 재미있는 것을 발견했어요. '+
								   '그분이 이곳에 처음 사서로 있으면서 썼던 일기인데 여기 있는 책장에 꽂아둔 채로 잊어버렸나 봅니다. 저도 이번에 책장 정리하면서 찾아냈거든요. 저의 바로 뒤에 있는 책장을 자세히 살펴 보세요.');
				g_textArea.WriteLn();
				g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_ORZ_DIARY] := TRUE;
			end
			else begin
				case Random(3) of
					0:   g_textArea.WriteLn('미안하지만 잘 모르겠습니다.');
					1:   g_textArea.WriteLn('그것말고 다른 질문은 없습니까?');
					else g_textArea.WriteLn('무어라고 하셨죠?');
				end;
				g_textArea.WriteLn('');
			end;
		end
		else if question = '오르츠' then begin
			g_textArea.WriteLn('이 건물을 나서서 바로 길 건너 건물에 사는 분이시죠.');
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('미안하지만 잘 모르겠습니다.');
				1:   g_textArea.WriteLn('그것말고 다른 질문은 없습니까?');
				else g_textArea.WriteLn('무어라고 하셨죠?');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	6: // 도구점 주인
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('다음에 또 들려 주세요.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.NameFlag[personalId] then begin
				g_textArea.WriteLn('어서오십시오. 필요한 도구가 있으면 말씀해 주십시오.');
			end
			else begin
				g_textArea.WriteLn('어서오십시오. 여기는 ''리홉의 도구점''입니다.');
				g_tileMap.NameFlag[personalId] := TRUE;
			end;
			g_textArea.WriteLn();
		end
		else if question = '리홉' then begin
			g_textArea.WriteLn('저의 이름입니다.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['파이로전', '파이로', '전기탄']) then begin
			g_textArea.WriteLn('그렇게 오래된 것을 굳이 찾으실 필요가...');
			g_textArea.WriteLn();
		end
		else if (question = '도구') or (question = '도구점') then begin
			g_textArea.WriteLn('이후 게임 진행을 위해 필요(현재 진행 안됨)', tcEvent);
			g_textArea.WriteLn();
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('어떤 도구 말씀이신가요?');
				1:   g_textArea.WriteLn('죄송합니다. 잘 모르겠군요.');
				else g_textArea.WriteLn('말씀하신 것은 없습니다만...');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	7: // 도구점 꼬마
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			g_textArea.WriteLn('안녕하세요. 저는 여기 가게 일을 도와 주고 있는 아이입니다.');
			g_textArea.WriteLn();
			g_tileMap.NameFlag[personalId] := TRUE;
		end
		else if question = '가게' then begin
			g_textArea.WriteLn('여기는 도구점입니다. 여러가지 생활에 필요한 것들을 팔고 있어요.');
			g_textArea.WriteLn();
		end
		else if question = '아이' then begin
			g_textArea.WriteLn('비록 아이의 모습이긴 하지만 이곳에 온지는 몇 십년이 되었답니다.');
			g_textArea.WriteLn();
		end
		else if (question = '도구') or (question = '도구점') then begin
			g_textArea.WriteLn('도구에 대한 것은 옆의 리홉 아저씨께 문의하세요.');
			g_textArea.WriteLn();
		end
		else if KeyWordIs(['파이로전', '파이로', '전기탄']) then begin
			player := g_tileMap.GetPlayer(personalId);
			if assigned(player) then begin
				pos := GetOriginalPos(personalId);
				if (pos.x = player.GetTilePos.x) and (pos.y = player.GetTilePos.y) then begin
					g_textArea.WriteLn('아마도 없을 것 같긴 합니다만 한 번 찾아 볼께요.');
					g_textArea.WriteLn();

					// move to the cargo
					for i := 1 to (2*BLOCK_H_SIZE) div (2*PLAYER_MOVE_INC) do begin
						player.Move(2*PLAYER_MOVE_INC, -2*PLAYER_MOVE_INC);
						g_GameMain.UpdateDisplay();
					end;
					player.TurnFace(fdUp);
					g_tileMap[player.GetTilePos.x+player.GetFacedVector.dx, player.GetTilePos.y+player.GetFacedVector.dy] := OBJ_DOOR_OPEN;
					for i := 1 to (2*BLOCK_H_SIZE) div (2*PLAYER_MOVE_INC) do begin
						player.Move(2*PLAYER_MOVE_INC, -2*PLAYER_MOVE_INC);
						g_GameMain.UpdateDisplay();
					end;
					player.TurnFace(fdRight);
					g_tileMap[player.GetTilePos.x+player.GetFacedVector.dx, player.GetTilePos.y+player.GetFacedVector.dy] := OBJ_DOOR_OPEN;
					for i := 1 to (2*BLOCK_W_SIZE) div (2*PLAYER_MOVE_INC) do begin
						player.Move(2*PLAYER_MOVE_INC, -2*PLAYER_MOVE_INC);
						g_GameMain.UpdateDisplay();
					end;
				end
				else begin
					g_textArea.WriteLn('지금 찾고 있는 중입니다.');
					g_textArea.WriteLn();
				end;
			end;
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('죄송합니다. 저는 심부름만 하는 역할이라 잘 모르겠네요.');
				1:   g_textArea.WriteLn('잘 모르는 내용이라...');
				else g_textArea.WriteLn('필요한 물건이 있으시면 옆의 리홉 아저씨께 말씀하세요.');
			end;
			g_textArea.WriteLn('');
		end;
	end;
	8: // 도구점 손님
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('잘 가게나.');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.NameFlag[personalId] then begin
				if g_inventory.Search(ITEM_PYRO_BOMB) then begin
					g_textArea.WriteLn('자네가 들고 있는 그건 ''파이로 전기탄''이로군. 몇 백년 전만 해도 엘리멘탈의 공격이 잦아서 자주 그걸 사용해서 전투를 하곤 했는데 말이야. 오랜만에 또 보게 되니 감회가 새롭군. 아마 이 가게에도 몇 개는 남아 있지 않을까 생각되네만.');
				end
				else begin
					g_textArea.WriteLn('이 도구점은 AVEJ에서는 유서깊은 곳인데 이제는 이렇게 초라한 가게가 되어 버렸다네. 이 가게는 이 도시의 역사라고 할 수 있지. 아직도 예전 물건들이 조금은 남아 있지 않을까 생각되네만.');
				end;
			end
			else begin
				g_textArea.WriteLn('여기서는 처음 보는 얼굴이로군만. 자넨 신입인가? 정말 오랜만이군, 이 도시에 새로운 영혼이 들어온 건.');
				g_tileMap.NameFlag[personalId] := TRUE;
			end;
			g_textArea.WriteLn('');
			g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
		end
	end;
	9: // 걸인
	begin
		if question = KEYWORD_BYE then begin
			g_textArea.WriteLn('... ...');
			g_textArea.WriteLn('');
			g_textArea.ReservedClear();

			REQUIRE_ANSWER := FALSE;
		end
		else if REQUIRE_ANSWER then begin
			if question = '예' then begin
				g_textArea.Write('헤헤헤 고맙네. 얼마만에 구경해 보는 술인지 모르겠구만. ');
				g_textArea.Write('나는 은혜를 모르는 그런 야박한 사람은 아니야. 술을 받은 대신으로 ');
				g_textArea.Write('좋은 정보', tcMonolog);
				g_textArea.Write('를 하나 알려 주지.');
				g_textArea.WriteLn();
				g_textArea.WriteLn();
				g_textArea.WriteLn('[평범해 보이는 술 -1]', tcEvent);

				g_inventory.Remove(ITEM_WISKEY);
				g_tileMap.MapFlag[0, FLAG_GIVE_WISKEY] := TRUE;
			end
			else begin
				g_textArea.WriteLn('싫으면 말고. 자네가 여기서 살아가는데 좋은 정보나 알려 주려고 했는데.');
				g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
			end;
			g_textArea.WriteLn();
			REQUIRE_ANSWER := FALSE;
		end
		else if question = KEYWORD_GREETING then begin
			g_textArea.Clear();
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
				g_textArea.Write('영적으로 눈이 밝아지려면 글쎄... ... 여러 원로들에게 ');
				g_textArea.Write('영적인 눈', tcMonolog);
				g_textArea.Write('이라고 물어서 다시 깨달음을 얻을 수 밖에 없겠네 그려.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('');
			end
			else if g_tileMap.MapFlag[0, FLAG_GIVE_WISKEY] then begin
				g_textArea.WriteLn('술을 줬으니 {좋은 정보}가 필요하다면 알려 주지');
				g_textArea.WriteLn('');
			end
			else begin
				if not g_tileMap.NameFlag[personalId] then begin
					g_textArea.WriteLn('거지를 처음보나? 왜 그런 표정이야!');
					g_textArea.WriteLn('');
					g_tileMap.NameFlag[personalId] := TRUE;
				end;

				if g_inventory.Search(ITEM_WISKEY) then begin
					g_textArea.WriteLn('그나저나 손에 들고 있는 그것. 나에게 주지 않겠나? 값 비싼 술은 아닌 것 같지만...');
					g_textArea.WriteLn('');

					g_textArea.Write('[');
					g_textArea.Write('예', tcHelp);
					g_textArea.Write(' 또는 ');
					g_textArea.Write('아니오', tcHelp);
					g_textArea.Write('로 대답]');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('');

					REQUIRE_ANSWER := TRUE;
				end;
			end;
		end
		else if question = '영적인눈' then begin
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
				g_textArea.WriteLn('그건 나에게 묻지 말고 원로들에게나 물어봐.');
			end
			else begin
				g_textArea.WriteLn('알고 싶다면 {좋은 정보}를 들으면 돼.');
			end;
			g_textArea.WriteLn('');
		end
		else if question = '좋은정보' then begin
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] then begin
				g_textArea.WriteLn('내가 가르쳐 줄 수 있는 것은 그게 다야. 설사 술을 더 준다고 해도 나는 더 이상 아는 것이 없어.');
			end
			else begin
				if g_tileMap.MapFlag[0, FLAG_GIVE_WISKEY] then begin
					g_textArea.WriteLn('영혼은 무언가가 외부에서 깨달음을 주지 않으면 스스로 인지하기 어려운 부분들이 많아. '+
										'가장 기본적인 것이 자신이 죽었다는 사실이고, 그 이외에도 많은 것들이 있어. '+
										'지금 당신이 서 있는 옆에 문이 있다고 생각하나? 물론 아니라고 생각할 가능성이 크겠지. '+
										'그 길은 영혼의 눈으로는 쉽게 찾을 수가 없는 영적으로 좁은 문이거든. '+
										'나는 이 거리에서 몇백 년을 살았지만 이 길을 발견한 것은 최근의 일이야. '+
										'그것도 내 능력으로 찾았다기보다는 우연에 가까웠지.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('다시 눈을 뜨고 옆을 보게. 어때? 이제 길이 보이나?');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('<space 키를 누르십시오>', tcHelp);
					g_GameMain.PressAnyKey();

					g_tileMap[21, 19] := OBJ_DOOR_OPEN;
					g_GameMain.UpdateDisplay();

					g_textArea.WriteLn('');
					g_textArea.WriteLn('나는 어떻게 바로 옆에 길을 두고도 나 자신이 깨닫지 못한 것인지 지금으로서는 이해가 안 가. '+
										'지금은 여기에 길이 있다는 것을 알기 때문에 도리어 길이 없다고 여겼을 때로 다시 돌아가지를 못하지. '+
										'아마 자네도 여기에 길이 있다는 것을 영혼에 기억시켰으니 아마 이제는 항상 이 길이 보일걸세.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('이런 길을 보이게 하는 방법에는 두 가지가 있어. '+
										'내가 당신에게 말을 해준 것처럼 외부적 요인으로 깨닫게 되는 것과, 자신의 영적인 눈이 밝아져서 '+
										'스스로 그 길을 찾을 수 있도록 하는 것이지.');
					g_textArea.WriteLn('');

					g_textArea.Write('영적으로 눈이 밝아지려면 글쎄... ... 여러 원로들에게 ');
					g_textArea.Write('영적인 눈', tcMonolog);
					g_textArea.Write('이라고 물어서 다시 깨달음을 얻을 수 밖에 없겠네 그려.');
					g_textArea.WriteLn('');

					g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_HIDDEN_DOOR] := TRUE;
				end
				else begin
					g_textArea.WriteLn('맨입에는 안되지. 나에게 술을 준다면 몰라도.');
				end;
			end;
			g_textArea.WriteLn('');
		end
		else begin
			case Random(3) of
				0:   g_textArea.WriteLn('영혼의 세상에는 거지 팔자가 제일 좋아.');
				1:   g_textArea.WriteLn('뭐라 중얼 거리는지 통 모르겠군.');
				else g_textArea.WriteLn('리홉의 가게에서 예전에는 술도 팔았었는데...');
			end;
			g_textArea.WriteLn('');
		end;
	end
	else begin
		g_textArea.WriteLn('이 메시지가 보이면 가까운 경찰서로 신고해 주세요. 버그입니다.');
		g_textArea.WriteLn();
		g_InputArea.HideCaret;
		g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
	end;
	end;

	if question = KEYWORD_BYE then begin
		g_gameMain.SendCommand(GAME_COMMAND_END_TALK, personalId);
	end;
end;

function EventData04(eventType: TEventType; eventId : integer): boolean;
var
	player: TPlayer;
	equipment: TItem;
begin
	result := TRUE;

	case eventType of
		etOn:
		case eventId of
			1:
			begin
				player := g_tileMap.GetPlayer('도구점의 꼬마');
				if assigned(player) then begin
					player.WarpOnTile(48, 9);
					g_tileMap[player.GetTilePos.x-1, player.GetTilePos.y+0] := OBJ_DOOR_OPEN;
					g_tileMap[player.GetTilePos.x-2, player.GetTilePos.y+1] := OBJ_DOOR_OPEN;
				end;
			end;
			2:
			begin
				g_textArea.WriteLn('눈 앞에는 빈 상자가 보인다.');
				g_textArea.WriteLn('');
				g_textArea.WriteLn('''여기는 대부분의 사람들은 들어 올 수 없는 곳이니 여기다가 물건을 보관해 두면 되겠다.''', tcMonolog);
				g_textArea.ReservedClear();

				g_statusArea.Clear();
				g_statusArea.WriteLn('[Tutorial]', tcEvent);
				g_statusArea.WriteLn('-- ''A''키로 보관함을 사용하자', tcHelp);
				g_statusArea.WriteLn('');
				g_statusArea.WriteLn('TIP: 앞의 빈 상자 앞에서 ''A''키를 누르면 보관함의 기능을 이용할 수 있다.', tcHelp);
			end;
		end;

		etOpen:
		case eventId of
			1:
			begin
			end;
		end;

		etSearch, etSearchQuery:
		case eventId of
			1:
			if not g_tileMap.MapFlag[0, FLAG_GET_DEAD_BOOK] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('책장에는 눈에 띄는 책이 한 권 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('나는 책장에서 책을 빼내었다. 책의 제목은 {사후세계 입문서}이다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[사후세계 입문서 +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_BOOK, ITEM_BOOK_DEAD_WORLD);
					g_tileMap.MapFlag[0, FLAG_GET_DEAD_BOOK] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			2:
			if not g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_KEY] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('책상 서랍에는 열쇠 하나가 들어 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('[열쇠 +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_KEY, 8, 13);
					g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_KEY] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			3:
			if not g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_NOTE] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('책상 위에는 노트 한 권이 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('[노트 +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_BOOK, ITEM_BOOK_LIBRARY_NOTE);
					g_tileMap.MapFlag[0, FLAG_GET_LIBRARY_NOTE] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			4:
			if g_tileMap.MapFlag[0, FLAG_TALK_ABOUT_ORZ_DIARY] and (not g_tileMap.MapFlag[0, FLAG_GET_ORZ_DIARY]) then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('찾기는 좀 힘들지만 책장의 책 중에는 일반 책과는 다른 노트가 하나 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('[책 +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_BOOK, ITEM_BOOK_ORZ_DIARY);
					g_tileMap.MapFlag[0, FLAG_GET_ORZ_DIARY] := TRUE;
				end;
			end
			else begin
				result := FALSE;
			end;
			5: // FLAG_GET_AIR_GUN
			if not g_tileMap.MapFlag[0, FLAG_GET_AIR_GUN] then begin
				if eventType = etSearchQuery then begin
					g_textArea.WriteLn('박스 안에는 조잡한 모형 총과 같이 생긴 것이 들어 있다.');
					g_textArea.WriteLn('');
				end
				else begin
					g_textArea.WriteLn('나는 장난감 총처럼 보이는 것을 집어 들었다.');
					g_textArea.WriteLn('');
					g_textArea.WriteLn('[에어 건 +1]', tcEvent);
					g_textArea.WriteLn('[에어 건 매뉴얼 +1]', tcEvent);
					g_textArea.WriteLn('');

					g_inventory.Add(ITEM_AIR_GUN);
					g_inventory.Add(ITEM_MEMO, ITEM_MEMO_AIR_GUN_MANUAL);
					g_tileMap.MapFlag[0, FLAG_GET_AIR_GUN] := TRUE;

				end;
			end
			else begin
				result := FALSE;
			end;
			6:
			if not TRUE then begin
			end
			else begin
				result := FALSE;
			end;
		end;

		etReadQuery:
		case eventId of
			1:
			begin
				g_textArea.WriteLn('문에는 ''오르츠 사무소''라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
			2:
			begin
				g_textArea.WriteLn('문에는 ''주민 등록 사무소''라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
			3:
			begin
				g_textArea.WriteLn('문에는 ''리홉의 도구점''이라고 적혀있다.');
				g_textArea.WriteLn('');
			end;
		end;

		etAction:
		case eventId of
			1:
			begin
				if g_tileMap.GetPC.Equipment.itemId = ITEM_TV_REMOCON then begin
					g_gameMain.SendCommand(GAME_COMMAND_LOAD_SCRIPT, SCRIPT_DESERT);
				end;
				result := FALSE;
			end;
			2:
			begin
				equipment := g_tileMap.GetPC.Equipment;
				if equipment.itemId > 0 then begin
					g_inventory.Remove(equipment.itemId, equipment.aux1, equipment.aux2);
					//g_backPack.Add(ixEquipment);
				end;
			end;
		end;

		etTime:
		case eventId of
			1:
			begin
			end;
		end;
	end;
end;

end.


'코세르'
코세르? 뭔가 기억 날 듯하면서도 잘 모르겠구만.
else (일기를 보여준다)
음.. 맞아 그 사람의 이름이 코세르였지. 나는 한동안 그의 이름이 생각나지 않아 괴로워 했었거든. 물론 며칠 안되어서 포기해버리고 다른 일에 몰두 했었지.
else ('스캔라인'질문 이후)
그는 이 도시에 사는 사람이 아니야. 사실 그를 잠시 만난 이후로 다시 만난적은 없어. 원로라고 불리는 이곳에 나보다 먼저 온 사람들에게 물어 보면 아마도 그에 대한 실마리를 찾을 수 있을지도 모르겠군. 이곳에서 원로라고 불릴만한 사람은 '@1', '@2', '@3', '@4' 정도의 4명이지. 아, 자네가 만났을 주민등록소의 그분도 원로 중의 한 사람이지.

'스캔라인', '넘어선자'
아.. 요새는 기억력이 많이 나빠져서 말이지 몇 백년 지난 일들은 잘 기억이 안난다네.
else (일기를 보여준다)
(자신의 일기를 읽고 나서) 후.. 그래도 그것이 무엇을 의미하는 지는 모르겠네. 사실 이 세계에서는 망각이 빠른 편이거든. 대부분의 사람들은 자신이 이전 세계에서 무엇을 했는지 어떤 사람이었는지에 대해서 거의 기억을 못하거든? 아무래도 코세르를 찾아서 물어봐야 겠군.

'@1'
그분은 그나마 내가 자주 만나는 사람이라네. 지금은 AVEJ의 중앙 관료 중에 우두머리이지. 도시의 중앙에 있는 중앙집중국에 가면 그를 만날 수 있을걸세.
'@2'
'@3'
'@4'

'중앙집중국'
AVEJ의 중심부에 있는 건물이지.

>> 설정
'@1'은 등록소의 원로와 사이가 좋지 않음. 그래서 그와는 먼곳에 있는 등록소를 관리
'@4'는 실존 유명 사상가 겸 철학가

