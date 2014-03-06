--
-- Author: sundyhy@163.com
-- Date: 2014-01-16 11:24:07
--

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

require("app.MyApp").new():run()
