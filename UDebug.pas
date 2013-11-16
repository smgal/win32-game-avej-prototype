unit UDebug;

interface

uses
	Windows,
	USmD3D9, USmHangul, USmUtil,
	UConfig;

procedure Debug_DisplayFPS();
procedure Debug_DisplayAxis();

implementation

uses
	UGameMain;

procedure Debug_DisplayFPS();
const
	s_FPS_baseTick: integer = 0;
	s_FPS_count: integer = 0;
	s_FPS_string: string = '--';
begin
	if s_FPS_baseTick = 0 then begin
		s_FPS_baseTick := timeGetTime();
		s_FPS_count    := 1;
		s_FPS_string   := '--';
	end
	else if integer(timeGetTime()) - s_FPS_baseTick > 1000 then begin
		str(s_FPS_count, s_FPS_string);
		s_FPS_baseTick := timeGetTime();
		s_FPS_count := 1;
	end;

	inc(s_FPS_count);
	SmDrawText(0, 0, 'FPS: ' + s_FPS_string, $FFFF90FF, $FFFF0000, DxBitBlt);
end;

procedure Debug_DisplayAxis();
var
	s1, s2: string;
begin
	str(g_tileMap.GetPC.m_pos.x div BLOCK_W_SIZE, s1);
	str(g_tileMap.GetPC.m_pos.y div BLOCK_H_SIZE, s2);

	SmDrawText(0, 16, '(x: ' + s1 + ', y: ' + s2 + ')', $FFFFFF90, $FFFF0000, DxBitBlt);
end;

end.
