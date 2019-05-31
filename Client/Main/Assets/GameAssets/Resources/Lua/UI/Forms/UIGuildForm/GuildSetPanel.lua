------------------------------------------------
--作者： 何健
--日期： 2019-05-24
--文件： GuildSetPanel.lua
--模块： GuildSetPanel
--描述： 宗派设置界面
------------------------------------------------
local L_CheckBox = require "UI.Components.UICheckBox"
local L_AddReduce = require "UI.Components.UIAddReduce"
local GuildSetPanel = {
    Trans = nil,
    Go = nil,
    --选择框，是否需要审核
    CheckBox = nil,
    --公告输入
    NoticeInput = nil,
    --阻挡，宗派等级低的时候，不让修改公告
    NoticeBoxGo = nil,
    --等级输入控件
    LevelInput = nil,
    --公告修改限制提示
    DefalutTipsLabel = nil,
    --加入宗派最小最大等级，由配置表配置
    GlobalMin = 0,
    GlobalMax = 0,
    CurSetLevel = 0,
    --公告输入限制等级，必须达到一定宗派等级才可输入公告
    NoticeLimit = 0,
}

--创建一个新的对象
function GuildSetPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--查找控件
function GuildSetPanel:FindAllComponents()
    self.CheckBox = L_CheckBox:OnFirstShow(UIUtils.FindTrans(self.Trans, "UseApply"))
    self.NoticeInput = UIUtils.FindInput(self.Trans, "DeclarationInput")
    self.NoticeBoxGo = UIUtils.FindGo(self.Trans, "InputContainer")
    self.DefalutTipsLabel = UIUtils.FindLabel(self.Trans, "DefaultLabel")
    self.LevelInput = L_AddReduce:OnFirstShow(UIUtils.FindTrans(self.Trans, "UIAddReduce"))
    self.LevelInput:SetCallBack(Utils.Handler(self.OnClickAddReduce, self), Utils.Handler(self.OnClickAddReduceInput, self))
    self.CheckBox:SetOnClickFunc(Utils.Handler(self.OnClickCheckBox, self))
    local _btn = UIUtils.FindBtn(self.Trans, "SaveBtn")
    UIUtils.AddBtnEvent(_btn, self.OnSaveBtnClick, self)
    local _closeBtn = UIUtils.FindBtn(self.Trans, "CloseBtn")
    UIUtils.AddBtnEvent(_closeBtn, self.Close, self)

    local _global = DataConfig.DataGlobal[1198]
    if _global ~= nil then
        self.GlobalMin = tonumber(_global.Params)
    end

    _global = DataConfig.DataGlobal[1099]
    if _global ~= nil then
        self.GlobalMax = tonumber(_global.Params)
    end
    _global = DataConfig.DataGlobal[1496]
    if _global ~= nil then
        self.NoticeLimit = tonumber(_global.Params)
    end
end

function GuildSetPanel:Open()
    self.Go:SetActive(true)
    self:OnUpdateForm()
end

function GuildSetPanel:Close()
    self.Go:SetActive(false)
end
--保存设置
function GuildSetPanel:OnSaveBtnClick()
    if self.CurSetLevel < self.GlobalMin then
        GameCenter.MsgPromptSystem:ShowPrompt(UIUtils.CSFormat(DataConfig.DataMessageString.Get("UI_GUILD_LEVELISERROR"), self.GlobalMin))
        return
    end

    local _req = {
        icon = 100,
        notice = self.NoticeInput.value,
        isApply = not self.CheckBox.IsChecked,
        lv = self.CurSetLevel
    }
    GameCenter.Network.Send("MSG_Guild.ReqChangeGuildSetting", _req)
end

function GuildSetPanel:OnClickCheckBox(check)
end
--等级加减
function GuildSetPanel:OnClickAddReduce(add)
    if add then
        self.CurSetLevel = self.CurSetLevel + 1
    else
        self.CurSetLevel = self.CurSetLevel - 1
    end

    self:FixLevel()
    self.LevelInput:SetValueLabel(CommonUtils.GetLevelDesc(self.CurSetLevel))
end
--输入点击，打开数字输入键盘
function GuildSetPanel:OnClickAddReduceInput()
    GameCenter.NumberInputSystem:OpenInput(self.GlobalMax, Vector3(-200, 0, 0), function(num)
        if num < 1 then
            num = 1
        end
        self.CurSetLevel = num
        self.LevelInput:SetValueLabel(CommonUtils.GetLevelDesc(num))
    end, 0, function()
        self:FixLevel()
        self.LevelInput:SetValueLabel(CommonUtils.GetLevelDesc(self.CurSetLevel))
    end)
end
--等级判断 是否超过上下限制
function GuildSetPanel:FixLevel()
    if self.CurSetLevel < self.GlobalMin then
        self.CurSetLevel = self.GlobalMin
    end
    if self.CurSetLevel > self.GlobalMax then
        self.CurSetLevel = self.GlobalMax
    end
end

--加载界面数据
function GuildSetPanel:OnUpdateForm()
    local _info = GameCenter.GuildSystem.GuildInfo
    if _info == nil then
        return
    end
    self.CurSetLevel = _info.limitLv
    self.LevelInput:SetValueLabel(CommonUtils.GetLevelDesc(_info.limitLv))
    self.NoticeInput.value = _info.notice;
    self.CheckBox:SetChecked(not _info.isApply)
    self.DefalutTipsLabel.text = UIUtils.CSFormat("宗派等级达到{0}级才可修改宗派公告", self.NoticeLimit)

    if _info.lv >= self.NoticeLimit then
        self.NoticeBoxGo:SetActive(false)
    else
        self.NoticeBoxGo:SetActive(true)
    end
end
return GuildSetPanel