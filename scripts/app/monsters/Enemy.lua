-- -------------------------------------------------------------------------
--	文件名		：	Define.lua
--	创建者		：	Sundyhy
--	创建时间	：	2013/12/4 12:15:07
--	功能描述	：	常量定义
--
-- -----------------------------------------------------------------------*/

require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");

local Enemy = class("Enemy", function()
    return CCNode:create();
end)

function Enemy:ctor(fileName, hp, speed, figt, pos)
	self.mainLayer = GameMediator:getGameLayer();
	local maxTileWidth = mainLayer:getMaxTileWidth();
	local maxTileWidth = 
end

