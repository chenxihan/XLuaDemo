--文件是自动生成,请勿手动修改.来自数据文件:pet_sacrifice_item
local M = {
   [50107] = {1000, 50107, 0},
   [50108] = {5000, 50108, 0},
   [50109] = {20000, 50109, 0},
   [70001] = {1000, 70001, 1010},
   [70002] = {1000, 70002, 2010},
   [70003] = {1000, 70003, 3010},
   [70004] = {1000, 70004, 4010},
   [70005] = {1000, 70005, 5010},
   [70006] = {2000, 70006, 6010},
   [70007] = {2000, 70007, 7010},
   [70008] = {2000, 70008, 8010},
   [70009] = {2000, 70009, 9010},
   [70010] = {2000, 70010, 10010},
   [70012] = {1500, 70012, 12010},
   [70013] = {1500, 70013, 13010},
   [70014] = {1500, 70014, 11010},
   [70015] = {1500, 70015, 15010},
   [70016] = {1500, 70016, 16010},
   [70020] = {3000, 70020, 20010},
   [70021] = {3000, 70021, 21010},
   [70022] = {3000, 70022, 22010},
   [70023] = {3000, 70023, 23010},
}
local _namesByNum = {
   Exp = 1,
   ItemID = 2,
   PetLevel = 3,
}
local _namesByString = {
}
local mt = {}
mt.__index = function (t,key)
    local _value = _namesByNum[key]
    if _value ~= nil then
        return t[_value]
    end
    _value = _namesByString[key]
    if _value ~= nil then
        return StringDefines[t[_value]]
    end
    if key ~= "_OnCopyAfter_" then
        Debug.LogError(string.format("不存在 key = %s", key))
    end
end
for _,v in pairs(M) do
    setmetatable(v,mt)
end
return M
