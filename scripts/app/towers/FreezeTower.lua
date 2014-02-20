--
-- Author: Sundyhy
-- Date: 2014-01-22 10:01:56
--

require("scripts/app/towers/Tower.lua")

local FreezeTower = class("FreezeTower", function()
    return Tower.new();
end)

function FreezeTower:ctor()
end

function FreezeTower:initWithFileAndRange(fileName, range)
	self.super:initWithFileAndRange(fileName, range);
	self:setMoney(Tower2Cost);
	self.damage = T2Damage;
	self.maxDamage = T2MaxDamage;
	self.range = range;

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), 1.0, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.2, false);
end

function FreezeTower:initWithSpriteFrame(frame, range)
	self.super:initWithSpriteFrame(frame, range);
	self:setMoney(Tower2Cost);
	self.damage = T2Damage;
	self.maxDamage = T2MaxDamage;
	self.range = range;

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), T2Interval, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.2, false);
end

function FreezeTower:fire(dt)
	audio.playEffect("tower2.wav");

	local shootVector = ccpSub(self:getTarget():getPosition(), self:getPosition());
	local normalizeShootVector = ccpNormalize(shootVector);
	local overshotVector = ccpMult(normalizedShootVector, self:getRange());
	local offscreenPoint = ccpAdd(self:getPosition(), overshotVector);

	local projectTile = IceProjectTile.new(offscreenPoint);
	projectTile:setPosition(self:getPosition());
	projectTile:setRotation(self:getRotation());
	projectTile:setDamage(self.damage);
	projectTile:setMaxDamage(self.maxDamage);
	projectTile:setRange(self.range);
	GameMediator:getGameLayer():addChild(projectTile);
end

function FreezeTower.create()
end

function FreezeTower.create(fileName, range)
	local ft = FreezeTower.new();
	if ft:initWithFileAndRange(fileName, range) then
		ft:autorelease();

		return ft;
	end

	return nil;
end

function FreezeTower.create(frame, range)
	local ft = FreezeTower.new();
	if ft:initWithSpriteFrame(frame, range) then
		ft:autorelease();

		return ft;
	end

	return nil;
end

function FreezeTower:levelUp()
	self.super:levelUp();
	local frame = Tower2_2;
	if self:getLevel() == 2 then
		frame = Tower2_2;
	elseif self:getLevel() == 2 then
		frame = Tower2_3;
	elseif self:getLevel() == 2 then
		frame = Tower2_4;
	end

	self.sprite = CCSprite:createWithSpriteFrame(frame);
	local scaleX = 32 / self.sprite:getContentSize().width;
	local scaleY = 32 / self.sprite:getContentSize().height;
	self.sprite:setScaleX(scaleX);
	self.sprite:setScaleY(scaleY);
	self:addChild(self.sprite);
end