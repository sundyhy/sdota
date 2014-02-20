--
-- Author: Sundyhy
-- Date: 2014-01-22 10:03:01
--
local MutilTower = class("MutilTower", function()
    return Tower.new();
end)

function MutilTower:ctor()
	self.fireMount = 0;
	self.enemys = nil;
end

function MutilTower:initWithFileAndRange(fileName, range)
	self.super:initWithFileAndRange(fileName, range);
	self:setMoney(Tower4Cost);
	self.damage = T4Damage;
	self.maxDamage = T4MaxDamage;
	self.range = range;

	self.enemy = CCArray:create();
	self.enemy:retain();

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), T4Interval, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.2, false);
end

function MutilTower:initWithSpriteFrame(frame, range)
	self.super:initWithFileAndRange(fileName, range);
	self:setMoney(Tower4Cost);
	self.damage = T4Damage;
	self.maxDamage = T4MaxDamage;
	self.range = range;

	self.enemy = CCArray:create();
	self.enemy:retain();

	self.schedulerFireEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.fire), 2.0, false);
	self.schedulerTowerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.towerLogic), 0.2, false);
end

function MutilTower:fire(dt)
	if self:getEnemys():count() == 0 then
		return;
	end

	audio.playEffect("tower4.wav");
	for i = 1, self:getEnemys():count() do
		local target = self:getEnemys():objectAtIndex(i - 1);
		local shootVector = ccpSub(target:getPosition(), self:getPosition());
		local shootAngle = ccpToAngle(shootVector);
		local cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
		local projectTile = CannonProjectTile.new(target);
		projectTile:setSpeed(400);
		projectTile:setDamage(self.damage);
		projectTile:setMaxDamage(self.maxDamage);
		projectTile:setProbability(0.25);
		projectTile:setPosition(self:getPosition());
		projectTile:setRotation(cocosAngle);
		GameMediator:getGameLayer():addChild(projectTile);
	end
end

function MutilTower:getMutilFireEnemys()
	local arr = GameMediator:getTargets();
	if arr:count() == 0 then
		return;
	else
		local count = arr:count();
		local num = 0;
		self.enemys:removeAllObjects();
		for i = 1, count do
			local enemy = arr:objectAtIndex(i - 1);
			local distance = ccpDistance(enemy:getPosition(), self:getPosition());
			if distance <= self:getRange() and enemy:getHP() > 0 then
				self.enemys:addObject(enemy);
				num = num + 1;
				if num == 3 then
					break;
				end
			end
		end
	end
end

function MutilTower:towerLogic(dt)
	local enemyArr = self:getEnemys();
	if enemyArr:count() == 0 then
		self:getMutilFireEnemys();
	end

	local shouldChange = false;
	for i = 1, enemyArr:count() do
		local enemy = enemyArr:objectAtIndex(i - 1);
		local curDis = ccpDistance(self:getPosition(), enemy:getPosition());
		if enemy:getHP() <= 0 or curDis > self:getRange() then
			shouldChange = true;
			break;
		end
	end

	if shouldChange then
		self:getMutilFireEnemys();
	end
end

function MutilTower.create()
	return MutilTower.create(Tower4_1, T4Range);
end

function MutilTower.create(fileName, range)
	local t = MutilTower.new();
	if t and t:initWithFileAndRange(fileName, range) then
		t:autorelease();

		return t;
	end

	return ni;
end

function MutilTower.create(frame, range)
	local t = MutilTower.new();
	if t and t:initWithSpriteFrame(frame, range) then
		t:autorelease();

		return t;
	end

	return nil;
end

function MutilTower:levelUp()
	self.super:levelUp();
	
	local frame = Tower4_2;
	if self:getLevel() == 2 then
		frame = Tower4_2;
	else self:getLevel() == 3 then
		frame = Tower4_3;
	else self:getLevel() == 4 then
		frame = Tower4_4;
	end

	self.sprite = CCSprite:createWithSpriteFrame(frame);
	local scaleX = 32 / self.sprite:getContentSize().width;
	local scaleY = 32 / self.sprite:getContentSize().height;

	self.sprite:setScaleX(scaleX);
	self.sprite:setScaleY(scaleY);
	self:addChild(self.sprite);
end

function MutilTower:getEnemys()
	return self.enemys;
end

function MutilTower:getFireMount()
	return self.fireMount;
end