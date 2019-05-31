------------------------------------------------
--作者： 何健
--日期： 2019-05-20
--文件： UICreateGuildPanel.lua
--模块： UICreateGuildPanel
--描述： 创建宗派界面
------------------------------------------------
local ItemBase = CS.Funcell.Code.Logic.ItemBase
local L_AddReduce = require "UI.Components.UIAddReduce"
local UICreateGuildPanel ={
    Go = nil,
    Trans = nil,
    GuildNameInput = nil,
    GuildNoticeLabel = nil,
    CostIcon = nil,
    CostNumLabel = nil,
    SelectGo = nil,
    LevelSetting = nil,
    MinJoinLevel = 0,
    MaxJoinLevel = 0,
    CurSelectLevel = 0
}

--创建一个新的对象
function UICreateGuildPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UICreateGuildPanel:FindAllComponents()
    self.GuildNameInput = UIUtils.FindInput(self.Trans, "NameInput")
    self.GuildNoticeLabel = UIUtils.FindLabel(self.Trans, "DeclarationInput/InputLabel")
    self.CostIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "CostLabel/Icon"))
    self.CostNumLabel = UIUtils.FindLabel(self.Trans, "CostLabel")
    self.SelectGo = UIUtils.FindGo(self.Trans, "UseApply/Sprite")
    self.LevelSetting = L_AddReduce:OnFirstShow(UIUtils.FindTrans(self.Trans, "UIAddReduce"))
    self.LevelSetting:SetCallBack(Utils.Handler(self.OnClickAddReduce, self), Utils.Handler(self.OnClickAddReduceInput, self))

    local _btn = UIUtils.FindBtn(self.Trans, "CloseBtn")
    UIUtils.AddBtnEvent(_btn, self.Close, self)
    _btn = UIUtils.FindBtn(self.Trans, "CreateGuild")
    UIUtils.AddBtnEvent(_btn, self.CreateBtnClick, self)
    _btn = UIUtils.FindBtn(self.Trans, "UseApply")
    UIUtils.AddBtnEvent(_btn, self.OnSelectApplyClick, self)

    local _global = DataConfig.DataGlobal[1198]
    if _global ~= nil then
        self.MinJoinLevel = tonumber(_global.Params)
    end

    _global = DataConfig.DataGlobal[1099]
    if _global ~= nil then
        self.MaxJoinLevel = tonumber(_global.Params)
    end
 end

 --打开界面
 function UICreateGuildPanel:Open()
    self.Go:SetActive(true)
    self:OnRefreshForm()
 end

 --关闭界面
 function UICreateGuildPanel:Close()
    self.Go:SetActive(false)
 end

 --是否需要审核
 function UICreateGuildPanel:OnSelectApplyClick()
    self.SelectGo:SetActive(not self.SelectGo.activeSelf)
 end

 --创建按钮点击
 function UICreateGuildPanel:CreateBtnClick()
    if  #self.GuildNameInput.value > 0 and self.CurSelectLevel >= self.MinJoinLevel then
        local _msg = {
            icon = 100,
            isApply = not self.SelectGo.activeSelf,
            joinLv = self.CurSelectLevel,
            name = self.GuildNameInput.value,
            notice = self.GuildNoticeLabel.text
        }
        GameCenter.Network.Send("MSG_Guild.ReqCreateGuild", _msg)
    else
        if #self.GuildNameInput.value == 0 then
            GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("UI_GUILD_NAMECANTNULL"))
            return
        end
        if self.CurSelectLevel < self.CurSelectLevel then
            GameCenter.MsgPromptSystem:ShowPrompt(UIUtils.CSFormat(DataConfig.DataMessageString.Get("UI_GUILD_LEVELISERROR"), self.MinJoinLevel))
        end
    end
 end

 function UICreateGuildPanel:OnClickAddReduce(add)
    if add then
        self.CurSelectLevel = self.CurSelectLevel + 1
    else
        self.CurSelectLevel = self.CurSelectLevel - 1
    end

    self:FixLevel()
    self.LevelSetting:SetValueLabel(CommonUtils.GetLevelDesc(self.CurSelectLevel))
 end

function UICreateGuildPanel:OnClickAddReduceInput()
     GameCenter.NumberInputSystem:OpenInput(self.MaxJoinLevel, Vector3(-200, 0, 0), function(num)
         if num < 1 then
             num = 1
         end
         self.CurSelectLevel = num
         self.LevelSetting:SetValueLabel(CommonUtils.GetLevelDesc(num))
     end, 0, function()
         self:FixLevel()
         self.LevelSetting:SetValueLabel(CommonUtils.GetLevelDesc(self.CurSelectLevel))
     end)
end

function UICreateGuildPanel:FixLevel()
    if self.CurSelectLevel < self.MinJoinLevel then
        self.CurSelectLevel = self.MinJoinLevel
    end
    if self.CurSelectLevel > self.MaxJoinLevel then
        self.CurSelectLevel = self.MaxJoinLevel
    end
end

 --更新界面显示
 function UICreateGuildPanel:OnRefreshForm()
    local _item = DataConfig.DataGlobal[44]
    if _item ~= nil then
        local _itemID = 0
        local _itemNum = 0
        local _array = Utils.SplitStr(_item.Params, "_")
        if #_array == 2 then
            _itemID = tonumber(_array[1])
            _itemNum = tonumber(_array[2])
        end
        self.CostIcon:UpdateIcon(ItemBase.GetItemIcon(_itemID))
        self.CostNumLabel.text = tostring(_itemNum)
        if GameCenter.ItemContianerSystem:GetEconomyWithType(ItemTypeCode.__CastFrom(_itemID)) < _itemNum then
            self.CostNumLabel.color = Color.red
        else
            self.CostNumLabel.color = Color.white
        end
    end
    self.GuildNoticeLabel.text = DataConfig.DataMessageString.Get("GUILD_NOTICE_EDIT")
    self.SelectGo:SetActive(true)
    self:FixLevel()
    self.LevelSetting:SetValueLabel(CommonUtils.GetLevelDesc(self.CurSelectLevel))
 end

return UICreateGuildPanel