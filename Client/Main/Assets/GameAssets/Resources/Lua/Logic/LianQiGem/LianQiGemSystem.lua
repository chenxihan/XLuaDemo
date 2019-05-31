--作者： cy
--日期： 2019-05-09
--文件： LianQiGemSystem.lua
--模块： LianQiGemSystem
--描述： 1.本系统为：炼器功能的子功能 宝石 系统
--                （炼器 还有一个子功能是 锻造）
--      2.面板为：UILianQiGemForm（目前有3个分页：宝石镶嵌、宝石精炼、仙玉镶嵌）
------------------------------------------------

local LianQiGemSystem = {
    GemInlayCfgByPosDic = Dictionary:New(),             --宝石镶嵌配置表字典
    AllCanInlayGemIDList = List:New(),                  --所有能镶嵌的宝石List
    JadeInlayCfgByPosDic = Dictionary:New(),            --仙玉镶嵌配置表字典
    AllCanInlayJadeIDList = List:New(),                 --所有能镶嵌的仙玉List
    GemInlayInfoByPosDic = Dictionary:New(),            --宝石镶嵌信息字典
    JadeInlayInfoByPosDic = Dictionary:New(),           --仙玉镶嵌信息字典
    GemRefineInfoByPosDic = Dictionary:New(),           --宝石精炼信息字典
    RefineColorTypeDic = Dictionary:New(),              --精炼颜色字典
    GemRefineItemIDList = {19001, 19002, 19003, 19004, 19005, 19006},  --精炼所需道具id列表
    MaxHoleNum = 6,                                     --最大孔位
    GemMaxLevel = 0,                                    --宝石最大等级
    GemRefineMaxLevel = 100,                            --宝石最大精炼等级
    JadeMaxLevel = 0,                                   --仙玉最大等级
}

function LianQiGemSystem:Initialize()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _gemCfgID = 1000 + i
        local _gemCfg = DataConfig.DataGemstoneInlay[_gemCfgID]
        if _gemCfg then
            local _canInlayGemIDList = List:New()
            local _gemIDStringList = Utils.SplitStr(_gemCfg.GemstoneId, "_")
            for i=1,#_gemIDStringList do
                local _gemID = tonumber(_gemIDStringList[i])
                _canInlayGemIDList:Add(_gemID)
                if not self.AllCanInlayGemIDList:Contains(_gemID) then
                    self.AllCanInlayGemIDList:Add(_gemID)
                end
            end
            _canInlayGemIDList:Sort(
                function (a, b)
                    return a < b
                end
            )
            self.GemMaxLevel = self:GetGemLevelByItemID(_canInlayGemIDList[#_canInlayGemIDList])
            local _holeOpenConditions = Utils.SplitStr(_gemCfg.LocationCondition, ";")
            local _maxHole = _gemCfg.LimitNumber
            local _tempCfg = {CanInlayGemIDList = _canInlayGemIDList, HoleOpenConditions = _holeOpenConditions, MaxHole = _maxHole}
            self.GemInlayCfgByPosDic:Add(i, _tempCfg)

            if self.RefineColorTypeDic:ContainsKey(_gemCfg.ColorType) then
                local _posList = self.RefineColorTypeDic[_gemCfg.ColorType]
                if not _posList:Contains(i) then
                    _posList:Add(i)
                end
            else
                local _posList = List:New()
                _posList:Add(i)
                self.RefineColorTypeDic:Add(_gemCfg.ColorType, _posList)
            end
        end
        local _jadeCfgID = 2000 + i
        local _jadeCfg = DataConfig.DataGemstoneInlay[_jadeCfgID]
        if _jadeCfg then
            local _canInlayJadeIDList = List:New()
            local _jadeIDStringList = Utils.SplitStr(_jadeCfg.GemstoneId, "_")
            for i=1,#_jadeIDStringList do
                local _jadeID = tonumber(_jadeIDStringList[i])
                _canInlayJadeIDList:Add(_jadeID)
                if not self.AllCanInlayJadeIDList:Contains(_jadeID) then
                    self.AllCanInlayJadeIDList:Add(_jadeID)
                end
            end
            _canInlayJadeIDList:Sort(
                function (a, b)
                    return a < b
                end
            )
            self.JadeMaxLevel = self:GetJadeLevelByItemID(_canInlayJadeIDList[#_canInlayJadeIDList])
            local _holeOpenConditions = Utils.SplitStr(_jadeCfg.LocationCondition, ";")
            local _maxHole = _jadeCfg.LimitNumber
            local _tempCfg = {CanInlayJadeIDList = _canInlayJadeIDList, HoleOpenConditions = _holeOpenConditions, MaxHole = _maxHole}
            self.JadeInlayCfgByPosDic:Add(i, _tempCfg)

            if self.RefineColorTypeDic:ContainsKey(_jadeCfg.ColorType) then
                local _posList = self.RefineColorTypeDic[_jadeCfg.ColorType]
                if not _posList:Contains(i) then
                    _posList:Add(i)
                end
            else
                local _posList = List:New()
                _posList:Add(i)
                self.RefineColorTypeDic:Add(_jadeCfg.ColorType, _posList)
            end
        end
    end
    self.GemRefineMaxLevel = 100
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.OnItemUpdate, self);
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_WEAREQUIPSUC, self.SetFuncRedPoint, self);
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_UNWEAREQUIPSUC, self.SetFuncRedPoint, self);
end

function LianQiGemSystem:UnInitialize()
    self.GemInlayCfgByPosDic:Clear()
    self.JadeInlayCfgByPosDic:Clear()
    self.GemInlayInfoByPosDic:Clear()
    self.JadeInlayInfoByPosDic:Clear()
    self.GemRefineInfoByPosDic:Clear()
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.OnItemUpdate, self);
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_WEAREQUIPSUC, self.SetFuncRedPoint, self);
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_UNWEAREQUIPSUC, self.SetFuncRedPoint, self);
end

--上线发送的所有宝石、精炼、仙玉信息
function LianQiGemSystem:GS2U_ResGemInfo(result)
    if result.gemInlayList then
        for i=1, #result.gemInlayList do
            local _pos = result.gemInlayList[i].part
            local _gemIDList = result.gemInlayList[i].gemIds or {}
            if self.GemInlayInfoByPosDic:ContainsKey(_pos) then
                self.GemInlayInfoByPosDic[_pos] = _gemIDList
            else
                self.GemInlayInfoByPosDic:Add(_pos, _gemIDList)
            end
        end
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GEM_HOLEOPENSTATE)
    end
    if result.gemJadeList then
        for i=1, #result.gemJadeList do
            local _pos = result.gemJadeList[i].part
            local _jadeIDList = result.gemJadeList[i].gemIds or {}
            if self.JadeInlayInfoByPosDic:ContainsKey(_pos) then
                self.JadeInlayInfoByPosDic[_pos] = _jadeIDList
            else
                self.JadeInlayInfoByPosDic:Add(_pos, _jadeIDList)
            end
        end
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JADE_HOLEOPENSTATE)
    end
    if result.gemRefineList then
        for i=1, #result.gemRefineList do
            local _pos = result.gemRefineList[i].part
            local _refineInfo = {Level = result.gemRefineList[i].level, Exp = result.gemRefineList[i].exp}
            if self.GemRefineInfoByPosDic:ContainsKey(_pos) then
                self.GemRefineInfoByPosDic[_pos] = _refineInfo
            else
                self.GemRefineInfoByPosDic:Add(_pos, _refineInfo)
            end
        end
    end
    self:SetGemInlayRedPoint()
    self:SetJadeInlayRedPoint()
    self:SetGemRefineRedPoint()
end

--请求升级，upgradeType = 1为宝石升级，upgradeType = 2为仙玉升级。后面的参数依次为：部位、镶嵌位置
function LianQiGemSystem:ReqUpGradeGem(upgradeType, pos, inlayIndex)
    --服务器index从0开始，但lua端的List中index从1开始
    GameCenter.Network.Send("MSG_Gem.ReqUpGradeGem", {type = upgradeType, part = pos, index = inlayIndex - 1})
end

--请求镶嵌，inlayType = 1为宝石镶嵌，inlayType = 2为仙玉镶嵌。后面的参数依次为：部位、镶嵌位置、镶嵌的宝石/仙玉ID
function LianQiGemSystem:ReqInlay(inlayType, pos, index, id)
    --服务器index从0开始，但lua端的List中index从1开始
    GameCenter.Network.Send("MSG_Gem.ReqInlay", {type = inlayType, part = pos, gemIndex = index - 1, gemId = id})
end

--镶嵌返回
function LianQiGemSystem:GS2U_ResInlay(result)
    --1为宝石，2为仙玉
    if result.type == 1 then
        if self.GemInlayInfoByPosDic:ContainsKey(result.part) then
            local _gemInlayInfo = self.GemInlayInfoByPosDic[result.part]
            _gemInlayInfo[result.gemIndex + 1] = result.gemId
            --服务器发下来的index是从0开始的。但是服务器发过来的List索引在lua是从1开始的
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GEMINLAYINFO, {result.part, result.gemIndex + 1, result.gemId})
        end
        self:SetGemInlayRedPoint()
    elseif result.type == 2 then
        if self.JadeInlayInfoByPosDic:ContainsKey(result.part) then
            local _jadeInlayInfo = self.JadeInlayInfoByPosDic[result.part]
            _jadeInlayInfo[result.gemIndex + 1] = result.gemId
            --服务器发下来的index是从0开始的。但是服务器发过来的List索引在lua是从1开始的
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JADEINLAYINFO, {result.part, result.gemIndex + 1, result.gemId})
        end
        self:SetJadeInlayRedPoint()
    end
end

--请求快速精炼宝石，pos：部位，id：使用的道具id
function LianQiGemSystem:ReqQuickRefineGem(pos, id)
    GameCenter.Network.Send("MSG_Gem.ReqQuickRefineGem", {part = pos, itemId = id})
end

--快速精炼返回
function LianQiGemSystem:GS2U_ResQuickRefineGem(result)
    if self.GemRefineInfoByPosDic:ContainsKey(result.result.part) then
        local _gemRefineInfo = self.GemRefineInfoByPosDic[result.result.part]
        _gemRefineInfo.Level = result.result.level
        _gemRefineInfo.Exp = result.result.exp
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GEMREFINEINFO, result.result.part);
        self:SetGemRefineRedPoint()
    end
end

--请求智能精炼
function LianQiGemSystem:ReqAutoRefineGem(pos)
    GameCenter.Network.Send("MSG_Gem.ReqAutoRefineGem", {part = pos})
end

--智能精炼返回
function LianQiGemSystem:GS2U_ResAutoRefineGem(result)
    if result.result then
        local _newRefineInfo = result.result
        for i=1, #_newRefineInfo do
            if self.GemRefineInfoByPosDic:ContainsKey(_newRefineInfo[i].part) then
                local _gemRefineInfo = self.GemRefineInfoByPosDic[_newRefineInfo[i].part]
                _gemRefineInfo.Level = _newRefineInfo[i].level
                _gemRefineInfo.Exp = _newRefineInfo[i].exp
                GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GEMREFINEINFO, _newRefineInfo[i].part);
            end
        end
        self:SetGemRefineRedPoint()
    end
end


function LianQiGemSystem:SetFuncRedPoint()
    self:SetGemInlayRedPoint()
    self:SetJadeInlayRedPoint()
    self:SetGemRefineRedPoint()
end

--宝石镶嵌红点
function LianQiGemSystem:SetGemInlayRedPoint()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self:IsGemPosHaveRedPoint(i) then
            GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiGemInlay, true);
            return true
        end
    end
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiGemInlay, false);
    return false
end

function LianQiGemSystem:IsGemPosHaveRedPoint(pos)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    if not _equip then
        return false
    end
    if self.GemInlayInfoByPosDic:ContainsKey(pos) then
        for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
            if self:IsGemHoleHaveRedPoint(pos, i) then
                return true
            end
        end
    end
    return false
end

function LianQiGemSystem:IsGemHoleHaveRedPoint(pos, index)
    local _gemIDList = self.GemInlayInfoByPosDic[pos]
    local _gemID = _gemIDList[index]
    if _gemID then
        if _gemID > 0 then
            local _curInlayGemLv = self:GetGemLevelByItemID(_gemID)
            if self.GemInlayCfgByPosDic:ContainsKey(pos) then
                local _canInlayGemIDList = self.GemInlayCfgByPosDic[pos].CanInlayGemIDList
                if _canInlayGemIDList then
                    for i=1, #_canInlayGemIDList do
                        if self:GetGemLevelByItemID(_canInlayGemIDList[i]) > _curInlayGemLv then
                            local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayGemIDList[i])
                            if _haveCount > 0 then
                                return true
                            end
                        end
                    end
                end
            end
            return false
        elseif _gemID == 0 then
            if self.GemInlayCfgByPosDic:ContainsKey(pos) then
                local _canInlayGemIDList = self.GemInlayCfgByPosDic[pos].CanInlayGemIDList
                if _canInlayGemIDList then
                    for i=1, #_canInlayGemIDList do
                        local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayGemIDList[i])
                        if _haveCount > 0 then
                            return true
                        end
                    end
                end
            end
            return false
        else
            return false
        end
    end
end

--仙玉镶嵌红点
function LianQiGemSystem:SetJadeInlayRedPoint()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self:IsJadePosHaveRedPoint(i) then
            GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiGemJade, true);
            return true
        end
    end
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiGemJade, false);
    return false
end

function LianQiGemSystem:IsJadePosHaveRedPoint(pos)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    if not _equip then
        return false
    end
    if self.JadeInlayInfoByPosDic:ContainsKey(pos) then
        for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
            if self:IsJadeHoleHaveRedPoint(pos, i) then
                return true
            end
        end
    end
    return false
end

function LianQiGemSystem:IsJadeHoleHaveRedPoint(pos, index)
    local _jadeIDList = self.JadeInlayInfoByPosDic[pos]
    local _jadeID = _jadeIDList[index]
    if _jadeID then
        if _jadeID > 0 then
            local _curInlayJadeLv = self:GetJadeLevelByItemID(_jadeID)
            if self.JadeInlayCfgByPosDic:ContainsKey(pos) then
                local _canInlayjadeIDList = self.JadeInlayCfgByPosDic[pos].CanInlayJadeIDList
                if _canInlayjadeIDList then
                    for i=1, #_canInlayjadeIDList do
                        if self:GetJadeLevelByItemID(_canInlayjadeIDList[i]) > _curInlayJadeLv then
                            local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayjadeIDList[i])
                            if _haveCount > 0 then
                                return true
                            end
                        end
                    end
                end
            end
            return false
        elseif _jadeID == 0 then
            if self.JadeInlayCfgByPosDic:ContainsKey(pos) then
                local _canInlayjadeIDList = self.JadeInlayCfgByPosDic[pos].CanInlayJadeIDList
                if _canInlayjadeIDList then
                    for i=1, #_canInlayjadeIDList do
                        local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayjadeIDList[i])
                        if _haveCount > 0 then
                            return true
                        end
                    end
                end
            end
            return false
        else
            return false
        end
    end
end

function LianQiGemSystem:SetGemRefineRedPoint()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self:IsGemRefinePosHaveRedPoint(i) then
            GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiGemRefine, true);
            return true
        end
    end
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.LianQiGemRefine, false);
    return false
end

function LianQiGemSystem:IsGemRefinePosHaveRedPoint(pos)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    if not _equip then
        return false
    end
    local _refineInfo = self.GemRefineInfoByPosDic[pos]
    if _refineInfo then
        if _refineInfo.Level + 1 <= self.GemRefineMaxLevel then
            local _refineCfg = DataConfig.DataGemRefining[self:GetGemRefineCfgID(pos, _refineInfo.Level + 1)]
            if _refineCfg then
                local _itemIDList = Utils.SplitStr(_refineCfg.ItemID, "_")
                for i=1, #_itemIDList do
                    local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(tonumber(_itemIDList[i]))
                    if _haveCount > 0 then
                        return true
                    end
                end
            end
            return false
        else
            return false
        end
    end
    return false
end

function LianQiGemSystem:OnItemUpdate(itemID,sender)
    if self.AllCanInlayGemIDList:Contains(itemID) then
        self:SetGemInlayRedPoint()
    end
    if self.AllCanInlayJadeIDList:Contains(itemID) then
        self:SetJadeInlayRedPoint()
    end
    local _needUpdateGemRefineRedPoint = false
    for i=1, #self.GemRefineItemIDList do
        if itemID == self.GemRefineItemIDList[i] then
            _needUpdateGemRefineRedPoint = true
            break
        end
    end
    if _needUpdateGemRefineRedPoint then self:SetGemRefineRedPoint() end
end


--获取所有部位宝石总等级
function LianQiGemSystem:GetGemTotalLevel()
    local _totalLv = 0
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self.GemInlayInfoByPosDic:ContainsKey(i) then
            local _gemIDList = self.GemInlayInfoByPosDic[i]
            if _gemIDList then
                for i=1, #_gemIDList do
                    if _gemIDList[i] and _gemIDList[i] > 0 then
                        _totalLv = _totalLv + self:GetGemLevelByItemID(_gemIDList[i])
                    end
                end
            end
        end
    end
    return _totalLv
end

--根据部位判定当前部位是否镶嵌了宝石
function LianQiGemSystem:IsPosHaveGem(pos)
    local _haveGem = false
    if self.GemInlayInfoByPosDic:ContainsKey(pos) then
        local _gemList = self.GemInlayInfoByPosDic[pos]
        for i=1, #_gemList do
            if _gemList[i] > 0 then _haveGem = true end
        end
    end
    return _haveGem
end

--type = 1表示宝石，type = 2表示仙玉。根据（装备）部位，和孔位index（取值范围：[1, 6]）来获取：该孔位解锁条件，返回值是string
function LianQiGemSystem:GetHoleOpenCondition(type, pos, index)
    if index > self.MaxHoleNum then
        Debug.LogError("The index is over the max number!!!!!   index = ", index, " Maxnumber = ", self.MaxHoleNum)
        return nil
    end
    if type == 1 and self.GemInlayCfgByPosDic:ContainsKey(pos) then
        return self.GemInlayCfgByPosDic[pos].HoleOpenConditions[index]
    elseif type == 2 and self.JadeInlayInfoByPosDic:ContainsKey(pos) then
        return self.JadeInlayCfgByPosDic[pos].HoleOpenConditions[index]
    end
    return nil
end

--type = 1表示宝石，type = 2表示仙玉。根据（装备）部位，和孔位index（取值范围：[1, 6]）来获取：该孔位是否解锁（index从1开始）
function LianQiGemSystem:IsHoleUnlockByIndex(type, pos, index)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    if _equip then
        local _condition = self:GetHoleOpenCondition(type, pos, index)
        if _condition then
            return self:IsConditionTrue(pos, _condition)
        end
    end
    return false
end

--判断当前condition是否为true。（condition为字符串，例：2_99）。pos用于获取装备的阶数
function LianQiGemSystem:IsConditionTrue(pos, condition)
    local _conditionList = Utils.SplitStr(condition, "_")
    if #_conditionList > 1 then
        local _conditionType = tonumber(_conditionList[1])
        local _conditionData = tonumber(_conditionList[2])
        if _conditionType == 1 then
            --1 等级
            local _lp = GameCenter.GameSceneSystem:GetLocalPlayer()
            if _lp then
                return _lp.Level >= _conditionData
            end
        elseif _conditionType == 36 then
            --36 VIP等级
            return true
        elseif _conditionType == 200 then
            --200 装备阶数
            local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
            if _equip then
                if _equip.ItemInfo then
                    return _equip.ItemInfo.Grade >= _conditionData
                else
                    return false
                end
            else
                return false
            end
        end
    end
    return false
end

--type = 1表示宝石，type = 2表示仙玉。获取condition的文字。如：1_99，返回“等级99”；36_3，返回“VIP3”
function LianQiGemSystem:GetConditionDesc(type, pos, index)
    local _condition = self:GetHoleOpenCondition(type, pos, index)
    if _condition then
        local _conditionList = Utils.SplitStr(_condition, "_")
        if #_conditionList > 1 then
            local _conditionType = tonumber(_conditionList[1])
            local _conditionData = tonumber(_conditionList[2])
            if _conditionType == 1 then
                --1等级
                return UIUtils.CSFormat(DataConfig.DataMessageString.Get("LIANQI_GEM_CONDITION_LEVEL"), _conditionData)-- string.format( "等级%d", _conditionData)
                -- --1道具
                -- local _itemCfg = DataConfig.DataItem[_conditionData]
                -- if _itemCfg then
                --     return _itemCfg.Name
                -- else
                --     return ""
                -- end
            elseif _conditionType == 36 then
                --36 VIP等级
                return UIUtils.CSFormat(DataConfig.DataMessageString.Get("LIANQI_GEM_CONDITION_VIP"), _conditionData)--string.format( "VIP%d", _conditionData)
                -- --2等级
                -- return UIUtils.CSFormat("等级{0}", _conditionData)
            elseif _conditionType == 200 then
                --200 装备阶数
                return UIUtils.CSFormat(DataConfig.DataMessageString.Get("LIANQI_GEM_CONDITION_EQUIPSTAGE"), _conditionData)--string.format( "装备%d阶", _conditionData)
                -- --3vip等级
                -- return UIUtils.CSFormat("VIP{0}", _conditionData)
            -- elseif _conditionType == 4 then
            --     --4装备阶数
            --     return UIUtils.CSFormat("装备{0}阶", _conditionData)
            end
        end
    end
    return ""
end

function LianQiGemSystem:GetGemRefineCfgID(pos, level)
    return pos * 1000 + level
end

function LianQiGemSystem:GetGemLevelByItemID(itemID)
    return itemID % 1000
end

function LianQiGemSystem:GetJadeLevelByItemID(itemID)
    return itemID % 1000
end

return LianQiGemSystem