-- -------------------------------------------------------------------------
--  文件名     ：   StartScene.lua
--  创建者     ：   Sundyhy
--  创建时间    ：  2013/12/6 15:35:55
--  功能描述    ：  加载游戏界面
--
-- -----------------------------------------------------------------------*/

require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");
require("scripts/app/layers/TowersList.lua");
require("scripts/app/layers/ListPage.lua");

require("scripts/app/scenes/LoadingScene.lua");

MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
    self:initBg();
    self:initMenu();
end

function MenuScene:initBg()
    local bg = g_PlistMgr:getSprite("btn.plist", "mainmenuback.png");
    bg:setPosition(display.cx, display.cy);

    local bgW = bg:getTextureRect():getMaxX();
    local bgH = bg:getTextureRect():getMaxY();
    bg:setScaleX(display.width / bgW);
    bg:setScaleY(display.height / bgH);
    self:addChild(bg, 0, 1);

    local title = ui.newTTFLabel({
        text = "Defense of the Ancients",
        font = "Arial",
        size = 36,
        color = ccc3(255, 198, 2),
        align = ui.TEXT_ALIGN_CENTER
    });

    title:setPosition(display.width / 2 * 1 + 50, display.height / 5 * 4);
    self:addChild(title);

    local version = ui.newTTFLabel({
        text = "Version: 0.0.1.2",
        font = "Arial",
        size = 18,
        color = ccc3(255, 255, 255),
        align = ui.TEXT_ALIGN_CENTER
    });

    version:setPosition(display.width - version:getContentSize().width / 2 - version:getContentSize().height / 2, display.height - version:getContentSize().height / 2);
    self:addChild(version);

end

function MenuScene:initMenu()
    local posStartX = display.width / 3 * 2;
    local posStartY = display.height / 3;

    local menuList = {};
    local menuStart = self:createMainMenuBtn("Start  Game", posStartX, posStartY  + posStartY / 2, 1);
    local menuLoad  = self:createMainMenuBtn("Towers Info", posStartX, posStartY, 2);
    local menuHelp  = self:createMainMenuBtn("Maps   Info", posStartX, posStartY - posStartY / 2, 3);

    local mainMenu = ui.newMenu({menuStart, menuLoad, menuHelp});
    
    mainMenu:setPosition(ccp(0, 0));
    self:addChild(mainMenu);
end

function MenuScene:createMainMenuBtn(btnTitle, x, y, itemTag)
    local btnnSprite = g_PlistMgr:getSprite("btn.plist", "big_btn_n.png");
    local btnpSprite = g_PlistMgr:getSprite("btn.plist", "big_btn_p.png");

    local menuItem = ui.newImageMenuItem({
        image = btnnSprite,
        imageSelected = btnpSprite,
        tag = itemTag,
        listener = callFunc(self, self.onMenuClick)
    });

    local menuItemName = ui.newTTFLabel({
        text = btnTitle,
        font = "Arial",
        size = 28,
        align = ui.TEXT_ALIGN_CENTER -- 文字内部居中对齐
    });

    local itemSize = menuItem:rect().size;
    menuItemName:setPosition(ccp(itemSize.width / 2, itemSize.height / 2));
    menuItem:addChild(menuItemName);

    menuItem:setScaleX(0.8);
    menuItem:setScaleY(0.8);

    menuItem:setPosition(ccp(x, y));

    return menuItem;
end

function MenuScene:onMenuClick(tag)
    if tag == 1 then
        self:change2Start();
    end
    if tag == 2 then
        self:change2Towers();
    end
    if tag == 3 then
        self:change2Maps();
    end
end

function MenuScene:change2Start()
    display.replaceScene(LoadingScene.new());
end

function MenuScene:change2Towers()
    TowersList:show();
end

function MenuScene:change2Maps()
    local x = ListPage.new(200, 200, 4);
    self:addChild(x, 1);
   -- local scene = display.newScene("1111111111");
   -- scene:addChild(LevelSelect.new());
   -- print("---------------------222");
   -- display.replaceScene(scene);
   -- print("---------------------333");
end

function MenuScene:onEnter()
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

function MenuScene:onExit()
end

