unit UConfig;

interface

const
	SCREEN_WIDTH            = 800;
	SCREEN_HEIGHT           = 600;
	SCREEN_DEPTH            = 16;
	USE_FULLSCREEN          = TRUE;
	USE_AUX_DISPLAY         = not TRUE;

	PLAYER_MOVE_INC         = 1;
	MAX_PLAYER              = 50;

	BLOCK_W_SIZE            = 28;
	BLOCK_H_SIZE            = 32;
	BLOCK_W_GAP             = 28;
	BLOCK_H_GAP             = BLOCK_H_SIZE;
	BLOCK_W_PITCH           = (512 div BLOCK_W_GAP);
	BLOCK_SHADOW_W          = 8;

	SHOW_TILE_W_RADIUS      = 6;
	SHOW_TILE_H_RADIUS      = 6;
	SHOW_TILE_WIDTH         = 2 * SHOW_TILE_W_RADIUS + 1;
	SHOW_TILE_HEIGHT        = 2 * SHOW_TILE_H_RADIUS + 2;

	WORLD_MAP_XPOS          = 8;
	WORLD_MAP_YPOS          = 32;
	WORLD_MAP_WIDTH         = (2 * SHOW_TILE_W_RADIUS + 1) * BLOCK_W_SIZE;
	WORLD_MAP_HEIGHT        = (2 * SHOW_TILE_H_RADIUS + 1) * BLOCK_H_SIZE;
	WORLD_MAP_HALF_WIDTH    = (SHOW_TILE_W_RADIUS+2) * BLOCK_W_SIZE;
	WORLD_MAP_HALF_HEIGHT   = (SHOW_TILE_H_RADIUS+2) * BLOCK_H_SIZE;

	TILE_CHARACTER_YPOS     = 5 * BLOCK_H_GAP;

	FLOOR_BASE              = 0 * BLOCK_W_PITCH;
	FLOOR_INNER_TILE1       = (FLOOR_BASE+0);
	FLOOR_BOARD_BLOCK       = (FLOOR_BASE+1);
	FLOOR_BOARD_BLOCK1      = (FLOOR_BASE+2);
	FLOOR_INNER_TILE2       = (FLOOR_BASE+3);
	FLOOR_INNER_TILE3       = (FLOOR_BASE+4);
	FLOOR_GREEN             = (FLOOR_BASE+5);
	FLOOR_BLANK             = (FLOOR_BASE+6);
	FLOOR_INNER_X           = (FLOOR_BASE+7);
	FLOOR_BOARD_BLOCK2      = (FLOOR_BASE+8);
	FLOOR_BOARD_BLOCK3      = (FLOOR_BASE+9);
	FLOOR_INNER_TILE4       = (FLOOR_BASE+12);
	FLOOR_END               = 1 * BLOCK_W_PITCH - 1 - 4;

	STAIRS_BASE             = FLOOR_END + 1;
	STAIRS_DOWN_L           = STAIRS_BASE + 0;
	STAIRS_DOWN_R           = STAIRS_BASE + 1;
	STAIRS_UP_L             = STAIRS_BASE + 2;
	STAIRS_UP_R             = STAIRS_BASE + 3;
	STAIRS_END              = 1 * BLOCK_W_PITCH - 1;

	WALL_BASE               = 1 * BLOCK_W_PITCH;
	WALL_ARROW_LEFT         = (WALL_BASE+3);
	WALL_FRAGILE            = (WALL_BASE+9);
	WALL_TRASH1             = (WALL_BASE+10);
	WALL_TRASH2             = (WALL_BASE+11);
	WALL_TRASH3             = (WALL_BASE+12);
	WALL_TRASH4             = (WALL_BASE+13);
	WALL_END                = 2 * BLOCK_W_PITCH - 1;

	WALL_MOVEABLE_BASE      = WALL_ARROW_LEFT;
	WALL_MOVEABLE_END       = WALL_ARROW_LEFT+5;

	OBJ_DOOR_BASE           = 2 * BLOCK_W_PITCH;
	OBJ_DOOR_WINDOWED_CLOSE = (OBJ_DOOR_BASE+0);
	OBJ_DOOR_WINDOWED_OPEN  = (OBJ_DOOR_BASE+1);
	OBJ_DOOR_CLOSE          = (OBJ_DOOR_BASE+2);
	OBJ_DOOR_OPEN           = (OBJ_DOOR_BASE+3);
	OBJ_DOOR_LOCKED_CLOSE   = (OBJ_DOOR_BASE+4);
	OBJ_DOOR_LOCKED_OPEN    = (OBJ_DOOR_BASE+5);
	OBJ_DOOR_NAMED_CLOSE    = (OBJ_DOOR_BASE+6);
	OBJ_DOOR_NAMED_OPEN     = (OBJ_DOOR_BASE+7);
	OBJ_WINDOW              = (OBJ_DOOR_BASE+8);
	OBJ_DOOR_END            = 3 * BLOCK_W_PITCH - 1;

	OBJ_BASE                = 3 * BLOCK_W_PITCH;
	OBJ_FLOWERPOT           = (OBJ_BASE+0);
	OBJ_TABLE_V             = (OBJ_BASE+1);
	OBJ_CHAIR_LEFT          = (OBJ_BASE+2);
	OBJ_CABINET             = (OBJ_BASE+3);
	OBJ_TABLE_LEFT          = (OBJ_BASE+4);
	OBJ_TABLE_CENTER        = (OBJ_BASE+5);
	OBJ_TABLE_RIGHT         = (OBJ_BASE+6);
	OBJ_DESK                = (OBJ_BASE+7);
	OBJ_BED                 = (OBJ_BASE+8);
	OBJ_TELEVISION          = (OBJ_BASE+9);
	OBJ_TABLE               = (OBJ_BASE+10);
	OBJ_BOOKCASE            = (OBJ_BASE+11);
	OBJ_STOOL               = (OBJ_BASE+12);
	OBJ_CHAIR_RIGHT         = (OBJ_BASE+13);
	OBJ_CHAIR_DOWN          = (OBJ_BASE+14);
	OBJ_BOX_OPEN            = (OBJ_BASE+15);
	OBJ_BOX_CLOSE           = (OBJ_BASE+16);
	OBJ_TREE1               = (OBJ_BASE+17);
	OBJ_TREE2               = (OBJ_BASE+18);
	OBJ_PANEL1              = (OBJ_BASE+19);
	OBJ_PANEL2              = (OBJ_BASE+20);
	OBJ_PILLAR              = (OBJ_BASE+21);
	OBJ_END                 = OBJ_PILLAR;

	OBJ_MOVEABLE_BASE       = 8 * BLOCK_W_PITCH;
	OBJ_QAZ                 = (OBJ_MOVEABLE_BASE+0);
	OBJ_QAZ1                = (OBJ_MOVEABLE_BASE+1);
	OBJ_MOVEABLE_END        = OBJ_MOVEABLE_BASE + 4;

	SET_OBJ_DOOR            = [OBJ_DOOR_WINDOWED_CLOSE..OBJ_DOOR_NAMED_OPEN];

type
	LOOKABLE_OBJECT         = OBJ_BASE..OBJ_END;
const
	MOVEABLE_TILE_SET       = [FLOOR_BASE..FLOOR_END, STAIRS_BASE..STAIRS_END, OBJ_DOOR_OPEN, OBJ_DOOR_WINDOWED_OPEN, OBJ_DOOR_LOCKED_OPEN, OBJ_DOOR_NAMED_OPEN];
	TRANSMITABLE_TILE_SET   = [FLOOR_BASE..FLOOR_END, STAIRS_BASE..STAIRS_END, OBJ_DOOR_WINDOWED_CLOSE, OBJ_DOOR_WINDOWED_OPEN, OBJ_DOOR_OPEN, OBJ_DOOR_LOCKED_OPEN, OBJ_DOOR_NAMED_OPEN, OBJ_WINDOW, OBJ_BASE..OBJ_END, OBJ_MOVEABLE_BASE..OBJ_MOVEABLE_END];

	LOOKABLE_OBJECT_SET     = [OBJ_BASE..OBJ_END, OBJ_DOOR_NAMED_CLOSE];
	LOOKABLE_OBJECT_NAME_SET= [low(LOOKABLE_OBJECT)..high(LOOKABLE_OBJECT)];
	LOOKABLE_OBJECT_NAME    : array[LOOKABLE_OBJECT] of WideString =
	(
		'화분', '테이블', '의자', '캐비넷', '테이블', '테이블', '테이블',
		'책상', '침대', '텔레비전', '테이블', '책장', '등받이 없는 의자', '의자', '걸상',
		'열려진 박스', '박스', '나무', '나무', '판넬', '판넬', '기둥'
	);

const
	// the use of debugging
	DIR_MAKER_X =   0;
	DIR_MAKER_Y =   0;

const
	KEYWORD_LIMIT    = 4;
	KEYWORD_GREETING = '.@rz';
	KEYWORD_BYE      = '';

type
	TScreenColor = (scGreen, scWhite, scVermilion);
	TTextColor   = (tcNormal, tcMonolog, tcEvent, tcHelp);
	TFocusType   = (ftDisable, ftLook, ftSearch, ftTalk, ftEnemy);

var
	// image color mask
	g_colorMask: longword;
	// text foreground color
	g_screenColor: TScreenColor;
	// text background color
	g_textBgColor: longword;
	// text special color
	g_textColor: array[TTextColor] of longword;
	// focused color
	g_focusColor: array[TFocusType] of longword;

procedure ChangeScreenColor(screenColor: TScreenColor);

implementation

procedure ChangeScreenColor(screenColor: TScreenColor);
begin
	g_screenColor := screenColor;

	case screenColor of
		scGreen:
		begin
			g_colorMask             := $0000FF00;
			g_textBgColor           := $FF002010;
			g_textColor[tcNormal ]  := $FF00FF00;
			g_textColor[tcMonolog]  := $FF80FFBF;
			g_textColor[tcEvent  ]  := $FF00C0FF;
			g_textColor[tcHelp   ]  := $FFF08040;
			g_focusColor[ftDisable] := $80000000;
			g_focusColor[ftLook]    := $80FFFF00;
			g_focusColor[ftSearch]  := $8000FFFF;
			g_focusColor[ftTalk]    := $80C0CF30;
			g_focusColor[ftEnemy]   := $80FF0000;
		end;
		scWhite:
		begin
			g_colorMask             := $00FFFFFF;
			g_textBgColor           := $FF181818;
			g_textColor[tcNormal ]  := $FFFFFFFF;
			g_textColor[tcMonolog]  := $FFB0FFD0;
			g_textColor[tcEvent  ]  := $FF80C8FF;
			g_textColor[tcHelp   ]  := $FFF0C080;
			g_focusColor[ftDisable] := $80000000;
			g_focusColor[ftLook]    := $80FFFF00;
			g_focusColor[ftSearch]  := $8000FFFF;
			g_focusColor[ftTalk]    := $80C0CF30;
			g_focusColor[ftEnemy]   := $80FF0000;
		end;
		scVermilion:
		begin
			g_colorMask             := $00F08040;
			g_textBgColor           := $FF200010;
			g_textColor[tcNormal ]  := $FFF08040;
			g_textColor[tcMonolog]  := $FFD0FFBF;
			g_textColor[tcEvent  ]  := $FF80C0FF;
			g_textColor[tcHelp   ]  := $FF80F040;
			g_focusColor[ftDisable] := $80000000;
			g_focusColor[ftLook]    := $80C0C000;
			g_focusColor[ftSearch]  := $80A0C0B0;
			g_focusColor[ftTalk]    := $80C0CF30;
			g_focusColor[ftEnemy]   := $80FF0000;
		end;
	end;
end;

Initialization
	ChangeScreenColor(scWhite);
	ChangeScreenColor(scVermilion);
	ChangeScreenColor(scGreen);

end.

