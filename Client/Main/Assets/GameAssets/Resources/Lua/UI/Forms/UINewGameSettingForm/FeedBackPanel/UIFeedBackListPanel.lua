------------------------------------------------
--作者： gzg
--日期： 2019-05-13
--文件： UIFeedBackListPanel.lua
--模块： UIFeedBackListPanel
--描述： 展示反馈信息的界面
------------------------------------------------
local UIToggleGroup = require("UI.Components.UIToggleGroup");
local UICompContainer = require("UI.Components.UICompContainer");
local UIFeedBackItem = require("UI.Forms.UINewGameSettingForm.FeedBackPanel.UIFeedBackItem");

--定义反馈的面板
local UIFeedBackListPanel = {
    --是否显示
    IsVisibled = false,
    --主面板
    MainPanel = nil,
    --自身Transform
    Trans = nil,
    --选择反馈的类型
    StateToggleGroup = nil,

    --反馈的容器
    FeedBackContainer = nil,
    --排序的Table
    UITable = nil,

    --查看什么状态的反馈
    State = 0,
};
--状态开关组
local L_StateToggleProp = nil;

function UIFeedBackListPanel:Initialize(owner,trans)
    self.MainPanel = owner;
    self.Trans = trans;
    self:FindAllComponents();
    return self;
end

function UIFeedBackListPanel:Show()
    self.IsVisibled = true;    
    self.Trans.gameObject:SetActive(true);    
    self.State = 0;
    self:Refresh();
end

function UIFeedBackListPanel:Hide()
    self.IsVisibled = false;
    self.Trans.gameObject:SetActive(false);
end


--查找所有组件
function UIFeedBackListPanel:FindAllComponents()
    local _myTrans = self.Trans;
    self.StateToggleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"State"),2004,L_StateToggleProp);    
    local _tblTrans = UIUtils.FindTrans(_myTrans,"Content/ListPanel/Table");
    self.UITable = _tblTrans:GetComponent("UITable");
    local _c = UICompContainer:New();
    for i = 0, _tblTrans.childCount - 1 do
        _c:AddNewComponent(UIFeedBackItem:New(self, _tblTrans:GetChild(i)));
    end
    _c:SetTemplate();
    self.FeedBackContainer = _c;
end

--刷新界面
function UIFeedBackListPanel:Refresh()    
    local _dataList = GameCenter.FeedBackSystem:GetFeedBackByType(self.State);
    self.FeedBackContainer:EnQueueAll();
    Debug.LogError("ServerList.Count = " .. #_dataList);
    for _,v in ipairs(_dataList) do
        self.FeedBackContainer:DeQueue(v);
    end
    self.FeedBackContainer:RefreshAllUIData();
    self.UITable.repositionNow = true;
end

--设置反馈类型
function UIFeedBackListPanel:SetState(val)
    if self.State ~= val then
        self.State = val;
        self:Refresh();
    end
end

--==内部变量以及函数的定义==--
--状态开关的属性
L_StateToggleProp = {    
    [1] = {
        Get = function()
            return UIFeedBackListPanel.State == 0;
        end,
        Set = function(checked)
            if checked then UIFeedBackListPanel:SetState(0); end
        end
    },
    [2] = {
        Get = function()
            return UIFeedBackListPanel.State == 1;
        end,
        Set = function(checked)
            if checked then UIFeedBackListPanel:SetState(1); end
        end
    },
    [3] = {
        Get = function()
            return UIFeedBackListPanel.State == 2;
        end,
        Set = function(checked)
            if checked then UIFeedBackListPanel:SetState(2); end
        end
    },
    [4] = {
        Get = function()
            return UIFeedBackListPanel.State == 3;
        end,
        Set = function(checked)
            if checked then UIFeedBackListPanel:SetState(3); end
        end
    },
    [5] = {
        Get = function()
            return UIFeedBackListPanel.State == 4;
        end,
        Set = function(checked)
            if checked then UIFeedBackListPanel:SetState(4); end
        end
    }
};


return UIFeedBackListPanel;