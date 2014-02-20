--
-- Author: sundyhy@163.com
-- Date: 2014-01-28 11:45:21
--
require("scripts/app/base/Util.lua");

Npc = class("Npc", function()
    return display.newNode();
end)

function Npc:ctor()

	self.curHP = 0;
	self.totalHp = 0;

	self.curDir = kUnKnow;
	
	self.imageName = "";
	self.healthBar = nil;
	
	self.gift = 0;

	self.speed = 0;
	self.orgSpeed = 0;

	self.startPos = ccp(0, 0);
	self.endPos = ccp(0, 0);
	
	self.aim = nil;
	self.isAimed = false;
	
	self.wayTilesArray = {};
	
	
	self.hasRemoved = false;
	
	self.actionSprite = nil;
	self.animate = nil;
	self.sprite = nil;

	self.curTileIndex = 0;

	
	self.preTileData = nil;

	self.openSteps = 0;
	self.closedSteps = 0;
	self.shortestPath = 0;

	self.scheduler = CCDirector:sharedDirector():getScheduler();
end

function Npc:release()
end

function Npc:initWithMem(fileName, hp, speed, gift, pos)
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