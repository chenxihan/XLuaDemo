------------------------------------------------
--作者： yangqf
--日期： 2019-5-13
--文件： UIWYTResultForm.lua
--模块： UIWYTResultForm
--描述： 万妖塔结算UI
------------------------------------------------

local UIItem = require "UI.Components.UIItem";

--//模块定义
local UIWYTResultForm = {
    --胜利go
    WinGo = nil,
    --物品grid
    ItemGrid = nil,
    --物品table
    ItemTable = nil,
    --胜利描述
    WinDesc = nil,
    --倒计时
    WinRemainTime = nil,
    --离开按钮
    WinLeaveBtn = nil,
    --继续按钮
    WinGoOnBtn = nil,

    --失败go
    LoseGo = nil,
    --失败描述
    LoseDesc = nil,
    --失败倒计时
    LoseRemainTime = nil,
    --离开按钮
    LoseLeaveBtn = nil,

    --剩余时间
    RemainTime = nil,
    --是否胜利
    IsWin = false,
    --计时器
    Timer = 0.0,
    --上次更新剩余时间的秒数
    FrontUpdateTime = -1,
    --当前关卡配置
    CurLevelCfg = nil,
}

--继承Form函数
function UIWYTResultForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIWYTResultForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIWYTResultForm_CLOSE,self.OnClose);
end

function UIWYTResultForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.WinGo = UIUtils.FindGo(self.Trans, "WinGo");
    self.ItemGrid = UIUtils.FindGrid(self.Trans, "WinGo/Grid");
    self.ItemTable = {};
    for i = 1, 5 do
        self.ItemTable[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("WinGo/Grid/%d", i)));
    end
    self.WinDesc = UIUtils.FindLabel(self.Trans, "WinGo/Desc");
    self.WinRemainTime = UIUtils.FindLabel(self.Trans, "WinGo/RemainTime");
    self.WinLeaveBtn = UIUtils.FindBtn(self.Trans, "WinGo/LeaveBtn");
    UIUtils.AddBtnEvent(self.WinLeaveBtn, self.OnLeaveBtnClick, self);
    self.WinGoOnBtn = UIUtils.FindBtn(self.Trans, "WinGo/GoOnBtn");
    UIUtils.AddBtnEvent(self.WinGoOnBtn, self.OnGoOnBtnClick, self);
    
    self.LoseGo = UIUtils.FindGo(self.Trans, "LoseGo");
    self.LoseDesc = UIUtils.FindLabel(self.Trans, "LoseGo/Desc");
    self.LoseRemainTime = UIUtils.FindLabel(self.Trans, "LoseGo/RemainTime");
    self.LoseLeaveBtn = UIUtils.FindBtn(self.Trans, "LoseGo/LeaveBtn");
    UIUtils.AddBtnEvent(self.LoseLeaveBtn, self.OnLeaveBtnClick, self);
end

function UIWYTResultForm:OnShowAfter()
   self.FrontUpdateTime = -1;
   self.Timer = 5.0;
end

function UIWYTResultForm:OnHideBefore()
end

--更新
function UIWYTResultForm:Update(dt)
    if self.Timer > 0.0 then
        self.Timer = self.Timer - dt;
        if self.Timer <= 0.0 then
            --发送继续或者离开消息
            if self.IsWin then
                self:OnGoOnBtnClick();
            else
                self:OnLeaveBtnClick();
            end
        else
            local _time = math.floor(self.Timer);
            if _time ~= self.FrontUpdateTime then
                self.FrontUpdateTime = _time;
                local _min = _time // 60;
                local _sec = _time - (_min * 60);
                self.RemainTime.text =  DataConfig.DataMessageString.Get("C_SZZQ_TIME", _min, _sec);
            end
        end
    end
end

--开启事件
function UIWYTResultForm:OnOpen(obj, sender)
    self.CurLevelCfg = nil;
    self.CSForm:Show(sender);
    self:RefreshPageInfo(obj);
end

--关闭事件
function UIWYTResultForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--刷新界面
function UIWYTResultForm:RefreshPageInfo(msg)
    if msg == nil then
        return;
    end

    self.CurLevelCfg = DataConfig.DataChallengeReward[msg.challengeLevel];
    if self.CurLevelCfg == nil then
        return;
    end

    self.IsWin = msg.isWin;
    if self.IsWin then
        self.WinGo:SetActive(true);
        self.LoseGo:SetActive(false);
        self.WinDesc.text = UIUtils.CSFormat("恭喜您挑战[00FF00]{0}{1}[-]成功", self.CurLevelCfg.Name, self.CurLevelCfg.LittleName);
        self.RemainTime = self.WinRemainTime;
        
        local _itemCount = #msg.rewardlist;
        for i = 1, 5 do
            if i <= _itemCount then
                local _item = msg.rewardlist[i];
                self.ItemTable[i].RootGO:SetActive(true);
                self.ItemTable[i]:InItWithCfgid(_item.itemId, _item.num, false, false);
            else
                self.ItemTable[i].RootGO:SetActive(false);
            end
        end
        --ItemTable = nil,
        self.ItemGrid:Reposition();
    else
        self.WinGo:SetActive(false);
        self.LoseGo:SetActive(true);
        self.LoseDesc.text = UIUtils.CSFormat("您挑战[FF0000]{0}{1}[-]不幸失败", self.CurLevelCfg.Name, self.CurLevelCfg.LittleName);
        self.RemainTime = self.LoseRemainTime;
    end
end

--离开按钮点击
function UIWYTResultForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false);
    self:OnClose(nil, nil);
end

--继续按钮点击
function UIWYTResultForm:OnGoOnBtnClick()
    if self.CurLevelCfg == nil then
        return;
    end
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp == nil then
        return;
    end
    if _lp.FightPower < self.CurLevelCfg.NeedFightPower then
        local _text = UIUtils.CSFormat("即将面对的敌人战斗力高达[FF0000]{0}[-]，以您当前战斗力发起挑战，可能会[FF0000]失败[-]，您确认继续挑战吗？", self.CurLevelCfg.NeedFightPower)
        GameCenter.MsgPromptSystem:ShowMsgBox(_text, function(x)
            if x == MsgBoxResultCode.Button2 then
                GameCenter.CopyMapSystem:ReqGoOnChallenge();
            else
                GameCenter.MapLogicSystem:SendLeaveMapMsg(false);
            end
        end);
    else
        GameCenter.CopyMapSystem:ReqGoOnChallenge();
    end
    self:OnClose(nil, nil);
end

return UIWYTResultForm;