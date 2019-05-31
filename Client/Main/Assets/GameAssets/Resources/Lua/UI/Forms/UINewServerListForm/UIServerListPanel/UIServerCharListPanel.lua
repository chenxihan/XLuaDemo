------------------------------------------------
--作者： gzg
--日期： 2019-04-9
--文件： UIServerCharListPanel.lua
--模块： UIServerCharListPanel
--描述： 当前服务器角色列表的面板
------------------------------------------------
local UICompContainer = require("UI.Components.UICompContainer");
local UIServerCharItem = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerCharItem");

--模块定义
local UIServerCharListPanel = {
    Form = nil,
    ServerID = nil,
    GO = nil,
    Trans = nil,
    Grid = nil,
    ShowTrans = nil,
    HideTrans = nil,
    --背景的Sprite
    BGSprite = nil,
    --容器    
    Container = nil,
    --新角色的数据
    NewCharData={
        IsNew = true,
        --服务器ID,-1,是让服务器创建新角色
        ID = -1,
        Name = "",
        Level = 999,
        Career = 0,
    }
}

--初始化
function UIServerCharListPanel:Initialize(form,trans,showTrans,hideTrans)
    self.Form = form;
    self.GO = trans.gameObject;
    self.Trans = trans;
    self.ShowTrans = showTrans;
    self.HideTrans = hideTrans;
    --Debug.LogError(trans.name);
    local _tmpTrans = trans:Find("Content/CharList");
    self.Grid = _tmpTrans:GetComponent("UIGrid");
    self.BGSprite = trans:Find("BG"):GetComponent("UISprite");

    self.Container = UICompContainer:New();
    local _childCnt = _tmpTrans.childCount;
    for i = 0, _childCnt-1 do
        self.Container:AddNewComponent(UIServerCharItem:New(self,_tmpTrans:GetChild(i)));
    end
    self.Container:SetTemplate();
    return self;
end

--显示
function UIServerCharListPanel:Show(serPairItemName,serverID)
    self.ServerID = serverID;
    self.GO.name = serPairItemName .. "_OP";
    self.Trans.parent = self.ShowTrans;
    self:Refresh();
end

--隐藏
function UIServerCharListPanel:Hide()
    self.Container:EnQueueAll();
    self.Trans.parent = self.HideTrans;
end

--刷新UI
function UIServerCharListPanel:Refresh()
    
    local _sdata = GameCenter.ServerListSystem:FindServer(self.ServerID);
    local _c = self.Container;
    _c:EnQueueAll();
    local _cnt = 0;    
    local _h = self.Grid.cellHeight;
    if(_sdata ~= nil) then
        local _charList = _sdata.CharacterList;        
        if(_charList ~= nil) then
            _cnt = _charList.Count;            
            for i = 0, _cnt-1 do
                _c:DeQueue(_charList[i]);
            end
        end
    end
    Debug.Log("UIServerCharListPanel:Refresh"..tostring(_cnt));
    if _cnt < 4 then
        --追加一个新加的按钮
        _c:DeQueue(self.NewCharData);
        self.BGSprite.height = 74  + math.floor(_cnt / 2) *  _h;
    else
        self.BGSprite.height = 74 + math.floor((_cnt-1) / 2) *  _h;
    end
    _c:RefreshAllUIData();
    self.Grid.repositionNow = true;
end

--判断是否显示
function UIServerCharListPanel:IsShow()
    return self.Trans.parent == self.ShowTrans;
end

function UIServerCharListPanel:OnCharItemClick(charID)
    self.Form:OnCharItemClick(self.ServerID, charID);
end

return UIServerCharListPanel;
