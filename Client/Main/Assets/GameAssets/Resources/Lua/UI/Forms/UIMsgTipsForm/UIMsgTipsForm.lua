------------------------------------------------
--作者： dhq
--日期： 2019-03-25
--文件： MsgTipsForm.lua
--模块： MsgTipsForm
--描述： 右下角的经验获得提示框和打怪物品获得框
------------------------------------------------

local UIMsgTipsItem = require("UI.Forms.UIMsgTipsForm.UIMsgTipsItem")
local MsgPromptSystem = require("Logic.MsgPrompt.MsgPromptSystem")
--local MsgPromptSystem = CS.Funcell.Code.Logic.MsgPromptSystem

local UIMsgTipsForm = 
{
    --没有被使用的对象List<UIMsgTipsItem>
    UnUseList = List:New(),
    --已经使用的对象List<UIMsgTipsItem>
    UsedList = List:New(),
    --当前能够显示下一条
    EnableShow = false,
    --记录上一次显示的时间
    FrontShowTime = 0,
    --下一条出现间隔的时间
    ShowIntervalTime = 0.2,
    --移动的目标位置List<Vector3>
    ItemTargetPos = List:New(),
    -- 起始位置
    StartPos = Vector3(-78, -15, 0),
    --待显示的消息队列List<MsgPromptInfo>
    MsgQueue = List:New(),
    --显示的时间
    LifeTime = 1,
}

function UIMsgTipsForm:Update()
    if ((Time.realtimeSinceStartup - self.FrontShowTime) >= self.ShowIntervalTime) then
        self.EnableShow = true
        --缓存中有数据,有空余的显示对象,并且需要可以显示
        if ((self.MsgQueue:Count() > 0) == true and self:CheckShowNew() == true) then
            local msgPromptInfo = self:DeQueue()
            if msgPromptInfo ~= nil then
                self:SetInfo(msgPromptInfo)
            end
        end
    end
    UIMsgTipsItem:Update()
end

function UIMsgTipsForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIMsgTipsForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIMSGTIPS_SHOWINFO, self.OnShowInfo)
    self:RegisterEvent(UIEventDefine.UIMsgTipsForm_CLOSE,self.OnClose)
end

function UIMsgTipsForm:OnLoad()
    self.CSForm.UIRegion = CS.Funcell.Plugins.Common.UIFormRegion.MiddleRegion
    --self.CSForm.FormType = CS.Funcell.Plugins.Common.UIFormType.Hint
end

function UIMsgTipsForm:OnFirstShow()
    self.UnUseList:Clear()
    self.UsedList:Clear()
    local _msgTrans = UIUtils.FindTrans(self.Trans, "Msg")
    for i = 1, _msgTrans.childCount do
        local _transId = i - 1
        local _item = _msgTrans:Find(string.format("%d", _transId))
        local _tipsItem = UIMsgTipsItem:New(self, _item, _transId)
        self.UnUseList:Add(_tipsItem)
        self.ItemTargetPos:Add(_item.localPosition)
    end
end

function UIMsgTipsForm:OnShowBefore()
    self.EnableShow = true
end

function UIMsgTipsForm:OnHideAfter()
    for i,v in ipairs(self.UsedList) do
        self.UnUseList.Add(self.UsedList[i])
    end
    self.MsgQueue:Clear()
end

--显示信息
function UIMsgTipsForm:OnShowInfo(obj, sender)
    if (obj ~= nil) then
        if (self.CSForm.IsVisible == false) then
            self.CSForm:Show(sender)
        end
        if (self:CheckShowNew() == true) then
            self:SetInfo(obj)
        else
            self:EnQueue(obj)
        end
    end
end

--当某个Item变为非激活时,进行回收处理
function UIMsgTipsForm:OnItemDeactive(uiMsgTipsItem)
    self.UsedList:Remove(uiMsgTipsItem)
    self.UnUseList:Add(uiMsgTipsItem)
end

function UIMsgTipsForm:SetInfo(msgPromptInfo)
    if (self.UnUseList:Count() > 0) then
        self.EnableShow = false
        self.FrontShowTime = Time.realtimeSinceStartup
        local _currentItem = self.UnUseList[1]
        self.UnUseList:Remove(_currentItem)
        for i = 1, self.UsedList:Count() do
            --if (self.UsedList[i].GO.name == _currentItem.GO.name) then
            if (self.UsedList[i] == _currentItem) then
                self.UsedList:Remove(self.UsedList[i])
            end
        end
        self.UsedList:Add(_currentItem)
        if (msgPromptInfo.ItemBase ~= nil) then
            _currentItem:Show(msgPromptInfo.ItemBase, self.StartPos)
        else
            _currentItem:Show(msgPromptInfo.Msg, self.StartPos)
        end
        for i = 1, self.UsedList:Count() do
            self.UsedList[i]:MoveTo(self.ItemTargetPos[i]);
        end
    end
end

--添加信息对象
function UIMsgTipsForm:EnQueue(msgPromptInfo)
    if (self.MsgQueue:Count() > 0) then
        --MsgPromptSystem:EnQueueMsgPromptInfo(self.MsgQueue, msgPromptInfo)
        MsgPromptSystem:EnQueue(self.MsgQueue, msgPromptInfo)
    else
        self.MsgQueue:Add(msgPromptInfo)
    end
end

--从队列中获取一个信息
function UIMsgTipsForm:DeQueue()
    local result = MsgPromptSystem:DeQueue(self.MsgQueue)
    return result
end

--判断显示新的信息
function UIMsgTipsForm:CheckShowNew()
    local _unUseListCount = self.UnUseList:Count()
    local _usedListCount = self.UsedList:Count()
    local _itemTargetPostCount = self.ItemTargetPos:Count()
    if _unUseListCount > 0 == true and self.EnableShow == true and (_usedListCount <= _itemTargetPostCount) == true then
        return true
    else
        return false
    end
end

return UIMsgTipsForm