--
-- Author: Sundyhy
-- Date: 2014-01-17 17:42:03
--
require("scripts/app/data/Define.lua");
require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");
require("scripts/app/data/GameMediator.lua");

maxSpeed = 3;

local GameHUD = class("GameHUD", function()
    return display.newLayer();
end)

function GameHUD:ctor()
    self.ispause = false;

    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGB565);
    self.background = CCSprite:create("hud.png");
    self.background:setAnchorPoint(ccp(0, 0));
    self:addChild(self.background);
    self.background:setVisible(false);
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_Default);

    self:registerScriptTouchHandler(callFunc(self, self.onTouch));
    self:setTouchEnabled(true)


    self.movablesSprites = CCArray:create();
    self.movablesSprites:retain();

    self.selSprite = nil;
    self.selSpriteRange = nil;

    self.tScrollView = CCScrollView:create();
    self.tScrollView:setContentSize(CCSize(480, self.background:getContentSize().height));
    self.tScrollView:setDirection(kCCScrollViewDirectionHorizontal);
    self.tScrollView:setPosition(ccp(0, 0));
    self:addChild(self.tScrollView);

    local tower1 = spriteFrameFromFile(Res1Data, "frame1", 154);
    local tower2 = spriteFrameFromFile(Res1Data, "frame1", 156);
    local tower3 = spriteFrameFromFile(Res1Data, "frame1", 158);
    local tower4 = spriteFrameFromFile(Res1Data, "frame1", 160);

    local frameArr = CCArray:create();
    frameArr:addObject(tower1);
    frameArr:addObject(tower2);
    frameArr:addObject(tower3);
    frameArr:addObject(tower4);

    self.towersFrameArr = CCArray:create();
    self.towersFrameArr:addObject(tower1);
    self.towersFrameArr:addObject(tower2);
    self.towersFrameArr:addObject(tower3);
    self.towersFrameArr:addObject(tower4);
    self.towersFrameArr:retain();

    self.orignArr_L1 = CCPointArray:create(frameArr:count());
    self.orignArr_L1:retain();

    local tbCost = {25, 30, 40, 60};
    for i = 1, 4 do
    	local image = frameArr:objectAtIndex(i - 1);
    	local sprite = CCSprite:createWithSpriteFrame(image);
    	
    	sprite:setPosition(ccp(i * sprite:getContentSize().width + 15, 20));
    	sprite:setTag(i);
    	self.tScrollView:addChild(sprite);
    	self.movablesSprites:addObject(sprite);

    	self.orignArr_L1:add(ccp(sprite:getPosition()));
    	local towerCost = CCLabelTTF:create("$", "Marker Felt",25);
    	towerCost:setPosition(ccp(sprite:getContentSize().width / 2, sprite:getContentSize().height / 4));
    	towerCost:setColor(ccc3(255, 0, 0));
    	sprite:addChild(towerCost);
    	local cost = tbCost[i];
    	towerCost:setString(string.format("%d", cost));
    end

    self.resources = 300;
    self.resourceLabel = CCLabelTTF:create("Money 300", "Marker Felt", 20, CCSizeMake(150, 25), kCCTextAlignmentRight);
    self.resourceLabel:setPosition(ccp(30, display.cy - 15));
    self.resourceLabel:setColor(ccc3(255, 0, 0));
    self:addChild(self.resourceLabel, 1);

    local baseHpLabel = CCLabelTTF:create("Base Health", "Marker Felt", 20, CCSizeMake(150, 25), kCCTextAlignmentRight);
    baseHpLabel:setPosition(ccp(display.cx - 185, display.height - 15));
    baseHpLabel:setColor(ccc3(255, 80, 20));
    self:addChild(baseHpLabel, 1);

    self.waveCount = 1;
    self.waveCountLabel = CCLabelTTF:create("Wave 1", "Marker Felt", 20, CCSizeMake(150, 25), kCCTextAlignmentRight);
    self.waveCountLabel:setPosition(ccp(display.cx - 80, display.height - 15));
    self.waveCountLabel:setColor(ccc3(255, 0, 0));
    self:addChild(self.waveCountLabel, 1);

    self.baseHpPercentage = 100;
    self.healthBar = CCProgressTimer:create(CCSprite:create("health_bar_green.png"));
    self.healthBar:setType(kCCProgressTimerTypeBar);
    self.healthBar:setMidpoint(ccp(0, 0));
    self.healthBar:setBarChangeRate(ccp(1, 0));
    self.healthBar:setPercentage(self.baseHpPercentage);
    self.healthBar:setScale(0.5);
    self.healthBar:setPosition(ccp(display.width - 55, display.height - 15));
    self:addChild(self.healthBar);

    local back = CCMenuItemFont:create("back");
    back:registerScriptTapHandler(callFunc(self, self.backToMain));
    back:setPosition(ccp(0, 0));
    back:setFontSizeObj(20);

--    local pause = CCMenuItemFont:create("stop");
--    pause:registerScriptTapHandler(callFunc(self, self.pauseGame));
--    pause:setPosition(ccp(0, 0));
--    pause:setFontSizeObj(20);


    local speed = CCMenuItemFont:create("x1");
    speed:registerScriptTapHandler(callFunc(self, self.speedUp));
    speed:setPosition(ccp(0, 0));
    speed:setFontSizeObj(20);


    local menu1 = ui.newMenu({back});
    menu1:setColor(ccc3(255, 0, 0));
    menu1:setPosition(ccp(display.width - 150, display.height - 35));
    self:addChild(menu1);

--    local menu2 = ui.newMenu({pause});
--    menu2:setColor(ccc3(255, 0, 0));
--    menu2:setPosition(ccp(display.width - 100, display.height - 35));
--    menu2:setTag(100);
--    self:addChild(menu2);

    local menu3 = ui.newMenu({speed});
    menu3:setColor(ccc3(255, 0, 0));
    menu3:setPosition(ccp(display.width - 50, display.height - 35));
    menu3:setTag(101);
    self:addChild(menu3);

    local lev1 = CCMenuItemSprite:create(ui_lv1_normal(), ui_lv1_press());
    lev1:setTouchEnabled(true);
    lev1:registerScriptTapHandler(callFunc(self, self.levBtnPress));
    lev1:setPosition(ccp(0, 0));

    local menuLev1 = ui.newMenu({lev1});
    menuLev1:setPosition(ccp(30, 40));
    menuLev1:setTag(10);
    self.tScrollView:addChild(menuLev1);
end

function GameHUD:getIsPause()
    return self.ispause;
end

function GameHUD:setIsPause(val)
    self.ispause = val;
end

function GameHUD:levBtnPress()
 
    local count = self.movablesSprites:count();
    if self.show == nil then
        self.show = true;
    end
    if self.show == true then
        self.show = false;
    else
        self.show = true;
    end

    for i = 1, count do
        local sprite = tolua.cast(self.movablesSprites:objectAtIndex(i - 1), "CCSprite");
        if not self.show then
            local pos = sprite:getPosition();
            local move = CCMoveTo:create(0.25, ccp(0, 0));
            sprite:runAction(CCSequence:createWithTwoActions(move, CCHide:create()));
        else
            local arr = self.orignArr_L1;
            local move = CCMoveTo:create(0.25, arr:get(i - 1));
            sprite:runAction(CCSequence:createWithTwoActions(CCShow:create(), move));
        end
    end
end

function GameHUD:pauseGame()
    if self:getIsPause() then
        return;
    end

    self:setIsPause(true);

    local menu = self:getChildByTag(100);

    local pause = CCMenuItemFont:create("resume");
    pause:registerScriptTapHandler(callFunc(self, self.resumeGame));
    pause:setPosition(ccp(0, 0));
    pause:setFontSizeObj(20);

    local menu2 = ui.newMenu({pause});
    menu2:setColor(ccc3(0, 255, 0));
    menu2:setPosition(menu:getPosition());
    menu2:setTag(100);

    menu:removeFromParent();
    self:addChild(menu2);
    CCDirector:sharedDirector():pause();
end

function GameHUD:resumeGame()
    if not self:getIsPause() then
        return;
    end

    self:setIsPause(false);

    local menu = self:getChildByTag(100);

    local pause = CCMenuItemFont:create("stop");
    pause:registerScriptTapHandler(callFunc(self, self.pauseGame));
    pause:setPosition(ccp(0, 0));
    pause:setFontSizeObj(20);

    local menu2 = ui.newMenu({pause});
    menu2:setColor(ccc3(0, 0, 255));
    menu2:setPosition(menu:getPosition());
    menu2:setTag(100);

    menu:removeFromParent();
    self:addChild(menu2);
    CCDirector:sharedDirector():resume();
end

function GameHUD:speedUp()
    if self.isShouldUp == nil then
        self.isShouldUp = false;
    end

    if GameMediator.nowSpeed == 1 then
        self.isShouldUp = true;
    end

    if GameMediator.nowSpeed == maxSpeed then
        GameMediator.nowSpeed = 1;
        self.isShouldUp = false;
    end

    if GameMediator.nowSpeed < maxSpeed and self.isShouldUp then
        GameMediator.nowSpeed = GameMediator.nowSpeed + 1;
    end
end

function GameHUD:setSpeed(val)
    menu = self:getChildByTag(101);
    local speed = CCMenuItemFont:create(string.format("x%d", val));
    speed:registerScriptTapHandler(callFunc(self, self.speedUp));
    speed:setPosition(ccp(0, 0));
    speed:setFontSizeObj(20);

    local menu3 = ui.newMenu({speed});
    menu3:setColor(ccc3(0, 255, 0));
    menu3:setPosition(menu:getPosition());
    menu3:setTag(101);
    menu:removeFromParent();
    self:addChild(menu3);

    local scheduler = CCDirector:sharedDirector():getScheduler();
    scheduler:setTimeScale(val);
end

function GameHUD:backToMain()
    if self:getIsPause() then
        self.resumeGame();
    end
    print("+1111111111111111111111111111111111111111111");
    CCDirector:sharedDirector():replaceScene(CCTransitionTurnOffTiles:create(1, StartScene.new()));
end

function GameHUD:rangeScale(towerId)
    local range = 0;

    if towerId == 1 then
        range = T1Range;
    elseif towerId == 2 then
        range = T2Range;
    elseif towerId == 3 then
        range = T3Range;
    elseif towerId == 4 then
        range = T4Range;
    end

    return range * 2 / 100;
end

function GameHUD:updateBaseHp(amount)
    self.baseHpPercentage = self.baseHpPercentage + amount;
    if self.baseHpPercentage <= 25 then
        self.healthBar:setSprite(CCSprite:create("health_bar_red.png"));
        self.healthBar:setScale(0.5);
    end

    if self.baseHpPercentage <= 0 then
        ccLog("Game Over");
        self:unscheduleAll();
        GameMediator:clear();
        CCDirector:sharedDirector():replaceScene(CCTransitionJumpZoom:create(3.0, StartScene.new()));
        return;
    end
    print("-----------------------------", self.baseHpPercentage);
    self.healthBar:setPercentage(self.baseHpPercentage);
end

function GameHUD:updateResourcesNom()
    self.resources = self.resources + 1;
    self.resourceLabel:setString(string.format("Money %d", self.resources));
end

function GameHUD:updateWaveCount()
    self.waveCount = self.waveCount + 1;
    self.waveCountLabel:setString(string.format("wave %d", self.waveCount));
end


function GameHUD:resetHUD()
    self.waveCount = 1;
    GameMediator.nowSpeed = 1;
    self:setSpeed(1);
    self:resumeGame();
    self.waveCountLabel:setString(string.format("wave %d", self.waveCount));
    self.resources = 300;
    self.resourceLabel:setString(string.format("Money %d", self.resources));
    self.baseHpPercentage = 100;
    self.healthBar:setPercentage(self.baseHpPercentage);
end

function GameHUD:onTouch(eventType, x, y)
    if eventType == "began" then   
        return self:onTouchBegan(x, y);
    elseif eventType == "moved" then
        return self:onTouchMoved(x, y);
    else
        return self:onTouchEnded(x, y);
    end
end

function GameHUD:onTouchBegan(x, y)
    print("----------------------------------------------------+++1");
end

function GameHUD:onTouchMoved(x, y)
    print("----------------------------------------------------+++2");
end

function GameHUD:onTouchEnded(x, y)
    print("----------------------------------------------------+++3");
end

sharedHUD = function()
    if _sharedHUD == nil then
        _sharedHUD = GameHUD.new();
    end

    return _sharedHUD;
end
