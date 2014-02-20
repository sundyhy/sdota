--
-- Author: Sundyhy
-- Date: 2014-01-20 17:28:55
--
require("scripts/app/base/Util.lua");

require("scripts/app/base/TileInfo.lua");
require("scripts/app/maps/MapFactory.lua");

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
	self.layer:setTouchEnabled(true);

	self.currentLevel = level;
	self:addWaves();

	self.gameMap = MapFactory.createMap(level);
	self.layer:addChild(self.gameMap, 0);

	audio.playBackgroundMusic("battle1.wav", true);

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

function MainScene:addTower(pos, towerTag)
	local target = nil;
	
	if not self.gameMap:canBuildOnTilePos(pos) then
		return false;
	end

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

	local tilePos = self.gameMap:pos2Tile(pos);
	local newPos = self.gameMap:tile2Pos(tilePos);
	target:setPosition(newPos);
	self.layer:addChild(target, 5);

	GameMediator:getTowers():addObject(target);

	local td = self.gameMap:getTileInfo(tilePos);
	td:setIsUsed(true);
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

	local star = self.gameMap:getStartPos();
	star = Map.tile2Pos(star);
	local target = nil;
	if toint(math.random() * 100) % 2 == 0 then
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

	table.merge(target.wayTilesArray, self.gameMap.wayTilesArray);
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
		self.lastTimeTargetAdded = now + 10000;
	end
end

function MainScene:removeTower(tower)
	GameMediator:getTowers():removeObject(tower);

	local coordPos = self.gameMap:tileCoordForPosition(tower:getPosition());
	local td = self:getTileInfo(coordPos);
	td:setIsUsed(false);

	self.layer:removeChild(tower, true);
end

function MainScene:onExit()
	audio.stopBackgroundMusic();
	audio.stopAllEffects();
	GameMediator:clear();

	local hud = self.gameHUD;
	hud:resetHUD();
end
