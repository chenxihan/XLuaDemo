------------------------------------------------
--==============================--
--作者： xihan
--日期： 2019-05-30
--文件： UIArenaShouXiItem.lua
--模块： UIArenaShouXiItem
--描述： 首席竞技场Item
--==============================--

local UIArenaShouXiItem = {
    --当前Item的所有者对象
    Owner = nil,
    --当前Item关联的GameObject
    GO = nil,
    --当前Item关联的Transform
    Trans = nil,
    --当前Item使用数据对象.
    Data = nil,
}

--New函数
function UIArenaShouXiItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.GO = trans.gameObject;
    _m.Trans = trans;
    _m:FindAllComponent();
    return _m;
end

--查找组件
function UIArenaShouXiItem:FindAllComponent()
    local _myTrans = self.Trans;
    self.NameLab = UIUtils.FindLabel(_myTrans, "NameLab");
    self.RankLab = UIUtils.FindLabel(_myTrans, "RankLab");
    self.PowerLab = UIUtils.FindLabel(_myTrans, "PowerLab");
    self.ChallengeBtn = UIUtils.FindBtn(_myTrans, "ChallengeBtn");
    self.UIRoleSkin = UIUtils.RequireUIRoleSkinCompoent(UIUtils.FindTrans(_myTrans, "UIRoleSkinCompoent"));
end

--克隆一个对象
function UIArenaShouXiItem:OnFirstShow(csForm, fskinTypeCode)
    self.UIRoleSkin:OnFirstShow(csForm, fskinTypeCode);
end

--克隆一个对象
function UIArenaShouXiItem:Clone()
    local _go = GameObject.Instantiate(self.GO);
    local _trans = _go.transform;
    _trans.parent = self.Trans.parent;
    UnityUtils.ResetTransform(_trans);
    return UIArenaShouXiItem:New(self.Owner, _trans);
end

--设置Active
function UIArenaShouXiItem:SetActive(active)
    self.GO:SetActive(active);
end

--设置数据或者配置文件
function UIArenaShouXiItem:SetData(data)
    self.Data = data;
end
--创新数据
function UIArenaShouXiItem:RefreshData()
    if(self.Data ~= nil) then
        local _data = self.Data;
        self.PowerLab.text = "战力：".. tostring(_data.fightPower);
        self.NameLab.text = tostring(_data.name);
        self.RankLab.text = string.format( "第%s名",_data.rank);
        UIUtils.AddBtnEvent(self.ChallengeBtn, self.OnClickCallBack, self);
        self.UIRoleSkin:ResetRot()
        self.UIRoleSkin:ResetSkin()
        self.UIRoleSkin:SetCameraSize(1.8)
        --职业
        local _occ = _data.career
        if (_data.fashionBodyId ~= 0) then
            self.UIRoleSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetFashionModelID(_occ, _data.fashionBodyId, _data.fashionLayer));
        else
            self.UIRoleSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetBodyModelID(_occ, _data.clothesEquipId, _data.fashionLayer));
        end
        if (_data.fashionWeaponId ~= 0) then
            self.UIRoleSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetFashionModelID(_occ, _data.fashionWeaponId,_data.weaponStar));
        else
            self.UIRoleSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetWeaponModelID(_occ, _data.weaponsEquipId, _data.weaponStar));
        end
        self.UIRoleSkin:SetEquip(FSkinPartCode.Wing, RoleVEquipTool.GetWingModelID(_occ, _data.wingId));
    else
        Debug.LogError("UIArenaShouXiItem:当前数据为nill");
    end
end

--设置名字
function UIArenaShouXiItem:SetName(name)
    self.GO.name = name;
end

--点击挑战
function UIArenaShouXiItem:OnClickCallBack()
    GameCenter.ArenaShouXiSystem:ReqChallenge(self.Data.roleID);
end

return UIArenaShouXiItem;