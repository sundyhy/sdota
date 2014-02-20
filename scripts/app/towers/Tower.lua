--
-- Author: Sundyhy
-- Date: 2014-01-21 16:47:50
--
require("scripts/app/base/Util.lua");
require("scripts/app/layers/GameHUD.lua");

local Tower = class("Tower", function()
    return display.newNode();
end)

function Tower:ctor()
	self.actionSprite = nil;
	self.sprite = nil;
	self.rangeSprite = nil;
	self.sprite1 = nil;
	self.sprite2 = nil;
	self.sprite3 = nil;
	self.sprite4 = nil;

	self.money = 0;
	self.damge = 0;
	self.maxDamge = 0;
	self.interval = 0;
	self.moneyEnough = false;

	self.isShowing = false;

	self.range = 0;
	self.level = 0;
	self.target = nil;

	self.gameHUD = sharedHUD();

	self.scheduler = CCDirector:sharedDirector():getScheduler();

	self:registerScriptTouchHandler(callFunc(self, self.onTouch));
    self:setTouchEnabled(true);
end

function Tower:initWithFileAndRange(fileName, range)
	self.sprite = CCSprite:create(fileName);
	self:addChild(sprite);

	local frame1 = button_sel1_normal;
	self.sprite1 = CCSprite:createWithSpriteFrame(frame1);
	self:addChild(self.sprite1);
	self.sprite1:setVisible(false);

	self.sprite3 = CCSprite:createWithSpriteFrame(button_upgrade_normal);
	self:addChild(self.sprite3);
	self.sprite3:setVisible(false);

	self:setRange(range);

	self.rangeSprite = CCSprite:create("Range.png");
	local w = self.rangeSprite:getContentSize().width;
	local scale = 2 * range / w;
	self.rangeSprite:setScale(scale);
	self.rangeSprite:setVisible(false);
	self.rangeSprite:setPosition(self.sprite:getPosition());
	self:addChild(self.rangeSprite, -1);

	self.level = 1;
	self.target = nil;
	self.isShowing = false;
end

function Tower:initWithSpriteFrame(frame, range)
	self.sprite = CCSprite:createWithSpriteFrame(frame);
	local scaleX = 32.0 / self.sprite:getContentSize().width;
	local scaleY = 32.0 / self.sprite:getContentSize().height;
	self.sprite:setScaleX(scaleX);
	self.sprite:setScaleY(scaleY);
	self:addChild(self.sprite);

	local frame1 = button_sel1_normal;
	self.sprite1 = CCSprite:createWithSpriteFrame(frame1);
	self:addChild(self.sprite1);
	self.sprite1:setScale(0.75);
	self.sprite1:setVisible(false);

	self.sprite3 = CCSprite:createWithSpriteFrame(button_upgrade_normal);
	self:addChild(self.sprite3);
	self.sprite3:setScale(0.75);
	self.sprite3:setVisible(false);

	self:setRange(range);
	self.rangeSprite = CCSprite:create("Range.png");
	local scale = 2 * range / self.rangeSprite:getContentSize().width;
	self.rangeSprite:setScale(scale);
	self.rangeSprite:setVisible(false);
	self.rangeSprite:setPosition(self.sprite:getPosition());
	self:addChild(self.rangeSprite, -1);

	self.target = nil;
	self.level = 1;
	self.isShowing = false;
end

function Tower:levelUp()
	self.gameHUD:updateResources(-self.money);
	self.money = self.money * 2;
	self.damage = self.damage * 1.5;
	self.maxDamage = self.maxDamage * 2;
	self.range = self.range * 1.5;
	self.interval = self.interval * 0.5;

	self.sprite:removeFromParent();
	if self.level == TOWER_MAX_LEVEL then
		local max = CCSprite:createWithSpriteFrame(button_max_normal);
		max:setPosition(self.sprite3:getPosition());
		self.sprite3:removeFromParent();
		self.sprite3:setScale(0.75);
		self.sprite3 = max;
		self:addChild(max);
	else
		local label = self.sprite3:getChildByTag(888);
		local towerCast = CCLabelTTF:create("$", "Marker Felt", 20);
		towerCast:setPosition(lavel:getPosition());
		towerCast:setColor(ccc3(255, 0, 0));
		towerCast:setString(string.format("%d", self.money));
		label:removeFromParent();
		towerCast:setTag(888);
		self.sprite3:addChild(towerCast);
		self.sprite3:setScale(0.75);
	end
end

function Tower:getClosestTarget()
	local closestEnemy = nil;
	local maxDistant = 99999;

	for i = 1, GameMediator:getTargets():count() do
		local temp = GameMediator:getTargets():objectAtIndex(i - 1);
		if temp:getHP() > 0 then
			local curDistance = ccpDistance(self:getPosition(), enemy:getPosition());
			if curDistance < maxDistant then
				closestEnemy = enemy;
				maxDistance = curDistance;
			end
		end
	end

	if maxDistant < self:getRange() then
		return closestEnemy;
	end

	return nil;
end

function Tower:towerLogic(dt)
	if self:getTarget() == nil or GameMediator:getTargets():containsObject(self:getTarget()) == false then
		local ret = self:getClosestTarget();
		if ret ~= nil then
			self:setTarget(ret);
		else
			self:setTarget(nil);
		end
	else
		local curDistance = ccpDistance(self:getPosition(), self:getTarget():getPosition())
		if self:getTarget():setHP() <= 0 or curDistance > self:getRange() then
			local ret = self:getClosestTarget();
			if ret ~= nil then
				self:setTarget(ret);
			else
				self:setTarget(nil);
			end
		end
	end
end

function Tower:setMoney(val)
	self.money = val;
	local towerCast = CCLabelTTF:create("$", "Marker Felt", 20);
	towerCast:setPosition(ccp(self.sprite1:getPosition().x + self.sprite:getContentSize().width / 2, 15));
	towerCast:setColor(ccc3(255, 0, 0));
	towerCast:setTag(888);
	towerCast:setString(string.format("%d", self.money));
	self.sprite3:addChild(towerCost);
end

function Tower:getMoney()
	return self.money;
end

function Tower:fire()
end

function Tower:fireReady()
end

function Tower:fireNow()
end



function Tower:show()
	local fade = CCFadeIn:create(0.5);
	self.sprite1:runAction(CCMoveBy:create(0.5, ccp(-self.sprite:getContentSize().width - 10, 0)));
	self.sprite1:setVisible(true);

	self.sprite3:runAction(CCMoveBy:create(0.5, ccp(self.sprite:getContentSize().width + 10, 0)));
	self.sprite3:setVisible(true);

	self.rangeSprite:runAction(CCSequence:createWithTwoActions(fade, CCShow:create()));
end

function Tower:hide()
	local fade = CCFadeOut:create(0.5);
	self.sprite1:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.5, self.sprite:getPosition()), CCHide:create()));
	self.sprite3:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.5, self.sprite:getPosition()), CCHide:create()));
	self.rangeSprite:runAction(CCSequence:createWithTwoActions(fade, CCHide:create()));
end

function Tower:onTouch(eventType, x, y)
    if eventType == "began" then   
        return self:onTouchBegan(x, y);
    elseif eventType == "moved" then
        return self:onTouchMoved(x, y);
    else
        return self:onTouchEnded(x, y);
    end
end

function Tower:onTouchBegan(x, y)
	if self.sprite:boundingBox().containsPoint(ccp(x, y)) then
		if self.isShowing == false then
			self.isShowing = true;
			self:show();
		else
			self.isShowing = false;
			self:hide();
		end
	end

	if self.isShowing and self.sprite1:boundingBox():containsPoint(ccp(x, y)) then
		GameMediator:getGameLayer():removeTower(self);
		GameMediator:updateResources(self.mondy);

		return true;
	end

	if self.isShowing == true and self.sprite3:boundingBox():containsPoint(ccp(x, y)) then
		local moneyEnough = false;
		if self.gameHUD:getResources() < getMoney() then
			moneyEnough = false;
		else
			moneyEnough = true;
		end

		if moneyEnough == true then
			self.level = self.level + 1;
			self:levelUp();
		end

		return true;
	end

	return false;
end

function Tower:onTouchMoved(x, y)
	
end

function Tower:onTouchEnded(x, y)
	
end



