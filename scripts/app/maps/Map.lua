--
-- Author: sundyhy@163.com
-- Date: 2014-01-29 15:44:15
--
require("scripts/app/base/Util.lua");

TILE_WIDTH = 41
TILE_HEIGHT = 34;

MAP_TILE_WIDTH = 24;
MAP_TILE_HEIGHT = 15;

Map = class("Map", function()
    return display.newLayer()
end)

function Map:ctor()
	self.curLevel = 0;

	self.tileInfoArr = {};
	self.wayTilesArray = {};
	self.totalWays = {};
	self.dirChangeArr = {};
end

function Map:loadInfo()
	self:initBgInfo();
	self:initEmitter();
end

--------------------------------地图数据
function Map:getBgName()
	return "";
end

function Map:getName()
	return "";
end

function Map:getWaysInfo()
	return {};
end

function Map:getLevel()
	return -1;
end

function Map:getStartPos()
	return ccp(-1, -1);
end

function Map:getEndPos()
	return ccp(-1, -1);
end
----------------------------------------

function Map:initBgInfo()
	local bg = CCSprite:create(self:getBgName());
    bg:setPosition(display.cx, display.cy);
    self:addChild(bg, 0);

    for i = 1, MAP_TILE_WIDTH do
    	for j = 1, MAP_TILE_HEIGHT do
    		local td = TileInfo.create(ccp(i - 1, j - 1));
    		if self:isWay(i - 1, j - 1) then
    			td:setIsWay(true);
    			table.insert(self.totalWays, td);
    		end

    		td.isThroughing = false;
    		table.insert(self.tileInfoArr, td);
    	end
    end

    self:initWayTiles();
end

function Map:initWayTiles()
	local pos = self:getStartPos();
	local orgDir = kRight;
	local num = 0;
	local tile = nil;

	for i = 1, 10000 do
		tile = self:getTileInfo(pos);
		table.insert(self.wayTilesArray, tile);
		tile.isThroughing = true;
		local tiles = self:getNextTiles(pos);

		local ways = 0;
		for i, v in ipairs(tiles) do
			local tempTile = self:getTileInfo(ccp(v[2], v[3]));

			if not tempTile:getIsThroughing() and tempTile:getIsWay() then
				if self:isExit(tempTile) == true then
					ways = ways + 1;
					local dir = v[1];
					if dir ~= orignDirection then
						num = num + 1;
						orignDirection = dir;
						tempTile:setDirection(dir);
						table.insert(self.dirChangeArr, tempTile);
					end
					pos = tempTile:getPosition();
					break;
				end
			end
		end

		if ways <= 0 then
			break;
		end
	end

	num = 0;
	for i = 1, table.nums(self.wayTilesArray) do
		local hi = self.wayTilesArray[i]; ---- self.wayTilesArray:objectAtIndex(i);
		if hi:getDirection() ~= kUnKnow then
			num = num + 1;
		end
	end
end

function Map:getNextTiles(tilePos)
	local tiles = {};
	if tilePos.y - 1 >= 0 then
		table.insert(tiles, {kUp, tilePos.x, tilePos.y - 1});
	end

	if tilePos.x - 1 >= 0 then
		table.insert(tiles, {kLeft, tilePos.x - 1, tilePos.y});
	end

	if tilePos.x + 1 < MAP_TILE_WIDTH then
		table.insert(tiles, {kRight, tilePos.x + 1, tilePos.y})
	end

	if tilePos.y + 1 < MAP_TILE_HEIGHT then
		table.insert(tiles, {kDown, tilePos.x, tilePos.y + 1});
	end

	return tiles;
end

function Map:isExit(tile)
	local ret = false;
	for i = 1, table.nums(self.totalWays) do
		local tempTile = self.totalWays[i];
		if tempTile:getPosition():equals(tile:getPosition()) then
			ret = true;
			break;
		end
	end

	return ret;
end

function Map:initEmitter()
	self.emitter = CCParticleRain:create();
	self:addChild(self.emitter, 10);
	self.emitter:setLife(4);
	self.emitter:setTexture(CCTextureCache:sharedTextureCache():addImage("fire.png"));
end

function Map.pos2Tile(pos)
	local cooX = toint(math.floor(pos.x / TILE_WIDTH));
	local cooY = toint(math.floor(MAP_TILE_HEIGHT - pos.y / TILE_HEIGHT));

	if cooX >= 0 and cooX < MAP_TILE_WIDTH and cooY >= 0 and cooY < MAP_TILE_HEIGHT then
		return ccp(cooX, cooY);
	end

	return ccp(-1. -1);
end

function Map.tile2Pos(pos)
	local x = pos.x * TILE_WIDTH + TILE_WIDTH * 0.5;
	local y = display.height - (pos.y * TILE_HEIGHT + TILE_HEIGHT * 0.5);

	return ccp(x, y); 
end

function Map.isOutOfMap(pos)
	if pos.x >= 0 and pos.x < MAP_TILE_WIDTH  and pos.y >= 0 and pos.y < MAP_TILE_HEIGHT  then
		return true;
	end

	return false;
end

function Map:canBuildOnTilePos(pos)
	local cooPos = self:pos2Tile(pos);

	if self:isOutOfMap(cooPos) then
		return false;
	end

	local td = self:getTileInfo(cooPos);
	if td:getIsUsed() or td:getIsThroughing() then
		return false;
	end

	return true;
end

function Map:getTileInfo(tilePos)
	for i = 1, table.nums(self.tileInfoArr) do
		local td = self.tileInfoArr[i];
		if td:getPosition():equals(tilePos) then
			return td;
		end
	end

	return nil;
end


function Map:isWay(tileX, tileY)
	local waysInfo = self:getWaysInfo();
	for i = 1, table.nums(waysInfo) - 1 do
		local temp0 = waysInfo[i];
		local temp1 = waysInfo[i + 1];
		
		local minX = math.min(temp0[1], temp1[1]);
		local maxX = math.max(temp0[1], temp1[1]);
		local minY = math.min(temp0[2], temp1[2]);
		local maxY = math.max(temp0[2], temp1[2]);
		if tileX >= minX  and tileX <= maxX and tileY >= minY and tileY <= maxY then
			return true;
		end	
	end

	return false;
end

