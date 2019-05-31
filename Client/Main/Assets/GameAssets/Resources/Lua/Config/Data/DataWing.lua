--文件是自动生成,请勿手动修改.来自数据文件:wing
local M = {
   [1] = {1, 160, 19448, 19449, 19450, 1, 10, 19451, 19452, 0, 3, 19453, 1, 0, 19454, 19455, 19451},
   [2] = {1, 160, 19456, 19457, 19458, 2, 10, 19459, 19460, 0, 3, 19461, 1, 0, 19462, 19463, 19459},
   [3] = {1, 160, 19464, 19465, 19466, 3, 10, 19467, 19468, 1, 3, 19469, 1, 0, 19470, 19471, 19467},
   [4] = {1, 160, 19472, 19473, 19474, 4, 10, 19475, 19476, 1, 3, 19477, 1, 0, 19478, 19479, 19475},
   [5] = {1, 160, 19480, 19481, 19482, 5, 10, 19483, 19484, 1, 3, 19485, 1, 0, 19486, 19487, 19483},
   [6] = {19488, 160, 8455, 19489, 19490, 6, 10, 19491, 19492, 1, 3, 19493, 1, 0, 19494, 19488, 19491},
   [7] = {1, 160, 19495, 19496, 19497, 7, 10, 19498, 19499, 1, 3, 19500, 1, 0, 19501, 19502, 19498},
   [8] = {19503, 160, 16762, 19504, 19505, 8, 10, 19506, 19507, 1, 3, 19508, 1, 0, 19509, 19503, 19506},
   [9] = {1, 160, 19510, 19511, 19512, 9, 10, 19513, 19514, 1, 3, 19515, 1, 0, 19516, 19517, 19513},
   [10] = {19518, 200, 1, 1, 19519, 10, 10, 19520, 19521, 1, 3, 19522, 1, 0, 19522, 19518, 19520},
   [100] = {1, 170, 1, 1, 1, 100, 0, 19523, 19524, 1, 3, 19525, 19526, 60, 1, 1, 19523},
   [101] = {1, 170, 1, 1, 1, 101, 0, 19527, 19528, 1, 3, 19529, 19530, 666, 1, 1, 19527},
   [102] = {1, 170, 1, 1, 1, 102, 0, 19531, 19532, 1, 3, 19533, 19534, 6666, 1, 1, 19531},
}
local _namesByNum = {
   CameraSize = 2,
   Id = 6,
   MaxLevel = 7,
   Notice = 10,
   RentLanzuan = 14,
}
local _namesByString = {
   ActiveItem = 1,
   Condition = 3,
   ConditionInfo = 4,
   Icon = 5,
   Model = 8,
   Name = 9,
   QNameColor = 11,
   RentAtt = 12,
   RentInfo = 13,
   TrainAttr = 15,
   TrainItem = 16,
   UiModel = 17,
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