-- -------------------------------------------------------------------------
--  文件名     ：   LoadGameScene.lua
--  创建者     ：   Sundyhy
--  创建时间    ：  2013/12/6 15:35:55
--  功能描述    ：  加载游戏界面
--
-- -----------------------------------------------------------------------*/

require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");

LoadGameScene = class("LoadGameScene", function()
    return display.newScene("LoadGameScene")
end)

function LoadGameScene:ctor()
    self:initBg();
    self:initMenu();
end

function LoadGameScene:initBg()

end

function LoadGameScene:onEnter()
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

function LoadGameScene:onExit()
end

