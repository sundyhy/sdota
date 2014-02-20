--
-- Author: sundyhy@163.com
-- Date: 2014-01-26 22:17:55
--
require("scripts/app/base/Util.lua");
require("scripts/app/enemy/Enemy.lua");

FastRedEnemy = class("FastRedEnemy", function()
    return Enemy.new();
end)

function FastRedEnemy:ctor()

end

function FastRedEnemy.create(pos, fileName, hp, speed, figt)
	local fre = FastRedEnemy.new();
	if fileName == nil then
		if fre:initWithMem("hero_fast.png", 100, 64.0, 10, pos) then
			fre:autorelease();

			return fre;
		end
	else
		if fre:initWithMem(fileName, hp, speed, gift, pos) then
			fre:autorelease();

			return fre;
		end
	end
	

	return nil;
end

