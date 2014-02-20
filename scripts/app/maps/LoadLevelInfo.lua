--
-- Author: sundyhy@163.com
-- Date: 2014-01-24 18:22:09
--
require("scripts/app/base/Util.lua");

LoadLevelInfo = class("LoadLevelInfo", function()
    return display.newNode();
end)

function LoadLevelInfo:ctor()
	self.needToLoadImages = nil;
	self.levelParameter = nil;
	self.masters = nil;
end

function LoadLevelInfo:release()
end

function LoadLevelInfo.create(plistPath)
	local lli = LoadLevelInfo.new();
	if lli:setPlist(plistPath) then
		lli:autorelease();

		return lli;
	end

	return nil;
end

function LoadLevelInfo:setPlist(plistPath)
	local ccd = CCDictionary:createWithContentsOfFile(plistPath);
	self.needToLoadImages = ccd:objectForKey(NEED_TO_LOAD_IMAGES);
	self.levelParameter = ccd:objectForKey(LEVEL_PARAMETER);
	self.masters = ccd:objectForKey(MASTERS);
	ccLog("needtoloadimages count is : %d", self.needToLoadImages:count());
	ccLog("levelParameter count is : %d", self.levelParameter:count());
	ccLog("masters count is : %d", self.masters:count());
end

function LoadLevelInfo:getLevelInfo(key)
	local temp = self.levelParameter:objectForKey(key);
	return tonumber(temp);
end

function LoadLevelInfo:getLevelTmxPath(key)
	local temp = self.levelParameter:objectForKey(key);

	return temp;
end

function LoadLevelInfo:getLoadingImages(key)
	local str = string.format("%d", key);
	local temp = self.needToLoadImages:objectForKey(str);

	return temp;
end

function LoadLevelInfo:getMasterByTypeId(type)
	local temp = self.masters:objectForKey(string.format("%d", type));

	return temp;
end

function LoadLevelInfo:clearAll()
	self.needToLoadImages:removeAllObjects();
	self.levelParameter:removeAllObjects();
	self.masters:removeAllObjects();
end
