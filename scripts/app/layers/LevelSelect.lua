--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 17:49:10
--
require("scripts/app/base/Util.lua");
require("scripts/app/base/Plistmgr.lua");
require("scripts/app/layers/GameScrollView.lua")

LEVEL_COUNT = 5;

LevelSelect = class("LevelSelect", function()
    return display.newLayer();
end)

function LevelSelect:ctor()
	self:init();
end

function LevelSelect:init()
	self.dataArr = CCArray:create();
	self.dataArr:addObject(CCString:create("map1.png"));
	self.dataArr:addObject(CCString:create("map2.png"));
	self.dataArr:addObject(CCString:create("map3.png"));
	self.dataArr:addObject(CCString:create("map4.png"));
	self.dataArr:addObject(CCString:create("map5.png"));
	self.dataArr:retain();

	self.scrollView = GameScrollView.new();
	self.scrollView:setInitPageFunc(callFunc(self, self.initPage));
	self.scrollView:setScrollViewScrollEndFunc(callFunc(self, self.scrollViewScrollEnd));

	self.scrollView:createContainer(LEVEL_COUNT, CCSize(display.width, display.height));
	self.scrollView:setPosition(ccp(0, 0));
	self.scrollView:setContentOffset(ccp(0, 0));
	self.scrollView:setViewSize(CCSize(display.width, display.height));
	self.scrollView:setDirection(kCCScrollViewDirectionHorizontal);

	self:addChild(self.scrollView);

	self:setTouchEnabled(true);
	self:registerScriptTouchHandler(callFunc(self, self.onTouch));

	return true;
end

function LevelSelect:onEnter()

end

function LevelSelect:onExit()

end

function LevelSelect:release()

end

function LevelSelect:onTouch(eventType, x, y)
    if eventType == "began" then   
        return self:onTouchBegan(x, y);
    elseif eventType == "moved" then
        return self:onTouchMoved(x, y);
    else
        return self:onTouchEnded(x, y);
    end
end

function LevelSelect:onTouchBegan(x, y)
	local rt = self.scrollView:boundingBox();
	print("++++++", x, y, self.touchBegin, rt:containsPoint(ccp(x, y)));
	if rt:containsPoint(ccp(x, y)) then
		self.touchBegin = self.scrollView:onTouchBegan(x, y);
	end
	print("-1-1-1-1-1-1-1-1");
	return true;
end

function LevelSelect:onTouchMoved(x, y)
	local rt = self.scrollView:boundingBox();
	if self.touchBegin == true and rt:containsPoint(ccp(x, y)) then
		self.scrollView:onTouchMoved(x, y);
	end
end

function LevelSelect:onTouchEnded(x, y)
	local rt = self.scrollView:boundingBox();
	print("------", x, y, self.touchBegin, rt:containsPoint(ccp(x, y)));
	if self.touchBegin == true and rt:containsPoint(ccp(x, y)) then
		self.scrollView:onTouchEnded(x, y);
	end

	self.touchBegin = false;
end

function LevelSelect:initPage(pageNode, pageIndex)
	local file = self.dataArr:objectAtIndex(pageIndex);
	local sprite = CCSprite:create(file:getCString());
	pageNode:addChild(sprite);
	local label = CCLabelTTF:create(string.format("%d", pageIndex), "Arial", 20.0);
	label:setPosition(ccp(0, 200));
	pageNode:addChild(label);

	return true;
end

function LevelSelect:scrollViewScrollEnd(pageNode, pageIndex)
	ccLog("scrollViewScrollEnd %d", pageIndex);
end
