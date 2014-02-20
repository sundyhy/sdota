--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 14:09:32
--
require("scripts/app/base/Util.lua");

local IceBullet = class("IceBullet", function()
    return display.newNode();
end)


function IceBullet:ctor()
end

function IceBullet:initWithTargetPos(pos)
	self:initWithMyFile();
	self:setTargetPos(pos);
	self:moveToTargetPos();
end

function IceBullet:update(dt)
	local needRemove = false;
	for i = 1, GameMediator:getTargets():count() do
		local target = GameMediator:getTargets():objectAtIndex(i);
		if self:getRect():intersectsRect(target:getRect()) then
			needRemove = true;
			break;
		end
	end

	for i = 1, GameMediator:getTargets() do
		local target = GameMediator:getTargets():objectAtIndex(i);
		local dis = ccpDistance(self:getPosition(), self:getPosition());
		if dis <= self:getRange() then
			target:changeSpeed();
		end
	end

	if needRemove then
		self:removeSelf();
	end
end

function IceBullet.create(pos)
	local ib = IceBullet.new();
	if ib:initWithTargetPos(pos) then
		ib:autorelease();

		return ib;
	end

	return nil;
end

function IceBullet:initWithMyFile()
	self:init();
	self.mySprite = AniData:getSprite(270);
	self:addChild(self.mySprite);
end

function IceBullet:moveToTargetPos()
	local dis = ccpDistance(self:getPosition(), self:getTargets());
	local moveDur = dis / self.speed;
	local moveTo = CCMoveTo:create(moveDur, self:getTargets());
	local moveDone = CCCallFunc:create(callFunc(self.removeSelf));
	self:runAction(CCSequence:createWithTwoActions(moveTo, moveDone));
end
