------------------------------------------------
--作者： cy
--日期： 2019-05-23
--文件： UINewWorldBossHarmRankForm.lua
--模块： UINewWorldBossHarmRankForm
--描述： 个人BOSS副本左侧界面数据
------------------------------------------------

local UINewWorldBossHarmRankForm = {
    CloseBtn = nil,
    RankCloneGo = nil,
    RankCloneRoot = nil,
    RankCloneRootGrid = nil,
    RankCloneRootScrollView = nil,
    RankList = nil,
    AutoCloseFormTime = 10,             --自动关闭面板的时间
    CurTime = 0,                        --用于计算时间间隔
    StartCountDown = false,
}

function UINewWorldBossHarmRankForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINewWorldBossHarmRankForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UINewWorldBossHarmRankForm_CLOSE,self.OnClose)
end

--打开
function UINewWorldBossHarmRankForm:OnOpen(obj, sender)
    self.RankList = obj
    self.CSForm:Show(sender)
    self:SetRankList()
end

--关闭
function UINewWorldBossHarmRankForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UINewWorldBossHarmRankForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UINewWorldBossHarmRankForm:OnShowBefore()
    
end

function UINewWorldBossHarmRankForm:OnShowAfter()
    
end

--注册UI上面的事件，比如点击事件等
function UINewWorldBossHarmRankForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)
end

function UINewWorldBossHarmRankForm:OnClickCloseBtn()
    self:OnClose(nil, nil)
end

--查找组件
function UINewWorldBossHarmRankForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "Offset/CloseButton")
    self.RankCloneGo = UIUtils.FindGo(self.Trans, "Offset/RankClone")
    self.RankCloneRoot = UIUtils.FindTrans(self.Trans, "Offset/RankCloneRoot")
    self.RankCloneRootGrid = self.RankCloneRoot:GetComponent("UIGrid")
    self.RankCloneRootScrollView = self.RankCloneRoot:GetComponent("UIScrollView")
end

function UINewWorldBossHarmRankForm:SetRankList()
    if self.RankList then
        for i=1, #self.RankList do
            local _rankInfo = self.RankList[i]
            local _go
            if i - 1 < self.RankCloneRoot.childCount then
                _go = self.RankCloneRoot:GetChild(i - 1).gameObject
            else
                _go = UnityUtils.Clone(self.RankCloneGo, self.RankCloneRoot)
            end
            local _rankLab = UIUtils.FindLabel(_go.transform, "Rank")
            local _nameLab = UIUtils.FindLabel(_go.transform, "Name")
            local _damageLab = UIUtils.FindLabel(_go.transform, "Damage")
            _rankLab.text = tostring(_rankInfo.top)
            _nameLab.text = _rankInfo.name
            _damageLab.text = tostring(_rankInfo.harm)
            _go:SetActive(true)
        end
        for i=#self.RankList, self.RankCloneRoot.childCount - 1 do
            self.RankCloneRoot:GetChild(i).gameObject:SetActive(false)
        end
        self.RankCloneRootGrid.repositionNow = true
        self.RankCloneRootScrollView:ResetPosition()
        self.StartCountDown = true
    end
end

function UINewWorldBossHarmRankForm:Update(dt)
    if self.StartCountDown then
        if self.CurTime > self.AutoCloseFormTime then
            self.StartCountDown = false
            self.CurTime = 0
            self:OnClickCloseBtn()
        else
            self.CurTime = self.CurTime + dt
        end
    end
end

return UINewWorldBossHarmRankForm
