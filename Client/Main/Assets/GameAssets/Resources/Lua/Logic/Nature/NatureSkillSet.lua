--作者： xc
--日期： 2019-04-16
--文件： NatureSkillSet.lua
--模块： NatureSkillSet
--描述： 造化面板技能数据设置
------------------------------------------------
--引用
local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools

local NatureSkillSet = {
    Tras = nil, --根节点
    Go = nil, --obj
    Clone = nil, --克隆体
    Grid = nil, --Gird组件
    IconList = nil ,-- 技能icon组件
}

NatureSkillSet.__index = NatureSkillSet

function NatureSkillSet:New(trans)
    local _M = Utils.DeepCopy(self)
    _M.Tras = trans
    _M.Go = trans.gameObject
    _M.Clone = trans:Find("default").gameObject
    _M.Grid = trans:GetComponent("UIGrid")
    _M.IconList = List:New()
    return _M
end

function NatureSkillSet:RefreshSkill(skilllist)
    local _listobj = NGUITools.AddChilds(self.Go,self.Clone,#skilllist)
    for i = 1,#skilllist do
        local _go = _listobj[i - 1]
        local _info = skilllist[i]
        if not self.IconList[i] then
            local _icon = {
                Icon = nil,--Icon组件
                NotActive = nil,--是否激活组件
            }
            _icon.Icon = UnityUtils.RequireComponent(_go.transform:Find("Icon"),"Funcell.GameUI.Form.UIIconBase")
            _icon.NotActive = _go.transform:Find("NotActive").gameObject
            self.IconList:Add(_icon)
        end
        if _info.SkillInfo then
            self.IconList[i].Icon:UpdateIcon(_info.SkillInfo.Icon)
        end
        self.IconList[i].Icon.IsGray = not _info.IsActive
        self.IconList[i].NotActive:SetActive(_info.IsActive == false)
        UIEventListener.Get(_go).parameter = _info
        UIEventListener.Get(_go).onClick = Utils.Handler( self.OnClickSkill,self)
    end
    self.Grid:Reposition()
end

function NatureSkillSet:OnClickSkill(go)
    local _info = UIEventListener.Get(go).parameter
    GameCenter.PushFixEvent(UIEventDefine.UINatureSkillTipsForm_OPEN, _info)
end



return NatureSkillSet