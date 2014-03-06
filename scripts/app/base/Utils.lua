--
-- Author: sundyhy@163.com
-- Date: 2014-03-06 14:49:52
--

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
