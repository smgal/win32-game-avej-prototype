unit UResString;

interface

resourcestring
	ZENIUS = 'Zen_orz';

type
	TWideStringSet = record
		wstrLen: integer;
		wstrData: Pwidestring;
	end;

const
	MAX_RES_PERSON_NOT_FOUND = 3;
	RES_PERSON_NOT_FOUND: array[0..pred(MAX_RES_PERSON_NOT_FOUND)] of widestring =
	(
		'대화를 할만한 사람은 보이지 않는다.',
		'나의 근처에는 아무도 없다.',
		'주위에 말을 걸 수 있는 사람은 없다.'
	);

	MAX_RES_OBJECT_NOT_FOUND = 3;
	RES_OBJECT_NOT_FOUND: array[0..pred(MAX_RES_OBJECT_NOT_FOUND)] of widestring =
	(
		'특별히 눈에 띄는 것이 없다',
		'관심 있어 보이는 것이 눈에 들어오지 않는다.',
		'주위를 둘러봐도 눈에 띄는 것은 없다.'
	);

	MAX_RES_OBJECT_NOT_INTERESTED = 3;
	RES_OBJECT_NOT_INTERESTED: array[0..pred(MAX_RES_OBJECT_NOT_INTERESTED)] of widestring =
	(
		'찾아봐도 별다른 특징이 없다.',
		'그냥 평범해 보인다.',
		'눈에 띄는 점을 발견할 수가 없다.'
	);

	MAX_RES_DESCRIPT_OBJECT_NAME = 1;
	RES_DESCRIPT_OBJECT_NAME: array[0..pred(MAX_RES_DESCRIPT_OBJECT_NAME)] of widestring =
	(
		'이것은 %s.'
	);

// 오르츠의 책
type
	RES_STRING_ORZ_DIARY_PAGE = 1..22;
const
	RES_STRING_ORZ_DIARY_01: array[0..13] of widestring =
	(
		'{> 1일}',
		'',
		'나의 이름은 {오르츠}.',
		'나는 한 달 전에 죽었다.',
		'',
		'정확하게는 24일 전에 죽었다.',
		'아니 23일 전인지도 모르겠다.',
		'',
		'하지만, 언제 죽었느냐는 그리 중요하지 않다.',
		'내가 어떻게 죽었는지도 이젠 생각나지 않는다.',
		'',
		'중요한 것은... 내가 죽어있다는 것을 나 자신이 안다는 것이다.',
		'',
		'오늘부터 일기를 쓰기로 했다. 망각은 빛의 속도로 내 머릿속을 달려 지나간다. '+
		'이 기록을 어느 누구도 보지 못할지 모르지만, 나의 기억이 멀리 사라져 없어지는 것보다는 '+
		'사라지기 전에 글로 남겨 두는 것이 더 좋을 것 같아서다.'
	);
	RES_STRING_ORZ_DIARY_02: array[0..4] of widestring =
	(
		'{> 2일}',
		'',
		'아직 나와 같은 사람은 만나지 못했다. 가끔씩 마주치는 것은 사람인지 환상인지 '+
		'알 수 없는 것들뿐이다. 한때는 그들이 사람의 영혼이었는지는 모르겠지만 이제는 '+
		'힘이 약해져 그 존재감 마저 느끼기 힘들 정도로 쇠약해진 것들이 대부분이었다.',
		'',
		'나는 그들을 도와 주고 싶지만 도와 주는 방법을 알지 못한다.'
	);
	RES_STRING_ORZ_DIARY_03: array[0..4] of widestring =
	(
		'{> 4일}',
		'',
		'오늘 만난 영혼은 여지껏 만난 다른 쇠잔한 영혼들과는 달랐다. 스스로를 영적 존재라고 '+
		'인식하고 있었을뿐만 아니라 그는 나에게 여러 가지를 알려 주었다. '+
		'그다지 새로운 것은 아니었지만 여기가 현실 세계가 아니라는 것과 나는 확실히 죽었다는 것을 '+
		'더욱 더 확신할 수 있는 계기가 되었다.',
		'',
		'그는 ''무엇''인가를 찾는다고 했다. 그것이 나에게는 생소한 단어였기에 정확하게 무엇이었는지 '+
		'기억하지는 못한다. 그를 떠나 보내기는 조금 아쉬웠다. 하지만 앞으로도 더 많은 만남을 기대할 수 '+
		'있을 것이라고 나에게 위로했다.'
	);
	RES_STRING_ORZ_DIARY_04: array[0..2] of widestring =
	(
		'{> 7일}',
		'',
		'한동안 우울했다. 어두운 청색 계통의 단색의 세계가 나에게 어떠한 의미를 가지는지 알 수가 없다. '+
		'여기에서는 딱 두 가지가 존재한다. 그것은 단색의 세계와 고독이다.'
	);
	RES_STRING_ORZ_DIARY_05: array[0..2] of widestring =
	(
		'{> 9일}',
		'',
		'이 세계에 들어와서 가장 감동적인 발견을 했다. '+
		'그것은 꽃이었다. 단색의 세계에서 분명하게 느낄 수 있는 빨간색의 꽃이었다. '+
		'하지만 그것은 땅에 피어 있는 꽃이 아니라 벽에 낙서인 양 그려져 있는 그런 꽃이었다. '+
		'이것을 그린 사람이 누군지는 알 수 없지만 그는 예술가일 것이다. 죽기 전에는 '+
		'아마도 세계적으로 추앙 받는 훌륭한 예술가였을 것이다. 지금 나의 가슴이 뛰고있는 만큼 '+
		'다른 사람들을 감동시켰을 그런 멋진 예술가.'
	);
	RES_STRING_ORZ_DIARY_06: array[0..2] of widestring =
	(
		'{> 12일}',
		'',
		'꽤 먼 곳까지 나왔다. 6일 동안 영적 존재로 보이는 어떤 것도 발견하지 못했다. '+
		'차라리 원래 있던 곳으로 돌아갈까 생각도 해보았다. 하지만 돌아가는 길을 잃어버렸다.'
	);
	RES_STRING_ORZ_DIARY_07: array[0..2] of widestring =
	(
		'{> 13일}',
		'',
		'최근까지도 불이 타고 있었던 흔적을 발견했다. 아마도 누군가가 여기에서 불을 지폈지 않았을까하고 '+
			'생각되었다. 불을 피운다는 의미는 현실 세계에서와는 조금 다른 의미지만 설명을 잘 못하겠다.'
	);
	RES_STRING_ORZ_DIARY_08: array[0..4] of widestring =
	(
		'{> 14일}',
		'',
		'아주 이상한 생물체를 보았다. 다른 것들과 마찬가지로 생명체라기 보다는 영적 존재이지만 그들의 '+
		'모습은 기이하게 보였다. 마치 불타고 있는 듯하면서도 모습은 수시로 변화했다. 형체가 없는 듯하지만 '+
		'그들의 기운은 나에게까지 퍼져나와서 나의 살갗을 따끔 따끔하게 자극하는 느낌을 주었다. (살갗이라고 '+
		'표현하는 것이 맞는지 모르겠지만 적절한 용어가 없다) ',
		'',
		'아마도 그들이 어제의 불을 피운 자국의 주인이 아닐까 생각된다. 일단 그들이 나에게 호의를 '+
		'품고 있는 것 같지는 않아서 들키지 않게 조심스레 그곳을 빠져나왔다.'
	);
	RES_STRING_ORZ_DIARY_09: array[0..2] of widestring =
	(
		'{> 16일}',
		'',
		'오늘은 아주 특별한 날이다. 완전히 나와 같은 영혼을 만났다. 그는 세기도 힘들 정도로 오래 전에 '+
		'이곳에 왔다고 한다. 그의 이름은 {코세르}(Koser). 짧고 뭉퉁한 손가락을 가진 중년의 모습이다. '+
		'그는 살아 있었을 때 엔지니어라고 했다. 단순한 엔지니어는 아니었는지 그의 지식은 해박했고 '+
		'이 세계에 대해서도 아주 조리있게 설명해 주었다. 당분간은 그와 이야기 하면서 내가 이곳에서 어떻게 '+
		'해야하는지를 고민해 봐야 할 것 같다.'
	);
	RES_STRING_ORZ_DIARY_10: array[0..2] of widestring =
	(
		'{> 24일}',
		'',
		'오늘 코세르와 헤어졌다. 그와 같이 있으면서 많은 것을 배웠다. 그리고 내가 여기서 살아가야 하는 목표도 '+
		'얻은 것 같다. 10일 전에 본 기이한 영적 존재에 대한 이야기도 들었다. 그들은 ''엘리멘탈''이라는 것으로 '+
		'또 다른 형태의 유기생명체라고 한다.'
	);
	RES_STRING_ORZ_DIARY_11: array[0..2] of widestring =
	(
		'{> 25일}',
		'',
		'코세르와 헤어진 후 하루를 고민했다. 그가 말한 것 중에서 {스캔 라인을 넘어선 자}에 대한 이야기가 가장 끌렸다. '+
		'그리고 그를 만나게 되면 이 부조화스런 세계의 진실을 알 수 있을 것도 같았다. '+
		'그가 어디 있는지는 모르지만 코세르가 말한 ''도시''의 방향으로 무작정 떠나기로 결정했다. 지금 내 손에는 '+
		'코세르로부터 받은 {파이로전기탄}이 있다. 엘리멘탈로부터 나를 지키기 위한 가장 기본적인 무기라고 한다. '+
		'이것은 엘리멘탈이 군집한 곳에 던져 넣는 것인데, 엘리멘탈 피부 자체의 불에 의해 증폭된 파이로전기로 주위의 '+
		'엘리멘탈을 공격하는 무기라고 한다. 일단은 호신용 이상은 기대하지 않는 것이 좋다고 하니, 이것을 사용할 사태가 발생하지 '+
		'않게 하는 것이 최우선이다.'
	);
	RES_STRING_ORZ_DIARY_12: array[0..2] of widestring =
	(
		'{> 30일}',
		'',
		'며칠을 이동한 끝에 ''도시''에 도착했다. 사람들은 비교적 활기차있었고 동질감 때문인지 대부분 친절했다. '+
		'나는 제일 먼저 꽃을 그릴 줄 아는 예술가를 찾았다. 하지만 금방 포기해버렸다. 대부분의 사람들은 '+
		'꽃이라는 것과 그것의 색깔에 대해서 이해하지 못했다. 어두운 청색의 세계에 길들여진 사람들에게는 '+
		'색깔이라는 것은 전혀 존재하지 않는 개념이 되어버렸다. 사실 나도 점점 색에 대한 기억이 사라져 간다.'
	);
	RES_STRING_ORZ_DIARY_13: array[0..2] of widestring =
	(
		'{> 31일}',
		'',
		'신기하게도 이곳의 사람들은 죽기 전의 세계와 비슷한 도시를 형성하고 공동체를 만들어 놓았다. '+
		'이 도시의 역사를 제대로 기억하는 사람은 전혀 없었다. 다만 기억하기도 어려운 과거에도 이 도시는 '+
		'존재했었고 이곳으로 흘러들어오는 사람들은 그 도시가 정하는 규칙에 맞춰서 살게 되었다. '+
		'나도 지금 그 중의 한 사람이다.'
	);
	RES_STRING_ORZ_DIARY_14: array[0..2] of widestring =
	(
		'{> 32일}',
		'',
		'이 도시는 금방 싫증이 난다. 사람들에겐 미적 감각이 전혀 없다. 이렇게 단조로운 모습의 도시가 '+
		'존재한다는 자체가 죄악이다. 내가 이런 주장을 펼쳐 보았지만 아무도 내가 말하는 것을 이해하지 못한다.'
	);
	RES_STRING_ORZ_DIARY_15: array[0..2] of widestring =
	(
		'{> 35일}',
		'',
		'자기가 이곳에 온지 얼마나 되었는지도 기억하지 못하는 늙은 영혼을 만났다. 그다지 활동적이지도 못하고 '+
		'그 기운은 약해져서 조금 희미하게 보였다. 그와 이야기를 나누면서도 연신 그의 몸에 비쳐 보이는 '+
		'뒤쪽의 풍경을 보곤 했다. 지루했다. 하지만 그에게는 말 상대가 필요했는가 보다.'
	);
	RES_STRING_ORZ_DIARY_16: array[0..2] of widestring =
	(
		'{> 40일}',
		'',
		'많은 사람을 만나보았지만 내가 원하는 답을 얻을 수가 없었다. 모두들 나에게 그냥 이 세계에 익숙해지라고 '+
		'충고했다. 그들은 변화를 원하지 않았다. 갑자기 코세르가 다시 보고 싶어졌다.'
	);
	RES_STRING_ORZ_DIARY_17: array[0..2] of widestring =
	(
		'{> 42일}',
		'',
		'오늘은 두통이 심해서 도시를 많이 둘러보지는 못했다. 주위로부터 들려오는 기묘한 소리에 머리가 터질 지경이다. '+
		'살아 있었을 때의 날짜 개념으로 보면 죽은지 2달이 된 것 같다. 그런데 왜인지, 내가 죽기 전에 무엇을 했었는지가 '+
		'도무지 생각나지 않는다. 무료함을 달래기 위해서라도 이곳에서 직업을 가져야겠다고 생각했다.'
	);
	RES_STRING_ORZ_DIARY_18: array[0..2] of widestring =
	(
		'{> 44일}',
		'',
		'무작정 사람들을 따라 나섰다. 그들이 하는 것은 ''사냥''의 일종이었다. 단순히 즐기기 위해 따라 나선 사람이 '+
		'있는 반면 그것을 삶의 수단으로 하고 있는 사람도 있었다. ''사냥''은 그 이름과는 어울리지 않게 집단으로 '+
		'몰려다니며 ''엘리멘탈''을 궁지에 몰아 넣는 것이었다. 가끔 일부 엘리멘탈은 사납기도 하고 위험해서 '+
		'몇몇의 사람들은 부상을 입기도 했다. 기운을 빼앗긴 엘리멘탈은 사람들에게 흡수되었다. 정확하게 이해가 '+
		'되지는 않지만 엘리멘탈이 지닌 에너지를 자신의 에너지로 만들어 버리는 것이다. 마치 짐승을 잡아서 '+
		'그 고기로 배를 채우는 것과 같은 이치라고도 할 수 있겠다.'
	);
	RES_STRING_ORZ_DIARY_19: array[0..2] of widestring =
	(
		'{> 45일}',
		'',
		'''사냥''은 금방 싫증이 났다. 몇몇 강한 사람들이 대부분의 활약을 독차지 하기 때문에 나와 같은 사람은 '+
		'전혀 도움이 되질 못했다. 배울 점은 많았지만 굳이 위험을 감수하지 않더도 다른 할 일을 찾을 수 있을 것 같다.'
	);
	RES_STRING_ORZ_DIARY_20: array[0..2] of widestring =
	(
		'{> 46일}',
		'',
		'오늘 시작한 일은 도서관의 책을 정리하는 일이다. 전혀 힘든 일도 아니고 머리 회전이 많이 필요한 것은 '+
		'아니지만 책을 읽을 수 있다는 기쁨에 이 일을 선택했다. 이 일이 끝나고 나니 마치 돈과도 같은 금속질의 '+
		'것을 나에게 주었다. 특별히 물어 보지 않아도 이것이 이 도시의 ''화폐''라는 것을 짐작할 수 있었다. '+
		'아마도 다른 일보다는 수입이 적은 것 같았지만 일단 내 힘으로 돈을 번 것에 대해서는 기분이 좋았다. '+
		'사실 이 세계에서는 돈이 그다지 중요하다고 생각되지는 않는다. 배가 고파지지도 않고 배를 채운다는 '+
		'개념 자체도 없다. 하긴 배고픔이란 육체에 종속된 느낌이라 이제는 그런 것을 느끼지 않아도 된다. '+
		'오늘 받은 ''화폐''로 무엇인가 해보려 했지만 할 것이 없었다. 바른대로 말하면 내가 필요한 것이 없다는 '+
		'것이 옳겠다. 분명 사람들은 많은 것을 팔고 있었고 그 중의 일부는 내가 가진 ''화폐''로 살 수 있는 것이었다. '+
		'하지만 그것들은 나에게 무척이나 생소했고 정확에 어디에 쓰이는 것인지 모르기 때문에 섣불리 '+
		'물건을 살 수가 없었다. 일단은 도서관 일을 계속 맡기로 했다.'
	);
	RES_STRING_ORZ_DIARY_21: array[0..2] of widestring =
	(
		'{> 52일}',
		'',
		'생각보다는 일이 많아서 그동안 일기를 쓰지 못했다. 도서관에서 일을 하면 책을 많이 볼 줄 알았는데 '+
		'실상은 그렇지 못했다. 이유인즉, 첫째는 내가 여유가 없었고, 둘째는 책의 대부분에 기록되어 있는 문자를 읽을 수가 '+
		'없다는 것이다. 적어도 이 도시의 역사는 내가 생각한 것보다는 훨씬 오래되었을 것 같다. 문자의 '+
		'종류를 보면 적어도 10가지 이상은 되는 것 같았는데 이것은 지역에 따라 달라진 글자가 아니라 세월에 '+
		'따라 달라진 글자였다. 고대 영어에 쓰인 알파벳 정도도 굉장히 최근 문서로 분류하고 있었다. '+
		'이 세계의 말이란 것은 육체의 귀로 듣는 것이 아니라서 이야기 하고자 하는 내용만 있으면 항상 '+
		'의사소통이 가능하다. 하지만 책의 경우에는 그렇지 않은 것 같다. 종이라는 매체를 통하는 것이기 때문에 '+
		'살아 생전의 문자를 그대로 사용했던 것이 아닐까 생각된다.'
	);
	RES_STRING_ORZ_DIARY_22: array[0..2] of widestring =
	(
		'{> 59일}',
		'',
		'단조롭고 다소 멍청한 것처럼 보이는 이 세계도 나름대로의 원리과 규칙에 의해 운행하고 있다는 확신이 선다. '+
		'나의 지식이 점점 늘어나는 것을 느낄 수 있다. 도서관의 일을 맡기를 잘했다는 생각이 든다. 시간의 여유가 '+
		'어느 정도 생기면 코세르와 함께 이와 관련된 이야기를 진지하게 토론하고 싶다.'
	);

	RES_STRING_ORZ_DIARY: array[low(RES_STRING_ORZ_DIARY_PAGE)..high(RES_STRING_ORZ_DIARY_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_ORZ_DIARY_01); wstrData: @RES_STRING_ORZ_DIARY_01),
		(wstrLen: high(RES_STRING_ORZ_DIARY_02); wstrData: @RES_STRING_ORZ_DIARY_02),
		(wstrLen: high(RES_STRING_ORZ_DIARY_03); wstrData: @RES_STRING_ORZ_DIARY_03),
		(wstrLen: high(RES_STRING_ORZ_DIARY_04); wstrData: @RES_STRING_ORZ_DIARY_04),
		(wstrLen: high(RES_STRING_ORZ_DIARY_05); wstrData: @RES_STRING_ORZ_DIARY_05),
		(wstrLen: high(RES_STRING_ORZ_DIARY_06); wstrData: @RES_STRING_ORZ_DIARY_06),
		(wstrLen: high(RES_STRING_ORZ_DIARY_07); wstrData: @RES_STRING_ORZ_DIARY_07),
		(wstrLen: high(RES_STRING_ORZ_DIARY_08); wstrData: @RES_STRING_ORZ_DIARY_08),
		(wstrLen: high(RES_STRING_ORZ_DIARY_09); wstrData: @RES_STRING_ORZ_DIARY_09),
		(wstrLen: high(RES_STRING_ORZ_DIARY_10); wstrData: @RES_STRING_ORZ_DIARY_10),
		(wstrLen: high(RES_STRING_ORZ_DIARY_11); wstrData: @RES_STRING_ORZ_DIARY_11),
		(wstrLen: high(RES_STRING_ORZ_DIARY_12); wstrData: @RES_STRING_ORZ_DIARY_12),
		(wstrLen: high(RES_STRING_ORZ_DIARY_13); wstrData: @RES_STRING_ORZ_DIARY_13),
		(wstrLen: high(RES_STRING_ORZ_DIARY_14); wstrData: @RES_STRING_ORZ_DIARY_14),
		(wstrLen: high(RES_STRING_ORZ_DIARY_15); wstrData: @RES_STRING_ORZ_DIARY_15),
		(wstrLen: high(RES_STRING_ORZ_DIARY_16); wstrData: @RES_STRING_ORZ_DIARY_16),
		(wstrLen: high(RES_STRING_ORZ_DIARY_17); wstrData: @RES_STRING_ORZ_DIARY_17),
		(wstrLen: high(RES_STRING_ORZ_DIARY_18); wstrData: @RES_STRING_ORZ_DIARY_18),
		(wstrLen: high(RES_STRING_ORZ_DIARY_19); wstrData: @RES_STRING_ORZ_DIARY_19),
		(wstrLen: high(RES_STRING_ORZ_DIARY_20); wstrData: @RES_STRING_ORZ_DIARY_20),
		(wstrLen: high(RES_STRING_ORZ_DIARY_21); wstrData: @RES_STRING_ORZ_DIARY_21),
		(wstrLen: high(RES_STRING_ORZ_DIARY_22); wstrData: @RES_STRING_ORZ_DIARY_22)
	);

// 사후 세계 입문서
type
	RES_STRING_DEAD_WORLD_PAGE = 1..9;
const
	RES_STRING_DEAD_WORLD_01: array[0..2] of widestring =
	(
		'{사후세계의 정의}',
		'',
		'이곳은 육체와 영혼이 합쳐져 있는 세계에서 사후세계라고 부르는 곳이다. 이 책에서는 더 이상 사후세계라는 말을 쓰지 않고 이후부터는 {이곳}이라 칭한다.'
	);
	RES_STRING_DEAD_WORLD_02: array[0..2] of widestring =
	(
		'{이곳의 역사}',
		'',
		'여기가 언제부터 있었는지는 전혀 기록이 없다.'
	);
	RES_STRING_DEAD_WORLD_03: array[0..2] of widestring =
	(
		'{이곳이 현실의 세계와 비슷한 이유}',
		'',
		'사후 세계는 여기에 모인 인간들이 만들어 내는, 실체가 존재하지 않지만 느낄 수 있는 그런 곳이다. '+
		'일단은 죽기 전의 세계가 모델이 되는 것이니 아무래도 죽기 전의 세계와 많이 닮아 있다고 할 수 있다. '+
		'그런데 이것 역시 각자가 느끼는 것은 조금씩 다른데, 어떤 망상가는 이곳이 화성과 같은 붉은 대지의 사막으로 보인다고 한다. 하지만 대부분의 사람은 그렇지 않게 보인다.'
	);
	RES_STRING_DEAD_WORLD_04: array[0..2] of widestring =
	(
		'{이 세상을 이루는 7가지의 속성}',
		'',
		'그것은 각각의 기운이라고 불리는데, 기운의 생성 근거에 의해 3가지로 구분하고 생성 결과에 따라 4가지로 구분한다. '+
		'생성 근거에 의한 속성은 日,月,火가 있고 생성 결과에 따른 속성은 水,木,金,土로 나눈다.'
	);
	RES_STRING_DEAD_WORLD_05: array[0..4] of widestring =
	(
		'{생성 근거에 의한 기운의 속성 <日,月,火>}',
		'',
		'日은 자신 내부의 에너지원을 이용해서 기운을 생성하는 방법이다. 다른 것에 비해 기운의 강도가 쎄지만 '+
		'자신의 에너지를 소모하는 것이라서 언젠가는 수명을 다하게 되는 방법이다. '+
		'그에 비해 月은 자신의 에너지를 전혀 사용하지 않고 외부의 에너지원을 이용해 기운을 생성하는 방법이다. '+
		'외부의 에너지를 그대로 반사하든, 변형을 가하든 간에 자신에게 흡수되지 않고 반사를 통해 기운을 생성하지만 '+
		'주위에 반사할만한 에너지원이 없다면 이것은 사용이 불가능하고, 반사에 의한 기운은 그다지 강하지 '+
		'못하다는 단점이 있다. ',
		'',
		'그리고 마지막으로 火가 있다. 이것은 위의 日과 月의 장단점을 섞어 놓은 것과 같은 형태인데 자신의 내부 에너지원과 '+
		'외부의 에너지원을 결합시키면서 그 결합에 의한 손실되는 에너지로 기운을 생성하는 방법이다. 火는 알게 모르게 '+
		'살아 있었을 때도 육체에서 일어나고 있던 반응인데 그때의 용어로는 산화라고 이해하면 된다. '+
		'산화는 육체가 체온을 가지게 되는 가장 근본적인 이유이지만 영혼에게는 체온을 유지해줘야 할 육체가 없으니 '+
		'火는 단지 기운을 생성하기 위한 한 방법으로만 사용된다.'
	);
	RES_STRING_DEAD_WORLD_06: array[0..4] of widestring =
	(
		'{생성 결과에 의한 기운의 속성 <水, 木, 金, 土>}',
		'',
		'생성 결과에 따라서는 水,木,金,土의 기운으로 나눈다. 이것은 각각 기운의 형태를 말하는 것이다. '+
		'먼저 水는 에너지 밀도가 다른 것에 비해서 낮아서 유동적인 기운이라고 할 수 있다. 자신보다 밀도가 '+
		'높은 것 위에 고이기도 하고 고밀도 에너지 면 위를 흐르기도 하고 에너지 밀도의 틈 사이로 스며들기도 한다. '+
		'木은 土의 기운이 유기체의 형태로 바뀐 것이다. 대표적으로 우리와 같은 형태를 하고 있는 영적 존재는 모두 木의 '+
		'기운이라고 볼 수 있다. 木은 土에서 나왔지만 실제로 계속 에너지를 공급받기 위해서는 水와 같은 유동적인 '+
		'기운을 받아들여서 그것을 다시 내부의 에너지로 재사용 한다. 나중에 기운이 다하면 결국 木은 土로 돌아간다. '+
		'金은 木과 반대로 土의 기운이 무기물로 바뀐 것이다. 金은 이미 에너지의 최종 단계이기 때문에 외부에서 '+
		'에너지 공급을 받을 수도 받을 필요도 없다. 여기서 물질의 형태를 띄는 것들은 모두 金의 기운이라고 '+
		'말할 수 있는데 金의 기운의 정도에 따라 그 느낌이 푹신한 솜의 느낌도 될 수 있고 딱딱한 금속의 느낌이 '+
		'될 수도 있다.',
		'',
		'土는 아주 원시적인 에너지 형태인데 木이나 金으로 성질을 바꿀 수 있는 기본이 되는 기운이라고 할 수 있다. '
	);
	RES_STRING_DEAD_WORLD_07: array[0..2] of widestring =
	(
		'{세상을 보는 방법}',
		'',
		'이 세계에서 불편한 것은 소리를 들을 수 없다는 것이다. 소리를 듣는다는 것이 공기라는 매질을 '+
		'통과하는 특정한 파동을 읽는 것이라서 공기라는 개념도 없고 육체도 없는 이곳에서는 소리를 들을 '+
		'수가 없다. 그대신 육체의 청각 신호와 동일하게 느끼는 것은 있는데 그것을 여기서는 聲이라고 부른다. '+
		'사실 육체가 있을 때에도 청각 신호가 聲으로 변화되어 영혼에 전달된다. 어차피 '+
		'영혼은 聲만 들을 수 있으니까 결과적으로 같은 것이라 불 수 있다. 聲은 특별한 매질이 필요없다. 빛에 매질이 필요없 듯이 '+
		'聲은 입자도 아니고 파동도 아니게 전달된다. 빛이 공간으로 확산되면 거리에 따라 그 빛이 약해지듯이 '+
		'聲도 거리가 멀어지면 거리의 제곱에 비례해서 그 정도가 약해진다. 聲을 발생하는 근원은 '+
		'에너지의 변환이다. 물건끼리 부딪히면서 聲이 생기는 생기는 것도 한 예인데, 움직이던 에너지가 '+
		'정지해버리거나 속도가 줄어들면서 남은 에너지는 聲의 형태로 확산된다. 그리고 우리가 직접 에너지를 '+
		'사용해서 만들 수도 있다. 그것은 마치 매미가 날개를 비비면서 소리는 내는 것에 비유할 수 있다. '+
		'자신이 가진 에너지를 소비해서 그것을 소리로 변화시키는 과정이라는 점이 동일하기 때문이다.'
	);

	RES_STRING_DEAD_WORLD_08: array[0..10] of widestring =
	(
		'{킨델 슈타이너 법칙}',
		'',
		'2차원의 동차 공간을 ''주파수가 다른 파동의 합''으로 정의한 킨델의 법칙을 발전시켜, '+
		'훗날 슈타이너가 하나의 차원 파라미터를 추가하는 방식으로 역변환을 해석했다. ' +
		'이것을 ''킨델 슈타이너 법칙''이라고 한다.',
		'',
		'이 법칙의 응용은 무궁무진한데, 그중의 하나가 2차원적인 공간 이동을 가능하게 하는 것이다. 공간 이동은 아래의 3단계를 거쳐야 한다.',
		'',
		'1. 2차원 공간을 파동의 집합으로 변환',
		'2. 파동들에 대한 주파수 천이를 행한 후 역변환',
		'3. 2차원 공간 상의 위치 이동',
		'',
		'이 방식은 시간 천이를 동반하는 것이 일반적이며, 천이 정도는 공간 상의 2개의 실수 축과 '+
		'하나의 허수 축에 대한 이동 벡터의 크기에 비례한다.'
	);

	RES_STRING_DEAD_WORLD_09: array[0..4] of widestring =
	(
		'{인지(recognition)}',
		'',
		'이 능력은 일반적으로 지력에 비례한다. 영혼체가 되면 사용하지 않는 부분의 지력은 점점 감소하게 되며 깨닫지 못하면 인지하지 못하는 것이 일반적이다.',
		'',
		'늘 지나다니던 길인데도 아주 뒤에야 우연하게 길 옆에 쪽문이 있다는 것을 알아차린 적이 있는가? '+
		'쪽문은 항상 그 자리에 있었지만 당신이 알아차리지 못한 것은 당신이 거기에 관심이 없었기 때문이다. '+
		'사후 세계에서도 이것과 마찬가지다. 도리어 이곳에서는 聲을 통해 주위를 보기 때문에 알아차리기 위한 감각은 '+
		'도리어 떨어진다고 할 수 있다. 이럴 때는 스스로 알아차리든지 누군가가 알려준다면 당신은 거기에 관심을 가지게 되고 '+
		'비로소 聲을 통해 감지가 가능하다. 그렇지 않으면 관심이 없기 때문에 보이지 않는다.'
	);

	RES_STRING_DEAD_WORLD: array[low(RES_STRING_DEAD_WORLD_PAGE)..high(RES_STRING_DEAD_WORLD_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_DEAD_WORLD_01); wstrData: @RES_STRING_DEAD_WORLD_01),
		(wstrLen: high(RES_STRING_DEAD_WORLD_02); wstrData: @RES_STRING_DEAD_WORLD_02),
		(wstrLen: high(RES_STRING_DEAD_WORLD_03); wstrData: @RES_STRING_DEAD_WORLD_03),
		(wstrLen: high(RES_STRING_DEAD_WORLD_04); wstrData: @RES_STRING_DEAD_WORLD_04),
		(wstrLen: high(RES_STRING_DEAD_WORLD_05); wstrData: @RES_STRING_DEAD_WORLD_05),
		(wstrLen: high(RES_STRING_DEAD_WORLD_06); wstrData: @RES_STRING_DEAD_WORLD_06),
		(wstrLen: high(RES_STRING_DEAD_WORLD_07); wstrData: @RES_STRING_DEAD_WORLD_07),
		(wstrLen: high(RES_STRING_DEAD_WORLD_08); wstrData: @RES_STRING_DEAD_WORLD_08),
		(wstrLen: high(RES_STRING_DEAD_WORLD_09); wstrData: @RES_STRING_DEAD_WORLD_09)
	);

// 도서관 노트
type
	RES_STRING_LIBRARY_NOTE_PAGE = 1..1;
const
	RES_STRING_LIBRARY_NOTE_01: array[0..0] of widestring =
	(
		'각 날짜별로 도서관 책의 출납에 대한 것이 적혀 있다. 그다지 특별한 책은 아니다.'
	);

	RES_STRING_LIBRARY_NOTE: array[low(RES_STRING_LIBRARY_NOTE_PAGE)..high(RES_STRING_LIBRARY_NOTE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_LIBRARY_NOTE_01); wstrData: @RES_STRING_LIBRARY_NOTE_01)
	);

// 렌더즈
type
	RES_STRING_RENDERZ_PAGE = 1..3;
const
	RES_STRING_RENDERZ_01: array[0..4] of widestring =
	(
		'Corexis elm Hydios Ine.',
		'',
		'Dyrucsus Vizkwa Karo ita Inehent elm Shemass.',
		'',
		'Zecan elm Lenderz am Twara elm Qatz rar Ine Tbem Shenp ita Favoke Karo deyeentzel, '+
		'Betuirogani em Xemop Gruk Ieros Qeska Fytoekkwa Sreina elm Irogani desimos Lenderz elm Celmoskwa Shyqwess un sherrok mana Greysaltorkwa Kuhelopa Zaspha elm Kezakyake cellm Pavosaru Ruster irua getuplema nasse Gruk Iomof am Grualite yeen defytoek. '+
		'Tebess Kurfoclass ita Nufi Talon Zellotta surres Lustinkwa Umrey am Wathekwa Vetro jerros Jetu Irogani irua Inehent elm Kalisess Gruk Ieros am Karo desuba. '+
		'Betumrey elm Theles em Nesta Zecan elm Lenderz ita Destuskwa Bacellom rem Tbara desimos mana Betuss em Tazem Ekwa irua Guknfrunkwa Ineumrey elm Gruk Iomof un Lyapha ubalma Chelakwa Bacellom rem Nyael Ruphas desuba. '+
		'Betuss em Destuskwa Gruk Iomof un Seine ubaem Cnema gaaz hwara ubalma qeska deyeen mana betumop am Jetu Bluearu irua Karokwa Inehent elm Kalismop imos mana Kalismopess desimos. '+
		'ManaBetu Cnemass em Betu Vetro Nufi Kamn Zellotta varri Iomofkalis, Shraykalis, Shenparukalis Jamuss Ruster Kalismop elm Gelopelite Twararukn un Veheche desuba. '
	);
	RES_STRING_RENDERZ_02: array[0..0] of widestring =
	(
		'Betuss am Geterikenkwa Passara em Roks irua deguknfrun mana Twararukn irua Guknfrunkwa Iomofkalis Halo rem Iomofkalis Tomkuwa KETEIR un Muraba dehammu. '+
		'Betuss em Kemshe un DAGON deborren mana Plegmaakwa Gruk Iomof un Seine ubalma IROC Eteka elm Iomofkalis un Ruphas dehammu pessa Betus em Whema elm Iomof un Shruss Thellakwa Vassem Messo Pyashess un decemuuhammu mana Fetta Pavosaru Ruster '+
			'un Shemas hammu fyto Iomofess am Cnemirogani rar Yakewa deyeen. '+
		'Messo Jekwass un gekuma Yakewakwa Pavosess elm Iomof em Pavosaru Shema elm Loobe rem jamota deyeen mana, Jetu irua Bepoll Inepemo elm Kaliswhema imos mana takar Iomofkaliswhema desimosnasse {IROGANISS elm ZEKUWA} em Whema am Karokwa TRIKUWA '+
			'Eteka elm Ezak Iomofkalis un Seine ubalma Bluearu un Trikuwa irua tolem hammu desuba. '+
		'Alma Lenderz elm Shema em devumovas pessa DAGON Cnema elm Shemass em yumovas defytoek.'
	);

	RES_STRING_RENDERZ_03: array[0..0] of widestring =
	(
		'그 뒤의 내용은 찢겨져 나가 있다.'
	);

	RES_STRING_RENDERZ: array[low(RES_STRING_RENDERZ_PAGE)..high(RES_STRING_RENDERZ_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_RENDERZ_01); wstrData: @RES_STRING_RENDERZ_01),
		(wstrLen: high(RES_STRING_RENDERZ_02); wstrData: @RES_STRING_RENDERZ_02),
		(wstrLen: high(RES_STRING_RENDERZ_03); wstrData: @RES_STRING_RENDERZ_03)
	);

// DERIKUS
type
	RES_STRING_DERIKUS_PAGE = 1..1;
const
	RES_STRING_DERIKUS_01: array[0..2] of widestring =
	(
		'{DERIKUS}',
		'',
		'''진화''라는 뜻의 ''DERIK''에서 발전한 이름에서 알 수 있듯이 이 데릭커스는 자신의 일생동안 자기 진화를 거듭하는 매우 희귀한 생명체이다. '+
			'데릭커스의 진화 단계는 크게 유생체, 성체, 신성체로 나눌 수가 있다. '+
			'유생체의 경우에는 회색의 30cm정도되는 몸체에 2-3m의 꼬리와 날개가 달려 있고 진화의 초기단계라서 외부 에너지를 흡수하여 자기 동화를 시키게 된다. '+
			'성체의 경우 꼬리는 유생체와 같이 2-3m이며 몸체의 크기는 10-15m정도가 된다. '+
			'유생체에서 성체로의 진화 과정은 일정 에너지 수준에 도달한 유생체에 의한 에너지 방출로 이루어진다고 생각되어진다. '+
			'그리고 신성체는 진화의 마지막 단계로, 자신의 형체, 이루는 물질등등을 마음대로 바꿀수 있는 형태이며, 각 인종을 능가하는 지식과 지능, 마법력을 가진다고 전해진다. '+
			'일반적인 고서에 적힌 기록과 생각으로는 데릭커스는 흑마법사들의 분신 혹은 종이라 생각되어진다'
	);

	RES_STRING_DERIKUS: array[low(RES_STRING_DERIKUS_PAGE)..high(RES_STRING_DERIKUS_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_DERIKUS_01); wstrData: @RES_STRING_DERIKUS_01)
	);

// Albireo
type
	RES_STRING_ALBIREO_PAGE = 1..2;
const
	RES_STRING_ALBIREO_01: array[0..2] of widestring =
	(
		'{Albireo the Timewalker}',
		'',
		'그가 어느 시간대에 태어나고 어느 공간에서 자라왔는지 아는 사람은 없다. 그가 어떻게 시간을 초월하는 마법을 알게되었는지도 알려지지 않았다. '+
			'하지만 그는 ''타임워커''라는 그의 또다른 이름이 세상에 알려지기 전부터 많은 시간과 공간을 떠돌면서 여행을 하였다고 전해질 뿐이다. '+
			'어떤 사람은 그가 세상을 구원하는 절대신이라고도 했고, 또 어떤 사람은 그가 세상을 창조해낸 조물주일 것이라고 했다. '+
			'하지만 그 사실이 어떻든 우리에게는 별로 중요하지가 않다. 단지 그가 많은 사람들로부터 칭송받는 인물임에는 틀림없다는 것이고 세상의 역사에 긍정적으로 개입해주는 훌륭한 중재자라는데 있다.'
	);

	RES_STRING_ALBIREO_02: array[0..0] of widestring =
	(
		'그는 일찍이 우리가 있는 지금 이 공간에서 많은 역할을 해주었다. 태고 때부터 이 ''렌더즈(Lenderz)''를 주시해 왔던 카이나 클레나(CAINA CRENA)라고 불리우는 정보 기록체의 칼리스(KALIS)어 기록에 의하면 크게 두 번을 역사에 관여한 것으로 나와 있다. '+
			'그 첫번째는 다곤(DAGON)이라는 생명체가 스스로의 힘에 의해 멸망한 후 후만(HUMAN)이라는 생명체가 세상의 지배자로 나서기 시작했을 때, 로어(LORE)라고 불리우는 전제 군주국의 역사에 100년 정도 그 영향을 미친 것으로 기록되어 있다. '+
			'그리고 두번째는 후만(HUMAN)이 멸망한 후 살아남은 후손들로 인해 다시 렌더즈가 죽음의 별로 바뀌었을 때 나타났었다고 한다.'
	);

	RES_STRING_ALBIREO: array[low(RES_STRING_ALBIREO_PAGE)..high(RES_STRING_ALBIREO_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_ALBIREO_01); wstrData: @RES_STRING_ALBIREO_01),
		(wstrLen: high(RES_STRING_ALBIREO_02); wstrData: @RES_STRING_ALBIREO_02)
	);

////////////////////////////////////////////////////////////////////////////////

// 제작자의 메모
type
	RES_STRING_MY_MESSAGE_PAGE = 1..1;
const
	RES_STRING_MY_MESSAGE_01: array[0..2] of widestring =
	(
		'이 게임은 {비전속으로}라는 게임을 만들어낸 지 딱 10년째 되는 날을 자축하는 의미에서 만드는 것입니다. '+
		'너무나 게임이 만들고 싶었지만 군대라는 특수한 곳에 소속되어 있던 시절이라 게임을 만드는 것은 거의 불가능했습니다. '+
		'유일한 희망은 상병이 되면 받는 15일짜리 첫 휴가. 그 15일 동안 게임을 완성시키기 위해서는 그만큼 완벽한 기획서가 필요했습니다. '+
		'고참들의 눈을 피해 야간 근무 복귀한 후 새벽에 계속 기획서와 시나리오를 써나갔습니다. 모눈종이에 맵을 그리고 주사위로 시뮬레이션을 해서 게임의 레벨링을 했습니다. '+
		'그러기를 4개월... 15일 동안 만들 수 있는 게임의 분량만큼의 기획이 되었고 그렇게 고대하던 첫 휴가를 맞이하게 되었습니다. '+
		'원래의 기획을 조금 줄여 12일 만에 게임을 만들어 하이텔 자료실에 올렸습니다. 그때가 1995년 2월 13일. 딱 10년 전의 오늘이었습니다. ',
		'',
		'그 후 바로 군대에 복귀했기 때문에 게임이 어느 정도의 반응이 있었는지는 모릅니다. 사실 그것은 그다지 중요하지 않았습니다. '+
		'게임을 만들었다는 성취감만으로도 행복했기 때문입니다. 지금은 게임과는 관련없는 일을 합니다. 그리고 이제는 배고프지 않을 정도로 살아가고 있습니다. '+
		'게다가 이제는 발 뺄 수 없을 정도로 깊이 발을 담구었습니다. 그래서 이제는 게임 제작자가 아닙니다. '+
		'{하지만, 돌아갈 수 없는 꿈을 좇기에 이 게임을 만듭니다.}'
	);

	RES_STRING_MY_MESSAGE: array[low(RES_STRING_MY_MESSAGE_PAGE)..high(RES_STRING_MY_MESSAGE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_MY_MESSAGE_01); wstrData: @RES_STRING_MY_MESSAGE_01)
	);

// 에어 건 매뉴얼
type
	RES_STRING_AIR_GUN_MANUAL_PAGE = 1..1;
const
	RES_STRING_AIR_GUN_MANUAL_01: array[0..5] of widestring =
	(
'본 제품은 자녀들의 꿈을 심어주는 기업 ''디에손사''에서 만든 최신 에어 건입니다. 본체는 에어 카트리지에 의한 공기 압축으로 플라스틱 탄을 발사하도록 구성되어진 모델 건입니다. (에어 카트리지는 별매입니다)',
'',
'사용자의 부주의한 사용이나, 본 제품의 개조로 인한 사고 발생시 당사는 책임지지 않습니다.',
'',
'주의: {사람을 향해서 쏘지 말 것}',
'사용 연령: 8세 이상'
	);

	RES_STRING_AIR_GUN_MANUAL: array[low(RES_STRING_AIR_GUN_MANUAL_PAGE)..high(RES_STRING_AIR_GUN_MANUAL_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_AIR_GUN_MANUAL_01); wstrData: @RES_STRING_AIR_GUN_MANUAL_01)
	);

// PROCRETE 메모
type
	RES_STRING_PROCRETE_PAGE = 1..1;
const
	RES_STRING_PROCRETE_01: array[0..5] of widestring =
	(
		'{PROCRETE}',
		'',
		'Dor COROIe ESPILe DYREia HORZOT un ASOADUrio BYSYEsion Dor KOAri Shori OCHESYAe ESKISSsion HORYsion PORIOSnu ISHUsine OISLOzya??',
		'',
		'* KALEXia DESKOIER',
		'	  CAINA - CRENA *'
	);

	RES_STRING_PROCRETE: array[low(RES_STRING_PROCRETE_PAGE)..high(RES_STRING_PROCRETE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_PROCRETE_01); wstrData: @RES_STRING_PROCRETE_01)
	);

// 시작 메시지
type
	RES_STRING_START_MESSAGE_PAGE = 1..1;
const
	RES_STRING_START_MESSAGE_01: array[0..7] of widestring =
	(
		'@버전정보',
		'',
		'AVEJ 1편 (미완성) 2005/08/28 버전',
		'',
		'@제작 사이트 및 e-mail',
		'',
		'제작사이트: http://avej.com',
		'제작자: 안영기(smgal@avej.com)'
	);

	RES_STRING_START_MESSAGE: array[low(RES_STRING_START_MESSAGE_PAGE)..high(RES_STRING_START_MESSAGE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_START_MESSAGE_01); wstrData: @RES_STRING_START_MESSAGE_01)
	);

// F1 메시지
type
	RES_STRING_HELP_MESSAGE_PAGE = 1..1;
const
	RES_STRING_HELP_MESSAGE_01: array[0..19] of widestring =
	(
		'@게임에 사용되는 키',
		'',
		'--------------------------------------------',
		'[q] quickly look around - 주위의 물체를 본다',
		'[a] accept - 선택된 물체를 자세히 본다',
		'',
		'[s] search - 주위의 물체를 조사한다',
		'[a] aquire - 선택된 물체를 가진다',
		'',
		'[w] who    - 대화 가능한 상대를 찾는다',
		'[a] accept - 대화를 시작한다',
		'',
		'[z], [Shift+z] 손에 든 물건을 바꾼다',
		'[a] action - 손에 든 물건으로 행동을 취한다',
		'',
		'[Esc] escape - 게임을 저장하고 빠져 나간다',
		'[Ctrl+n] new game - 게임을 처음부터 시작한다',
		'[F1] 지금 보고 있는 도움말',
		'[F2] 모니터 시뮬레이션 모드를 바꾼다',
		'--------------------------------------------'
	);

	RES_STRING_HELP_MESSAGE: array[low(RES_STRING_HELP_MESSAGE_PAGE)..high(RES_STRING_HELP_MESSAGE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_HELP_MESSAGE_01); wstrData: @RES_STRING_HELP_MESSAGE_01)
	);

implementation

end.

