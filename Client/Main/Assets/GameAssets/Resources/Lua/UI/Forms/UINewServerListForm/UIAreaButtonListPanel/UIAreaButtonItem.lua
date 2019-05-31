------------------------------------------------
--作者： gzg
--日期： 2019-04-09
--文件： UIAreaButtonItem.lua
--模块： UIAreaButtonItem
--描述： 窗体按钮的对象
------------------------------------------------
local GameObject = CS.UnityEngine.GameObject;

local UIAreaButtonItem = {
    --所属对象
    Owner = nil,
    --数据
    Data = nil,
    --当前对象的GameObject
    GO = nil,
    --当前对象的Transform
    Trans = nil,
    --当前对象的Button
    ItemButton = nil,
    --按钮的文本
    NameLabel = nil,
    --当前按钮被选择后的标记
    SelectedTagGO = nil,
}

--创建一个新的对象
function UIAreaButtonItem:New(owner,trans)
   local _m = Utils.DeepCopy(self);
   _m.Trans = trans;
   _m.GO = trans.gameObject;
   _m.Owner = owner;
   _m:FindAllComponents();
   return _m;
end

--查找组件
function UIAreaButtonItem:FindAllComponents()
    self.ItemButton = self.Trans:GetComponent("UIButton");
    self.NameLabel = self.Trans:Find("NameLabel"):GetComponent("UILabel");
    self.SelectedTagGO = self.Trans:Find("SelectTag").gameObject;

    self.ItemButton.onClick:Clear();
    EventDelegate.Add(self.ItemButton.onClick, Utils.Handler(self.OnItemButtonClick,self));
end

--克隆一个对象
function UIAreaButtonItem:Clone()
    local _go = GameObject.Instantiate(self.GO);
    local _trans = _go.transform;
    _trans.parent = self.Transform.parent;
    UnityUtils.ResetTransform(_trans);
    return UIAreaButtonItem:New(self.Owner, _trans);

end
--设置Active
function UIAreaButtonItem:SetActive(active)
    self.GO:SetActive(active);
end

--设置数据或者配置文件
function UIAreaButtonItem:SetData(dat)
    self.Data = dat;
end

function UIAreaButtonItem:RefreshData()
    if(self.Data ~= nil) then
        self.NameLabel.text = self.Data.Name;
        self.SelectedTagGO:SetActive(self.Data.IsSelected);
    else
        Debug.LogError("数据是空,UIAreaButtonItem:RefreshData");
    end
end
--设置名字
function UIAreaButtonItem:SetName(name)
    self.GO.name = name;
end

--点击
function UIAreaButtonItem:OnItemButtonClick()
    self.Owner:OnAreaButtonClick(self.Data);
end

return UIAreaButtonItem;