--
-- Author: Sundyhy
-- Date: 2014-01-11 10:04:13
--

TowersList = {}

function TowersList:init()
	self.towersInfos = CCArray:createWithCapacity(4);
	self.towersInfos:addObject(CCString:create("物理攻击，速度很快"));
	self.towersInfos:addObject(CCString:create("减速攻击，减速无伤害"));
	self.towersInfos:addObject(CCString:create("导弹攻击，自动锁定并跟踪目标，射程远，速度慢"));
	self.towersInfos:addObject(CCString:create("光明魔法攻击"));
	self.towersInfos:addObject(CCString:create("黑暗魔法攻击"));
	self.towersInfos:addObject(CCString:create("自然魔法攻击"));
	self.towersInfos:addObject(CCString:create("混乱攻击"));
	self.towersInfos:retain();

	self.towersImages = CCArray:create();
	self.towersImages:addObject(CCString:create("MachineGunTurret.png"));
	self.towersImages:addObject(CCString:create("FreezeTurret.png"));
	self.towersImages:addObject(CCString:create("CannonTurret.png"));
	self.towersImages:addObject(CCString:create("CannonTurret.png"));
	self.towersImages:addObject(CCString:create("CannonTurret.png"));
	self.towersImages:addObject(CCString:create("CannonTurret.png"));
	self.towersImages:addObject(CCString:create("CannonTurret.png"));
	self.towersImages:addObject(CCString:create("CannonTurret.png"));
	self.towersImages:retain();

	self.mLayerColor = CCLayerColor:create(ccc4(0, 100, 0, 125));
	self.mLayerColor:setTouchEnabled(true);
	self.mLayerColor:setContentSize(CCSize(display.width, display.height));

	local tableView = CCTableView:create(CCSizeMake(display.width - 150, display.height));
    tableView:setDirection(kCCScrollViewDirectionVertical);
    tableView:setPosition(CCPointMake(100, 0));
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown);
    self.mLayerColor:addChild(tableView)

    --registerScriptHandler functions must be before the reloadData function
    tableView:registerScriptHandler(callFunc(self, self.scrollViewDidScroll),CCTableView.kTableViewScroll)
    tableView:registerScriptHandler(TowersList.scrollViewDidZoom,CCTableView.kTableViewZoom)
    tableView:registerScriptHandler(TowersList.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(TowersList.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(TowersList.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(TowersList.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData();

    self:initDlg();
end

function TowersList:numberOfCellsInTableView(table)
   return TowersList.towersInfos:count();
end

function TowersList:scrollViewDidScroll(view)
    print("scrollViewDidScroll");
end

function TowersList.scrollViewDidZoom(view)
    print("scrollViewDidZoom");
end

function TowersList.tableCellTouched(table,cell)
    print("+++++++");
    print("cell touched at index: " .. cell:getIdx());
end

function TowersList.cellSizeForTable(table,idx)
    return 80, 75
end

function TowersList.tableCellAtIndex(table, idx)
    print("2222222222221111");
    local pString = TowersList.towersInfos:objectAtIndex(idx);
    local tString = TowersList.towersImages:objectAtIndex(idx);

    local cell = table:dequeueCell();
    if nil == cell then
        cell = CCTableViewCell:new();
        local sprite = CCSprite:create("hud.png");
        sprite:setAnchorPoint(CCPointMake(0,0));
        sprite:setPosition(CCPointMake(0, 0));
        cell:addChild(sprite)

        label = CCLabelTTF:create(pString:getCString(), "Arial", 10.0);
        label:setPosition(CCPointMake(10, 10));
        label:setAnchorPoint(CCPointMake(0,0));
        label:setColor(ccc3(0, 0, 255));
        label:setTag(123);
        cell:addChild(label);

        local tower = CCSprite:create(tString:getCString());
        tower:setPosition(CCPointMake(30,50));
        cell:addChild(tower);
    else
        label = tolua.cast(cell:getChildByTag(123),"CCLabelTTF")
        label:setString(pString:getCString());
        print("----------------", tString:getCString());
        local tower = CCSprite:create(tString:getCString());
        tower:setPosition(CCPointMake(30,50));
        cell:addChild(tower);
    end

    return cell;
end

function TowersList:initDlg()
	local okMenuFont = CCMenuItemFont:create("Return");
	okMenuFont:registerScriptTapHandler(callFunc(self, self.onOkMenuItem));
	okMenuFont:setFontSizeObj(20);
	okMenuFont:setPosition(ccp(okMenuFont:getContentSize().width / 2 + 10, display.height - 50));

	local menu = ui.newMenu({okMenuFont});
	menu:setPosition(ccp(0, 0));
	self.mLayerColor:addChild(menu);
end

function TowersList:onOkMenuItem()
    self:onClose();
end


function TowersList:show()
	self:init();

	CCDirector:sharedDirector():getRunningScene():addChild(self.mLayerColor);
end

function TowersList:onClose()
	self.mLayerColor:removeFromParentAndCleanup(true);
	self.mLayerColor = nil;
end

