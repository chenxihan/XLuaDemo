------------------------------------------------
--作者： gzg
--日期： 2019-05-13
--文件： UIFeedBackInputPanel.lua
--模块： UIFeedBackInputPanel
--描述： 填写反馈并提交的界面
------------------------------------------------

local UIToggleGroup = require("UI.Components.UIToggleGroup");

--定义反馈的面板
local UIFeedBackInputPanel = {
   --是否显示
   IsVisibled = false,
   --主面板
   MainPanel = nil,
   --自身Transform
   Trans = nil,

   --选择反馈的类型
   StateToggleGroup = nil,

   --提交按钮
   PostBtn = nil,

   --输入区域
   Input = nil,

   --当前状态
   State = 0,
};

--状态开关组
local L_StateToggleProp = nil;

function UIFeedBackInputPanel:Initialize(owner,trans)
    self.MainPanel = owner;
    self.Trans = trans;
    self:FindAllComponents();
    self:RegUICallback();
    return self;
end

function UIFeedBackInputPanel:Show()
    self.IsVisibled = true;    
    self.Trans.gameObject:SetActive(true);
    self:Refresh();
end

function UIFeedBackInputPanel:Hide()
    self.IsVisibled = false;
    self.Trans.gameObject:SetActive(false);
end


--查找所有组件
function UIFeedBackInputPanel:FindAllComponents()
    local _myTrans = self.Trans;    
    self.StateToggleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"State"),2002,L_StateToggleProp);
    self.PostBtn = UIUtils.FindBtn(_myTrans,"PostBtn");
    self.Input = UIUtils.FindInput(_myTrans,"Content/Panel/Input");	
end

--绑定UI组件的回调函数
function UIFeedBackInputPanel:RegUICallback()
   UIUtils.AddBtnEvent(self.PostBtn,self.PostFeedBack,self);
end

function UIFeedBackInputPanel:Refresh()
   self.State = 1;
   self.StateToggleGroup:Refresh();
end

function UIFeedBackInputPanel:PostFeedBack()
    local _c = self.Input.text;    
    Debug.Log("提交反馈".. tostring(self.State) .. _c);
end

function UIFeedBackInputPanel:SetState(val)    
    self.State = val;
end

--==内部变量以及函数的定义==--
--状态开关的属性
L_StateToggleProp = {    
    [1] = {
        Get = function()
            return UIFeedBackInputPanel.State == 1;
        end,
        Set = function(checked)
            if checked then UIFeedBackInputPanel:SetState(1); end
        end
    },
    [2] = {
        Get = function()
            return UIFeedBackInputPanel.State == 2;
        end,
        Set = function(checked)
            if checked then UIFeedBackInputPanel:SetState(2); end
        end
    },
    [3] = {
        Get = function()
            return UIFeedBackInputPanel.State == 3;
        end,
        Set = function(checked)
            if checked then UIFeedBackInputPanel:SetState(3); end
        end
    },
    [4] = {
        Get = function()
            return UIFeedBackInputPanel.State == 4;
        end,
        Set = function(checked)
            if checked then UIFeedBackInputPanel:SetState(4); end
        end
    }
};


return UIFeedBackInputPanel;