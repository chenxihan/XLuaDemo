
------------------------------------------------
--作者： 王圣
--日期： 2019-05-23
--文件： UIFuDiRankForm.lua
--模块： UIFuDiRankForm
--描述： 
------------------------------------------------

-- c#类
local UIAttentionForm = {
    NameLabel = nil,
    Icon = nil,
    GoToBtn = nil,
    CloseBtn = nil,
    MonsterId = 0,
}
--继承Form函数
function UIAttentionForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIAttentionForm_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIAttentionForm_Close,self.OnClose)
end

function UIAttentionForm:OnFirstShow()
    self:FindAllComponents()
end

function UIAttentionForm:OnShowAfter()
    
end

function UIAttentionForm:OnHideBefore()
    
end

function UIAttentionForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    local cfgId = obj
    self.MonsterId = DataConfig.DataGuildBattleBoss[cfgId].MonsterID
    local monsterCfg = DataConfig.DataMonster[self.MonsterId]
    if monsterCfg ~= nil then
        self.Icon:UpdateIcon(monsterCfg.Icon)
        self.NameLabel.text = monsterCfg.Name
    end
end

function UIAttentionForm:OnClickCloseBtn()
    self:OnClose()
end

function UIAttentionForm:OnClickGoToBtn()
    GameCenter.PushFixEvent(UIEventDefine.UIFuDiForm_Open,{SubPage = 2 ,BossId = self.MonsterId})
end

function UIAttentionForm:FindAllComponents()
    self.NameLabel = UIUtils.RequireUILabel(self.Trans:Find("Right/Name"))
    self.Icon = UIUtils.RequireUIIconBase(self.Trans:Find("Right/Icon"))
    self.GoToBtn = UIUtils.RequireUIButton(self.Trans:Find("Right/GoTo"))
    self.CloseBtn = UIUtils.RequireUIButton(self.Trans:Find("Right/Close"))
    UIUtils.AddBtnEvent(self.GoToBtn,self.OnClickGoToBtn,self)
    UIUtils.AddBtnEvent(self.CloseBtn,self.OnClickCloseBtn,self)
end
return UIAttentionForm