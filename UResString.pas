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
		'��ȭ�� �Ҹ��� ����� ������ �ʴ´�.',
		'���� ��ó���� �ƹ��� ����.',
		'������ ���� �� �� �ִ� ����� ����.'
	);

	MAX_RES_OBJECT_NOT_FOUND = 3;
	RES_OBJECT_NOT_FOUND: array[0..pred(MAX_RES_OBJECT_NOT_FOUND)] of widestring =
	(
		'Ư���� ���� ��� ���� ����',
		'���� �־� ���̴� ���� ���� ������ �ʴ´�.',
		'������ �ѷ����� ���� ��� ���� ����.'
	);

	MAX_RES_OBJECT_NOT_INTERESTED = 3;
	RES_OBJECT_NOT_INTERESTED: array[0..pred(MAX_RES_OBJECT_NOT_INTERESTED)] of widestring =
	(
		'ã�ƺ��� ���ٸ� Ư¡�� ����.',
		'�׳� ����� ���δ�.',
		'���� ��� ���� �߰��� ���� ����.'
	);

	MAX_RES_DESCRIPT_OBJECT_NAME = 1;
	RES_DESCRIPT_OBJECT_NAME: array[0..pred(MAX_RES_DESCRIPT_OBJECT_NAME)] of widestring =
	(
		'�̰��� %s.'
	);

// �������� å
type
	RES_STRING_ORZ_DIARY_PAGE = 1..22;
const
	RES_STRING_ORZ_DIARY_01: array[0..13] of widestring =
	(
		'{> 1��}',
		'',
		'���� �̸��� {������}.',
		'���� �� �� ���� �׾���.',
		'',
		'��Ȯ�ϰԴ� 24�� ���� �׾���.',
		'�ƴ� 23�� �������� �𸣰ڴ�.',
		'',
		'������, ���� �׾����Ĵ� �׸� �߿����� �ʴ�.',
		'���� ��� �׾������� ���� �������� �ʴ´�.',
		'',
		'�߿��� ����... ���� �׾��ִٴ� ���� �� �ڽ��� �ȴٴ� ���̴�.',
		'',
		'���ú��� �ϱ⸦ ����� �ߴ�. ������ ���� �ӵ��� �� �Ӹ����� �޷� ��������. '+
		'�� ����� ��� ������ ���� ������ ������, ���� ����� �ָ� ����� �������� �ͺ��ٴ� '+
		'������� ���� �۷� ���� �δ� ���� �� ���� �� ���Ƽ���.'
	);
	RES_STRING_ORZ_DIARY_02: array[0..4] of widestring =
	(
		'{> 2��}',
		'',
		'���� ���� ���� ����� ������ ���ߴ�. ������ ����ġ�� ���� ������� ȯ������ '+
		'�� �� ���� �͵���̴�. �Ѷ��� �׵��� ����� ��ȥ�̾������� �𸣰����� ������ '+
		'���� ������ �� ���簨 ���� ������ ���� ������ ������� �͵��� ��κ��̾���.',
		'',
		'���� �׵��� ���� �ְ� ������ ���� �ִ� ����� ���� ���Ѵ�.'
	);
	RES_STRING_ORZ_DIARY_03: array[0..4] of widestring =
	(
		'{> 4��}',
		'',
		'���� ���� ��ȥ�� ������ ���� �ٸ� ������ ��ȥ����� �޶���. �����θ� ���� ������ '+
		'�ν��ϰ� �־����Ӹ� �ƴ϶� �״� ������ ���� ������ �˷� �־���. '+
		'�״��� ���ο� ���� �ƴϾ����� ���Ⱑ ���� ���谡 �ƴ϶�� �Ͱ� ���� Ȯ���� �׾��ٴ� ���� '+
		'���� �� Ȯ���� �� �ִ� ��Ⱑ �Ǿ���.',
		'',
		'�״� ''����''�ΰ��� ã�´ٰ� �ߴ�. �װ��� �����Դ� ������ �ܾ�⿡ ��Ȯ�ϰ� �����̾����� '+
		'��������� ���Ѵ�. �׸� ���� ������� ���� �ƽ�����. ������ �����ε� �� ���� ������ ����� �� '+
		'���� ���̶�� ������ �����ߴ�.'
	);
	RES_STRING_ORZ_DIARY_04: array[0..2] of widestring =
	(
		'{> 7��}',
		'',
		'�ѵ��� ����ߴ�. ��ο� û�� ������ �ܻ��� ���谡 ������ ��� �ǹ̸� �������� �� ���� ����. '+
		'���⿡���� �� �� ������ �����Ѵ�. �װ��� �ܻ��� ����� ���̴�.'
	);
	RES_STRING_ORZ_DIARY_05: array[0..2] of widestring =
	(
		'{> 9��}',
		'',
		'�� ���迡 ���ͼ� ���� �������� �߰��� �ߴ�. '+
		'�װ��� ���̾���. �ܻ��� ���迡�� �и��ϰ� ���� �� �ִ� �������� ���̾���. '+
		'������ �װ��� ���� �Ǿ� �ִ� ���� �ƴ϶� ���� ������ �� �׷��� �ִ� �׷� ���̾���. '+
		'�̰��� �׸� ����� �������� �� �� ������ �״� �������� ���̴�. �ױ� ������ '+
		'�Ƹ��� ���������� �߾� �޴� �Ǹ��� ���������� ���̴�. ���� ���� ������ �ٰ��ִ� ��ŭ '+
		'�ٸ� ������� ���������� �׷� ���� ������.'
	);
	RES_STRING_ORZ_DIARY_06: array[0..2] of widestring =
	(
		'{> 12��}',
		'',
		'�� �� ������ ���Դ�. 6�� ���� ���� ����� ���̴� � �͵� �߰����� ���ߴ�. '+
		'���� ���� �ִ� ������ ���ư��� ������ �غ��Ҵ�. ������ ���ư��� ���� �Ҿ���ȴ�.'
	);
	RES_STRING_ORZ_DIARY_07: array[0..2] of widestring =
	(
		'{> 13��}',
		'',
		'�ֱٱ����� ���� Ÿ�� �־��� ������ �߰��ߴ�. �Ƹ��� �������� ���⿡�� ���� ������ �ʾ������ϰ� '+
			'�����Ǿ���. ���� �ǿ�ٴ� �ǹ̴� ���� ���迡���ʹ� ���� �ٸ� �ǹ����� ������ �� ���ϰڴ�.'
	);
	RES_STRING_ORZ_DIARY_08: array[0..4] of widestring =
	(
		'{> 14��}',
		'',
		'���� �̻��� ����ü�� ���Ҵ�. �ٸ� �͵�� ���������� ����ü��� ���ٴ� ���� ���������� �׵��� '+
		'����� �����ϰ� ������. ��ġ ��Ÿ�� �ִ� ���ϸ鼭�� ����� ���÷� ��ȭ�ߴ�. ��ü�� ���� �������� '+
		'�׵��� ����� �����Ա��� �������ͼ� ���� �찯�� ���� �����ϰ� �ڱ��ϴ� ������ �־���. (�찯�̶�� '+
		'ǥ���ϴ� ���� �´��� �𸣰����� ������ �� ����) ',
		'',
		'�Ƹ��� �׵��� ������ ���� �ǿ� �ڱ��� ������ �ƴұ� �����ȴ�. �ϴ� �׵��� ������ ȣ�Ǹ� '+
		'ǰ�� �ִ� �� ������ �ʾƼ� ��Ű�� �ʰ� ���ɽ��� �װ��� �������Դ�.'
	);
	RES_STRING_ORZ_DIARY_09: array[0..2] of widestring =
	(
		'{> 16��}',
		'',
		'������ ���� Ư���� ���̴�. ������ ���� ���� ��ȥ�� ������. �״� ���⵵ ���� ������ ���� ���� '+
		'�̰��� �Դٰ� �Ѵ�. ���� �̸��� {�ڼ���}(Koser). ª�� ������ �հ����� ���� �߳��� ����̴�. '+
		'�״� ��� �־��� �� �����Ͼ��� �ߴ�. �ܼ��� �����Ͼ�� �ƴϾ����� ���� ������ �ع��߰� '+
		'�� ���迡 ���ؼ��� ���� �����ְ� ������ �־���. ��а��� �׿� �̾߱� �ϸ鼭 ���� �̰����� ��� '+
		'�ؾ��ϴ����� ����� ���� �� �� ����.'
	);
	RES_STRING_ORZ_DIARY_10: array[0..2] of widestring =
	(
		'{> 24��}',
		'',
		'���� �ڼ����� �������. �׿� ���� �����鼭 ���� ���� �����. �׸��� ���� ���⼭ ��ư��� �ϴ� ��ǥ�� '+
		'���� �� ����. 10�� ���� �� ������ ���� ���翡 ���� �̾߱⵵ �����. �׵��� ''������Ż''�̶�� ������ '+
		'�� �ٸ� ������ �������ü��� �Ѵ�.'
	);
	RES_STRING_ORZ_DIARY_11: array[0..2] of widestring =
	(
		'{> 25��}',
		'',
		'�ڼ����� ����� �� �Ϸ縦 ����ߴ�. �װ� ���� �� �߿��� {��ĵ ������ �Ѿ ��}�� ���� �̾߱Ⱑ ���� ���ȴ�. '+
		'�׸��� �׸� ������ �Ǹ� �� ����ȭ���� ������ ������ �� �� ���� �͵� ���Ҵ�. '+
		'�װ� ��� �ִ����� ������ �ڼ����� ���� ''����''�� �������� ������ ������� �����ߴ�. ���� �� �տ��� '+
		'�ڼ����κ��� ���� {���̷�����ź}�� �ִ�. ������Ż�κ��� ���� ��Ű�� ���� ���� �⺻���� ������ �Ѵ�. '+
		'�̰��� ������Ż�� ������ ���� ���� �ִ� ���ε�, ������Ż �Ǻ� ��ü�� �ҿ� ���� ������ ���̷������ ������ '+
		'������Ż�� �����ϴ� ������ �Ѵ�. �ϴ��� ȣ�ſ� �̻��� ������� �ʴ� ���� ���ٰ� �ϴ�, �̰��� ����� ���°� �߻����� '+
		'�ʰ� �ϴ� ���� �ֿ켱�̴�.'
	);
	RES_STRING_ORZ_DIARY_12: array[0..2] of widestring =
	(
		'{> 30��}',
		'',
		'��ĥ�� �̵��� ���� ''����''�� �����ߴ�. ������� ���� Ȱ�����־��� ������ �������� ��κ� ģ���ߴ�. '+
		'���� ���� ���� ���� �׸� �� �ƴ� �������� ã�Ҵ�. ������ �ݹ� �����ع��ȴ�. ��κ��� ������� '+
		'���̶�� �Ͱ� �װ��� ���� ���ؼ� �������� ���ߴ�. ��ο� û���� ���迡 ��鿩�� ����鿡�Դ� '+
		'�����̶�� ���� ���� �������� �ʴ� ������ �Ǿ���ȴ�. ��� ���� ���� ���� ���� ����� ����� ����.'
	);
	RES_STRING_ORZ_DIARY_13: array[0..2] of widestring =
	(
		'{> 31��}',
		'',
		'�ű��ϰԵ� �̰��� ������� �ױ� ���� ����� ����� ���ø� �����ϰ� ����ü�� ����� ���Ҵ�. '+
		'�� ������ ���縦 ����� ����ϴ� ����� ���� ������. �ٸ� ����ϱ⵵ ����� ���ſ��� �� ���ô� '+
		'�����߾��� �̰����� �귯������ ������� �� ���ð� ���ϴ� ��Ģ�� ���缭 ��� �Ǿ���. '+
		'���� ���� �� ���� �� ����̴�.'
	);
	RES_STRING_ORZ_DIARY_14: array[0..2] of widestring =
	(
		'{> 32��}',
		'',
		'�� ���ô� �ݹ� ������ ����. ����鿡�� ���� ������ ���� ����. �̷��� �����ο� ����� ���ð� '+
		'�����Ѵٴ� ��ü�� �˾��̴�. ���� �̷� ������ ���� �������� �ƹ��� ���� ���ϴ� ���� �������� ���Ѵ�.'
	);
	RES_STRING_ORZ_DIARY_15: array[0..2] of widestring =
	(
		'{> 35��}',
		'',
		'�ڱⰡ �̰��� ���� �󸶳� �Ǿ������� ������� ���ϴ� ���� ��ȥ�� ������. �״��� Ȱ���������� ���ϰ� '+
		'�� ����� �������� ���� ����ϰ� ������. �׿� �̾߱⸦ �����鼭�� ���� ���� ���� ���� ���̴� '+
		'������ ǳ���� ���� �ߴ�. �����ߴ�. ������ �׿��Դ� �� ��밡 �ʿ��ߴ°� ����.'
	);
	RES_STRING_ORZ_DIARY_16: array[0..2] of widestring =
	(
		'{> 40��}',
		'',
		'���� ����� ������������ ���� ���ϴ� ���� ���� ���� ������. ��ε� ������ �׳� �� ���迡 �ͼ�������� '+
		'����ߴ�. �׵��� ��ȭ�� ������ �ʾҴ�. ���ڱ� �ڼ����� �ٽ� ���� �;�����.'
	);
	RES_STRING_ORZ_DIARY_17: array[0..2] of widestring =
	(
		'{> 42��}',
		'',
		'������ ������ ���ؼ� ���ø� ���� �ѷ������� ���ߴ�. �����κ��� ������� �⹦�� �Ҹ��� �Ӹ��� ���� �����̴�. '+
		'��� �־��� ���� ��¥ �������� ���� ������ 2���� �� �� ����. �׷��� ������, ���� �ױ� ���� ������ �߾������� '+
		'������ �������� �ʴ´�. �������� �޷��� ���ؼ��� �̰����� ������ �����߰ڴٰ� �����ߴ�.'
	);
	RES_STRING_ORZ_DIARY_18: array[0..2] of widestring =
	(
		'{> 44��}',
		'',
		'������ ������� ���� ������. �׵��� �ϴ� ���� ''���''�� �����̾���. �ܼ��� ���� ���� ���� ���� ����� '+
		'�ִ� �ݸ� �װ��� ���� �������� �ϰ� �ִ� ����� �־���. ''���''�� �� �̸����� ��︮�� �ʰ� �������� '+
		'�����ٴϸ� ''������Ż''�� ������ ���� �ִ� ���̾���. ���� �Ϻ� ������Ż�� �糳�⵵ �ϰ� �����ؼ� '+
		'����� ������� �λ��� �Ա⵵ �ߴ�. ����� ���ѱ� ������Ż�� ����鿡�� ����Ǿ���. ��Ȯ�ϰ� ���ذ� '+
		'������ ������ ������Ż�� ���� �������� �ڽ��� �������� ����� ������ ���̴�. ��ġ ������ ��Ƽ� '+
		'�� ���� �踦 ä��� �Ͱ� ���� ��ġ��� �� �� �ְڴ�.'
	);
	RES_STRING_ORZ_DIARY_19: array[0..2] of widestring =
	(
		'{> 45��}',
		'',
		'''���''�� �ݹ� ������ ����. ��� ���� ������� ��κ��� Ȱ���� ������ �ϱ� ������ ���� ���� ����� '+
		'���� ������ ���� ���ߴ�. ��� ���� �������� ���� ������ �������� �ʴ��� �ٸ� �� ���� ã�� �� ���� �� ����.'
	);
	RES_STRING_ORZ_DIARY_20: array[0..2] of widestring =
	(
		'{> 46��}',
		'',
		'���� ������ ���� �������� å�� �����ϴ� ���̴�. ���� ���� �ϵ� �ƴϰ� �Ӹ� ȸ���� ���� �ʿ��� ���� '+
		'�ƴ����� å�� ���� �� �ִٴ� ��ݿ� �� ���� �����ߴ�. �� ���� ������ ���� ��ġ ������ ���� �ݼ����� '+
		'���� ������ �־���. Ư���� ���� ���� �ʾƵ� �̰��� �� ������ ''ȭ��''��� ���� ������ �� �־���. '+
		'�Ƹ��� �ٸ� �Ϻ��ٴ� ������ ���� �� �������� �ϴ� �� ������ ���� �� �Ϳ� ���ؼ��� ����� ���Ҵ�. '+
		'��� �� ���迡���� ���� �״��� �߿��ϴٰ� ���������� �ʴ´�. �谡 ���������� �ʰ� �踦 ä��ٴ� '+
		'���� ��ü�� ����. �ϱ� ������̶� ��ü�� ���ӵ� �����̶� ������ �׷� ���� ������ �ʾƵ� �ȴ�. '+
		'���� ���� ''ȭ��''�� �����ΰ� �غ��� ������ �� ���� ������. �ٸ���� ���ϸ� ���� �ʿ��� ���� ���ٴ� '+
		'���� �ǰڴ�. �и� ������� ���� ���� �Ȱ� �־��� �� ���� �Ϻδ� ���� ���� ''ȭ��''�� �� �� �ִ� ���̾���. '+
		'������ �װ͵��� ������ ��ô�̳� �����߰� ��Ȯ�� ��� ���̴� ������ �𸣱� ������ ���Ҹ� '+
		'������ �� ���� ������. �ϴ��� ������ ���� ��� �ñ�� �ߴ�.'
	);
	RES_STRING_ORZ_DIARY_21: array[0..2] of widestring =
	(
		'{> 52��}',
		'',
		'�������ٴ� ���� ���Ƽ� �׵��� �ϱ⸦ ���� ���ߴ�. ���������� ���� �ϸ� å�� ���� �� �� �˾Ҵµ� '+
		'�ǻ��� �׷��� ���ߴ�. ��������, ù°�� ���� ������ ������, ��°�� å�� ��κп� ��ϵǾ� �ִ� ���ڸ� ���� ���� '+
		'���ٴ� ���̴�. ��� �� ������ ����� ���� ������ �ͺ��ٴ� �ξ� �����Ǿ��� �� ����. ������ '+
		'������ ���� ��� 10���� �̻��� �Ǵ� �� ���Ҵµ� �̰��� ������ ���� �޶��� ���ڰ� �ƴ϶� ������ '+
		'���� �޶��� ���ڿ���. ��� ��� ���� ���ĺ� ������ ������ �ֱ� ������ �з��ϰ� �־���. '+
		'�� ������ ���̶� ���� ��ü�� �ͷ� ��� ���� �ƴ϶� �̾߱� �ϰ��� �ϴ� ���븸 ������ �׻� '+
		'�ǻ������ �����ϴ�. ������ å�� ��쿡�� �׷��� ���� �� ����. ���̶�� ��ü�� ���ϴ� ���̱� ������ '+
		'��� ������ ���ڸ� �״�� ����ߴ� ���� �ƴұ� �����ȴ�.'
	);
	RES_STRING_ORZ_DIARY_22: array[0..2] of widestring =
	(
		'{> 59��}',
		'',
		'�����Ӱ� �ټ� ��û�� ��ó�� ���̴� �� ���赵 ��������� ������ ��Ģ�� ���� �����ϰ� �ִٴ� Ȯ���� ����. '+
		'���� ������ ���� �þ�� ���� ���� �� �ִ�. �������� ���� �ñ⸦ ���ߴٴ� ������ ���. �ð��� ������ '+
		'��� ���� ����� �ڼ����� �Բ� �̿� ���õ� �̾߱⸦ �����ϰ� ����ϰ� �ʹ�.'
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

// ���� ���� �Թ���
type
	RES_STRING_DEAD_WORLD_PAGE = 1..9;
const
	RES_STRING_DEAD_WORLD_01: array[0..2] of widestring =
	(
		'{���ļ����� ����}',
		'',
		'�̰��� ��ü�� ��ȥ�� ������ �ִ� ���迡�� ���ļ����� �θ��� ���̴�. �� å������ �� �̻� ���ļ����� ���� ���� �ʰ� ���ĺ��ʹ� {�̰�}�̶� Ī�Ѵ�.'
	);
	RES_STRING_DEAD_WORLD_02: array[0..2] of widestring =
	(
		'{�̰��� ����}',
		'',
		'���Ⱑ �������� �־������� ���� ����� ����.'
	);
	RES_STRING_DEAD_WORLD_03: array[0..2] of widestring =
	(
		'{�̰��� ������ ����� ����� ����}',
		'',
		'���� ����� ���⿡ ���� �ΰ����� ����� ����, ��ü�� �������� ������ ���� �� �ִ� �׷� ���̴�. '+
		'�ϴ��� �ױ� ���� ���谡 ���� �Ǵ� ���̴� �ƹ����� �ױ� ���� ����� ���� ��� �ִٰ� �� �� �ִ�. '+
		'�׷��� �̰� ���� ���ڰ� ������ ���� ���ݾ� �ٸ���, � ���󰡴� �̰��� ȭ���� ���� ���� ������ �縷���� ���δٰ� �Ѵ�. ������ ��κ��� ����� �׷��� �ʰ� ���δ�.'
	);
	RES_STRING_DEAD_WORLD_04: array[0..2] of widestring =
	(
		'{�� ������ �̷�� 7������ �Ӽ�}',
		'',
		'�װ��� ������ ����̶�� �Ҹ��µ�, ����� ���� �ٰſ� ���� 3������ �����ϰ� ���� ����� ���� 4������ �����Ѵ�. '+
		'���� �ٰſ� ���� �Ӽ��� ��,��,���� �ְ� ���� ����� ���� �Ӽ��� �,��,��,�Ϸ� ������.'
	);
	RES_STRING_DEAD_WORLD_05: array[0..4] of widestring =
	(
		'{���� �ٰſ� ���� ����� �Ӽ� <��,��,��>}',
		'',
		'���� �ڽ� ������ ���������� �̿��ؼ� ����� �����ϴ� ����̴�. �ٸ� �Ϳ� ���� ����� ������ ������ '+
		'�ڽ��� �������� �Ҹ��ϴ� ���̶� �������� ������ ���ϰ� �Ǵ� ����̴�. '+
		'�׿� ���� ���� �ڽ��� �������� ���� ������� �ʰ� �ܺ��� ���������� �̿��� ����� �����ϴ� ����̴�. '+
		'�ܺ��� �������� �״�� �ݻ��ϵ�, ������ ���ϵ� ���� �ڽſ��� ������� �ʰ� �ݻ縦 ���� ����� ���������� '+
		'������ �ݻ��Ҹ��� ���������� ���ٸ� �̰��� ����� �Ұ����ϰ�, �ݻ翡 ���� ����� �״��� ������ '+
		'���ϴٴ� ������ �ִ�. ',
		'',
		'�׸��� ���������� ���� �ִ�. �̰��� ���� ��� ���� ������� ���� ���� �Ͱ� ���� �����ε� �ڽ��� ���� ���������� '+
		'�ܺ��� ���������� ���ս�Ű�鼭 �� ���տ� ���� �սǵǴ� �������� ����� �����ϴ� ����̴�. ���� �˰� �𸣰� '+
		'��� �־��� ���� ��ü���� �Ͼ�� �ִ� �����ε� �׶��� ���δ� ��ȭ��� �����ϸ� �ȴ�. '+
		'��ȭ�� ��ü�� ü���� ������ �Ǵ� ���� �ٺ����� ���������� ��ȥ���Դ� ü���� ��������� �� ��ü�� ������ '+
		'���� ���� ����� �����ϱ� ���� �� ������θ� ���ȴ�.'
	);
	RES_STRING_DEAD_WORLD_06: array[0..4] of widestring =
	(
		'{���� ����� ���� ����� �Ӽ� <�, ��, ��, ��>}',
		'',
		'���� ����� ���󼭴� �,��,��,���� ������� ������. �̰��� ���� ����� ���¸� ���ϴ� ���̴�. '+
		'���� ⩴� ������ �е��� �ٸ� �Ϳ� ���ؼ� ���Ƽ� �������� ����̶�� �� �� �ִ�. �ڽź��� �е��� '+
		'���� �� ���� ���̱⵵ �ϰ� ��е� ������ �� ���� �帣�⵵ �ϰ� ������ �е��� ƴ ���̷� �����⵵ �Ѵ�. '+
		'���� ���� ����� ����ü�� ���·� �ٲ� ���̴�. ��ǥ������ �츮�� ���� ���¸� �ϰ� �ִ� ���� ����� ��� ���� '+
		'����̶�� �� �� �ִ�. ���� �Ͽ��� �������� ������ ��� �������� ���޹ޱ� ���ؼ��� ⩿� ���� �������� '+
		'����� �޾Ƶ鿩�� �װ��� �ٽ� ������ �������� ���� �Ѵ�. ���߿� ����� ���ϸ� �ᱹ ���� �Ϸ� ���ư���. '+
		'���� �ʰ� �ݴ�� ���� ����� ���⹰�� �ٲ� ���̴�. ���� �̹� �������� ���� �ܰ��̱� ������ �ܺο��� '+
		'������ ������ ���� ���� ���� �ʿ䵵 ����. ���⼭ ������ ���¸� ��� �͵��� ��� ���� ����̶�� '+
		'���� �� �ִµ� ���� ����� ������ ���� �� ������ ǫ���� ���� ������ �� �� �ְ� ������ �ݼ��� ������ '+
		'�� ���� �ִ�.',
		'',
		'�ϴ� ���� �������� ������ �����ε� ���̳� ������ ������ �ٲ� �� �ִ� �⺻�� �Ǵ� ����̶�� �� �� �ִ�. '
	);
	RES_STRING_DEAD_WORLD_07: array[0..2] of widestring =
	(
		'{������ ���� ���}',
		'',
		'�� ���迡�� ������ ���� �Ҹ��� ���� �� ���ٴ� ���̴�. �Ҹ��� ��´ٴ� ���� ������ ������ '+
		'����ϴ� Ư���� �ĵ��� �д� ���̶� ������ ���䵵 ���� ��ü�� ���� �̰������� �Ҹ��� ���� '+
		'���� ����. �״�� ��ü�� û�� ��ȣ�� �����ϰ� ������ ���� �ִµ� �װ��� ���⼭�� ��̶�� �θ���. '+
		'��� ��ü�� ���� ������ û�� ��ȣ�� ����� ��ȭ�Ǿ� ��ȥ�� ���޵ȴ�. ������ '+
		'��ȥ�� ᢸ� ���� �� �����ϱ� ��������� ���� ���̶� �� �� �ִ�. ��� Ư���� ������ �ʿ����. ���� ������ �ʿ�� ���� '+
		'��� ���ڵ� �ƴϰ� �ĵ��� �ƴϰ� ���޵ȴ�. ���� �������� Ȯ��Ǹ� �Ÿ��� ���� �� ���� ���������� '+
		'ᢵ� �Ÿ��� �־����� �Ÿ��� ������ ����ؼ� �� ������ ��������. ��� �߻��ϴ� �ٿ��� '+
		'�������� ��ȯ�̴�. ���ǳ��� �ε����鼭 ��� ����� ����� �͵� �� ���ε�, �����̴� �������� '+
		'�����ع����ų� �ӵ��� �پ��鼭 ���� �������� ��� ���·� Ȯ��ȴ�. �׸��� �츮�� ���� �������� '+
		'����ؼ� ���� ���� �ִ�. �װ��� ��ġ �Ź̰� ������ ���鼭 �Ҹ��� ���� �Ϳ� ������ �� �ִ�. '+
		'�ڽ��� ���� �������� �Һ��ؼ� �װ��� �Ҹ��� ��ȭ��Ű�� �����̶�� ���� �����ϱ� �����̴�.'
	);

	RES_STRING_DEAD_WORLD_08: array[0..10] of widestring =
	(
		'{Ų�� ��Ÿ�̳� ��Ģ}',
		'',
		'2������ ���� ������ ''���ļ��� �ٸ� �ĵ��� ��''���� ������ Ų���� ��Ģ�� ��������, '+
		'�ʳ� ��Ÿ�̳ʰ� �ϳ��� ���� �Ķ���͸� �߰��ϴ� ������� ����ȯ�� �ؼ��ߴ�. ' +
		'�̰��� ''Ų�� ��Ÿ�̳� ��Ģ''�̶�� �Ѵ�.',
		'',
		'�� ��Ģ�� ������ ���ù����ѵ�, ������ �ϳ��� 2�������� ���� �̵��� �����ϰ� �ϴ� ���̴�. ���� �̵��� �Ʒ��� 3�ܰ踦 ���ľ� �Ѵ�.',
		'',
		'1. 2���� ������ �ĵ��� �������� ��ȯ',
		'2. �ĵ��鿡 ���� ���ļ� õ�̸� ���� �� ����ȯ',
		'3. 2���� ���� ���� ��ġ �̵�',
		'',
		'�� ����� �ð� õ�̸� �����ϴ� ���� �Ϲ����̸�, õ�� ������ ���� ���� 2���� �Ǽ� ��� '+
		'�ϳ��� ��� �࿡ ���� �̵� ������ ũ�⿡ ����Ѵ�.'
	);

	RES_STRING_DEAD_WORLD_09: array[0..4] of widestring =
	(
		'{����(recognition)}',
		'',
		'�� �ɷ��� �Ϲ������� ���¿� ����Ѵ�. ��ȥü�� �Ǹ� ������� �ʴ� �κ��� ������ ���� �����ϰ� �Ǹ� ������ ���ϸ� �������� ���ϴ� ���� �Ϲ����̴�.',
		'',
		'�� �����ٴϴ� ���ε��� ���� �ڿ��� �쿬�ϰ� �� ���� �ʹ��� �ִٴ� ���� �˾����� ���� �ִ°�? '+
		'�ʹ��� �׻� �� �ڸ��� �־����� ����� �˾������� ���� ���� ����� �ű⿡ ������ ������ �����̴�. '+
		'���� ���迡���� �̰Ͱ� ����������. ������ �̰������� ��� ���� ������ ���� ������ �˾������� ���� ������ '+
		'������ �������ٰ� �� �� �ִ�. �̷� ���� ������ �˾��������� �������� �˷��شٸ� ����� �ű⿡ ������ ������ �ǰ� '+
		'��μ� ��� ���� ������ �����ϴ�. �׷��� ������ ������ ���� ������ ������ �ʴ´�.'
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

// ������ ��Ʈ
type
	RES_STRING_LIBRARY_NOTE_PAGE = 1..1;
const
	RES_STRING_LIBRARY_NOTE_01: array[0..0] of widestring =
	(
		'�� ��¥���� ������ å�� �ⳳ�� ���� ���� ���� �ִ�. �״��� Ư���� å�� �ƴϴ�.'
	);

	RES_STRING_LIBRARY_NOTE: array[low(RES_STRING_LIBRARY_NOTE_PAGE)..high(RES_STRING_LIBRARY_NOTE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_LIBRARY_NOTE_01); wstrData: @RES_STRING_LIBRARY_NOTE_01)
	);

// ������
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
		'�� ���� ������ ������ ���� �ִ�.'
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
		'''��ȭ''��� ���� ''DERIK''���� ������ �̸����� �� �� �ֵ��� �� ����Ŀ���� �ڽ��� �ϻ����� �ڱ� ��ȭ�� �ŵ��ϴ� �ſ� ����� ����ü�̴�. '+
			'����Ŀ���� ��ȭ �ܰ�� ũ�� ����ü, ��ü, �ż�ü�� ���� ���� �ִ�. '+
			'����ü�� ��쿡�� ȸ���� 30cm�����Ǵ� ��ü�� 2-3m�� ������ ������ �޷� �ְ� ��ȭ�� �ʱ�ܰ�� �ܺ� �������� ����Ͽ� �ڱ� ��ȭ�� ��Ű�� �ȴ�. '+
			'��ü�� ��� ������ ����ü�� ���� 2-3m�̸� ��ü�� ũ��� 10-15m������ �ȴ�. '+
			'����ü���� ��ü���� ��ȭ ������ ���� ������ ���ؿ� ������ ����ü�� ���� ������ ����� �̷�����ٰ� �����Ǿ�����. '+
			'�׸��� �ż�ü�� ��ȭ�� ������ �ܰ��, �ڽ��� ��ü, �̷�� ��������� ������� �ٲܼ� �ִ� �����̸�, �� ������ �ɰ��ϴ� ���İ� ����, �������� �����ٰ� ��������. '+
			'�Ϲ����� ���� ���� ��ϰ� �������δ� ����Ŀ���� �渶������� �н� Ȥ�� ���̶� �����Ǿ�����'
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
		'�װ� ��� �ð��뿡 �¾�� ��� �������� �ڶ�Դ��� �ƴ� ����� ����. �װ� ��� �ð��� �ʿ��ϴ� ������ �˰ԵǾ������� �˷����� �ʾҴ�. '+
			'������ �״� ''Ÿ�ӿ�Ŀ''��� ���� �Ǵٸ� �̸��� ���� �˷����� ������ ���� �ð��� ������ �����鼭 ������ �Ͽ��ٰ� ������ ���̴�. '+
			'� ����� �װ� ������ �����ϴ� ������̶�� �߰�, �� � ����� �װ� ������ â���س� �������� ���̶�� �ߴ�. '+
			'������ �� ����� ��� �츮���Դ� ���� �߿������� �ʴ�. ���� �װ� ���� �����κ��� Ī�۹޴� �ι��ӿ��� Ʋ�����ٴ� ���̰� ������ ���翡 ���������� �������ִ� �Ǹ��� �����ڶ�µ� �ִ�.'
	);

	RES_STRING_ALBIREO_02: array[0..0] of widestring =
	(
		'�״� ������ �츮�� �ִ� ���� �� �������� ���� ������ ���־���. �°� ������ �� ''������(Lenderz)''�� �ֽ��� �Դ� ī�̳� Ŭ����(CAINA CRENA)��� �Ҹ���� ���� ���ü�� Į����(KALIS)�� ��Ͽ� ���ϸ� ũ�� �� ���� ���翡 ������ ������ ���� �ִ�. '+
			'�� ù��°�� �ٰ�(DAGON)�̶�� ����ü�� �������� ���� ���� ����� �� �ĸ�(HUMAN)�̶�� ����ü�� ������ �����ڷ� ������ �������� ��, �ξ�(LORE)��� �Ҹ���� ���� ���ֱ��� ���翡 100�� ���� �� ������ ��ģ ������ ��ϵǾ� �ִ�. '+
			'�׸��� �ι�°�� �ĸ�(HUMAN)�� ����� �� ��Ƴ��� �ļյ�� ���� �ٽ� ����� ������ ���� �ٲ���� �� ��Ÿ�����ٰ� �Ѵ�.'
	);

	RES_STRING_ALBIREO: array[low(RES_STRING_ALBIREO_PAGE)..high(RES_STRING_ALBIREO_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_ALBIREO_01); wstrData: @RES_STRING_ALBIREO_01),
		(wstrLen: high(RES_STRING_ALBIREO_02); wstrData: @RES_STRING_ALBIREO_02)
	);

////////////////////////////////////////////////////////////////////////////////

// �������� �޸�
type
	RES_STRING_MY_MESSAGE_PAGE = 1..1;
const
	RES_STRING_MY_MESSAGE_01: array[0..2] of widestring =
	(
		'�� ������ {����������}��� ������ ���� �� �� 10��° �Ǵ� ���� �����ϴ� �ǹ̿��� ����� ���Դϴ�. '+
		'�ʹ��� ������ ����� �;����� ������ Ư���� ���� �ҼӵǾ� �ִ� �����̶� ������ ����� ���� ���� �Ұ����߽��ϴ�. '+
		'������ ����� ���� �Ǹ� �޴� 15��¥�� ù �ް�. �� 15�� ���� ������ �ϼ���Ű�� ���ؼ��� �׸�ŭ �Ϻ��� ��ȹ���� �ʿ��߽��ϴ�. '+
		'�������� ���� ���� �߰� �ٹ� ������ �� ������ ��� ��ȹ���� �ó������� �ᳪ�����ϴ�. �����̿� ���� �׸��� �ֻ����� �ùķ��̼��� �ؼ� ������ �������� �߽��ϴ�. '+
		'�׷��⸦ 4����... 15�� ���� ���� �� �ִ� ������ �з���ŭ�� ��ȹ�� �Ǿ��� �׷��� ����ϴ� ù �ް��� �����ϰ� �Ǿ����ϴ�. '+
		'������ ��ȹ�� ���� �ٿ� 12�� ���� ������ ����� ������ �ڷ�ǿ� �÷Ƚ��ϴ�. �׶��� 1995�� 2�� 13��. �� 10�� ���� �����̾����ϴ�. ',
		'',
		'�� �� �ٷ� ���뿡 �����߱� ������ ������ ��� ������ ������ �־������� �𸨴ϴ�. ��� �װ��� �״��� �߿����� �ʾҽ��ϴ�. '+
		'������ ������ٴ� ���밨�����ε� �ູ�߱� �����Դϴ�. ������ ���Ӱ��� ���þ��� ���� �մϴ�. �׸��� ������ ������� ���� ������ ��ư��� �ֽ��ϴ�. '+
		'�Դٰ� ������ �� �� �� ���� ������ ���� ���� �㱸�����ϴ�. �׷��� ������ ���� �����ڰ� �ƴմϴ�. '+
		'{������, ���ư� �� ���� ���� ���⿡ �� ������ ����ϴ�.}'
	);

	RES_STRING_MY_MESSAGE: array[low(RES_STRING_MY_MESSAGE_PAGE)..high(RES_STRING_MY_MESSAGE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_MY_MESSAGE_01); wstrData: @RES_STRING_MY_MESSAGE_01)
	);

// ���� �� �Ŵ���
type
	RES_STRING_AIR_GUN_MANUAL_PAGE = 1..1;
const
	RES_STRING_AIR_GUN_MANUAL_01: array[0..5] of widestring =
	(
'�� ��ǰ�� �ڳ���� ���� �ɾ��ִ� ��� ''�𿡼ջ�''���� ���� �ֽ� ���� ���Դϴ�. ��ü�� ���� īƮ������ ���� ���� �������� �ö�ƽ ź�� �߻��ϵ��� �����Ǿ��� �� ���Դϴ�. (���� īƮ������ �����Դϴ�)',
'',
'������� �������� ����̳�, �� ��ǰ�� ������ ���� ��� �߻��� ���� å������ �ʽ��ϴ�.',
'',
'����: {����� ���ؼ� ���� �� ��}',
'��� ����: 8�� �̻�'
	);

	RES_STRING_AIR_GUN_MANUAL: array[low(RES_STRING_AIR_GUN_MANUAL_PAGE)..high(RES_STRING_AIR_GUN_MANUAL_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_AIR_GUN_MANUAL_01); wstrData: @RES_STRING_AIR_GUN_MANUAL_01)
	);

// PROCRETE �޸�
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

// ���� �޽���
type
	RES_STRING_START_MESSAGE_PAGE = 1..1;
const
	RES_STRING_START_MESSAGE_01: array[0..7] of widestring =
	(
		'@��������',
		'',
		'AVEJ 1�� (�̿ϼ�) 2005/08/28 ����',
		'',
		'@���� ����Ʈ �� e-mail',
		'',
		'���ۻ���Ʈ: http://avej.com',
		'������: �ȿ���(smgal@avej.com)'
	);

	RES_STRING_START_MESSAGE: array[low(RES_STRING_START_MESSAGE_PAGE)..high(RES_STRING_START_MESSAGE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_START_MESSAGE_01); wstrData: @RES_STRING_START_MESSAGE_01)
	);

// F1 �޽���
type
	RES_STRING_HELP_MESSAGE_PAGE = 1..1;
const
	RES_STRING_HELP_MESSAGE_01: array[0..19] of widestring =
	(
		'@���ӿ� ���Ǵ� Ű',
		'',
		'--------------------------------------------',
		'[q] quickly look around - ������ ��ü�� ����',
		'[a] accept - ���õ� ��ü�� �ڼ��� ����',
		'',
		'[s] search - ������ ��ü�� �����Ѵ�',
		'[a] aquire - ���õ� ��ü�� ������',
		'',
		'[w] who    - ��ȭ ������ ��븦 ã�´�',
		'[a] accept - ��ȭ�� �����Ѵ�',
		'',
		'[z], [Shift+z] �տ� �� ������ �ٲ۴�',
		'[a] action - �տ� �� �������� �ൿ�� ���Ѵ�',
		'',
		'[Esc] escape - ������ �����ϰ� ���� ������',
		'[Ctrl+n] new game - ������ ó������ �����Ѵ�',
		'[F1] ���� ���� �ִ� ����',
		'[F2] ����� �ùķ��̼� ��带 �ٲ۴�',
		'--------------------------------------------'
	);

	RES_STRING_HELP_MESSAGE: array[low(RES_STRING_HELP_MESSAGE_PAGE)..high(RES_STRING_HELP_MESSAGE_PAGE)] of TWideStringSet =
	(
		(wstrLen: high(RES_STRING_HELP_MESSAGE_01); wstrData: @RES_STRING_HELP_MESSAGE_01)
	);

implementation

end.

