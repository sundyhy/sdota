-- -------------------------------------------------------------------------
--	文件名		：	Util.lua
--	创建者		：	Sundyhy
--	创建时间	：	2013/12/4 12:15:07
--	功能描述	：	辅助函数定义
--
-- -----------------------------------------------------------------------*/

callFunc = function(obj, func)
    return function(...)
        return func(obj, ...);
    end
end

ccLog = function(...)
	print(string.format(...));
end

printTable = function(tb)
	print("print tb[")
	for k, v in pairs(tb) do
		print("---", k, v);
	end
	print("]");
end

CC_RADIANS_TO_DEGREES = function(angle)
	return angle * 57.29577951;
end

CC_DEGREES_TO_RADIANS = function(angle) 
	return angle * 0.01745329252;
end

spriteFrameFromFile = function(fileTable, key, index)
	local tempInfo = fileTable[key];
	if tempInfo == nil then
		print("表中不存在key[" .. key .. "]");
		return nil;
	end

	tempInfo = tempInfo[index - 1];
	if tempInfo == nil then
		print("表中key[" .. key .. "]不存在索引为[" .. index .. "]");
		return nil;
	end

	local index = tonumber(tempInfo[1]);
	local name = tempInfo[2];
	local filename = tempInfo[3];

	local tempTexture = CCTextureCache:sharedTextureCache():textureForKey(filename);
	local frame = CCSpriteFrame:createWithTexture(tempTexture, CCRect(tonumber(tempInfo[4]), 
		tonumber(tempInfo[5]), tonumber(tempInfo[6]), tonumber(tempInfo[7])));
	
	return frame;
end 

frameSpriteFromFile = function(fileTable, key, index)
	local frame = spriteFrameFromFile(fileTable, key, index);
	local sprite = CCSprite:createWithSpriteFrame(frame);

	return sprite;
end

animateFromFile = function(fileTable, key, name, key2)

	local tempInfo = fileTable[key];
	if tempInfo == nil then
		print("表中不存在key[" .. key .. "]");
		return nil;
	end

	for i,v in ipairs(tempInfo) do
		
	end
end
