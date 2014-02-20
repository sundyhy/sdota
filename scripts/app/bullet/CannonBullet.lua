--
-- Author: sundyhy@163.com
-- Date: 2014-01-23 14:10:12
--
require("scripts/app/base/Util.lua");

local CannonBullet = class("CannonBullet", function()
    return display.newNode();
end)


function CannonBullet:ctor()
	self.angularVelocity = 0;
end

function CannonBullet:initWithTarget(enemy)
	self.super:initWithFile("rocket.png");
	self.myEnemy = enemy;
	self.myEnemy:IamAimed(true);
	self:setDamage(10);
	self:setMaxDamage(30);
	self:setSpeed(200);

	self.angularVelocity = 10;
	self.streak = CCMotionStreak:create(0.4, 5, 5, ccc3(255, 255, 0), "rocket.png");
	self.streak:setFastMode(true);
	GameMediator:getGameLayer():addChild(self.streak);
end

function CannonBullet:update(dt)
	if GameMediator:getTargets():containsObject(self.myEnemy) then
		self:removeSelf();

		return;
	end

	local targetPos = self.myEnemy:getPosition();
	local myPos = self:getPosition();

	if GameMediator:getGameLayer():isOutOfMap(myPos) or self.myEnemy:getHP() <= 0 then
		self:removeSelf();
	end

	if self:getRect():intersectsRect(self.myEnemy:getRect()) and self.myEnemy:getHP() > 0 then
		self.myEnemy:setHP(self.myEnemy:getHP() - self:getDamage());
		local f = self.myEnemy:getHP() / self.myEnemy:totalHP;
		self.myEnemy.healthBar:setPercentage(f * 100);
		self.myEnemy:setDamage(self:getDamage(), self:getIsBoom());
		self:removeSelf();
	end

	local radian = math.atan2(targetPos.y - myPos.y, targetPos.x - myPos.x);
	local angle = -CC_RADIANS_TO_DEGREES(radian);
	angle = self:to360Angle(angel);

	local myAngle = self:to360Angle(self:getRotation());
	local tempAngle = myAngle;
	if myAngle < angle then
		tempAngle = angularVelocity;
	elseif myAngle > angle then
		tempAngle = -angularVelocity;
	else
		tempAngle = 0;
	end

	if 360 - (angle - myAngle) < angel - myAngle then
		tempAngle = tempAngle * -1;
	end

	self:setRotation(self:getRotation() + tempAngle);
	local myRadian = CC_DEGREES_TO_RADIANS(self:getRotation());
	local x = math.cos(myRadian) * self:getSpeed() * dt;
	local y = -math.sin(myRadian) * self:getSpeed() * dt;

	self:setPosition(ccp(myPos.x + x, myPos.y + y));
	self.streak:setPosition(ccp(myPos.x, myPos.y));
end

function CannonBullet.create(enemy)
	local cp = CannonBullet.new();
	if cp:initWithTarget(enemy) then
		cp:autorelease();

		return cp;
	end

	return nil;
end

function CannonBullet:to360Angle(angel)
	angle = angel % 360;
	if angle < 0 then
		angle += 360;
	end

	return angle;
end
