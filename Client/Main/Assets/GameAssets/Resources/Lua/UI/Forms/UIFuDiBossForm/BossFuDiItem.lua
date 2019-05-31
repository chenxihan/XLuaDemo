
------------------------------------------------
--作者： 王圣
--日期： 2019-05-14
--文件： BossFuDiItem.lua
--模块： BossFuDiItem
--描述： 福地Item
------------------------------------------------

-- c#类
local BossFuDiItem = {
    FuDiType = 0,
    Trans = nil,
    GoBtn = nil,
    GuildNameLabel = nil,
    LingZhuLabel = nil,
    JingYingLabel = nil,
    ShiwWeiLabel = nil,
}

function BossFuDiItem:New(trans, type)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.FuDiType = type
    _m.GoBtn = trans:Find("GoTo"):GetComponent("UIButton")
    _m.GuildNameLabel = trans:Find("Tips/GuildName"):GetComponent("UILabel")
    _m.LingZhuLabel = trans:Find("Tips/LingZhu/Count"):GetComponent("UILabel")
    _m.JingYingLabel = trans:Find("Tips/JingYing/Count"):GetComponent("UILabel")
    _m.ShiwWeiLabel = trans:Find("Tips/ShiWei/Count"):GetComponent("UILabel")
    return _m
end

function BossFuDiItem:SetData(data)
    if data == nil then
        return
    end
    if data.GuildName == nil then
        --china
        self.GuildNameLabel.text = "无"
    else
        self.GuildNameLabel.text = data.GuildName
    end
    --self.LingZhuLabel.text = data.
    for i = 1,#data.SurvivalList do
        if data.SurvivalList[i].MonsterType == 1 then
            self.LingZhuLabel.text = tostring(data.SurvivalList[i].Count)
        elseif data.SurvivalList[i].MonsterType == 2 then
            self.JingYingLabel.text = tostring(data.SurvivalList[i].Count)
        elseif data.SurvivalList[i].MonsterType == 3 then
            self.ShiwWeiLabel.text = tostring(data.SurvivalList[i].Count)
        end
    end
end
return BossFuDiItem