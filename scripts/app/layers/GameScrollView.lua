--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 17:53:40
--
require("scripts/app/base/Util.lua");

GameScrollView = class("GameScrollView", function()
    return CCScrollView:create();
end)

ADJUST_ANIM_VELOCITY = 2000;

function GameScrollView:ctor()
	self.pageCount = 0;
	self.prePage = 0;
	self.beginOffset = ccp(0, 0);
	self.cellSize = nil;
	self.adjustSpeed = ADJUST_ANIM_VELOCITY;

	self:setClippingToBounds(true)
    self:setBounceable(true)

	self.scheduler = CCDirector:sharedDirector():getScheduler();
end

function GameScrollView:setInitPageFunc(func)
	self.initPageFunc = func;
end

function GameScrollView:setScrollViewScrollEndFunc(func)
	self.scrollViewEndFunc = func;
end

function GameScrollView:release()
end

function GameScrollView:onTouchBegan(x, y)
	self.beginOffset = self:getContentOffset();

	return true;
end

function GameScrollView:onTouchMoved(x, y)
end

function GameScrollView:onTouchEnded(x, y)
	local endOffset = self:getContentOffset();
	if self.beginOffset:equals(endOffset) then
		local pageIndex = math.abs(endOffset.x / self.cellSize.width);
		self:scrollViewClick(self.begingOffset, endOffset, self.containter:getChildByTag(pageIndex), pageIndex);
		return;
	end

	self:adjustScrollView(self.beginOffset, endOffset);
end

function GameScrollView:adjustScrollView(beginPoint, endPoint)
	local pageIndex = math.abs(beginPoint.x / self.cellSize.width);
	local adjustPageIndex = 0;
	local dis = endPoint.x - beginPoint.x;

	if dis < -self:getViewSize().width / 5 then
		print("11-----");
		adjustPageIndex = pageIndex + 1;
	elseif dis > self:getViewSize().width / 5 then
		print("22-----");
		adjustPageIndex = pageIndex - 1;
	else
		print("33-----");
		adjustPageIndex = pageIndex;
	end

	adjustPageIndex = math.min(adjustPageIndex, self.pageCount - 1);
	adjustPageIndex = math.max(adjustPageIndex, 0);

	self:scrollToPage(adjustPageIndex);
end

function GameScrollView:scrollToPage(pageIndex)

	local offset = self:getContentOffset();
	local adjustPos = ccp(-self.cellSize.width * pageIndex, 0);
	print(pageIndex, adjustPos);
	local adjustAnimDelay = ccpDistance(adjustPos, offset) / self.adjustSpeed;

	self:setContentOffsetInDuration(adjustPos, adjustAnimDelay);

	if pageIndex ~=  self.prePage then
		self.schedulerEntry = self.scheduler:scheduleScriptFunc(callFunc(self, self.onScellEnd), adjustAnimDelay, false);
		self.prePage = pageIndex;
	end
end

function GameScrollView:onScellEnd()
	self.scheduler:unscheduleScriptEntry(self.schedulerEntry);
	local pageIndex = self:getCurPage();
	self.scrollViewEndFunc(self:getContainer():getChildByTag(pageIndex), pageIndex);
end

function GameScrollView:scrollToNextPage()
	local pageIndex = self:getCurPage();
	if pageIndex >= self.pageCount - 1 then
		return;
	end
	self:scrollToPage(pageIndex + 1);
end

function GameScrollView:scrollToPrePage()
	local pageIndex = self:getCurPage();
	if pageIndex <= 0 then
		return;
	end

	self:scrollToPage(pageIndex - 1);
end

function GameScrollView:createContainer(count, cellSize)
	self.pageCount = count;
	self.cellSize = cellSize;

	local container = display.newLayer();
	container:setAnchorPoint(ccp(0, 0));
	container:setPosition(ccp(0, 0));

	for i = 1, count do
		local node = display.newNode();
		if self.initPageFunc then
			self.initPageFunc(node, i - 1);
		end

		node:setPosition(ccp(display.cx + (i - 1) * cellSize.width, display.cy));
		node:setTag(i);
		container:addChild(node);
	end

	self:setContainer(container);
	self:setContentSize(CCSize(cellSize.width * count, cellSize.height));
end

function GameScrollView:getCurPage()
	return math.abs(self:getContentOffset().x / self.cellSize.width);
end