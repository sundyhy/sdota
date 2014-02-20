--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 17:24:07
--
require("scripts/app/base/Util.lua");

kDown 	= 0;
kLeft 	= 1;
kUp 	= 2;
kRight 	= 3;
kUnKnow = 4;

TileInfo = class("TileInfo");

function TileInfo:ctor()
end

function TileInfo:initWithPosition(pos)
	self:setPosition(pos);

	self.parentTile = nil;
	
	self.gScore = 0;
	self.hScore = 0;

	self.isUsed = false;
	self.direction = kUnKnow;
	self.isThroughing = false;
	self.isThroughingCount = 0;

	return true;
end

function TileInfo.create(pos)
	local ti = TileInfo.new();
	if ti:initWithPosition(pos) then
		return ti;
	end

	return nil;
end

function TileInfo:fScore()
	return self.gScore + self.hScore;
end

function TileInfo:getIsThroughing()
	return self.isThroughing;
end

function TileInfo:setIsInThroughing(val)
	if val then
		self.isThroughingCount = self.isThroughingCount + 1;
	else
		self.isThroughingCount = self.isThroughingCount - 1;
	end

	if self.isThroughingCount <= 0 then
		self.isThroughing = false;
	else
		self.isThroughing = true;
	end
end

function TileInfo:getParentTile()
	return self.parentTile;
end

function TileInfo:setParentTile(val)
	self.parentTile = val;
end

function TileInfo:getStartPos()
	return self.startPos;
end

function TileInfo:setStartPos(val)
	self.startPos = val;
end

function TileInfo:getPosition()
	return self.position;
end

function TileInfo:setPosition(val)
	self.position = val;
end

function TileInfo:getGScore()
	return self.gScore;
end

function TileInfo:setGScore(val)
	self.gScore = val;
end

function TileInfo:getHScore()
	return self.hScore;
end

function TileInfo:setHScore(val)
	self.hScore = val;
end

function TileInfo:getIsWay()
	return self.isWay;
end

function TileInfo:setIsWay(val)
	self.isWay = val;
end

function TileInfo:getIsUsed()
	return self.isUsed;
end

function TileInfo:setIsUsed(val)
	self.isUsed = val;
end

function TileInfo:getDirection()
	return self.direction;
end

function TileInfo:setDirection(val)
	self.direction = val;
end