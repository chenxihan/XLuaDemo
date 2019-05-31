------------------------------------------------
--作者： _SqL_
--日期： 2019-05-07
--文件： UISkillRoot.lua
--模块： UISkillRoot
--描述： 宗派技能Root
------------------------------------------------

local UISkillRoot = {
    Owner = nil,
    Trans = nil,
    ListPanel = nil,
    Item = nil,
    -- 当前选中的技能
    CurrSkill = -1,
    -- 技能按钮 Dic
    SkillBtnTransDic = Dictionary:New(),
}

function  UISkillRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end


function UISkillRoot:FindAllComponents()
    self.Item = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.ListPanel = UIUtils.FindTrans(self.Trans, "ListPanel")
end

function UISkillRoot:RefreshSkillList()
    local _skillList = GameCenter.FactionSkillSystem.SkillList
    local _index = 0
    for i = 1, #_skillList do
        if _index < self.ListPanel.childCount then
            self:SetSkillBtn(self.ListPanel:GetChild(_index), _skillList[i])
        else
            self:SetSkillBtn(self:Clone(self.Item, self.ListPanel), _skillList[i])
        end
        _index = _index + 1
    end
    self.ListPanel:GetComponent("UIScrollView"):ResetPosition()

    if self.CurrSkill == -1 then
        local _cfg = DataConfig.DataGuildCollege[_skillList[1]]
        if not _cfg then
            Debug.LogError("DataGuildCollege not contains key ",_skillList[1])
            return
        end
        self:OnSkillBtnClick({Type = _cfg.Type,Id = _cfg.Id})
    else
        self:OnSkillBtnClick({Type = self.CurrSkill,Id = GameCenter.FactionSkillSystem:GetSkillIdByType(self.CurrSkill)})
    end
end

function UISkillRoot:SetSkillBtn(trans, id)
    local _cfg = DataConfig.DataGuildCollege[id]
    if not _cfg then
        Debug.LogError("DataGuildCollege not contains key = ", id)
        return
    end
    local _icon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(trans, "Icon"))
    _icon:UpdateIcon(_cfg.ICON)
    self.SkillBtnTransDic[_cfg.Type] = trans
    UIUtils.FindLabel(trans, "Lv").text = tostring(_cfg.Level)
    UIUtils.FindLabel(trans, "Name").text = _cfg.Name
    UIUtils.FindTrans(trans, "Select").gameObject:SetActive(false)
    local _skillbBtn = trans:GetComponent("UIButton")
    UIUtils.AddBtnEvent(_skillbBtn, self.OnSkillBtnClick, self, {Type = _cfg.Type,Id = _cfg.Id})
end

function UISkillRoot:OnSkillBtnClick(data)
    if self.CurrSkill ~= -1 then
        UIUtils.FindTrans(self.SkillBtnTransDic[self.CurrSkill], "Select").gameObject:SetActive(false)
    end
    UIUtils.FindTrans(self.SkillBtnTransDic[data.Type], "Select").gameObject:SetActive(true)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_FACTIONSKILLINFO, data.Id)
    self.CurrSkill = data.Type
end

function UISkillRoot:Clone(obj, parent)
    local _go = GameObject.Instantiate(obj).transform
    if parent then
        _go:SetParent(parent)
    end
    UnityUtils.ResetTransform(_go)
    return _go
end

return UISkillRoot