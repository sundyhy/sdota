--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 14:06:43
--
require("scripts/app/base/Util.lua");

local MachineBullet = class("MachineBullet", function()
    return display.newNode();
end)


function MachineBullet:ctor()
end

function MachineBullet:initWithTargetPos(pos)
	self:initWithMyFile();
	self:setSpeed(500);
	self:setTargetPos(pos);
	self:moveToTargetPos();
	self.streak = CCMotionStreak:create(0.2, 15, 15, ccc3(0, 0, 255), self.mySprite:getTexture());
	self.streak:setFastMode(true);
	GameMediator:getGameLayer():addChild(self.streak);

	return true;
end

function MachineBullet:update(dt)
	self.streak:setPosition(self:getPosition());
	for i = 1, GameMediator:getTargets() do
		local enemy = GameMediator:getTargets():objectAtIndex(i);
		if self:getRect():intersectsRect(self.target:getRect()) and self.target:getHP() > 0 then
			self.target:setHP(self.target:getHP() - self:getDamage());
			local f = self.target:getHP() / self.target.totalHP;
			self.target.healthBar:setPercentage(f * 100);
			self.target:setDamage(self:getDamage(), self:getIsBoom);
			self:removeSelf();
			break;
		end
	end
end

function MachineBullet.create(pos)
	local mb = MachineBullet.new();
	if mb:initWithTargetPos(pos) then
		mb:autorelease();

		return mb;
	end

	return nil;
end

function MachineBullet:initWithMyFile()
	local self.mySprite = AniData:getSprite(40);
	self:addChild(self.mySprite);
end

function MachineBullet:moveToTargetPos()
	local distance = ccpDistance(self:getPosition(), self:getTargetPos());
	local moveDur = distance / speed;
	local moveTo = CCMoveTo:create(moveDur, self:getTargetPos());
	local moveDone = CCCallFunc:create(callFunc(self, self.removeSelf));
	self:runAction(CCSequence:createWithTwoActions(moveTo, moveDone));
end
