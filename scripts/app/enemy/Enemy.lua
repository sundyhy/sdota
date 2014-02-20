--
-- Author: sundyhy@163.com
-- Date: 2014-01-24 22:47:05
--
require("scripts/app/base/Util.lua");
require("scripts/app/maps/Map.lua");

Enemy = class("Enemy", function()
    return display.newNode();
end)

function Enemy:ctor()
	self.totalHp = 0;
	self.curDir = kUnKnow;
	self.imageName = "";
	self.gift = 0;
	self.hp = 0;
	self.speed = 0;
	self.startPos = ccp(0, 0);
	self.endPos = ccp(0, 0);
	self.isAimed = false;
	self.wayTilesArray = {};
	self.healthBar = nil;
	self.aim = nil;
	self.hasRemoved = false;
	self. actionSprite = nil;
	self.animate = nil;
	self.sprite = nil;
	self.cur = 0;
	self.orgSpeed = 0;
	self.times = 0;

	self.preTileData = nil;

	self.openSteps = 0;
	self.closedSteps = 0;
	self.shortestPath = 0;

	self.scheduler = CCDirector:sharedDirector():getScheduler();
end

function Enemy:release()
end

function Enemy:initWithMem(fileName, hp, speed, gift, pos)
	self.imageName = fileName;

	local maxTileWidth = GameMediator:getMaxTileW(); ---- self.mainLayer:getMaxTileWidth();
	local maxTileHeight = GameMediator:getMaxTileH(); ---- self.mainLayer:getMaxTileHeight();

	local heroTexture = CCTextureCache:sharedTextureCache():addImage(fileName);

	local frame0 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 0, 48 * 3, 36, 48));
	local frame1 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 1, 48 * 3, 36, 48));
	local frame2 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 2, 48 * 3, 36, 48));
	local frame3 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 3, 48 * 3, 36, 48));

	local animFrames = CCArray:create();
	animFrames:addObject(frame0);
	animFrames:addObject(frame1);
	animFrames:addObject(frame2);
	animFrames:addObject(frame3);

	local animation = CCAnimation:createWithSpriteFrames(animFrames);
	self.sprite = CCSprite:createWithSpriteFrame(frame0);
	self:addChild(self.sprite);

	animation:setDelayPerUnit(0.2);
	local animate = CCAnimate:create(animation);
	local forever = CCRepeatForever:create(animate);
	forever:setTag(100);
	self.sprite:runAction(forever);

	animFrames:release();

	self.actionSprite = CCSprite:createWithSpriteFrame(frame0);
	self.actionSprite:retain();
	self:setHP(hp);
	self:setSpeed(speed);
	self:setGift(gift);
	self.totalHP = hp;
	self.isAimed = false;
	self.aim = nil;

	self:setPosition(ccp(-20, pos.y + 10));
	self.startPos = ccp(15, pos.y + 10);
	local x = maxTileWidth;
	local y = maxTileHeight;
	self.endPos = ccp(x, y);

	self.hasRemoved = false;

	self.openSteps = CCArray:create();
	self.openSteps:retain();

	self.closedSteps = CCArray:create();
	self.closedSteps:retain();

	self.shortestStep = CCArray:create();
	self.shortestStep:retain();

	self.wayTilesArray = {};

	self.cur = 0;
	self.times = 0;
	self.orgSpeed = self.speed;
	self.pre = nil;

	self.healthBar = CCProgressTimer:create(CCSprite:create("health_bar_green.png"));
	self.healthBar:setType(kCCProgressTimerTypeBar);
	self.healthBar:setMidpoint(ccp(0, 0));
	self.healthBar:setBarChangeRate(ccp(1, 0));
	self.healthBar:setPercentage(100);
	self.healthBar:setScale(0.2);
	self.healthBar:setPosition(ccp(0, self.sprite:getContentSize().height * 0.5));
	self:addChild(self.healthBar, 2);

	local redBar = CCSprite:create("health_bar_red.png");
	redBar:setPosition(self.healthBar:getPosition());
	redBar:setScale(0.2);
	self:addChild(redBar, 1);

	self.schedulerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.attack), 0.5, false);

	return true;
end

function Enemy:unscheduleObj(schedulerEntry)
	if schedulerEntry ~= nil then
		self.scheduler:unscheduleScriptEntry(schedulerEntry);
		schedulerEntry = nil;
	else
		if self.schedulerEntry ~= nil then
			self.scheduler:unscheduleScriptEntry(self.schedulerEntry);
			self.schedulerEntry = nil;
		end
		if self.schedulerLogic ~= nil then
			self.scheduler:unscheduleScriptEntry(self.schedulerLogic);
			self.schedulerLogic = nil;
		end
		if self.schedulerTimer ~= nil then
			self.scheduler:unscheduleScriptEntry(self.schedulerTimer);
			self.schedulerTimer = nil;
		end
	end
end

function Enemy:attack()
	if self.schedulerEntry ~= nil then
		self.scheduler:unscheduleScriptEntry(self.schedulerEntry);
		self.schedulerEntry = nil;
	end
	
	self.cur = 1;
	local moveTime = 32 / self.speed;
	local moveBy = CCMoveTo:create(moveTime, self.startPos);
	local moveDone = CCCallFunc:create(callFunc(self, self.startLogic));
	self:runAction(CCSequence:createWithTwoActions(moveBy, moveDone));
end

function Enemy:setDamage(val, isBoom)
	local font = 30;
	if isBoom then
		font = 60;
	end

	local demageLab = CCLabelTTF:create(string.format("-%f", val), "Marker Felt", font);
	if isBoom then
		demageLab:setColor(ccc3(255, 255, 0));
	else
		demeageLab:setColor(ccc3(255, 0, 0));
	end

	local x = math.random() * 40;
	local y = math.random() * 40;

	demageLab:setPositionX(x);
	demageLab:setPositionY(y);
	self:addChild(demageLab);

	local scale = CCScaleTo:create(10, 0.5);
	local fade = CCFadeOut:create(0.5);
	demageLab:runAction(CCSpawn:createWithTwoActions(scale, fade));
	local animate = BoomReady();
	if animate == nil then
		return;
	end

	local func = CCCallFunc:create(callFunc(self, self.boomNow));
	self.actionSprite:runAction(CCSequence:createWithTwoActions(animate, func));
end

function Enemy:clearDemageLab()
end

function Enemy:setHP(val)
	self.hp = val;
end
function Enemy:getHP()
	return self.hp;
end

function Enemy:setSpeed(val)
	self.speed = val;
end
function Enemy:getSpeed()
	return self.speed;
end

function Enemy:setGift(val)
	self.gift = val;
end
function Enemy:getGift()
	return self.gift;
end

function Enemy:startLogic()
	if self.schedulerLogic == nil then
		self.schedulerLogic = self.scheduler:scheduleScriptFunc(callFunc(self, self.enemyLogic), 0.5, false);
	end
	
	if self.schedulerTimer == nil then
		self.schedulerTimer = self.scheduler:scheduleScriptFunc(callFunc(self, self.timer), 0.2, false);
	end

	self:moveToTarget();
end

function Enemy:getRect()
	local rect = CCRect(self:getPosition().x - self.sprite:getContentSize().width * 0.5, 
		self:getPosition().y - self.sprite:getContentSize().height * 0.5, 
		self.sprite:getContentSize().width, self.sprite:getContentSize().height);

	return rect;
end

function Enemy:changeSpeed(time)
	time = time * 5;
	if self.speed < 30 then
		return;
	end

	self.speed = self.speed * 0.5;
end

function Enemy:attackOnlyOne()
	local enemyArr = GameMediator:getTargets();
	for i = 1, enemyArr:count() do
		local theEnemy = enemyArr:objectAtIndex(i - 1);
		if theEnemy == self then
			theEnemy:IamAimed(true);
		else
			theEnemy:IamAimed(false);
		end
	end

	local towerArr = GameMediator:getTowers();
	for i = 1, towerArr:count() do
	 	local theTower = towerArr:objectAtIndex(i - 1);
	 	theTower:pauseAllRunningActions();
	 	theTower:setTarget(self);
	 	---------------------------------------
	 end 
end

function Enemy:IamAimed(aimed)
	if aimed and self.isAimed then
		if self.aim == nil then
			self.aim = CCSprite:create("aim.png");
			self.aim:setScale(0.4);
			self.aim:setPosition(ccp(0, 0));
			self:addChild(self.aim);
			ccLog("i am aimed");
		end

		self.isAimed = true;
	elseif not aimed and self.isAimed then
		if self.aim ~= nil then
			self.aim:removeFromParent();
			self.aim = nil;
			ccLog("dont aimed");
		end

		self.isAimed = false;
	end
end

function Enemy:createAnimationByDirection(dir)
	local heroTexture = CCTextureCache:sharedTextureCache():addImage(self.imageName);

	local frame0 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 0, 48 * dir, 36, 48));
	local frame1 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 1, 48 * dir, 36, 48));
	local frame2 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 2, 48 * dir, 36, 48));
	local frame3 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(36 * 3, 48 * dir, 36, 48));

	local animFrames = CCArray:create();
	animFrames:addObject(frame0);
	animFrames:addObject(frame1);
	animFrames:addObject(frame2);
	animFrames:addObject(frame3);

	local animation = CCAnimation:createWithSpriteFrames(animFrames);
	animation:setDelayPerUnit(0.2);

	return animation;
end

function Enemy:boomReady()
	if self.hasRemoved then
		return nil;
	end

	local heroTexture = CCTextureCache:sharedTextureCache():addImage("003-Attack01.png");

	local frame0 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(192 * 0, 0,192, 192));
	local frame1 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(192 * 1, 0,192, 192));
	local frame2 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(192 * 2, 0,192, 192));
	local frame3 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(192 * 3, 0,192, 192));
	local frame4 = CCSpriteFrame:createWithTexture(heroTexture, CCRect(192 * 4, 0,192, 192));

	local animFrames = CCArray:create();
	animFrames:addObject(frame0);
	animFrames:addObject(frame1);
	animFrames:addObject(frame2);
	animFrames:addObject(frame3);
	animFrames:addObject(frame4);

	local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2);
	self:setActionSprite(CCSprite:createWithSpriteFrame(frame0));
	self.actionSprite:setPosition(CCPointMake(0, 0));
	self.actionSprite:setScale(0.3);
	self:addChild(self.actionSprite);

	self.animation:setDelayPerUnit(0.2);
	local animate = CCAnimate:create(self.animation);

	return animate;
end

function Enemy:boomNow()
	if not self.hasRemoved then
		self.actionSprite:removeFromParentAndCleanup(true);
	end
end

function Enemy:timer(dt)
--	print("++++++++++++++++", self.times);
--	if self.times <= 0 then
--		if self.speed ~= self.orgSpeed then
--			self.speed = self.orgSpeed;
--		end
--
--		return;
--	end
--
--	self.times = self.times - 1;
end

function Enemy:moveToTarget()

	local lasttile = false;
	self.cur = self.cur + 1;
	if self.cur > table.nums(self.wayTilesArray) then
		lasttile = true;
	end

	local toTile = 0;
	local walktoPosition = ccp(0, 0);

	if not lasttile then
		toTile = self.wayTilesArray[self.cur];
		local currentTileCoord = toTile:getPosition();
		if currentTileCoord:equals(self.endPos) then
			return;
		end
		walktoPosition = Map.tile2Pos(currentTileCoord);
	else
		walktoPosition = ccp(self:getPosition());
		if self.curDir == kRight then
			walktoPosition.x = display.width + TILE_WIDTH / 2;
		elseif self.curDir == kUp then
			walktoPosition.y = display.height + TILE_HEIGHT / 2;
		elseif self.curDir == kDown then
			walktoPosition.y = 0 - TILE_HEIGHT / 2;
		elseif self.curDir == kLeft then
			walktoPosition.x = 0 - TILE_WIDTH / 2;
		end
	end

	walktoPosition.y = walktoPosition.y + 10;
	local moveTime = 32 / self.speed;
	local moveAction = CCMoveTo:create(moveTime, walktoPosition);
	local moveCallBack = CCCallFunc:create(callFunc(self, self.moveToTarget));
	if not lasttile then
		if toTile:getDirection() ~= kUnKnow and not self.hasRemoved then
			self.curDir = toTile:getDirection();
			local animation = self:createAnimationByDirection(toTile:getDirection());
			local animate = CCAnimate:create(animation);
			local forever = CCRepeatForever:create(animate);
			self.sprite:stopActionByTag(100);
			forever:setTag(100);
			self.sprite:runAction(forever);
		end
		self:runAction(CCSequence:createWithTwoActions(moveAction, moveCallBack));
	else
		local arr = CCArray:create();
		arr:addObject(moveAction);
		self:runAction(CCSequence:create(arr));
	end
end

function Enemy:insertInOpenSteps(tileInfo)
end

function Enemy:costToMoveFromTileToAdjacentTime(fromTile, toTile)
end

function Enemy:computeHScoreFromCoordToCoord(fromCoord, toCoord)
end

function Enemy:constructPathAndStartAnimationFromStep(tileInfo)
end

function Enemy:popStepAndAnimate()
end

function Enemy:removeSelf()
	if self.hasRemoved then
		return;
	end

	self:unscheduleObj();
	self:stopAllActions();
	self:removeFromParentAndCleanup(true);
	self.hasRemoved = true;
	GameMediator:getTargets():removeObject(self);
end

function Enemy:enemyLogic(dt)

	if Map.isOutOfMap(ccp(self:getPosition())) then
		self:unscheduleObj();

		print("####################################");
		GameMediator:getGameHUDLayer():updateBaseHp(-10);
		self:removeSelf();

		return;
	end

	if self:getHP() <= 0 then
		GameMediator:updateResources(gift);
		self:stopAllActions();

		local deadAction = CCBlink:create(0.3, 3);
		local deadDone = CCCallFunc:create(callFunc(self, self.removeSelf));
		self:runAction(CCSequence:createWithTwoActions(deadAction, deadDone));
	end
end

function Enemy:onTouch(type, x, y)
end

function Enemy:onTouchBegan(x, y)
	if self.sprite:boundingBox():containsPoint(ccp(x, y)) then
		self:attackOnlyOne();
		return true;
	end

	return false;
end

function Enemy:onTouchMoved(x, y)
	
end

function Enemy:onTouchEnded(x, y)
end

function Enemy:startAnimationFromStep(tileInfo)
end

function Enemy:myArrayGetIndexOfObject(arr, tileInfo)
	for i = 1, arr:count() do
		local temp = arr:objectAtIndex(i - 1);
		if temp:getPosition():equals(tileInfo:getPosition()) then
			return i - 1;
		end
	end

	return CC_INVALID_INDEX;
end