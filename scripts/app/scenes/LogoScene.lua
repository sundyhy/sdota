--
-- Author: sundyhy@163.com
-- Date: 2014-01-16 15:53:08
--

require("scripts/app/base/Util.lua");

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

    local fadeIn = CCFadeIn:create(0.1);
    local delay = CCDelayTime:create(0.1);
    local fadeOut = CCFadeOut:create(0.1);
    local call = CCCallFunc:create(callFunc(self, self.changeToLogin));
    actionArr:addObject(fadeIn);
    actionArr:addObject(delay);
    actionArr:addObject(fadeOut);
    actionArr:addObject(call);
    local action = CCSequence:create(actionArr);
    bg:runAction(action);   
end

function LogoScene:changeToLogin()
    require("scripts/app/scenes/MenuScene.lua");
    display.replaceScene(MenuScene.new());
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
