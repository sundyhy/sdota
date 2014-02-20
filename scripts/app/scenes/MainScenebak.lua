--
-- Author: Sundyhy
-- Date: 2014-01-20 17:28:55
--
require("scripts/app/base/Util.lua");
require("scripts/app/base/TileInfo.lua");
require("scripts/app/base/Wave.lua");

require("scripts/app/data/GameMediator.lua");

require("scripts/app/towers/MachineGunTower.lua");
require("scripts/app/towers/FreezeTower.lua");
require("scripts/app/towers/CannonTower.lua");
require("scripts/app/towers/MachineGunTower.lua");

require("scripts/app/base/Plistmgr.lua");

require("scripts/app/enemy/Enemy.lua");
require("scripts/app/enemy/FastRedEnemy.lua");
require("scripts/app/enemy/StrongGreenEnemy.lua");

MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor(level)
	self.layer = display.newLayer();
	CCTexture2D:PVRImagesHavePremultipliedAlpha(true);
	self.layer:setTouchEnabled(true);
	self:createTileMap();

	self.currentLevel = 0;
	self:addWaves();

	self.m_emitter = CCParticleRain:create();
	self.layer:addChild(self.m_emitter, 10);
	self.m_emitter:setLife(4);
	self.m_emitter:setTexture(CCTextureCache:sharedTextureCache():addImage("fire.png"));

---	local l = Lightning:create(ccp(160, maxHeight), ccp(200, 20));
---	l:setVisible(false);
---	self.layer:addChild(l, 1, 999);

	audio.playBackgroundMusic("battle1.wav", true);
---	self.layer:scheduleScriptFunc(nHandler, fInterval, bPaused)

	self:addChild(self.layer);

    self.gameHUD = sharedHUD();
    self:addChild(self.gameHUD, 2);

    GameMediator:setGameScene(self);
    GameMediator:setGameHUDLayer(self.gameHUD);

	self.scheduler = CCDirector:sharedDirector():getScheduler();
    self.gameLogicEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.gameLogic), 0.1, false);


    self:registerScriptTouchHandler(callFunc(self, self.onTouch));
    self:setTouchEnabled(true);
end

function MainScene:onTouch(eventType, x, y)
    if eventType == "began" then   
        return self:onTouchBegan(x, y);
    elseif eventType == "moved" then
        return self:onTouchMoved(x, y);
    else
        return self:onTouchEnded(x, y);
    end
end

function MainScene:onTouchBegan(x, y)

end

function MainScene:onTouchMoved(x, y)
end

function MainScene:onTouchEnded(x, y)

end

function MainScene:boundLayerPos(newPoint)
	local ret = CCPointMake(newPoint.x, newPoint.y);
	ret.x = math.min(ret.x, 0);
	ret.x = math.max(ret.x, display.width - self.mapSize.width);
	ret.y = math.min(0, ret.y);
	ret.y = math.max(display.height - self.mapSize.height, ret.y);
end

function MainScene:createTileMap()
	self.tileInfoArr = {};---CCArray:create();
	----self.tileInfoArr:retain();

	self.wayTilesArray = {}; ----CCArray:create();
	----self.wayTilesArray:retain();

	self.totalWays = {}; ---- CCArray:create();
	----self.totalWays:retain();

	self.dirChangeArr = {}; ----CCArray:create();
	----self.dirChangeArr:retain();


	self.gameMap = CCTMXTiledMap:create(GameMediator:getCurMapName());

	self.mapSize = self.gameMap:getContentSize();
	self.mapRect = CCRect(0, 0, self.mapSize.width, self.mapSize.height);
	self.gameMap:setPosition(0, 0);

	self.bg1Layer = self.gameMap:layerNamed("bg1");
	self.objects = self.gameMap:objectGroupNamed("Objects");

	self.layer:addChild(self.gameMap, 0);
	local tile = self.gameMap:getTileSize();
	self.tileSize = tile;

	self.maxWidth = self.mapSize.width - tile.width - tile.width / 2;
	self.mapHeight = self.mapSize.height - tile.height * 2 - tile.height / 2;
	local map = self.gameMap:getMapSize();
	self.maxTileWidth = map.width;
	self.maxTileHeight = map.height;

	GameMediator:setMaxTileW(self.maxTileWidth);
	GameMediator:setMaxTileH(self.maxTileHeight);

	for i = 1, self.maxTileWidth do
		for j = 1, self.maxTileHeight do
			local td = TileInfo.create(ccp(i - 1, j - 1));
			local gid = self.bg1Layer:tileGIDAt(ccp(i - 1, j - 1));
			local dic = self.gameMap:propertiesForGID(gid);

			if (dic ~= nil and dic:valueForKey("way"):intValue() == 1) then
				td:setIsWay(true);
				table.insert(self.totalWays, td);
				----self.totalWays:addObject(td);
			end

			td.isThroughing = false;
			table.insert(self.tileInfoArr, td);
			----self.tileInfoArr:addObject(td);
		end
	end
	self:getWayTiles();
end

function MainScene:objectPosition(group, object)
	local groupDic = group:objectNamed(object);
	local point = CCPointMake(0, 0);
	point.x = groupDic:valueForKey("x"):intValue() + self.tileSize.width / 2;
	point.y = groupDic:valueForKey("y"):intValue() + self.tileSize.height / 2;

	return point;
end

function MainScene:tileCoordinateFromPosition(pos)
	local cox = 0;
	local coy = 0;

	local szLayer = self.bg1Layer:getLayerSize();
	local szTile = self.gameMap:getTileSize();
	cox = toint(math.floor(pos.x / szTile.width));
	coy = toint(math.floor(szLayer.height - pos.y / szTile.height));

	if cox >= 0 and cox < szLayer.width and coy >= 0 and coy < szLayer.height then
		return ccp(cox, coy);
	end

	return ccp(-1, -1);
end

function MainScene:tileIDFromPosition(pos)
	local cpt = self:tileCoordinateFromPosition(pos);

	if cpt.x < 0 then
		return -1;
	end

	if cpt.y < 0 then
		return -1;
	end

	if cpt.x >= self.bg1Layer:getLayerSize().width then
		return -1;
	end

	if cpt.y >= self.bg1Layer:getLayerSize().height then
		return -1;
	end

	return self.bg1Layer:tileGIDAt(cpt);
end

function MainScene:tileCoordForPosition(pos)
	local x = 0;
	local y = 0;

	if pos.x < TILE_WIDTH then
		x = 0;
	elseif pos.x > maxWidth then
		x = maxTileWith - 1;
	else
		x = (pos.x - TILE_WIDTH) / TILE_WIDTH;
	end

	if pos.y < TILE_HEIGHT * 2 then
		y = 0;
	elseif pos.y > maxHeight then
		y = maxTileHeight - 1;
	else
		y = (pos.y - TILE_HEIGHT * 2) / TILE_HEIGHT;
	end

	return ccp(x, y);
end

function MainScene:positionForTileCoord(pos)
	local size = self.gameMap:getTileSize();
	local map = self.gameMap:getContentSize();

	x = pos.x * size.width + size.width * 0.5;
	y = map.height - pos.y * size.height - size.height * 0.5;

	return ccp(x, y);
end

function MainScene:canBuildOnTilePosition(pos)
	local towerLoc = self:tileCoordinateFromPosition(pos);

	if self:isOutOfMap(pos) == true then
		return false;
	end

	local td = self:getTileData(towerLoc);
	if td:getIsUsed() or td:getIsThroughing() then
		return false;
	end

	return true;
end

function MainScene:getTileData(tileCoord)
	for i = 1, table.nums(self.tileInfoArr) do
		local td = self.tileInfoArr[i];---- self.tileInfoArr:objectAtIndex(i - 1);
		if td:getPosition():equals(tileCoord) then
			return td;
		end
	end

	return nil;
end

function MainScene:getTileDataForPosition(tilePositon)
	local tilecoord = self:tileCoordForPosition(tilePositon);

	return self:getTileData(tilecoord);
end

function MainScene:addTower(pos, towerTag)
	local target = nil;
	local towerLoc = self:tileCoordinateFromPosition(pos);

	if self:canBuildOnTile(pos) then
		if towerTag == 1 then
			if self.gameHUD:getResources() >= 25 then
				target = MachineGunTower.new();
				self.gameHUD:updateResources(-25);
			else
				return;
			end
		elseif towerTag == 2 then
			if self.gameHUD:getResources() >= 30 then
				target = FreezeTower.new();
				self.gameHUD:updateResources(-30);
			else
				return;
			end
		elseif towerTag == 3 then
			if self.gameHUD:getResources() >= 40 then
				target = CannonTower.new();
				self.gameHUD:updateResources(-40);
			else
				return;
			end	
		elseif towerTag == 4 then
			if self.gameHUD:getResources() >= 60 then
				target = MutilTower.new();
				self.gameHUD:updateResources(-60);
			else
				return;
			end	
		end

		local newPos = self:positionForTileCoord(towerLoc);
		target:setPosition(newPos);
		self.layer:addChild(target, 5);

		GameMediator:getTowers():addObject(target);

		local td = self:getTileData(towerLoc);
		td:setIsUsed(true);
	end
end

function MainScene:getTilesNextToTile(tileCoord)
	local tiles = CCDictionary:create();
	if tileCoord.y - 1 >= 0 then
		tiles:setObject(CCString:create(string.format("{%f, %f}", tileCoord.x, math.max(tileCoord.y - 1, 0))), "up");
	end

	if tileCoord.x - 1 >= 0 then
		tiles:setObject(CCString:create(string.format("{%f, %f}", math.max(tileCoord.x - 1, 0), tileCoord.y)), "left");
	end

	if tileCoord.y + 1 >= 0 then
		tiles:setObject(CCString:create(string.format("{%f, %f}", tileCoord.x, math.min(tileCoord.y + 1, self.maxTileHeight - 1))), "down");
	end

	if tileCoord.x + 1 >= 0 then
		tiles:setObject(CCString:create(string.format("{%f, %f}", math.min(tileCoord.x + 1, self.maxTileWidth - 1), tileCoord.y)), "right");
	end

	return tiles;
end

function MainScene:isexit(tile)
	local ret = false;
	for i = 1, table.nums(self.totalWays) do
		local obj = self.totalWays[i]; ---- self.totalWays:objectAtIndex(i);
		if obj:getPosition():equals(tile:getPosition()) then
			ret = true;
			break;
		end
	end

	return ret;
end

function MainScene:addWaves()
	local wave = Wave.create(2.0, 5, 10);
	GameMediator:addWave(wave);

	local wave = Wave.create(1.7, 10, 15);
	GameMediator:addWave(wave);

	local wave = Wave.create(1.5, 25, 25);
	GameMediator:addWave(wave);
	
	local wave = Wave.create(1.3, 25, 30);
	GameMediator:addWave(wave);

	local wave = Wave.create(1.2, 30, 30);
	GameMediator:addWave(wave);
end

function MainScene:getWayTiles()
	local next = true;
	local star = self:objectPosition(self.objects, "pl1");
	local pos = self:tileCoordinateFromPosition(star);
	local orignDirection = kRight;
	local num = 0;
	local tile = nil;

	for i = 1, 10000 do
		ccLog(string.format("pos***%f, %f", pos.x, pos.y));
		tile = self:getTileData(pos);
		table.insert(self.wayTilesArray, tile);
		tile.isThroughing = true;
		local tiles = self:getTilesNextToTile(pos);
		
		local ways = 0;
		local dics = tiles:allKeys();
		for j = 1, dics:count() do
			local str = tolua.cast(dics:objectAtIndex(j - 1), "CCString");
			local tileName = tiles:objectForKey(str:getCString());
			
			local tileCoord = CCPointFromString(tileName:getCString());
			local neighbourTile = self:getTileData(tileCoord);

			if not neighbourTile:getIsThroughing() and neighbourTile:getIsWay() then
				if self:isexit(neighbourTile) == true then
					ways = ways + 1;
					local dir = self:directionFor(str);
					if dir ~= orignDirection then
						num = num + 1;
						orignDirection = dir;
						neighbourTile:setDirection(dir);
						table.insert(self.dirChangeArr, neighbourTile);
						----self.dirChangeArr:addObject(neighbourTile);
					end
					pos = neighbourTile:getPosition();
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

function MainScene:directionFor(dir)
	if string.find(dir:getCString(), "left") then
		return kLeft;
	elseif string.find(dir:getCString(), "right") then
		return kRight;
	elseif string.find(dir:getCString(), "up") then
		return kUp;
	elseif string.find(dir:getCString(), "down") then
		return kDown;
	end
end

function MainScene:getCurrentWave()
	local wave = GameMediator:getWave(self.currentLevel + 1);-- GameMediator:getWaves():objectAtIndex(self.currentLevel);
	return wave;
end

function MainScene:getNextWave()
	self.currentLevel = self.currentLevel + 1;

	if self.currentLevel >= 5 then
		ccLog("you have reached the end of the game");
		self.currentLevel = 1;
		self.layer:unscheduleAll();

		CCDirector:sharedDirector():replaceScene(CCTransitionJumpZoom:create(3.0, StartScene.new()));

		return nil;
	end

	wave = GameMediator:getWave(self.currentLevel + 1); ----GameMediator:getWaves():objectAtIndex(self.currentLevel);
	return wave;
end

function MainScene:addTarget()
	local wave = self:getCurrentWave();

	if wave:getRedEnemys() == 0 and wave:getGreenEnemys() == 0 then
		return;
	end

	local star = self:objectPosition(self.objects, "pl1");
	local target = nil;
	if math.random() % 2 == 0 then
		if wave:getRedEnemys() > 0 then
			target = FastRedEnemy.create(star);
			wave:setRedEnemys(wave:getRedEnemys() - 1);
		elseif wave:getGreenEnemys() > 0 then
			target = StrongGreenEnemy.create(star);
			wave:setGreenEnemys(wave:getGreenEnemys() - 1);
		end
	else
		if wave:getGreenEnemys() > 0 then
			target = StrongGreenEnemy.create(star);
			wave:setGreenEnemys(wave:getGreenEnemys() - 1);
		elseif wave:getRedEnemys() > 0 then
			target = FastRedEnemy.create(star);
			wave:setRedEnemys(wave:getRedEnemys() - 1);
		end
	end

	table.merge(target.wayTilesArray, self.wayTilesArray);
	self.layer:addChild(target, 1);
	GameMediator:getTargets():addObject(target);
end

function MainScene:gameLogic(dt)
	local wave = self:getCurrentWave();

	if GameMediator:getTargets():count() == 0 and wave:getRedEnemys() <= 0 and wave:getGreenEnemys() <= 0 then
		if self:getNextWave() == nil then
			return;
		end
		self.gameHUD:updateWaveCount();
	end

	if self.lastTimeTargetAdded == nil then
		self.lastTimeTargetAdded = 0;
	end

	local now = os.time();
	if self.lastTimeTargetAdded == 0 or now - self.lastTimeTargetAdded >= wave:getSpawnRate() then
		self:addTarget();
		self.lastTimeTargetAdded = now;
	end
end

function MainScene:isOutOfMap(pos)

	if self.mapRect:containsPoint(pos) then
		return false;
	end

	return true;
end

function MainScene:removeTower(tower)
	GameMediator:getTowers():removeObject(tower);

	local coordPos = self:tileCoordForPosition(tower:getPosition());
	local td = self:getTileData(coordPos);
	td:setIsUsed(false);

	self.layer:removeChild(tower, true);
end

function MainScene:strikeLight(dt)
	local l = self.layer:getChildByTag(999);

	math.randomseed(os.time());
	l:setStrikePoint(ccp(20 + math.random(0, self.mapSize.width), self.mapSize.height));
	l:setStrikePoint2(ccp(20 + math.random(0, self.mapSize.width), 10));
	l:setStrikePoint3(ccp(20 + math.random(0, self.mapSize.width), 10));

	l:setColor(ccc3(math.random(0, 255), math.random(0, 255), math.random(0, 255)));

	l:setDisplacement(100 + math.random(0, 200));
	l:setMinDisplacement(4 + math.random(0, 10));
	l:setLighteningWith(2.0);
	l:setSplit(true);

	l:strikeRandom();
end

function MainScene:onExit()
	audio.stopBackgroundMusic();
	audio.stopAllEffects();
	GameMediator:clear();

	local hud = self.gameHUD;
	hud:resetHUD();
end
