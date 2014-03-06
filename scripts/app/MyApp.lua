--
-- Author: sundyhy@163.com
-- Date: 2014-01-16 15:35:55
--

require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

require("scripts/app/base/Utils.lua");
require("scripts/app/scenes/LogoScene.lua");

GameState = require("framework.api.GameState");

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self);

     GameState.init(function(param)
		local retValue = nil;
		if param.errorCode then
			ccLog("load game data error!!!");
		else
			if param.name == "save" then
				local str = json.encode(param.values);
				str = crypto.encryptXXTEA(str, "_data");
				retValue = {data = str};
			elseif param.name == "load" then
				
				local str = crypto.decryptXXTEA(param.values.data, "_data");
				retValue = json.decode(str);
			end
		end

		return retValue;
	end, "game_data.txt", "_data");

	GameData = GameState.load();
	if not GameData then
		GameData = {};
	end
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/");
    CCFileUtils:sharedFileUtils():addSearchPath("res/Resources");

    display.replaceScene(LogoScene.new());
end

return MyApp
