-- -------------------------------------------------------------------------
--  文件名     ：   MapScene.lua
--  创建者     ：   Sundyhy
--  创建时间    ：  2014/1/3 11:02:03
--  功能描述    ：  地图基类
--
-- -----------------------------------------------------------------------*/
require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");

MapScene = class("MapScene", function()
    return display.newScene("MapScene")
end)

function GameMap:ctor()
    self.mMapName = "";
    self.mPath = {};
    self.mObjInfo = {};
    self.mMonsterInfo = {};
    self.mTowerInfo = {};

    self:initBg();
    self:initPath();
    self:initObject();
end

function MainMenuScene:initBg()
    local bg = CCSprite:create("map/" .. self.mMapName);
    bg:setPosition(display.cx, display.cy);

    local bgW = bg:getTextureRect():getMaxX();
    local bgH = bg:getTextureRect():getMaxY();
    bg:setScaleX(display.width / bgW);
    bg:setScaleY(display.height / bgH);
    self:addChild(bg, 0, 1);
end

function MainMenuScene:initPath()

end

function MainMenuScene:initObject()

end

function MainMenuScene:onMenuClick(tag)
    if tag == 1 then
        self:change2Start();
    end
    if tag == 2 then
        self:change2Load();
    end
    if tag == 3 then
        self:change2Help();
    end
end

function MainMenuScene:onEnter()
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

function MainMenuScene:onExit()
end
