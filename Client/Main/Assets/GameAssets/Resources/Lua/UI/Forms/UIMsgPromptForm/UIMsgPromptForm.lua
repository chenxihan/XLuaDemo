------------------------------------------------
--作者： dhq
--日期： 2019-04-28
--文件： MsgTipsForm.lua
--模块： MsgTipsForm
--描述： 系统消息提示框，跑马灯位置这块
------------------------------------------------
local UIMsgPromptItem = require("UI.Forms.UIMsgPromptForm.UIMsgPromptItem")
local MsgPromptSystem = CS.Funcell.Code.Logic.MsgPromptSystem

local UIMsgPromptForm = 
{
    --没有被使用的对象List<UIMsgPromptItem>
    UnUseList = List:New(),
    --已经使用的对象List<UIMsgPromptItem>
    UsedList = List:New(),
    --当前是否能够显示下一条
    EnableShow = false,
    --待显示的消息队列List<MsgPromptInfo>
    MsgQueue = List:New(),
    FrontShowTime = 0,
    ShowIntervalTime = 0.5,
    --目标位置List<Vector3>
    ItemTargetPos = List:New(),
    --起始位置
    StartPos = Vector3(0, 110, 0),
    LifeTime = 2,
}

function UIMsgPromptForm:Update()
    if(Time.realtimeSinceStartup - self.FrontShowTime >= self.ShowIntervalTime) then
        self.EnableShow = true
        --缓存中有数据,有空余的显示对象,并且可以显示
        if (self.MsgQueue:Count() > 0 and self:CheckShowNew()) then
            self:SetInfo(self:DeQueue())
        end
    end
end

function UIMsgPromptForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISYSTEMINFO_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISYSTEMINFO_SHOWINFO, self.OnShowInfo)
    self:RegisterEvent(UIEventDefine.UISYSTEMINFO_CLOSE, self.OnClose)
end

function UIMsgPromptForm:OnLoad()
    self.CSForm.UIRegion = CS.Funcell.Plugins.Common.UIFormRegion.NoticRegion
    --FormType = UIFormType.Hint
end

function UIMsgPromptForm:OnFirstShow()
    self.UnUseList:Clear()
    self.UsedList:Clear()

    for i=1, self.Trans.childCount do
        local _item = UIUtils.FindTrans(self.Trans, string.format( "Info%d",i))
        local _msgPromptItem = UIMsgPromptItem:New(self, _item)
        --UIMsgPromptItem msgPromptItem = UnityUtils.RequireComponent<UIMsgPromptItem>(TransformInst.Find(string.Format("Info{0}",i)).gameObject);
        --_msgPromptItem.OnFirstShow(this);
        self.UnUseList:Add(_msgPromptItem)
        self.ItemTargetPos:Add(_item.localPosition)
    end
    GameCenter.PushFixEvent(UIEventDefine.UIMARQUEE_OPEN)
end

function UIMsgPromptForm:OnShowBefore()
    self.EnableShow = true
end

function UIMsgPromptForm:OnHideAfter()
    for i=1, self.UsedList:Count() do
        self.UnUseList:Add(self.UsedList[i])
    end
    self.MsgQueue:Clear()
end

function UIMsgPromptForm:OnShowInfo(obj ,sender)
    if (obj ~= nil) then
        if (self.CSForm.IsVisible == false) then
            self.CSForm:Show(sender)
        end

        if (self:CheckShowNew()) then
            self.LifeTime = 2
            self:SetInfo(obj)
        else
            self:EnQueue(obj)
        end
    end
end

--当某个Item变为非激活时,进行回收处理
function UIMsgPromptForm:OnItemDeactive(uIMsgPromptItem)
    self.UsedList:Remove(uIMsgPromptItem)
    self.UnUseList:Add(uIMsgPromptItem)
end

function UIMsgPromptForm:SetInfo(msgPromptInfo)
    if (self.UnUseList.Count > 0) then
        self.EnableShow = false
        self.FrontShowTime = Time.realtimeSinceStartup
        local currentItem = self.UnUseList[0]
        self.UnUseList:Remove(currentItem)
        for i=1,self.UsedList:Count() do
            if (self.UsedList[i].name.Equals(currentItem.name)) then
                self.UsedList.Remove(self.UsedList[i]);
            end
        end
        self.UsedList:Add(currentItem);
        
        if (msgPromptInfo.ItemBase ~= nil) then
            currentItem.Show(msgPromptInfo.ItemBase, self.StartPos)
        else
            currentItem.Show(msgPromptInfo.Msg, self.StartPos)
        end

        for i=1, self.UsedList:Count() do
            self.UsedList[i].MoveTo(self.ItemTargetPos[i])
        end
        Debug.Log(msgPromptInfo.Msg)
        --FLogger.DebugLogTime("show:" + temp.Msg);
    end
end

--添加信息对象
function UIMsgPromptForm:EnQueue(msgPromptInfo)
    if (self.MsgQueue:Count() > 0) then
        --1.先判断队列中最后一个信息是否与当前信息相同,如果是就返回,如果不是就添加到队列中
        local item = self.MsgQueue[self.MsgQueue:Count() - 1]
        if (self.MsgPromptInfo.Equal(msgPromptInfo, item) == false) then
            --2.根据优先级插入一个信息
            MsgPromptSystem.EnQueue(self.MsgQueue, msgPromptInfo)
        else
            self.MsgQueue.Add(msgPromptInfo)
        end
    else
        self.MsgQueue.Add(msgPromptInfo);
    end

    if (self.MsgQueue:Count() >= 10) then
        self.LifeTime = 1
    elseif (self.MsgQueue:Count() >= 2) then
        self.LifeTime = 1.5
    else
        self.LifeTime = 2
    end
end

--从队列中获取一个信息
function UIMsgPromptForm:DeQueue()
    local result = MsgPromptSystem.DeQueue(self.MsgQueue)
    if (self.MsgQueue:Count() >= 10) then
        self.LifeTime = 1
    elseif (self.MsgQueue:Count() >= 2) then
        self.LifeTime = 1.5
    else
        self.LifeTime = 2
    end
    return result
end

--判断显示新的信息
function UIMsgPromptForm:CheckShowNew()
    return self.UnUseList:Count() > 0 and self.EnableShow and (self.UsedList.Count <= self.ItemTargetPos:Count())
end

return UIMsgPromptForm