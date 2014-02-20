--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 13:53:58
--
require("scripts/app/base/Util.lua");

local Bullet = class("Bullet", function()
    return display.newNode();
end)


function Bullet:ctor()
	self.damage = 0;
	self.maxDamage = 0;

	self.mySprite = nil;
	self.actionSprite = nil;

	self.hasRemoved = false;

	self.isBoom = false;
	self.speed = 0;

	self.targetPos = nil;
	self.probability = 100;
	self.range = 0;

	self.streak = nil;
end

function Bullet:init()
	self.speed = 960.0;
	self.targetPos = ccp(0, 0);
	self.damage = 3;
	self.maxDamage = 10;
	self.probability = 0.6;
	self.isBoom = false;
end

function Bullet:initWithFile(fileName)
	self:init();
	self.mySprite = CCSprite:create(fileName);
	self:addChild(mySprite);

	return true;
end

function Bullet:initWithMyFile()
	return true;
end

function Bullet:getRect()
	local x = self:getPosition().x - self.mySprite:getContentSize().width * 0.5;
	local y = self:getPosition().y - self.mySprite:getContentSize().height * 0.5;
	local w = self:getContentSize().width;
	local h = self:getContentSize().height;
	local rect = CCRectMake(x, y, w, h);

	return rect;
end

function Bullet:getDamage()
	if math.random() <= self.probability then
		self:setIsBoom(true);
	else
		self:setIsBoom(false);
	end

	local temp = math.random() * self.maxDamage;
	if self.isBoom then
		temp = self.damage + (self.maxDamage - self.damage) * (2.5 + math.random() * 3);
	end
	if temp <= self.damage then
		temp = self.damage;
	end

	return temp;
end

function Bullet:setDamage(val)
	self.damage = val;
end

function Bullet:getMaxDamage()
	return self.maxDamage;
end

function Bullet:setMaxDamage(val)
	self.maxDamage = val;
end

function Bullet:getIsBoom()
	return self.isBoom;
end

function Bullet:setIsBoom(val)
	self.isBoom = val;
end

function Bullet:getSpeed()
	return self.speed;
end

function Bullet:setSpeed(val)
	self.speed = val;
end

function Bullet:getTargetPos()
	return self.targetPos;
end

function Bullet:setTargetPos(val)
	self.targetPos = val;
end

function Bullet:getProbability()
	return self.probability;
end

function Bullet:setProbability(val)
	self.probability = val
end

function Bullet:getRange()
	return self.range;
end

function Bullet:setRange(val)
	self.range = val;
end

function Bullet:removeSelf()
	if self.hasRemoved then
		return;
	end

	self.hasRemoved = true;
	self:unscheduleAll();
	self:stopAllActions();
	self:removeFromParentAndCleanup(true);
end

function Bullet:boomReady()
	---
end

function Bullet:boomNow()
	---
end