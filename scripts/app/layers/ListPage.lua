--
-- Author: sundyhy@163.com
-- Date: 2014-02-08 16:10:27
--
require("scripts/app/base/Util.lua");

ListPage = class("ListPage", function()
    return  CCLayerColor:create(ccc4(0, 100, 0, 125));
end)

function ListPage:ctor(pageWidth, pageHeight, pageCount)
	self.pageWidth = pageWidth;
	self.pageHeight = pageHeight;
	self.pageCount = pageCount;

	self:setTouchEnabled(true);
	self:setContentSize(CCSize(pageWidth * pageCount, pageHeight));
	
	self.curPageIndex = 1;
	local pos = ccp(display.cx - self.pageWidth / 2, display.cy - self.pageHeight / 2);
	self:setPosition(pos);

	self:registerScriptTouchHandler(callFunc(self, self.onTouch));
    self:setTouchEnabled(true);

    self:setTouchPriority(256);

	local tb = {};
	for i = 1, self.pageCount do
		local version = ui.newTTFLabel({
	    	text = "+++" .. i .. "+++",
	    	font = "Arial",
	    	size = 18,
	    	color = ccc3(255, 0, 0),
	    	align = ui.TEXT_ALIGN_CENTER
		});
		table.insert(tb, version);
	end

	self:initPageInfo(tb);
end

function ListPage:initPageInfo(pageList)
	for i, v in ipairs(pageList) do
		v:setPosition(ccp(self.pageWidth * (i * 2 - 1) / 2, self.pageHeight / 2));
		self:addChild(v);
	end
end

function ListPage:setCurrentPage(pageIndex)
	self.curPageIndex = pageIndex;

	local pos = ccp(display.cx - self.pageWidth * (pageIndex * 2 - 1) / 2, display.cy - self.pageHeight / 2);
	local move = CCMoveTo:create(0.1, pos);

	local actions = CCArray:create();
	actions:addObject(move);
    self:runAction(CCSequence:create(actions));
end

function ListPage:onTouch(eventType, x, y)
    if eventType == "began" then   
        return self:onTouchBegan(x, y);
    elseif eventType == "moved" then
        return self:onTouchMoved(x, y);
    else
        return self:onTouchEnded(x, y);
    end


end

function ListPage:onTouchBegan(x, y)
	self.startX = x;
    self.lastX = x;
    
    return true;
end

function ListPage:onTouchMoved(x, y)
    if self.lastX == x then
    	return;
    end

    local disX = x - self.lastX;
    self.lastX = x;

    local x, y = self:getPosition();
    self:setPosition(ccp(x + disX, y));
end

function ListPage:onTouchEnded(x, y)
	if x == self.startX then
		return;
	end

	local sig = 1;
	if x < self.startX then
		sig = -1;
	end

    local dis = math.ceil(math.abs(x - self.startX) / self.pageWidth);
    self:setCurrentPage(self.curPageIndex - dis * sig);
end