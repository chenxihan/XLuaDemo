--文件是自动生成,请勿手动修改.来自数据文件:TaskChapter
local M = {
   [520001] = {20933, 20934, 520001, 20935, 20936, 20937},
   [510201] = {20938, 20937, 510201, 20939, 20940, 20941},
   [510302] = {20942, 20941, 510302, 20943, 20944, 20945},
   [504001] = {20946, 20945, 504001, 20947, 20948, 20949},
   [505001] = {20950, 20949, 505001, 20951, 20952, 20953},
   [510408] = {20954, 20953, 510408, 20955, 20956, 20957},
   [506013] = {20958, 20957, 506013, 20959, 20960, 20961},
   [510701] = {20958, 20961, 510701, 20962, 20963, 20964},
   [510801] = {20958, 20964, 510801, 20965, 20966, 20967},
}
local _namesByNum = {
   Id = 3,
}
local _namesByString = {
   FinishAtt = 1,
   FinishTitle = 2,
   StartDesc = 4,
   StartName = 5,
   StartTitle = 6,
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
