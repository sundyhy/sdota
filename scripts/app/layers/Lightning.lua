--
-- Author: sundyhy@163.com
-- Date: 2014-01-24 18:12:51
--
require("scripts/app/base/Util.lua");

Lighting = class("Lighting", function()
    return display.newNode();
end)

function Lighting:ctor()
	self.color = ccc3(0, 0, 0);
	self.opacity = 0;
	self.displaydOpacity = 0;

	self.displayedColor = ccc3(0, 0, 0);
	self.cascadeOpacityEnabled = false;
	self.cascadeColorEnabled = false;
end

function Lighting:initWithStrikePoint(...)

end

function Lighting:create(...)
end

function Lighting:strike()
end

function Lighting:strikeRandom()
end

function Lighting:strikeWithSeed()
end

function Lighting:draw()

	
end