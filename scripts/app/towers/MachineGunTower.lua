--
-- Author: Sundyhy
-- Date: 2014-01-22 09:58:57
--
require("scripts/app/towers/Tower.lua")

local MachineGunTower = class("MachineGunTower", function()
    return Tower.new();
end)

function MachineGunTower:ctor()
end

function MachineGunTower:initWithFileAndRange(fileName, range)
	self.super:initWithFileAndRange(fileName, range);
	self:setMoney(25);
	self.damage = T1Damage;
	self.maxDamage = T1MaxDamage;
	self.range = range;

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), 1.0, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.2, false);
end

function MachineGunTower:initWithSpriteFrame(frame, range)
	self.super:initWithSpriteFrame(frame, range);
	self:setMoney(Tower1Cost);
	self.damage = T1Damage;
	self.maxDamage = T1MaxDamage;
	self.range = range;

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), T1Interval, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.2, false);
end

function MachineGunTower:fire(dt)
	self.scheduler:unscheduleScriptEntry(self.schedulerEntry);
	audio.playEffect("tower1.wav");
	self:fireReady();
end

function MachineGunTower.create()
	return MachineGunTower.creatr(Tower1_1, T1Range);
end

function MachineGunTower.create(fileName, range)
	local t = MachineGunTower.new();
	if t ~= nil and t:initWithFileAndRange(fileName, range) then
		t:autorelease();

		return t;
	end

	return nil;
end

function MachineGunTower.create(frame, range)
	local t = MachineGunTower.new();
	if t ~= nil and t:initWithSpriteFrame(frame, range) then
		t:autorelease();

		return t;
	end

	return nil;
end

function MachineGunTower:fireReady()
	local ani = AniData:getAni("tower1Attack");
	self.actionSprite = AniData:getSprite(223);
	self.actionSprite:setPosition(ccp(0, 0));
	self.actionSprite:setAnchorPoint(CCPointMake(0.25, 0));

	self.sprite:addChild(self.actionSprite);

	ani:setDelayPerUnit(0.05);
	local animate = CCAnimate:create(ani);
	local callFunc = CCCallFunc:create(callFunc(self, self.fireNow));
	local shootVector = ccpSub(self:getTarget():getPosition(), self:getPosition());
	local shootAngle = 90 - CC_RADIANS_TO_DEGREES(shootAngle);
	local rotateSpeed = 0.25 / math.pi;
	local rotateDuration = math.abs(shootAngle * rotateSpeed);
	self.actionSprite:runAction(CCRotateTo:create(rotateDuration, cocosAngle));
	self.actionSprite:runAction(CCSequence:createWithTwoActions(animate, callFunc));
end

function MachineGunTower:fireNow()
	self.actionSprite:removeFromParentAndCleanup(true);
	if not GameMediator:getTargets():containsObject(self:getTarget()) then
		return;
	end

	local shootVector = ccpSub(self:getTarget():getPosition(), self:getPosition());
	local normalizedShootVector = ccpNormalize(shootVector);
	local overshotVector = ccpMult(normalizedShootVector, self:getRange());
	local offscreenPoint = ccpAdd(self:getPosition(), overshotVector);

	local projectTile = MachineProjectTile.new(offscreenPoint);
	projectTile:setPosition(self:getPosition());
	projectTile:setRotation(self:getRotation());

	projectTile:setDamage(self.damage);
	projectTile:setMaxDamage(self.maxDamage);
	GameMediator:getGameLayer():addChild(projectTile);
end

function MachineGunTower:levelUp()
	self.super:levelUp();
	local frame = nil;
	if self:getLevel() == 2 then
		frame = Tower1_2;
	elseif self:getLevel() == 3 then
		frame = Tower1_3;
	elseif self:getLevel() == 4 then
		frame = Tower1_4;
	end

	self.sprite = CCSprite:createWithSpriteFrame(frame);
	local scaleX = 32 / self.sprite:getContentSize().width;
	local scaleY = 32 / self.sprite:getContentSize().height;

	self.sprite:setScaleX(scaleX);
	self.sprite:setScaleY(scaleY);
	self:addChild(self.sprite);
end