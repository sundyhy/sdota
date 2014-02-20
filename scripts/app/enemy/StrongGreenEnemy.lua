--
-- Author: sundyhy@163.com
-- Date: 2014-01-26 22:18:08
--
require("scripts/app/base/Util.lua");
require("scripts/app/enemy/Enemy.lua");

StrongGreenEnemy = class("StrongGreenEnemy", function()
    return Enemy.new();
end)

function StrongGreenEnemy:ctor()

end

function StrongGreenEnemy.create(pos, fileName, hp, speed, gift)
	local sge = StrongGreenEnemy.new();
	if fileName == nil then
		if sge:initWithMem("hero_phy.png", 200, 32.0, 8, pos) then
			sge:autorelease();

			return sge;
		end
	else
		if sge:initWithMem(fileName, hp, speed, gift, pos) then
			sge:autorelease();

			return sge;
		end
	end
	

	return nil;
end