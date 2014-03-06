--
-- Author: sundyhy@163.com
-- Date: 2014-03-06 14:50:41
--

require("scripts/app/base/Utils.lua");
require("scripts/app/scenes/StartScene.lua");

LogoScene = class("LogoScene", function()
    return display.newScene("LogoScene")
end)

function LogoScene:ctor()
    self.layer = display.newLayer();
    self:addChild(self.layer);

    local bg = CCSprite:create("logo.png");
    local bgW = bg:getTextureRect():getMaxX();
    local bgH = bg:getTextureRect():getMaxY();
    bg:setScaleX(display.width / bgW);
    bg:setScaleY(display.height / bgH);

    bg:setPosition(ccp(display.cx, display.cy));
    self.layer:addChild(bg);

    local actionArr = CCArray:create();

    local fadeIn = CCFadeIn:create(2.0);
    local delay = CCDelayTime:create(2.0);
    local fadeOut = CCFadeOut:create(2.0);
    local call = CCCallFunc:create(callFunc(self, self.changeToLogin));
    actionArr:addObject(fadeIn);
    actionArr:addObject(delay);
    actionArr:addObject(fadeOut);
    actionArr:addObject(call);
    local action = CCSequence:create(actionArr);
    bg:runAction(action);   
end

function LogoScene:changeToLogin()
    display.replaceScene(StartScene.new());
end

function LogoScene:onEnter()
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

function LogoScene:onExit()
end