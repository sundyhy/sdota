--
-- Author: Sundyhy
-- Date: 2014-01-22 10:02:35
--

require("scripts/app/towers/Tower.lua")

local CannonTower = class("CannonTower", function()
    return Tower.new();
end)

function CannonTower:ctor()
end

function CannonTower:initWithFileAndRange(fileName, range)
	self.super:initWithFileAndRange(fileName, range);
	self:setMoney(Tower3Cost);
	self.damage = T3Damage;
	self.maxDamage = T3MaxDamage;
	self.range = range;

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), T3Interval, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.1, false);
end

function CannonTower:initWithSpriteFrame(frame, range)
	self.super:initWithSpriteFrame(frame, range);
	self:setMoney(Tower3Cost);
	self.damage = T3Damage;
	self.maxDamage = T3MaxDamage;
	self.range = range;

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), T3Interval, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.1, false);
end

function CannonTower:fire(dt)
	local shootVector = ccpSub(self:getTarget():getPosition(), self:getPosition());
	local shootAngle = ccpToAngle(shootVector);
	local cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);

	audio.playEffect("tower3.wav");

	local projectTile = CannonProjectTile.new(self:getTarget());
	ccLog("target pos is %d, %d", self:getTarget():getPosition().x, self:getTarget():getPosition().y);
	projectTile:setPosition(self:getPosition());
	projectTile:setRotation(cocosAngle);
	projectTile:setDamage(self.damage);
	projectTile:setMaxDamage(self.maxDamage);
	GameMediator:getGameLayer():addChild(projectTile, 1);
end

function CannonTower.create()
	return CannonTower.create(Tower3_1, T4Range);
end

function CannonTower.create(fileName, range)
	local ct = CannonTower.new();
	if ct:initWithFileAndRange(fileName, range) then
		ct:autorelease();

		return ct;
	end

	return nil;
end

function CannonTower.create(frame, range)
	local ct = CannonTower.new();
	if ct:initWithSpriteFrame(frame, range) then
		ct:autorelease();

		return ct;
	end

	return nil;
end

function CannonTower:levelUp()
	self.super:levelUp();
	local frame = Tower3_2;
	if self:getLevel() == 2 then
		frame = Tower3_2;
	elseif self:getLevel() == 3 then
		frame = Tower3_3;
	elseif self:getLevel() == 4 then
		frame = Tower3_4;
	end

	self.sprite = CCSprite:createWithSpriteFrame(frame);
	local scaleX = 32 / self.sprite:getContentSize().width;
	local scaleY = 32 / self.sprite:getContentSize().height;

	self.sprite:setScaleX(scaleX);
	self.sprite:setScaleY(scaleY);

	self:addChild(self.sprite);
end