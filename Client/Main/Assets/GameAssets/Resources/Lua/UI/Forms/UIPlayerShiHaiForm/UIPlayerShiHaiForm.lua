------------------------------------------------
--作者： yangqf
--日期： 2019-05-06
--文件： UIPlayerShiHaiForm.lua
--模块： UIPlayerShiHaiForm
--描述： 角色境界界面
------------------------------------------------

local UIItem = require "UI.Components.UIItem";
local CommonPanelRedPoint = require "Logic.Nature.Common.CommonPanelRedPoint"

--//模块定义
local UIPlayerShiHaiForm = {
    --当前等级
    CurLevel = nil,
    --当前战斗力
    CurFightPower = nil,
    --属性Table
    PropTable = nil,
    --需求万妖卷关数
    NeedCopyLevel = nil,
    --前往万妖卷按钮
    GoToCopyBtn = nil,
    --需求道具
    NeedItems = nil,
    --升级按钮
    LevelUpBtn = nil,
    --红点组件
    RedPointCom = nil,
};

--继承Form函数
function UIPlayerShiHaiForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIPlayerShiHaiForm_OPEN, self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIPlayerShiHaiForm_CLOSE, self.OnClose);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_PLAYER_SHIHAI, self.OnRefreshPage);
end

function UIPlayerShiHaiForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    local _rightTrans = UIUtils.FindTrans(self.Trans, "Right");
    self.CSForm:AddPositionAnimation(300, 0, _rightTrans)

    self.CurLevel = UIUtils.FindLabel(self.Trans, "CurLevel");
    self.CurFightPower = UIUtils.FindLabel(self.Trans, "FightPower/Value");
    self.PropTable = {};
    for i = 1, 6 do
        self.PropTable[i] = {};
        self.PropTable[i].RootGo = UIUtils.FindGo(self.Trans, string.format("Right/Pro%d", i));
        self.PropTable[i].Name = UIUtils.FindLabel(self.Trans, string.format("Right/Pro%d/Name", i));
        self.PropTable[i].Value = UIUtils.FindLabel(self.Trans, string.format("Right/Pro%d/Value", i));
        self.PropTable[i].AddValue = UIUtils.FindLabel(self.Trans, string.format("Right/Pro%d/AddValue", i));
        self.PropTable[i].AddGo = UIUtils.FindGo(self.Trans, string.format("Right/Pro%d/AddSpr", i));
    end
    self.NeedCopyLevel = UIUtils.FindLabel(self.Trans, "Right/NeedCopy");
    self.GoToCopyBtn = UIUtils.FindBtn(self.Trans, "Right/GoToBtn");
    UIUtils.AddBtnEvent(self.GoToCopyBtn, self.OnGoToBtnClick, self)
    self.NeedItems = {};
    for i = 1, 2 do
        self.NeedItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format( "Right/UIItem%d", i)));
    end
    self.LevelUpBtn = UIUtils.FindBtn(self.Trans, "Right/LevelUp");
    UIUtils.AddBtnEvent(self.LevelUpBtn, self.OnLevelUPBtnClick, self)

    self.RedPointCom = CommonPanelRedPoint:New();
    self.RedPointCom:Add(FunctionStartIdCode.PlayerJingJie, self.LevelUpBtn.transform, 0, false)
end

function UIPlayerShiHaiForm:OnShowBefore()
    self.RedPointCom:Initialize()
end

function UIPlayerShiHaiForm:OnShowAfter()
    GameCenter.PlayerShiHaiSystem:ReqShiHaiData();
    self:OnRefreshPage(nil, nil);
end

function UIPlayerShiHaiForm:OnHideBefore()
    self.RedPointCom:UnInitialize()
end

--开启事件
function UIPlayerShiHaiForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
end

--关闭事件
function UIPlayerShiHaiForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--前往副本按钮点击
function UIPlayerShiHaiForm:OnGoToBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.TowerCopyMap)
end

--升级按钮点击
function UIPlayerShiHaiForm:OnLevelUPBtnClick()
    GameCenter.PlayerShiHaiSystem:ReqLevelUP()
end

--刷新事件
function UIPlayerShiHaiForm:OnRefreshPage(obj, sender)
    local _level = GameCenter.PlayerShiHaiSystem.CurCfgID;
    local _cfg = DataConfig.DataPlayerShiHai[_level];
    if _cfg == nil then
        return
    end
    self.CurLevel.text = _cfg.Name;
    self.CurFightPower.text = string.format("%d", _cfg.FightPower);
    local _cs = {';','_'}
    local _curAtt = Utils.SplitStrByTableS(_cfg.CurAttribute, _cs);
    local _addAtt = Utils.SplitStrByTableS(_cfg.AddAttribute, _cs);
    local _attCount = #_curAtt;
    local _attAddCount = #_addAtt;
    for i = 1, 6 do
        if i <= _attCount then
            self.PropTable[i].RootGo:SetActive(true);
            local _attCfg = DataConfig.DataAttributeAdd[_curAtt[i][1]];
            if _attCfg ~= nil then
                self.PropTable[i].Name.text = _attCfg.Name .. ":";
            end
            self.PropTable[i].Value.text = string.format("%d", _curAtt[i][2]);
            if i <= _attAddCount then
                self.PropTable[i].AddValue.text = string.format("%d", _addAtt[i][2]);
            end
        else
            self.PropTable[i].RootGo:SetActive(false);
        end
    end

    local _copyCfg = DataConfig.DataChallengeReward[_cfg.NeedCopyLevel]
    if _copyCfg ~= nil then
        if GameCenter.PlayerShiHaiSystem.CurWYTLevel > _cfg.NeedCopyLevel then
            self.NeedCopyLevel.text = string.format( "[00FF00]%s%s[-]", _copyCfg.Name, _copyCfg.LittleName);
        else
            self.NeedCopyLevel.text = string.format( "[FF0000]%s%s[-]", _copyCfg.Name, _copyCfg.LittleName);
        end
    end

    local _curItem = Utils.SplitStrByTableS(_cfg.NeedItem, _cs);
    local _itemCount = #_curItem;
    for i = 1, 2 do
        if i <= _itemCount then
            self.NeedItems[i].RootGO:SetActive(true)
            self.NeedItems[i]:InItWithCfgid(_curItem[i][1], _curItem[i][2], false, true)
            self.NeedItems[i]:BindBagNum();
        else
            self.NeedItems[i].RootGO:SetActive(false)
        end
    end
end

return UIPlayerShiHaiForm;