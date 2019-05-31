------------------------------------------------
--作者： cy
--日期： 2019-05-22
--文件： UIBossInfoTips.lua
--模块： UIBossInfoTips
--描述： Boss提示信息面板（快捷前往）
------------------------------------------------
local UIBossInfoTips = {
    AnimModule = nil,
    CloseBtn = nil,
    GoBtn = nil,
    HeadIconSpr = nil,
    NameLab = nil,
    LevelLab = nil,
    MonsterCfgID = 0,
    TargetCloneMapID = 0,
    CustomCfgID = 0,
    StartCountDown = false,
    CurTime = 0,                    --计时器
    CloseTime = 5;                  --自动关闭面板的时间
}

--注册事件函数, 提供给CS端调用.
function UIBossInfoTips:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIBossInfoTips_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIBossInfoTips_CLOSE,self.OnClose)
end

--打开。obj.count = 4，obj[1] = monster配置表ID（用于获取BOSS名字、等级、头像）, obj[2] = 目标cloneMapId，进入副本用
--                     obj[3] = 自定义配置表ID（点击“立即前往”后，会存在BossInfoTipsSystem中，需要时自取）
function UIBossInfoTips:OnOpen(obj, sender)
    if obj and #obj >= 2 then
        self.MonsterCfgID = obj[1]
        self.TargetCloneMapID = obj[2]
        if obj[3] then
            self.CustomCfgID = obj[3]
        end
        Debug.LogError(obj[1], obj[2])
    end
    self.CSForm:Show(sender)
end

--关闭
function UIBossInfoTips:OnClose(obj,sender)
    self.CSForm:Hide()
end

--第一只显示函数, 提供给CS端调用.
function UIBossInfoTips:OnFirstShow()
	self:FindAllComponents();
	self:RegUICallback();
end

--显示之前的操作, 提供给CS端调用.
function UIBossInfoTips:OnShowBefore()
    
end

--显示后的操作, 提供给CS端调用.
function UIBossInfoTips:OnShowAfter()
    self:SetAllInfo()
    self.StartCountDown = true
end

--隐藏之前的操作, 提供给CS端调用.
function UIBossInfoTips:OnHideBefore()
    
end

--隐藏之后的操作, 提供给CS端调用.
function UIBossInfoTips:OnHideAfter()
    
end

--绑定UI组件的回调函数
function UIBossInfoTips:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)
    UIUtils.AddBtnEvent(self.GoBtn, self.OnClickGoBtn, self)
end

function UIBossInfoTips:OnClickCloseBtn()
    self:OnClose(nil, nil)
end

function UIBossInfoTips:OnClickGoBtn()
    if self.TargetCloneMapID > 0 then
        GameCenter.BossInfoTipsSystem.CustomCfgID = self.CustomCfgID
        GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(self.TargetCloneMapID)
    end
end

--查找所有组件
function UIBossInfoTips:FindAllComponents()
    local _myTrans = self.Trans;
    self.CloseBtn = UIUtils.FindBtn(_myTrans, "Container/Back/CloseBtn")
    self.GoBtn = UIUtils.FindBtn(_myTrans, "Container/Back/GoBtn")
    self.HeadIconSpr = UIUtils.FindSpr(_myTrans, "Container/Back/HeadIcon")
    self.NameLab = UIUtils.FindLabel(_myTrans, "Container/Back/Name")
    self.LevelLab = UIUtils.FindLabel(_myTrans, "Container/Back/Level")
    
    self.AnimModule = UIAnimationModule(self.Trans);
    self.AnimModule:AddAlphaScaleAnimation(self.Trans, 0, 1, 1, 0, 1, 1);
end

function UIBossInfoTips:SetAllInfo()
    local _monsterCfg = DataConfig.DataMonster[self.MonsterCfgID]
    if _monsterCfg then
        self.NameLab.text = _monsterCfg.Name
        self.LevelLab.text = string.format( "Lv.%d", tostring(_monsterCfg.Level))
    end
end

function UIBossInfoTips:Update(dt)
    if self.StartCountDown then
        if self.CurTime > self.CloseTime then
            self.CurTime = 0
            self.StartCountDown = false
            self:OnClickCloseBtn()
        else
            self.CurTime = self.CurTime + dt
        end
    end
end

return UIBossInfoTips;