--
-- Author: sundyhy@163.com
-- Date: 2014-01-29 23:14:40
--
require("scripts/app/maps/Map.lua");
require("scripts/app/maps/Map0.lua");

MapFactory = {};

function MapFactory.createMap(level)
	local map = nil;
	if level == 0 then
		map = Map0.new();
	end

	if map ~= nil then
		map:loadInfo();
	end

	return map;
end