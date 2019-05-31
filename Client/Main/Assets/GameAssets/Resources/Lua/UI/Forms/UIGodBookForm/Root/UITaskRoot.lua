------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UITaskRoot.lua
--模块： UITaskRoot
--描述： 符咒 Root
------------------------------------------------
local UITaskItem = require "UI.Forms.UIGodBookForm.Item.UITaskItem"

local UITaskRoot = {
    Owner = nil,
    Trans = nil,
    ListPanel = nil,
    TaskItem = nil,
}

function  UITaskRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UITaskRoot:FindAllComponents()
    self.ListPanel = UIUtils.FindTrans(self.Trans, "ListPanel/Grid")
    self.TaskItem = UIUtils.FindTrans(self.Trans, "ListPanel/Grid/Item")
end

-- 刷新符咒对应的任务 id = 符咒的id
function UITaskRoot:RefreshTaskList(id)
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
    local _taskList = GameCenter.GodBookSystem:GetTaskList(id)
    if not _taskList then
        Debug.LogError("TaskList = nil")
        return
    end
    local _item = nil
    for i=1, _taskList:Count() do
        if i <= self.ListPanel.childCount then
            _item = UITaskItem:New(self, self.ListPanel:GetChild(i - 1), _taskList[i].ID)
        else
            _item = UITaskItem:Clone(self, self.TaskItem.gameObject, self.ListPanel, _taskList[i].ID)
        end
        _item:UpdateData(_taskList[i])
    end
    UnityUtils.GridResetPosition(self.ListPanel)
    UnityUtils.ScrollResetPosition(UIUtils.FindTrans(self.Trans, "ListPanel"))
end

function UITaskRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
end

function UITaskRoot:OnCLose()
    self.Trans.gameObject:SetActive(false)
end

return UITaskRoot