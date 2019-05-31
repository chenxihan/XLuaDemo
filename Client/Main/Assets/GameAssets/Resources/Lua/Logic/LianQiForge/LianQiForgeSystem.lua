--作者： cy
--日期： 2019-04-26
--文件： LianQiForgeSystem.lua
--模块： LianQiForgeSystem
--描述： 1.本系统为：炼器功能的子功能 锻造 系统（目前仅有 装备强化。后续可能增加。如装备X化、装备Y化等）
--                （炼器 还有一个子功能是 宝石）
--      2.面板为：UILianQiForgeForm（目前只有1个分页：装备强化）
------------------------------------------------

local LianQiForgeSystem = {
    StrengthPosLevelDic = nil,   --装备强化字典，key = 部位，value = {等级，熟练度}
    StrengthMaxLevel = 0,
}

function LianQiForgeSystem:Initialize()
    self.StrengthPosLevelDic = Dictionary:New()
    self.StrengthMaxLevel = 285--DataConfig.DataEquipIntenMain[#DataConfig.DataEquipIntenMain].Level
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.SetFuncRedPoint, self);
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_WEAREQUIPSUC, self.SetFuncRedPoint, self);
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_UNWEAREQUIPSUC, self.SetFuncRedPoint, self);
end

function LianQiForgeSystem:UnInitialize()
    self.StrengthPosLevelDic:Clear()
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.SetFuncRedPoint, self);
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_WEAREQUIPSUC, self.SetFuncRedPoint, self);
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_UNWEAREQUIPSUC, self.SetFuncRedPoint, self);
end

--！！！强化功能开始！！！
--红点相关
function LianQiForgeSystem:SetFuncRedPoint()
    local _canStrenth = false
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self:IsMoneyEnoughByPos(i) then
            _canStrenth = true
            break
        end
    end
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiForgeStrength, _canStrenth);
end

function LianQiForgeSystem:IsMoneyEnoughByPos(pos)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    if _equip and self.StrengthPosLevelDic[pos] then
        local _strenthInfo = self.StrengthPosLevelDic[pos]
        --部位的最高强化等级
        local _posIntenMaxLv = self.StrengthMaxLevel
        --部位的最高强化等级对应的DataEquipIntenMain表
        local _posIntenMaxCfg = DataConfig.DataEquipIntenMain[self:GetCfgID(pos, _posIntenMaxLv)]
        --当前装备的最高强化等级
        local _equipIntenMaxLv = _equip.ItemInfo.LevelMax
        --当前装备最高强化等级对应的DataEquipIntenMain表
        local _equipIntenMaxCfg = DataConfig.DataEquipIntenMain[self:GetCfgID(pos, _equipIntenMaxLv)]
        if _strenthInfo.level < _equipIntenMaxLv then
            local _cfgID = self:GetCfgID(pos, _strenthInfo.level)
            local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
            if _cfg then
                local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
                local _needMoney = _cfg.StoneNum
                if _haveMoney >= _needMoney then
                    return true
                end
            end
        elseif _strenthInfo.level == _equipIntenMaxLv then
            --如果和当前装备最大等级相等，比较经验值
            if _equipIntenMaxCfg ~= nil and _strenthInfo.exp >= _equipIntenMaxCfg.ProficiencyMax then
                --如果比当前装备最大强化等级的最大经验还高，给提示
                return false
            else
                --如果比当前装备最大强化等级的最大经验小，发消息
                local _cfgID = self:GetCfgID(pos, _strenthInfo.level)
                local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
                if _cfg then
                    local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
                    local _needMoney = _cfg.StoneNum
                    if _haveMoney >= _needMoney then
                        return true
                    end
                end
            end
        else
            return false
        end
    end
    return false
end

--此消息目前没用（因为上线会发一次）。该消息为：请求所有部位强化信息
function LianQiForgeSystem:ReqEquipStrength(holder)
    GameCenter.Network.Send("MSG_Equip.ReqEquipStrength", {placeholder = holder})
end

--所有部位强化信息返回，上线会发一次。如果装备更新（强化上限该变），也会同步一次消息
function LianQiForgeSystem:GS2U_ResEquipStrength(result)
    local count = Utils.GetTableLens( result.infos )
    if result.infos ~= nil then
        for i = 1, count do
            local levelInfo = { level = result.infos[i].level, exp = result.infos[i].exp }
            if self.StrengthPosLevelDic:ContainsKey(result.infos[i].type) then
                self.StrengthPosLevelDic[result.infos[i].type] = levelInfo
            else
                self.StrengthPosLevelDic:Add(result.infos[i].type, levelInfo)
            end
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CHANGE_EQUIPMAXSTRENGTHLV, result.infos[i].type)
        end
    end
    self:SetFuncRedPoint()
end

--请求强化，pos为部位，isOneKey表示是否一键强化
function LianQiForgeSystem:ReqEquipStrengthUpLevel(pos, oneKey)
    --pos:部位
    GameCenter.Network.Send("MSG_Equip.ReqEquipStrengthUpLevel", {type = pos, isOneKey = oneKey})
end

--强化返回
function LianQiForgeSystem:GS2U_ResEquipStrengthUpLevel(result)
    if self.StrengthPosLevelDic:ContainsKey(result.info.type) then
        --local oldLevel = self.StrengthPosLevelDic[result.info.type].level
        self.StrengthPosLevelDic[result.info.type].level = result.info.level
        self.StrengthPosLevelDic[result.info.type].exp = result.info.exp
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_ALLINFO, result)
    end
    self:SetFuncRedPoint()
end
--！！！强化功能结束！！！


--通过部位（0,1,2……）获取DataEquipIntenMain配置表ID
function LianQiForgeSystem:GetCfgID(pos, level)
    return (pos + 100) * 1000 + level
end

--获取强化总等级
function LianQiForgeSystem:GetTotalStrengthLv()
    local _totalLv = 0
    for k,v in pairs(self.StrengthPosLevelDic) do
        local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(k)
        if v ~= nil and _equip ~= nil then
            _totalLv = _totalLv + v.level
        end
    end
    return _totalLv
end

return LianQiForgeSystem