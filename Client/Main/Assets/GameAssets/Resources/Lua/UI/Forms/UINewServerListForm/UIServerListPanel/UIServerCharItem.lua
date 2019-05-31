------------------------------------------------
--作者： gzg
--日期： 2019-04-9
--文件： UIServerCharItem.lua
--模块： UIServerCharItem
--描述： 用于展示角色信息
------------------------------------------------
--引用
local GameObject = CS.UnityEngine.GameObject;

local UIServerCharItem = {
    --所属
    Owner = nil,
    --角色信息 数据,CharacterInfo
    Data = nil,
    --当前对象的GameObject
    GO = nil,
    --当前对象的Transform
    Trans = nil,
    --名字的文本
    NameLabel = nil,
    --新建用户的Icon
    NewIconGO = nil,
    --头像的Icon
    HeadIconGO = nil,
    HeadIcon = nil,
    --等级的文本
    LevelLabel = nil,
    --按钮
    ItemButton = nil,
    --战斗力对象
    PowerGo = nil,
    --战斗力文本
    PowerValueLabel = nil,
}

--创建一个对象
function UIServerCharItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Trans = trans;
    _m.GO = trans.gameObject;
    _m.Owner = owner;
    _m:FindAllComponents();
    return _m;
end

--填充组件
function UIServerCharItem:FindAllComponents()
    self.NameLabel = self.Trans:Find("NameLabel"):GetComponent("UILabel");
    self.NewIconGO = self.Trans:Find("HeadBg/New").gameObject;
    self.HeadIconGO = self.Trans:Find("HeadBg/Head").gameObject; 
    self.HeadIcon = self.HeadIconGO:GetComponent("UISprite");
    self.LevelLabel = self.Trans:Find("HeadBg/Head/Level"):GetComponent("UILabel");
    self.ItemButton = self.Trans:GetComponent("UIButton");
    self.PowerGo = UIUtils.FindGo(self.Trans,"Power");
    self.PowerValueLabel = UIUtils.FindLabel(self.Trans,"Power/ValueLabel");

    self.ItemButton.onClick:Clear();
    EventDelegate.Add(self.ItemButton.onClick, Utils.Handler(self.OnItemButtonClick,self));
end

--按钮点击的处理
function UIServerCharItem:OnItemButtonClick()
    --创建角色,或者选择角色,进入服务器.
    self.Owner:OnCharItemClick(self.Data.ID);
end

--克隆一个对象
function UIServerCharItem:Clone()
    local _go = GameObject.Instantiate(self.GO);
    local _trans = _go.transform;
    _trans.parent = self.Trans.parent;
    UnityUtils.ResetTransform(_trans);
    return UIServerCharItem:New(self.Owner, _trans);
end

--设置Active
function UIServerCharItem:SetActive(active)
    self.GO:SetActive(active);
end
--设置数据或者配置文件
function UIServerCharItem:SetData(dat)
    self.Data = dat;
end
--刷新数据
function UIServerCharItem:RefreshData()
    if(self.Data ~= nil) then
        
        self.HeadIconGO:SetActive(not self.Data.IsNew);
        self.PowerGo:SetActive(not self.Data.IsNew);
        self.NewIconGO:SetActive(not not self.Data.IsNew);
        

        self.NameLabel.text = self.Data.Name;
        self.LevelLabel.text = tostring(self.Data.Level);
        self.HeadIcon.spriteName = "head_" .. self.Data.Career;
        self.PowerValueLabel.text = tostring(self.Data.PowerValue);
        if self.Data.ID >= 0 then
            self:SetName(string.format("item_%02d",self.Data.ID));
        else
            self:SetName("item_NEW");
        end
    else
        Debug.LogError("UIServerPairItem:当前数据为null");
    end
end
--设置名字
function UIServerCharItem:SetName(name)
    self.GO.name = name; 
end

return UIServerCharItem;