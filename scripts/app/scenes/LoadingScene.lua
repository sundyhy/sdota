-- -------------------------------------------------------------------------
--  文件名     ：   MainMenuScene.lua
--  创建者     ：   Sundyhy
--  创建时间    ：  2013/12/6 15:28:03
--  功能描述    ：  plist文件的加载
--
-- -----------------------------------------------------------------------*/
require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");
require("scripts/app/data/GameMediator.lua");

require("scripts/app/scenes/MainScene.lua");

LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

function LoadingScene:ctor(level)
    self.scheduler = CCDirector:sharedDirector():getScheduler();
    self:initWithLevel(lelel);
end

function LoadingScene:initWithLevel()
    self.layer = display.newLayer();
    self.layer:setTouchEnabled(true);
    self:addChild(self.layer);

    local bg = CCSprite:create("loading_bg.png");
    local bgW = bg:getTextureRect():getMaxX();
    local bgH = bg:getTextureRect():getMaxY();
    bg:setScaleX(display.width / bgW);
    bg:setScaleY(display.height / bgH);
    bg:setPosition(ccp(display.cx, display.cy));
    self.layer:addChild(bg);

    self.currentCount = 0;
    self.totalCount = 16 + 5;


    self.process = 1;
    self.processBg = CCSprite:create("process_b.png");
    self.processBg:setPosition(ccp(display.cx, display.cy));
    self.processBar = CCSprite:create("process_p.png");
    self.processBar:setPosition(ccp(30 + 1 * 1.45 , 19));
    self.processBar:setScaleX(1 / 100);
    self.processBg:addChild(self.processBar);
    self.layer:addChild(self.processBg, 1);


    self.schedulerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.update), 0.1, false);

    audio.preloadBackgroundMusic("battle1.wav");
    self.currentCount = self.currentCount + 1;
    audio.preloadEffect("tower1.wav");
    self.currentCount = self.currentCount + 1;
    audio.preloadEffect("tower2.wav");
    self.currentCount = self.currentCount + 1;
    audio.preloadEffect("tower3.wav");
    self.currentCount = self.currentCount + 1;
    audio.preloadEffect("tower4.wav");
    self.currentCount = self.currentCount + 1;

    require("scripts/app/data/ActorData.lua");
    self.currentCount = self.currentCount + 1;
    require("scripts/app/data/PathData.lua");
    self.currentCount = self.currentCount + 1;
    require("scripts/app/data/Res1Data.lua");
    self.currentCount = self.currentCount + 1;
    require("scripts/app/data/ResData.lua");
    self.currentCount = self.currentCount + 1;
    require("scripts/app/data/StageData.lua");
    self.currentCount = self.currentCount + 1;
    require("scripts/app/data/UiData.lua");
    self.currentCount = self.currentCount + 1;

    GameMediator:SetFirstLoad(false);

    CCTextureCache:sharedTextureCache():addImageAsync("enemy.png", callFunc(self, self.LoadingCallBack));
    CCTextureCache:sharedTextureCache():addImageAsync("choose.png", callFunc(self, self.LoadingCallBack));
    CCTextureCache:sharedTextureCache():addImageAsync("effect1.png", callFunc(self, self.LoadingCallBack));
    CCTextureCache:sharedTextureCache():addImageAsync("icon.png", callFunc(self, self.LoadingCallBack));
    CCTextureCache:sharedTextureCache():addImageAsync("effect2.png", callFunc(self, self.LoadingCallBack));
end

function LoadingScene:LoadingCallBack()
    self.currentCount = self.currentCount + 1;
end

function LoadingScene:startGame()
    self.scheduler:unscheduleScriptEntry(self.schedulerEntry);
    display.replaceScene(MainScene.new(0), "SLIDEINB", 0.3);
end

function LoadingScene:update()
    self.currentCount = self.currentCount + 1;
    local percent = self.currentCount * 100 / self.totalCount;
    self.processBar:setPosition(ccp(30 + percent * 1.45 , 19));
    self.processBar:setScaleX(percent / 100);

    if self.currentCount == self.totalCount then
        self.scheduler:unscheduleScriptEntry(self.schedulerEntry);

        self.schedulerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.startGame), 0.3, false);
    end
end


function LoadingScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)

            layer:setKeypadEnabled(true)
        end, 0.5)
    end
end

function LoadingScene:onExit()
end

