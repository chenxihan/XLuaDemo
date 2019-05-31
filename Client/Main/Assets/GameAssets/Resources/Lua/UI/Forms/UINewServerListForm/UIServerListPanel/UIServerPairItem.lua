------------------------------------------------
--作者： gzg
--日期： 2019-04-3
--文件： UIServerPairItem.lua
--模块： UIServerPairItem
--描述： 服务器列表的服务器Item的成对
------------------------------------------------

local UIServerItem = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerItem");
local GameObject = CS.UnityEngine.GameObject;

--模块定义
local UIServerPairItem = {
    --填充的服务器数据
    Data = nil,
    --所有者
    Owner = nil,
    --当前对象的GameObject
    GO = nil,
    --当前对象的Transform
    Trans = nil,
    --左边的ServerItem
    LeftItem = nil,
    --右边的ServerItem
    RightItem = nil,
}

--创建新的Item
function UIServerPairItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.GO = trans.gameObject;
    _m.Trans = trans;
    _m:FindAllComponent();
    return _m;
end

--处理组件
function UIServerPairItem:FindAllComponent()
    self.LeftItem = UIServerItem:New(self,self.Trans:Find("Left"));
    self.RightItem = UIServerItem:New(self,self.Trans:Find("Right"));
end

--克隆一个对象
function UIServerPairItem:Clone()
    local _go = GameObject.Instantiate(self.GO);
    local _trans = _go.transform;
    _trans.parent = self.Trans.parent;
    UnityUtils.ResetTransform(_trans);
    return UIServerPairItem:New(self.Owner, _trans);
end

--设置Active
function UIServerPairItem:SetActive(active)
    self.GO:SetActive(active);
end
--设置数据或者配置文件
function UIServerPairItem:SetData(dat)
    self.Data = dat;
end
--刷新数据
function UIServerPairItem:RefreshData()
    if(self.Data ~= nil) then
        self.LeftItem:Refresh(self.Data.Left);
        self.RightItem:Refresh(self.Data.Right);
        self:SetName(string.format("item_%02d" , self.Data.SortID));
    else
        Debug.LogError("UIServerPairItem:当前数据为null");
    end
end
--设置名字
function UIServerPairItem:SetName(name)
    self.GO.name = name;
end

--当前用户点击某个服务器
function UIServerPairItem:OnServerItemClick(serverData)    
    self.Owner:OnServerItemClick(self.GO.name,serverData);
end

--选择某个服务器ID
function UIServerPairItem:OnChooseServerID(serID)
    self.Owner:OnChooseServerID(serID);
end

return UIServerPairItem;