------------------------------------------------
--作者： 薛超
--日期： 2019-05-23
--文件： UIMySelfBossCopyItemForm.lua
--模块： UIMySelfBossCopyItemForm个人BOSS道具使用
------------------------------------------------

local UIItem = require "UI.Components.UIItem"

local UIMySelfBossCopyItemForm = {
    TimeLab = nil, --道具剩余时间
    DoubleLab = nil, --双倍掉落
    TimeButton = nil, --道具切割按钮
    DoubleButton = nil, --双倍掉落按钮
    LevelButton = nil, --离开按钮

    AutoButton = nil, --自动按钮
    AutoSelectGo = nil, --自动显示
    UseItemTimeButton = nil, --使用道具时间
    TimeTittleLab = nil, --时间道具描述
    TimeItemTrs = nil, --时间道具
    TimeTexture = nil, --时间道具背景图片

    LeftButton = nil, --次数按钮
    RightButton = nil, --次数按钮
    NumLabel = nil, --次数
    UseDoubleButton = nil, --使用道具时间
    DoubleTexture = nil, --双倍道具背景图片
    DoubleTittleLab = nil, --双倍道具描述
    DoubleItemTrs = nil, --时间道具

    TimeGo = nil, --切割面板节点
    DoubleGo = nil, --双倍道具节点
    TimeClose = nil, --切割面板关闭
    DoubleClose = nil, --双倍道具面板关闭

    MsgInfo = nil, --数据
    OffsetTime = 0.5, --间隔时间更新
    CurTime = 0, --当前时间
    ItemInfo = nil, --Global中的切割道具数据
    DoubleInfo = nil, --Global中的双倍道具数据
    RefershButton = nil, --刷新按钮
    RefershItemid = 0, --刷新道具ID

    DoubleCurNum = 0, --双倍道具选择数量
    DoubleMaxNum = 0, --双倍道具最大选择数量
}

function UIMySelfBossCopyItemForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMySelfBossCopyItemForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIMySelfBossCopyItemForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.BOSS_EVENT_MYSELF_COPYINFO, self.UpDateInfo)
    self:RegisterEvent(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.UpDataMaxNum)
    self:RegisterEvent(LogicEventDefine.BOSS_EVENT_MYSELF_COPYITEM, self.UpDataItemInfo)
end

--打开
function UIMySelfBossCopyItemForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

--关闭
function UIMySelfBossCopyItemForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UIMySelfBossCopyItemForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
    self:InitString()
end

function UIMySelfBossCopyItemForm:OnShowBefore()
    self:InitMsg()
end

--注册UI上面的事件，比如点击事件等
function UIMySelfBossCopyItemForm:RegUICallback()
    EventDelegate.Add(self.TimeButton.onClick, Utils.Handler(self.OnClickTimeButton, self))
    EventDelegate.Add(self.DoubleButton.onClick, Utils.Handler(self.OnClickDoubleButton, self))
    EventDelegate.Add(self.LevelButton.onClick, Utils.Handler(self.OnClickLevelButton, self))
    EventDelegate.Add(self.AutoButton.onClick, Utils.Handler(self.OnClickAutoButton, self))
    EventDelegate.Add(self.UseItemTimeButton.onClick, Utils.Handler(self.OnClickUseItemTimeButton, self))
    EventDelegate.Add(self.LeftButton.onClick, Utils.Handler(self.OnClickLeftButton, self))
    EventDelegate.Add(self.RightButton.onClick, Utils.Handler(self.OnClickRightButton, self))
    EventDelegate.Add(self.UseDoubleButton.onClick, Utils.Handler(self.OnClickUseDoubleButton, self))
    EventDelegate.Add(self.TimeClose.onClick, Utils.Handler(self.OnClickTimeClose, self))
    EventDelegate.Add(self.DoubleClose.onClick, Utils.Handler(self.OnClickDoubleClose, self))
    EventDelegate.Add(self.RefershButton.onClick, Utils.Handler(self.OnClickRefershButton, self))
end

--查找组件
function UIMySelfBossCopyItemForm:FindAllComponents()
    self.TimeLab = UIUtils.FindLabel(self.Trans,"Bottom/Offset/Item/Time")
    self.DoubleLab = UIUtils.FindLabel(self.Trans,"Bottom/Offset/Double/Time")
    self.TimeButton = UIUtils.FindBtn(self.Trans,"Bottom/Offset/Item/Add")
    self.DoubleButton = UIUtils.FindBtn(self.Trans,"Bottom/Offset/Double/Add")
    self.LevelButton = UIUtils.FindBtn(self.Trans,"RightTop/Leave")
    self.AutoButton = UIUtils.FindBtn(self.Trans,"Center/Panel/Item/Auto")
    self.AutoSelectGo = UIUtils.FindGo(self.Trans,"Center/Panel/Item/Auto/Sprite")
    self.UseItemTimeButton =  UIUtils.FindBtn(self.Trans,"Center/Panel/Item/Button")
    self.TimeTittleLab =  UIUtils.FindLabel(self.Trans,"Center/Panel/Item/Tittle")
    self.TimeItemTrs = UIUtils.FindTrans(self.Trans,"Center/Panel/Item/UIItem")
    self.TimeTexture = UIUtils.FindTex(self.Trans,"Center/Panel/Item/bg")

    self.LeftButton =  UIUtils.FindBtn(self.Trans,"Center/Panel/Double/UseItem/Left")
    self.RightButton =  UIUtils.FindBtn(self.Trans,"Center/Panel/Double/UseItem/Right")
    self.NumLabel =  UIUtils.FindLabel(self.Trans,"Center/Panel/Double/UseItem/Num")
    self.UseDoubleButton = UIUtils.FindBtn(self.Trans,"Center/Panel/Double/Button")
    self.DoubleTexture = UIUtils.FindTex(self.Trans,"Center/Panel/Double/bg")
    self.DoubleTittleLab = UIUtils.FindLabel(self.Trans,"Center/Panel/Double/Tittle")
    self.DoubleItemTrs =  UIUtils.FindTrans(self.Trans,"Center/Panel/Double/UIItem")

    self.RefershButton = UIUtils.FindBtn(self.Trans,"Bottom/Offset/Refersh")

    self.TimeGo = UIUtils.FindGo(self.Trans,"Center/Panel/Item")
    self.DoubleGo = UIUtils.FindGo(self.Trans,"Center/Panel/Double")
    self.TimeClose = UIUtils.FindBtn(self.Trans,"Center/Panel/Item/bg")
    self.DoubleClose = UIUtils.FindBtn(self.Trans,"Center/Panel/Double/bg")
    local _gCfg = DataConfig.DataGlobal[1512]
    if _gCfg ~= nil then
        self.ItemInfo = Utils.SplitStr(_gCfg.Params,'_')
        for i=1,#self.ItemInfo do
            self.ItemInfo[i] = tonumber(self.ItemInfo[i])
        end
    end
    local _gCfgdouble = DataConfig.DataGlobal[1514]
    if _gCfgdouble ~= nil then
        self.DoubleInfo = Utils.SplitStr(_gCfgdouble.Params,'_')
        for i=1,#self.DoubleInfo do
            self.DoubleInfo[i] = tonumber(self.DoubleInfo[i])
        end
    end
    local _gCfrefersh = DataConfig.DataGlobal[1518]
    self.RefershItemid = tonumber(_gCfrefersh.Params)
end

--初始化面板数据字符串显示
function UIMySelfBossCopyItemForm:InitString()
    local _itemDb = DataConfig.DataItem[self.ItemInfo[1]]
    local _messagestr = DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_ITEMTIPS")
    _messagestr = UIUtils.CSFormat(_messagestr,_itemDb.Name,self.ItemInfo[3],math.FormatNumber(self.ItemInfo[2] / 3600))
    self.TimeTittleLab.text = _messagestr

    local _item = UIItem:New(self.TimeItemTrs)
    _item.IsShowTips = true
    _item:InItWithCfgid(self.ItemInfo[1], 1,true,true)
    _item:BindBagNum()
    --双倍道具描述
    local _itemDoubleDb = DataConfig.DataItem[self.DoubleInfo[1]]
    local _messagestrDouble = DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_DOUBLETIPS")
    _messagestrDouble = UIUtils.CSFormat(_messagestrDouble,_itemDoubleDb.Name,self.DoubleInfo[2])
    self.DoubleTittleLab.text = _messagestrDouble
    --双倍道具
    local _itemdouble = UIItem:New(self.DoubleItemTrs)
    _itemdouble.IsShowTips = true
    _itemdouble:InItWithCfgid(self.DoubleInfo[1], 1,true,true)
    _itemdouble:BindBagNum()
    self.DoubleMaxNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.DoubleInfo[1])
end

--打开切割道具面板
function UIMySelfBossCopyItemForm:OnClickTimeButton()
    self.TimeGo:SetActive(true)
end

--打开双倍道具面板
function UIMySelfBossCopyItemForm:OnClickDoubleButton()
    self.DoubleCurNum = 0
    self:SetDoubleItemNum()
    self.DoubleGo:SetActive(true)
end

--关闭切割面板
function UIMySelfBossCopyItemForm:OnClickTimeClose()
    self.TimeGo:SetActive(false)
end

--关闭双倍面板
function UIMySelfBossCopyItemForm:OnClickDoubleClose()
    self.DoubleGo:SetActive(false)
end

--点击刷新按钮
function UIMySelfBossCopyItemForm:OnClickRefershButton()
    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.RefershItemid )
    if _haveNum > 0 then
        local _itemDb = DataConfig.DataItem[self.RefershItemid]
        local _messagestr = DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_REFERSHBOSS")
        _messagestr = UIUtils.CSFormat(_messagestr,_itemDb.Name)
        GameCenter.MsgPromptSystem:ShowMsgBox(_messagestr, function(code)
                    if (code == MsgBoxResultCode.Button2) then
                        GameCenter.Network.Send("MSG_Boss.ReqMySelfBossUseItem",
                        {itemid = self.RefershItemid,num = 1})
                    end
            end)
    else
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_NOTITEM"))
    end
end

--离开按钮
function UIMySelfBossCopyItemForm:OnClickLevelButton()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false)
	GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_INITIATIVE_EXIT_PLANECOPY)
end

--自动扣钱按钮
function UIMySelfBossCopyItemForm:OnClickAutoButton()
    GameCenter.Network.Send("MSG_Boss.ReqMySelfBossAuto",
    {auto = not self.MsgInfo.auto})
end

--使用切割道具
function UIMySelfBossCopyItemForm:OnClickUseItemTimeButton()
    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.ItemInfo[1])
    if _haveNum > 0 then
        GameCenter.Network.Send("MSG_Boss.ReqMySelfBossUseItem",
        {itemid = self.ItemInfo[1],num = 1})
    else
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_NOTITEM"))
    end
end

--选择道具数量-
function UIMySelfBossCopyItemForm:OnClickLeftButton()
    if self.DoubleCurNum > 0 then
        self.DoubleCurNum = self.DoubleCurNum - 1
        self:SetDoubleItemNum()
    end
end

--选择道具数量+
function UIMySelfBossCopyItemForm:OnClickRightButton()
    if self.DoubleCurNum < self.DoubleMaxNum then
        self.DoubleCurNum = self.DoubleCurNum + 1
        self:SetDoubleItemNum()
    end
end

--使用双倍道具
function UIMySelfBossCopyItemForm:OnClickUseDoubleButton()
    if self.DoubleCurNum > 0 then
        GameCenter.Network.Send("MSG_Boss.ReqMySelfBossUseItem",
        {itemid = self.DoubleInfo[1],num = self.DoubleCurNum})
    else
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_SELECTITEMNUM"))
    end
end

--网络消息初始化
function UIMySelfBossCopyItemForm:UpDateInfo()
    self:InitMsg()
end

function UIMySelfBossCopyItemForm:InitMsg()
    local _data = GameCenter.MapLogicSystem.ActiveLogic.Msg
    if _data then
        self.MsgInfo = _data.iteminfo
        self:SetDoubleNum()
        self.AutoSelectGo:SetActive(self.MsgInfo.auto)
    end
end

--设置双倍次数显示
function UIMySelfBossCopyItemForm:SetDoubleNum()
    local _messagestr = DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_DOUBLENUM")
    _messagestr = UIUtils.CSFormat(_messagestr,self.MsgInfo.doublenum)
    self.DoubleLab.text = _messagestr
end

--更新最大道具数量
function UIMySelfBossCopyItemForm:UpDataMaxNum(item,sender)
    if self.DoubleInfo and item == self.DoubleInfo[1] then
        self.DoubleMaxNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.DoubleInfo[1])
        if self.DoubleCurNum > self.DoubleMaxNum then
            self.DoubleCurNum = self.DoubleMaxNum
            self:SetDoubleItemNum()
        end
    end
end

--更新道具时间次数自动扣钱
function UIMySelfBossCopyItemForm:UpDataItemInfo(info)
    self.MsgInfo = info
    self:SetDoubleNum()
    self.AutoSelectGo:SetActive(self.MsgInfo.auto)
end

--设置双倍道具数量
function UIMySelfBossCopyItemForm:SetDoubleItemNum()
    self.NumLabel.text = tostring(self.DoubleCurNum)
end

function UIMySelfBossCopyItemForm:Update(dt)
    if self.MsgInfo then
        if self.CurTime >= self.OffsetTime  then
            local _remaintime = self.MsgInfo.time < GameCenter.HeartSystem.ServerTime and 0 or self.MsgInfo.time - GameCenter.HeartSystem.ServerTime
            if _remaintime >= 0 then
                local t1, t2 = math.modf(_remaintime % 60)
                local _secound = t1
                local _minute = math.FormatNumber((_remaintime // 60) % 60)
                local _hour = math.FormatNumber((_remaintime // 3600) % 60)
                local _messagestr = DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_ITEMTIME")
                _messagestr = UIUtils.CSFormat(_messagestr,_hour,_minute,_secound)
                self.TimeLab.text = _messagestr
            end
        else
            self.CurTime = self.CurTime + dt
        end
    end
end

--加载texture
function UIMySelfBossCopyItemForm:LoadTextures()
    self.CSForm:LoadTexture(self.TimeTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
    self.CSForm:LoadTexture(self.DoubleTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
end


return UIMySelfBossCopyItemForm