-- -------------------------------------------------------------------------
--	文件名		：	Define.lua
--	创建者		：	Sundyhy
--	创建时间	：	2013/12/4 12:15:07
--	功能描述	：	常量定义
--
-- -----------------------------------------------------------------------*/

TowerMaxLevel 	= 4
Tower1Cost		= 25
Tower2Cost		= 30
Tower3Cost 		= 40
Tower4Cost 		= 60

T1Range  		= 100
T2Range   		= 100
T3Range   		= 120
T4Range   		= 120

T1Damage  		= 10
T2Damage  		= 10
T3Damage   		= 30
T4Damage   		= 20

T1MaxDamage  	= 25
T2MaxDamage   	= 25
T3MaxDamage    	= 55
T4MaxDamage    	= 45

T1Speed 		= 0.5
T2Speed  		= 0.8
T3Speed  		= 0.8
T4Speed  		= 0.8

T1Interval 		= 0.5
T2Interval 		= 0.8
T3Interval 		= 0.8
T4Interval 		= 1.0

EnemyTexture = function()
	return CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
end

Tower1_1 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(520, 156, 40, 59));

	return frame;
end

Tower1_2 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(979, 189, 41, 57));

	return frame;
end

Tower1_3 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(468, 238, 52, 61));

	return frame;
end

Tower1_4 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(248, 333, 61, 73));

	return frame;
end

--

Tower2_1 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(58, 225, 45, 62));

	return frame;
end

Tower2_2 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(0, 307, 47, 69));

	return frame;
end

Tower2_3 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(309, 333, 49, 77));

	return frame;
end

Tower2_4 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(358, 333, 51, 82));

	return frame;
end

--

Tower3_1 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(904, 366, 60, 55));

	return frame;
end

Tower3_2 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(964, 372, 60, 58));

	return frame;
end

Tower3_3 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(718, 443, 60, 69));

	return frame;
end

Tower3_4 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(784, 422, 60, 90));

	return frame;
end

--

Tower4_1 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(409, 333, 43, 62));

	return frame;
end

Tower4_2 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(0, 376, 53, 72));

	return frame;
end

Tower4_3 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(53, 393, 53, 83));

	return frame;
end

Tower4_4 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("enemy.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(106, 393, 53, 92));

	return frame;
end

--

TowerIcon1 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("icons.png");
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(50, 50, 50, 50));

	return frame;
end

TowerIcon2 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("icons.png")
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(150, 50, 50, 50));

	return frame;
end

TowerIcon3 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("icons.png")
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(0, 100, 50, 50));

	return frame;
end

TowerIcon4 = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("icons.png")
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(100, 100, 50, 50));

	return frame;
end

ui_play = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("icons.png")
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(203, 202, 30 ,30));

	return frame;
end

ui_stop = function()
	local texture = CCTextureCache:sharedTextureCache():textureForKey("icons.png")
	local frame = CCSpriteFrame:createWithTexture(texture, CCRect(38 ,220 ,30, 30));

	return frame;
end

button_max_normal = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(812, 344, 52, 59));

	return CCSprite:createWithSpriteFrame(frame);
end

button_sell_normal = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(864, 344, 52, 59));

	return CCSprite:createWithSpriteFrame(frame);
end

button_upgrade_normal = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(916, 344, 52, 59));

	return CCSprite:createWithSpriteFrame(frame);
end

ui_lv1_normal = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(390, 343, 60, 60));

	return CCSprite:createWithSpriteFrame(frame);
end

ui_lv1_press = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(450, 344, 60, 60));

	return CCSprite:createWithSpriteFrame(frame);
end

ui_lv2_normal = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(510, 344, 60, 60));

	return CCSprite:createWithSpriteFrame(frame);
end

ui_lv2_press = function()
	local chooseTexture = CCTextureCache:sharedTextureCache():textureForKey("choose.png");
	local frame = CCSpriteFrame:createWithTexture(chooseTexture, CCRect(570, 344, 60, 60));

	return CCSprite:createWithSpriteFrame(frame);
end