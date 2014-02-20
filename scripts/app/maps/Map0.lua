--
-- Author: sundyhy@163.com
-- Date: 2014-01-29 23:33:10
--
require("scripts/app/base/Util.lua");
require("scripts/app/maps/Map.lua")

Map0 = class("Map0", function()
    return Map.new();
end)

function Map0:ctor()
end

function Map0:getBgName()
	return "maps/map0.png";
end

function Map0:getName()
	return "MAP-00";
end

function Map0:getWaysInfo()
	return {{0, 3}, {4, 3}, 
			{4, 3}, {4, 12}, 
			{4, 12}, {13, 12}, 
			{13, 12}, {13, 8}, 
			{13, 8}, {9, 8}, 
			{9, 8}, {9, 4}, 
			{9, 4}, {17, 4}, 
			{17, 4}, {17, 12}, 
			{17, 12}, {22, 12}, 
			{22, 12}, {22, 8}, 
			{22, 8}, {23, 8}
		};
end

function Map0:getLevel()
	return 0;
end

function Map0:getStartPos()
	return ccp(0, 3);
end

function Map0:getEndPos()
	return ccp(23, 8);
end