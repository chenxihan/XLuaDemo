------------------------------------------------
--作者： gzg
--日期： 2019-04-3
--文件： UIServerListPanel.lua
--模块： UIServerListPanel
--描述： 服务器列表展示的Panel
------------------------------------------------
--引用
local UICompContainer = require("UI.Components.UICompContainer");
local UIServerPairItem = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerPairItem");
local UIServerItemPairData = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerItemPairData");
--模块定义
local UIServerListPanel = {
    --所有者 Form
    Form = nil,
    --对象的GameObject
    GO = nil,
    --对象的Transform
    Trans = nil,
    --角色列表的Panel
    CharListPanel = nil,
    --服务器Item组件的容器
    ServerContainer = nil,
    --排序的Table
    UITable = nil,

    --服务器对的数据
    ServerPairDataList = nil,
}

--初始化
function UIServerListPanel:Initialize(owner,trans,charListPanel)        
    local _c = UICompContainer:New();
    local _cnt = trans.childCount;
    self.Form = owner;
    self.GO = trans.gameObject;
    self.Trans = trans;
    self.CharListPanel = charListPanel;
    self.ServerContainer = _c;
    self.UITable = trans:GetComponent("UITable");
    for i = 0, _cnt - 1 do
        _c:AddNewComponent(UIServerPairItem:New(self, trans:GetChild(i)));
    end
    _c:SetTemplate();
    return self;
end

--刷新数据
function UIServerListPanel:Refresh(serverList)
    self.CharListPanel:Hide();
    self.ServerContainer:EnQueueAll();
    local _dataList = UIServerItemPairData:ConvertList(serverList);
    self.ServerPairDataList = _dataList;
    --Debug.LogError("ServerList.Count = " .. #_dataList);
    for _,v in ipairs(_dataList) do
        self.ServerContainer:DeQueue(v);
    end
    self.ServerContainer:RefreshAllUIData();    
    self.UITable.repositionNow = true;
end

--当用户点击某个服务器
function UIServerListPanel:OnServerItemClick(itemName,serverData)

    if not serverData.IsSelected then        
        self.CharListPanel:Show(itemName,serverData.ServerID);
        for _,v in ipairs(self.ServerPairDataList) do
            v.Left.IsSelected = false;
            if(not not v.Right) then
                v.Right.IsSelected = false;
            end
        end
        serverData.IsSelected = true;
        self.ServerContainer:RefreshAllUIData();
        self.Form:OnServerItemClick(serverData);
    else
        self.CharListPanel:Hide();
        serverData.IsSelected = false;  
        self.ServerContainer:RefreshAllUIData();  
    end
    self.UITable.repositionWaitFrameCount = 2;
    self.UITable.repositionNow = true;
    
end

--服务器ID被选择
function UIServerListPanel:OnChooseServerID(serID)
    self.Form:OnChooseServerID(serID);
end

return UIServerListPanel;