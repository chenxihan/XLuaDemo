--作者： xc
--日期： 2019-04-17
--文件： NatureBaseData.lua
--模块： NatureBaseData
--描述： 造化面板通用数据父类
------------------------------------------------
--引用
local BaseAttrData = require "Logic.Nature.NatureBaseAttrData"
local BaseItemData = require "Logic.Nature.NatureBaseItemData"
local BaseDrugData = require "Logic.Nature.NatureBaseDrugData"
local RedPointCustomCondition = CS.Funcell.Code.Logic.RedPointCustomCondition

local NatureBaseData = {
    Level = 0, -- 等级也是配置表ID
    CurExp = 0, -- 当前经验
    CurModel = 0, --当前模型ID
    SkillList = List:New(),   --技能列表，存储NatureSkillModelData
    ModelList = List:New(), --模型列表,NatureBaseModelData
    AttrList =List:New(), --属性列表，存储NatureBaseAttrData
    ItemList = List:New(),--道具列表，存储NatureBaseItemData
    DrugList = List:New(), --吃药列表，存储NatureBaseDrugData
    FishionList = List:New(), --化形数据储存NatureFashionData
    Fight = 0, --当前战斗力
}

NatureBaseData.__index = NatureBaseData

function NatureBaseData:New( )
    local _M = Utils.DeepCopy(self)
    return _M
end

--更新数据函数!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--解析属性
function NatureBaseData:AnalysisAttr(str)
    self.AttrList:Clear()
    if str then
        local _cs = {';','_'}
        local _attr = Utils.SplitStrByTableS(str,_cs)
        for i=1,#_attr do        
            local _data = BaseAttrData:New(_attr[i][1],_attr[i][2],_attr[i][3])
            self.AttrList:Add(_data)
        end
    end
end

--解析道具和ITEM表中的数值
function NatureBaseData:AnalysisItem(str)
    self.ItemList:Clear()
    if str then
        local _attr = Utils.SplitStr(str,'_')
        for i=1,#_attr do
            local _itemid = tonumber(_attr[i])
            local _itemInfo = DataConfig.DataItem[_itemid]
            if _itemInfo then
                local _value = Utils.SplitStr(_itemInfo.EffectNum,'_')
                if _value[2] then
                    local _data = BaseItemData:New(_itemid,tonumber(_value[2]))
                    self.ItemList:Add(_data)
                end
            end
        end
    end
end

--解析道具和ITEM表中的数值
function NatureBaseData:AddMagicItem(itemid)
    self.ItemList:Clear()
    local _data = BaseItemData:New(tonumber(itemid),0)
    self.ItemList:Add(_data)
end


--解析道具和数量
function NatureBaseData:AnalysisItemAndNum(str)
    self.ItemList:Clear()
    if str then
        local _cs = {';','_'}
        local _attr = Utils.SplitStrByTableS(str,_cs)
        for i=1,#_attr do
            local _itemid = _attr[i]
            local _data = BaseItemData:New(_itemid[1],_itemid[2])
            self.ItemList:Add(_data)
        end
    end
end

--解析吃丹数据
function NatureBaseData:AnalysisOtherItemCfg(type,info)
        if GameCenter.NatureSystem.NatureDrugDir:ContainsKey(type) then
            local _druglist = GameCenter.NatureSystem.NatureDrugDir[type]
            if _druglist then
                 self.DrugList:Clear()
                 local _count = #_druglist
                 for i=1,_count do 
                        local _eatnum = 0
                        local _level = 0
                        local _pos = 0
                        if info.fruitInfo then                         
                            for j=1,#info.fruitInfo do
                                if info.fruitInfo[j].fruitId == _druglist[i].ItemId  then
                                    _eatnum = info.fruitInfo[j].eatnum
                                    _level= info.fruitInfo[j].level
                                    _pos = _druglist[i].Position
                                    break
                                end
                            end
                        end
                        if _pos ~= 0 then
                            local _id = type * 1000 + _pos * 100 + _level
                            local _dataConfig = DataConfig.DataNatureAtt[_id]
                            local _data = BaseDrugData:New(_dataConfig,_eatnum)
                            self.DrugList:Add(_data)
                        else
                            local _data = BaseDrugData:New(_druglist[i],0)
                            self.DrugList:Add(_data)                         
                        end
               
                 end
            end
        end
end

--网络消息,设置化形信息
function NatureBaseData:UpDataFashionInfos(info)
    if info then
        for i=1,#info do
            self:UpDataFashion(info[i])
        end
    end
end

--设置单个化形数据
function NatureBaseData:UpDataFashion(info)
    local _fashion = self.FishionList:Find(function(code)
        return info.id == code.ModelId
    end)
    if _fashion then
        _fashion.Fight = info.fight
        _fashion.IsActive = true
        _fashion.Level = info.level
        local _info = DataConfig.DataHuaxingWing[info.id]
        if _info then
            _fashion:UpDateAttrData(_info)
        end
    end 
end

--更新技能设置
function NatureBaseData:UpDateSkill(skill)
    if skill then
        for i=1,#skill do
            self:SetSkillActive(skill[i])
        end
    end
end

--设置技能激活
function NatureBaseData:SetSkillActive(skillid)
    local _skillinfo = self.SkillList:Find(function(code)
        if code.SkillInfo then
            return skillid == code.SkillInfo.Id
        end
        return nil
    end)
    if _skillinfo then
        _skillinfo.IsActive = true
    end 
end

--更新模型设置
function NatureBaseData:UpDateModel(models)
    if models then
        for i=1,#models do
            self:SetModelActive(models[i])
        end
    end
end

--设置模型激活
function NatureBaseData:SetModelActive(modelid)
    local _modelList = self.ModelList:Find(function(code)
        return modelid == code.Modelid
    end)
    if _modelList then
        _modelList.IsActive = true
    end 
end

--更新吃果子信息
function NatureBaseData:UpDateDrug(info,type)
    for i=1,#self.DrugList do
        if self.DrugList[i].ItemId == info.fruitId then
            if info.level > self.DrugList[i].Level  then
                local _id = type * 1000 + self.DrugList[i].Position * 100 + info.level
                local _dataConfig = DataConfig.DataNatureAtt[_id]
                self.DrugList[i]:UpDateAttrData(_dataConfig)
            end
            self.DrugList[i].EatNum = info.eatnum
            break
        end
    end
end

--解析吃药以及赋值
function NatureBaseData:Parase(type,info)
    if info then
        self.Level = info.curLevel
        self.CurExp = info.curExp
        self.CurModel = info.modelId
        self.Fight = info.fight
        self:AnalysisOtherItemCfg(type,info)
    end
end

---功能函数!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--获得已经激活的模型ID
function NatureBaseData:GetModelsList()
    local _list = List:New()
    for i=1,#self.ModelList do
        if self.ModelList[i].IsActive then
            _list:Add(self.ModelList[i])
        end
    end
    return _list
end

--获得模型的名字
function NatureBaseData:GetModelsName(modelid)
    for i=1,#self.ModelList do
        if self.ModelList[i].Modelid == modelid then
            return self.ModelList[i].Name
        end
    end
    return ""
end

--得到当前显示的模型，如果没有设置基础外观则默认显示最大
function NatureBaseData:GetCurShowModel()
    local _list = self:GetModelsList()
    if _list:Count() > 0 then
        for i=1,_list:Count() do
            if _list[#_list].Modelid == self.CurModel then
                return self.CurModel
            end
        end
        return _list[#_list].Modelid
    end
    return 0
end

--通过模型ID获得是否能点击左边切换按钮
function NatureBaseData:GetNotLeftButton(modelid)
    local _list = self:GetModelsList()
    if _list:Count() > 0 then
        return _list[1].Modelid ~= modelid
    end
    return false
end

--通过模型ID获得上一个模型ID
function NatureBaseData:GetLastModel(modelid)
    local _list = self:GetModelsList()
    local _index = 0;
    if _list:Count() > 0 then
        for i=1,_list:Count() do
            if modelid == _list[i].Modelid then
                _index = i-1
            end
        end
        return _list[_index].Modelid
    end
    return 0
end

--通过模型ID获得下一个模型ID
function NatureBaseData:GetNextModel(modelid)
    local _list = self:GetModelsList()
    local _index = 0;
    if _list:Count() > 0 then
        for i=1,_list:Count() do
            if modelid == _list[i].Modelid then
                _index = i + 1
            end
        end
        return _list[_index].Modelid
    end
    return 0
end

--通过模型ID获得是否能点击右边切换按钮
function NatureBaseData:GetNotRightButton(modelid)
    local _list = self:GetModelsList()
    if _list:Count() > 0 then
        return _list[#_list].Modelid ~= modelid
    end
    return false
end

--通过ID获得化形数据
function NatureBaseData:GetFashionInfo(id)
    local _info = self.FishionList:Find(function(code)
        return code.ModelId == id
    end)
    if _info then
        return _info
    end
    return nil
end

--红点功能!!!!!!!!!!!!!!

--更新等级红点
function NatureBaseData:UpDateLevelHit(functionid,ismax,needitem)
    local _isReach = false
    local _ismax = self.Level >= ismax
    local _count = #self.ItemList
    for i = 1,_count do
        if GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.ItemList[i].ItemID) >= needitem and not _ismax then
            _isReach = true
            GameCenter.RedPointSystem:AddFuncCondition(functionid, NatureSubEnum.Begin, RedPointCustomCondition(true))
            break
        end
    end
    if not _isReach then
        GameCenter.RedPointSystem:RemoveFuncCondition(functionid, NatureSubEnum.Begin)
    end
end

--更新吃果子红点
function NatureBaseData:UpDateDrugHit(functionid,type)
    local _isReach = false
    local _count = #self.DrugList
    for i = 1,_count do
        local _ismax = self.DrugList[i].Level >= GameCenter.NatureSystem:GetDrugItemMax(type,self.DrugList[i].ItemId)
        if GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.DrugList[i].ItemId) > 0 and not _ismax then
            _isReach = true
            GameCenter.RedPointSystem:AddFuncCondition(functionid, NatureSubEnum.Begin, RedPointCustomCondition(true))
            break
        end
    end
    if not _isReach then
        GameCenter.RedPointSystem:RemoveFuncCondition(functionid, NatureSubEnum.Begin)
    end
end

--更新翅膀化形红点
function NatureBaseData:UpDateFashionHit(functionid)
    local _isReach = false
    local _count = #self.FishionList
    for i = 1,_count do
        local _ismax = self.FishionList[i].Level >= self.FishionList[i].MaxLevel
        self.FishionList[i]:UpDateNeedItem()
        if GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.FishionList[i].Item) >= self.FishionList[i].NeedItemNum and not _ismax then
            self.FishionList[i].IsRed = true
            _isReach = true
        else
            self.FishionList[i].IsRed = false
        end
    end
    if not _isReach then
        GameCenter.RedPointSystem:RemoveFuncCondition(functionid, NatureSubEnum.Begin)
    else 
        GameCenter.RedPointSystem:AddFuncCondition(functionid, NatureSubEnum.Begin, RedPointCustomCondition(true))
    end
end

return NatureBaseData