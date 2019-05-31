------------------------------------------------
--作者： yangqf
--日期： 2019-5-8
--文件： UISZZQEnterForm.lua
--模块： UISZZQEnterForm
--描述： 勇者之巅进入界面
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UISZZQEnterForm = {
    --副本ID
    DailyID = 21,
    --进入按钮
    EnterBtn = nil,
    --排名奖励btn
    AwardBtn = nil,
    --关闭按钮
    CloseBtn = nil,
    --物品grid
    ItemGrid = nil,
    --奖励物品列表
    AwardItems = nil,
};

--继承Form函数
function UISZZQEnterForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISZZQEnterForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UISZZQEnterForm_CLOSE,self.OnClose);
end

function UISZZQEnterForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.EnterBtn = UIUtils.FindBtn(self.Trans, "Enter");
    UIUtils.AddBtnEvent(self.EnterBtn, self.OnEnterBtnClik, self);

    self.AwardBtn = UIUtils.FindBtn(self.Trans, "RankAward");
    UIUtils.AddBtnEvent(self.AwardBtn, self.OnAwardBtnClik, self);

    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CloseBtn");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCloseBtnClick, self);

    self.ItemGrid = UIUtils.FindGrid(self.Trans, "Grid");
    self.AwardItems = {};
    for i = 1, 4 do
        self.AwardItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format( "Grid/%d", i)));
    end

    local _cfg = DataConfig.DataDaily[self.DailyID];
    if _cfg ~= nil then
        local _itemTable = Utils.SplitStr(_cfg.Reward, ';');
        local _itemCount = #_itemTable
        for i = 1, 4 do
            if i <= _itemCount then
                self.AwardItems[i].RootGO:SetActive(true)
                self.AwardItems[i]:InItWithCfgid(_itemTable[i], 1, false, false)
            else
                self.AwardItems[i].RootGO:SetActive(false)
            end
        end
    end
end

function UISZZQEnterForm:OnShowAfter()
end

function UISZZQEnterForm:OnHideBefore()
end

--开启事件
function UISZZQEnterForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
end

--关闭事件
function UISZZQEnterForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--进入按钮点击
function UISZZQEnterForm:OnEnterBtnClik()
    if GameCenter.TeamSystem:IsTeamExist() then
        GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("C_LUANDOU_EXITTEAM_ASK"), function(x)
            if x == MsgBoxResultCode.Button2 then
                --退出队伍
                GameCenter.TeamSystem:ReqTeamOpt(GameCenter.GameSceneSystem:GetLocalPlayerID(), 3);
                --发送进入副本消息
                GameCenter.DailyActivitySystem:ReqJoinActivity(self.DailyID);
            end
        end)
    else
        --发送进入副本消息
        GameCenter.DailyActivitySystem:ReqJoinActivity(self.DailyID);
    end
end

--排名奖励按钮点击
function UISZZQEnterForm:OnAwardBtnClik()
    GameCenter.PushFixEvent(UIEventDefine.UISZZQAwardForm_OPEN);
end

--关闭按钮点击
function UISZZQEnterForm:OnCloseBtnClick()
    self:OnClose(nil, nil);
end

return UISZZQEnterForm;