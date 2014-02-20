--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 17:14:45
--
require("scripts/app/base/Util.lua");

Wave = class("Wave")

function Wave:ctor()

end

function Wave:initWithCreepSpawnRateTotalCreeps(spawnrate, redcreeps, greencreeps)
	self:setSpawnRate(spawnrate);
	self:setRedEnemys(redcreeps);
	self:setGreenEnemys(greencreeps);

	return true;
end

function Wave.create(spawnrate, redcreeps, greencreeps)
	local wave = Wave.new();
	
	if wave:initWithCreepSpawnRateTotalCreeps(spawnrate, redcreeps, greencreeps) then
	----	wave:autorelease();

		return wave;
	end

	return nil;
end

function Wave:getSpawnRate()
	return self.spawnRate;
end

function Wave:setSpawnRate(val)
	self.spawnRate = val;
end

function Wave:getRedEnemys()
	return self.redEnemys;
end

function Wave:setRedEnemys(val)
	self.redEnemys = val;
end

function Wave:getGreenEnemys()
	return self.greenEnemys;
end

function Wave:setGreenEnemys(val)
	self.greenEnemys = val;
end