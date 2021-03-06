--文件是自动生成,请勿手动修改.来自数据文件:templeAward
local M = {
   [101] = {17844, 101, 50, 1},
   [102] = {17845, 102, 100, 1},
   [103] = {17846, 103, 200, 1},
   [104] = {17847, 104, 500, 1},
   [105] = {17848, 105, 1000, 1},
   [106] = {17849, 106, 2000, 1},
   [107] = {17850, 107, 3000, 1},
   [108] = {17851, 108, 4000, 1},
   [109] = {17852, 109, 5000, 1},
   [201] = {17844, 201, 50, 2},
   [202] = {17853, 202, 100, 2},
   [203] = {17854, 203, 200, 2},
   [204] = {17855, 204, 500, 2},
   [205] = {17856, 205, 1000, 2},
   [206] = {17857, 206, 2000, 2},
   [207] = {17859, 207, 3000, 2},
   [208] = {17861, 208, 4000, 2},
   [209] = {17863, 209, 5000, 2},
   [301] = {17844, 301, 50, 3},
   [302] = {17866, 302, 100, 3},
   [303] = {17869, 303, 200, 3},
   [304] = {17871, 304, 500, 3},
   [305] = {17873, 305, 1000, 3},
   [306] = {17875, 306, 2000, 3},
   [307] = {17877, 307, 3000, 3},
   [308] = {17880, 308, 4000, 3},
   [309] = {17882, 309, 5000, 3},
   [401] = {17844, 401, 50, 4},
   [402] = {17886, 402, 100, 4},
   [403] = {17889, 403, 200, 4},
   [404] = {17891, 404, 500, 4},
   [405] = {17894, 405, 1000, 4},
   [406] = {17896, 406, 2000, 4},
   [407] = {17899, 407, 3000, 4},
   [408] = {17901, 408, 4000, 4},
   [409] = {17904, 409, 5000, 4},
   [501] = {17844, 501, 50, 5},
   [502] = {17908, 502, 100, 5},
   [503] = {17911, 503, 200, 5},
   [504] = {17914, 504, 500, 5},
   [505] = {17916, 505, 1000, 5},
   [506] = {17919, 506, 2000, 5},
   [507] = {17921, 507, 3000, 5},
   [508] = {17924, 508, 4000, 5},
   [509] = {17926, 509, 5000, 5},
}
local _namesByNum = {
   Id = 2,
   Point = 3,
   Process = 4,
}
local _namesByString = {
   Award = 1,
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
