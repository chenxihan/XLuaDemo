------------------------------------------------
--作者： yangqf
--日期： 2019-04-30
--文件： UIStarCopyAwardIcon.lua
--模块： UIStarCopyAwardIcon
--描述： 星级副本奖励的icon
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--关卡头像
local UIStarCopyAwardIcon = {
    --UIItem
    Item = nil,
    --星数
    StarCount = nil,
    --未达成提示
    WeiDaChengGo = nil,
    --可领取提示
    KeLingQuGo = nil,
    --领取按钮
    LingQuBtn = nil,
    --已领取提示
    YiLingQuGo = nil,

    --当前索引
    Index = nil,
}

function UIStarCopyAwardIcon:New(trans, index)
    local _result = Utils.DeepCopy(UIStarCopyAwardIcon);
    _result.Index = index;
    _result.Item = UIItem:New(UIUtils.FindTrans(trans, "UIItem"));
    _result.StarCount = UIUtils.FindLabel(trans, "Star");
    _result.WeiDaChengGo = UIUtils.FindGo(trans, "WeiDaCheng");
    _result.KeLingQuGo = UIUtils.FindGo(trans, "KeLingQu");
    _result.LingQuBtn = UIUtils.FindBtn(trans, "KeLingQu");
    UIUtils.AddBtnEvent(_result.LingQuBtn, _result.OnLingQuBtnClick ,_result);
    _result.YiLingQuGo = UIUtils.FindGo(trans, "YiLingQu");
    return _result;
end

--刷新界面
function UIStarCopyAwardIcon:Refresh(cfgTable, state)
    self.StarCount.text = tostring(cfgTable[1]);
    self.Item:InItWithCfgid(cfgTable[2], cfgTable[3], false, false);
    self.WeiDaChengGo:SetActive(state == 0);
    self.KeLingQuGo:SetActive(state == 1);
    self.YiLingQuGo:SetActive(state == 2);
end

--点击领取按钮
function UIStarCopyAwardIcon:OnLingQuBtnClick()
    GameCenter.CopyMapSystem:ReqGetStarAward(self.Index);
end

return UIStarCopyAwardIcon;