--文件是自动生成,请勿手动修改.来自数据文件:sevendaypartystrong
local M = {
   [101] = {0, 17638, 726, 101, 1, 1024000, 1},
   [102] = {0, 5015, 882, 102, 6903, 0, 2},
   [103] = {6666, 17639, 880, 103, 1, 2030000, 1},
   [104] = {0, 5046, 876, 104, 1, 0, 1},
   [201] = {0, 17640, 737, 201, 1, 1024000, 1},
   [202] = {0, 17641, 877, 202, 1, 1022000, 1},
   [203] = {0, 17642, 886, 203, 1, 1026000, 1},
   [301] = {0, 4978, 737, 301, 1, 1047000, 1},
   [302] = {0, 17643, 1008, 302, 1, 1024000, 1},
   [401] = {0, 17644, 1008, 401, 1, 2261000, 1},
   [402] = {0, 17645, 281, 402, 1, 1023000, 1},
   [501] = {0, 17643, 732, 501, 1, 1024000, 1},
   [502] = {0, 4871, 740, 502, 1, 111000, 1},
   [601] = {0, 4859, 739, 601, 1, 102000, 1},
   [602] = {0, 17624, 887, 602, 1, 1024000, 1},
   [603] = {0, 17646, 492, 603, 1, 1046000, 1},
}
local _namesByNum = {
   CloneGroupID = 1,
   Icon = 3,
   Id = 4,
   OpenUI = 6,
   Type = 7,
}
local _namesByString = {
   Desc1 = 2,
   NpcID = 5,
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
