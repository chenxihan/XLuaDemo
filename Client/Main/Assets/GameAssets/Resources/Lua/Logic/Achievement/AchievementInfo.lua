------------------------------------------------
--作者：xihan
--日期：2019-05-17
--文件：AchievementItem.lua
--模块：AchievementItem
--描述：成就Info
------------------------------------------------
local L_Tonumber = tonumber;
local L_SplitStr = Utils.SplitStr;
local L_DeepCopy = Utils.DeepCopy;

--成就Info
local  AchievementInfo = {
    --配置Id
    Id = nil,
    --成就[配置表的数据,严禁修改]
    DataAchievementItem = nil,
    --成就类型[配置表的数据,严禁修改]
    DataAchievementTypeItem = nil,
    --功能Id
    FunctionId = nil,
    --需要达成的数量
    Count = nil,
    --当前状态(AchievementState枚举类型)
    State = nil,
    --奖励ItemId
    AwardItemId = nil,
    --奖励Item数量
    AwardItemCount = nil,
    --奖励Item是否绑定
    AwardItemBind = nil,
    --进度
    Progress = nil,
}

-- AchievementItem.__index = AchievementItem
local function InitData(self ,DataAchievementItem, DataAchievementTypeItem)
    self.Id = DataAchievementItem.Id;
    self.DataAchievementItem = DataAchievementItem;
    self.DataAchievementTypeItem = DataAchievementTypeItem;
    local _t = L_SplitStr(DataAchievementItem.Condition, "_");
    self.FunctionId = L_Tonumber(_t[1]);
    self.Count = L_Tonumber(_t[2]);
    local _award = L_SplitStr(DataAchievementItem.Item, "_");
    self.AwardItemId = L_Tonumber(_award[1]);
    self.AwardItemCount = L_Tonumber(_award[2]);
    self.AwardItemBind = L_Tonumber(_award[3]);
    self.State = AchievementState.None;
end

function AchievementInfo:New(id)
    -- local _data = setmetatable({},self)
    local _data = L_DeepCopy(self)
    local DataAchievement = DataConfig.DataAchievement;
    local DataAchievementType = DataConfig.DataAchievementType;
    local DataAchievementItem = DataAchievement[id]
    InitData(_data, DataAchievementItem, DataAchievementType[DataAchievementItem.BigType])
    return _data
end

function AchievementInfo:NewAll(DataTypeDic, DataIdDic)
    local DataAchievementType = DataConfig.DataAchievementType;
    for _,v in pairs(DataConfig.DataAchievement) do
        -- local _data = setmetatable({},self)
        local _data = L_DeepCopy(self)
        InitData(_data, v, DataAchievementType[v.BigType]);
        if not DataTypeDic:ContainsKey(v.BigType) then
            DataTypeDic:Add(v.BigType,Dictionary:New());
        end
        local _DataTypeDicBigType = DataTypeDic[v.BigType];
        if not _DataTypeDicBigType:ContainsKey(_data.FunctionId) then
            _DataTypeDicBigType:Add(_data.FunctionId, List:New());
        end
        _DataTypeDicBigType[_data.FunctionId]:Add(_data);
        DataIdDic:Add(v.Id,_data);
    end
    DataTypeDic:SortKey(function(a, b) return a < b end)
    -- DataTypeDic:Foreach(function(_, v)
    --     table.sort(v, function(a, b)
    --         return a.Count < b.Count;
    --     end)
    -- end)
end

return AchievementInfo