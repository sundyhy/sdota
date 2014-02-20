--
-- Author: Sundyhy
-- Date: 2014-01-17 10:08:43
--

GameMediator = {}

function GameMediator:init()

	self:setCurMapId(0);

	self.nowSpeed = 1;
	
	self.gameLayer = nil;
	self.gameHUDLayer = nil;
	
	self.firstLoad = true;
	
	self.targets = CCArray:create();
	self.targets:retain();

	self.waves = {}; ---- CCArray:create();
----	self.waves:retain();

	self.towers = CCArray:create();
	self.towers:retain();

	self.maps = CCArray:create();
	self.maps:retain();

	self.projectTiles = CCArray:create();
	self.projectTiles:retain();
end

function GameMediator:setCurMapId(curId)
	self.curMapId = curId;
	self:setCurMapName(string.format("TileMap%d.tmx", curId));
end

function GameMediator:curMapId()
	return self.curMapId;
end

function GameMediator:IsFirstLoad()
	return self.firstLoad;
end


function GameMediator:SetFirstLoad(bFirst)
	self.firstLoad = bFirst;
end


function GameMediator:setGameLayer(layer)
	self.gameLayer = layer;
end

function GameMediator:setGameScene(scene)
	self.gameScene = scene;
end

function GameMediator:getGameMap()
	return self.gameScene.gameMap;
end

function GameMediator:getGameScene()
	return self.gameScene;
end

function GameMediator:getGameLayer()
	return self.gameLayer;
end

function GameMediator:getMaxTileW()
	return 24;
end

function GameMediator:getMaxTileH()
	return 15;
end

function GameMediator:setGameHUDLayer(gameHUD)
	self.gameHUDLayer = gameHUD;
end

function GameMediator:getGameHUDLayer()
	return self.gameHUDLayer;
end

function GameMediator:setCurMapName(mapName)
	self.curMapName = mapName;
end

function GameMediator:getCurMapName()
	return self.curMapName;
end

function GameMediator:getTowers()
	return self.towers;
end

function GameMediator:getWaves()
	return self.waves;
end

function GameMediator:addWave(wave)
	table.insert(self.waves, wave);
end

function GameMediator:getWave(index)
	local wave = self.waves[index];

	return self.waves[index];
end

function GameMediator:getTargets()
	return self.targets;
end

function GameMediator:clear()
	self.gameLayer:stopAllActions();
----	self.gameLayer:unscheduleAll();

	for i = 1, self.targets:count() do
		local enemy = self.targets:objectAtIndex(i - 1);
		enemy:stopAllActions();
		enemy:unscheduleAll();
	end

	for i = 1, self.towers:count() do
		local tower = self.towers:objectAtIndex(i - 1);
		tower:stopAllActions();
		tower:unscheduleAll();
	end

	for i = 1, self.projectTiles:count() do
		local projectTile = self.projectTiles:objectAtIndex(i - 1);
		projectTile:stopAllActions();
		projectTile:unscheduleAll();
	end

	self.targets:removeAllObjects();
	self.waves:removeAllObjects();
	self.towers:removeAllObjects();
	self.projectTiles:removeAllObjects();
end

GameMediator:init();
