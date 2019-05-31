------------------------------------------------
--作者： yangqf
--日期： 2019-5-13
--文件： UIDNYFResultForm.lua
--模块： UIDNYFResultForm
--描述： 万妖塔结算UI
------------------------------------------------

local UIItem = require "UI.Components.UIItem";

--//模块定义
local UIDNYFResultForm = {
    --胜利go
    WinGo = nil,
    --物品grid
    ItemGrid = nil,
    --物品table
    ItemTable = nil,
    --胜利描述
    WinDesc = nil,

    --失败go
    LoseGo = nil,
    --失败描述
    LoseDesc = nil,

    --离开按钮
    LeaveBtn = nil,
    --剩余时间
    RemainTime = nil,
    --是否胜利
    IsWin = false,
    --计时器
    Timer = 0.0,
    --上次更新剩余时间的秒数
    FrontUpdateTime = -1,
}

--继承Form函数
function UIDNYFResultForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIDNYFResultForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIDNYFResultForm_CLOSE,self.OnClose);
end

function UIDNYFResultForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.WinGo = UIUtils.FindGo(self.Trans, "WinGo");
    self.ItemGrid = UIUtils.FindGrid(self.Trans, "WinGo/Grid");
    self.ItemTable = {};
    for i = 1, 5 do
        self.ItemTable[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("WinGo/Grid/%d", i)));
    end
    self.WinDesc = UIUtils.FindLabel(self.Trans, "WinGo/Desc");
    
    self.LoseGo = UIUtils.FindGo(self.Trans, "LoseGo");
    self.LoseDesc = UIUtils.FindLabel(self.Trans, "LoseGo/Desc");

    self.RemainTime = UIUtils.FindLabel(self.Trans, "RemainTime");
    self.LeaveBtn = UIUtils.FindBtn(self.Trans, "LeaveBtn");
    UIUtils.AddBtnEvent(self.LeaveBtn, self.OnLeaveBtnClick, self);
end

function UIDNYFResultForm:OnShowAfter()
   self.FrontUpdateTime = -1;
   self.Timer = 5.0;
end

function UIDNYFResultForm:OnHideBefore()
end

--更新
function UIDNYFResultForm:Update(dt)
    if self.Timer > 0.0 then
        self.Timer = self.Timer - dt;
        if self.Timer <= 0.0 then
            --发送离开消息
            self:OnLeaveBtnClick();
        else
            local _time = math.floor(self.Timer);
            if _time ~= self.FrontUpdateTime then
                self.FrontUpdateTime = _time;
                self.RemainTime.text =  tostring(_time);
            end
        end
    end
end

--开启事件
function UIDNYFResultForm:OnOpen(obj, sender)
    self.CurLevelCfg = nil;
    self.CSForm:Show(sender);
    self:RefreshPageInfo(obj);
end

--关闭事件
function UIDNYFResultForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--刷新界面
function UIDNYFResultForm:RefreshPageInfo(msg)
    if msg == nil then
        return;
    end

    local _copyCfg = DataConfig.DataCloneMap[msg.copyId];
    if _copyCfg == nil then
        return
    end

    self.IsWin = msg.starNum > 0;
    if self.IsWin then
        self.WinGo:SetActive(true);
        self.LoseGo:SetActive(false);
        self.WinDesc.text = UIUtils.CSFormat("恭喜您挑战[00FF00]{0}[-]成功", _copyCfg.DuplicateName);
        
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
        self.ItemGrid:Reposition();
    else
        self.WinGo:SetActive(false);
        self.LoseGo:SetActive(true);
        self.LoseDesc.text = UIUtils.CSFormat("您挑战[FF0000]{0}[-]不幸失败", _copyCfg.DuplicateName);
    end
end

--离开按钮点击
function UIDNYFResultForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false);
    self:OnClose(nil, nil);
end

return UIDNYFResultForm;