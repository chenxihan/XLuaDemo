------------------------------------------------
--作者： gzg
--日期： 2019-04-09
--文件： UIButtonListPanel.lua
--模块： UIButtonListPanel
--描述： 窗体按钮的列表的面板
------------------------------------------------
local UICompContainer = require("UI.Components.UICompContainer");
local UIAreaButtonItem = require("UI.Forms.UINewServerListForm.UIAreaButtonListPanel.UIAreaButtonItem");
local UIAreaButtonItemData = require("UI.Forms.UINewServerListForm.UIAreaButtonListPanel.UIAreaButtonItemData");

local UIAreaButtonListPanel = {
    --当前区域的所属对象 Form
    Owner = nil,
    --当前对象的GameObject
    GO = nil,
    --当前对象的Transform
    Trans = nil,
    --我的服务器按钮
    MyServerBtn = nil,
    --我的服务器按钮的选择对象
    MySelectedGO = nil,
    --推荐按钮
    RecommendBtn = nil,
    --推荐按钮的选择对象
    RecommendSelectedGO = nil,
    --容器的Grid
    Grid = nil,
    --分组服务器的按钮
    Container = nil, 
    --区域数据列表
    AreaDataList = nil,
}

--初始化
function UIAreaButtonListPanel:Initialize(owner,trans)
    self.Owner = owner;
    self.Trans = trans;
    self.GO = trans.gameObject;
    self:FindAllComponents();
    return self;
end

--查找组件
function UIAreaButtonListPanel:FindAllComponents()
    local _tf = self.Trans;
    self.MyServerBtn = _tf:Find("MyServerBtn"):GetComponent("UIButton");
    self.RecommendBtn = _tf:Find("RecommendServerBtn"):GetComponent("UIButton");
    self.MySelectedGO = _tf:Find("MyServerBtn/Sprite").gameObject;
    self.RecommendSelectedGO = _tf:Find("RecommendServerBtn/Sprite").gameObject;

    local _tmpTrans = _tf:Find("AreaServerBtnList/Panel/Grid");
    self.Grid = _tmpTrans:GetComponent("UIGrid");

    local _c = UICompContainer:New();
    self.Container = _c;    
    for i = 0 , _tmpTrans.childCount - 1 do        
        _c:AddNewComponent(UIAreaButtonItem:New(self,_tmpTrans:GetChild(i)));
    end
    _c:SetTemplate();

    self.MyServerBtn.onClick:Clear();
    EventDelegate.Add(self.MyServerBtn.onClick, Utils.Handler(self.OnMyServerBtnClick,self));

    self.RecommendBtn.onClick:Clear();
    EventDelegate.Add(self.RecommendBtn.onClick, Utils.Handler(self.OnRecommendBtnClick,self));   
end

--刷新数据
function UIAreaButtonListPanel:Refresh(groupList,groupID)    
    self.AreaDataList = UIAreaButtonItemData:Convert(groupList);
    self.Container:EnQueueAll();
    local _c = self.Container;
    for _,v in ipairs(self.AreaDataList) do             
         v.IsSelected = (v.GroupID == groupID);
        _c:DeQueue(v);
    end
    _c:RefreshAllUIData();
    self.Grid.repositionNow = true;
    self.MySelectedGO:SetActive(groupID == -1);
    self.RecommendSelectedGO:SetActive(groupID == -2);
end

--点击我的服务器按钮
function UIAreaButtonListPanel:OnMyServerBtnClick()
    self:RefreshAreaButton(nil,-1);
    self.Owner:RefreshServerList(-1);
end

--点击推荐服务器按钮
function UIAreaButtonListPanel:OnRecommendBtnClick()
    self:RefreshAreaButton(nil,-2);
    self.Owner:RefreshServerList(-2);
end

--点击服务器分区按钮
function UIAreaButtonListPanel:OnAreaButtonClick(data)
    self:RefreshAreaButton(data,0);
    self.Owner:RefreshServerList(data.GroupID);
end

--刷新区域按钮
function UIAreaButtonListPanel:RefreshAreaButton(data,groupID)
    for _,v in pairs(self.AreaDataList) do
        v.IsSelected = false;
    end
    if data ~= nil then
        data.IsSelected = true;
    end

    self.Container:RefreshAllUIData();
    self.MySelectedGO:SetActive(groupID == -1);
    self.RecommendSelectedGO:SetActive(groupID == -2);
end

return UIAreaButtonListPanel;