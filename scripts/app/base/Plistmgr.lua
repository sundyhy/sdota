-- -------------------------------------------------------------------------
--	文件名		：	Plistmgr.lua
--	创建者		：	Sundyhy
--	创建时间	：	2013/12/5 17:18:57
--	功能描述	：	plist文件的加载
--
-- -----------------------------------------------------------------------*/

PlistMgr = class("PlistMgr");

function PlistMgr:ctor()
	self.mFileInfo = {};
end

function PlistMgr:getPlist(file)
	local plistData = self.mFileInfo[file];
	if not plistData then
		plistData = CCDictionary:createWithContentsOfFile(file);
		if not plistData then
			error("no file:" .. file);
			return nil;
		end

		plistData:retain();
		self.mFileInfo[file] = plistData;
	end

	return plistData;
end

function PlistMgr:getImageCount(file)
	local plist = self:getPlist(file);
	if not plist then
		return 0;
	end

	local frames = tolua.cast(plist:objectForKey("frames"), "CCDictionary");
	if frames then
		return frames:count();
	end

	return 0;
end

function PlistMgr:getImageNames(file)
	local plist = self:getPlist(file)
	if not plist then
		return nil
	end

	local frames = tolua.cast(plist:objectForKey("frames"), "CCDictionary")
	if frames then
		return frames:allKeys()
	end

	return nil
end

function PlistMgr:getSprite(listFileName, spriteName)
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
    cache:addSpriteFramesWithFile(listFileName);

    local sprite = CCSprite:createWithSpriteFrameName(spriteName);

    return sprite;
end

function PlistMgr:getScale9Sprite(listFileName, spriteName)
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
    cache:addSpriteFramesWithFile(listFileName);

    local sprite = CCScale9Sprite:createWithSpriteFrameName(spriteName);

    return sprite;	
end

g_PlistMgr = g_PlistMgr or PlistMgr.new();

