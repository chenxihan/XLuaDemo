--作者： xc
--日期： 2019-04-24
--文件： UINatureFashionForm.lua
--模块： UINatureFashionForm
--描述： 造化面板外形
------------------------------------------------
--引用

local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools
local BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools
local UIItem = require "UI.Components.UIItem"

local UINatureFashionForm = {
    Form = NatureEnum.Begin,
    FunctionStartId = 0,
    FashionBase = nil, --化形数据根据FORM不同区分
    CloseBtn = nil,
    Skin = nil, --通用模型数据
    LeftGrid = nil, --左边列表节点
    LeftClone = nil, --左边列表克隆体
    AttrGrid = nil, --属性列表节点
    AttrClone = nil,--属性列表克隆体
    ItemTrs = nil, --道具显示节点
    BlessSlider = nil, --进度条显示
    BlessLab = nil, --进度条显示文字
    FightLab = nil, --战斗力文字
    ActiveButton = nil, --激活按钮
    ActiveRed = nil, --激活红点
    ChangeModelButton = nil, --切换模型按钮
    UpButton = nil, --升星按钮
    UpRed = nil,
    Scrollview = nil, --左边滑动列表
    CurSelectModel = 0, --当前选择模型ID
    IsMaxLevelGo = nil, --满级图标
    IsInit = true, --是否初始化
    DicGo = Dictionary:New(), --model对应相应的gameobject
    EquipTrs = nil, --显示穿戴图标
    BackTexture = nil, --Texture
}

function UINatureFashionForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UINatureFashionForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UINatureFashionForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_FASHION_CHANGEMODEL, self.UpDateChangeModel)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_WING_UPDATEFASHION,self.UpDateFashion)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_FUNCTION_UPDATE, self.UpDateRedEvent)
end

function UINatureFashionForm:OnOpen(obj, sender)
    self.Form = obj
    self.CSForm:Show(sender)
end

function UINatureFashionForm:UpDateInfo()
    if self.Form == NatureEnum.Mount then --坐骑数据
        self.FashionBase = GameCenter.NatureSystem.NatureMountData.super
    elseif self.Form == NatureEnum.Wing then --翅膀数据
        self.FashionBase = GameCenter.NatureSystem.NatureWingsData.super
    elseif self.Form == NatureEnum.Talisman then --法器数据
        self.FashionBase = GameCenter.NatureSystem.NatureTalismanData.super
    elseif self.Form == NatureEnum.Magic then --阵道数据
        self.FashionBase = GameCenter.NatureSystem.NatureMagicData.super
    elseif self.Form == NatureEnum.Weapon then --神兵数据
        self.FashionBase = GameCenter.NatureSystem.NatureWeaponData.super
    end
    self.FunctionStartId = FunctionStartIdCode.__CastFrom(self.Form)
end

function UINatureFashionForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end


function UINatureFashionForm:OnShowAfter()
    self:LoadTextures()
end

function UINatureFashionForm:OnShowBefore()
    self:UpDateInfo()
    self.EquipTrs.gameObject:SetActive(false)
    self:InitLeftList()
    self.IsInit = false
end


function UINatureFashionForm:OnHideBefore()
    self.IsInit = true
    self.CurSelectModel = 0
    self.EquipTrs.parent = self.Trans
    if self.Skin then
        self.Skin:ResetSkin()
    end
end


function UINatureFashionForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"Top/closeButton")
    self.LeftGrid = UIUtils.FindGrid(self.Trans,"Left/Panel/Grid")
    self.LeftClone = UIUtils.FindGo(self.Trans,"Left/Panel/Grid/default")
    self.AttrGrid = UIUtils.FindGrid(self.Trans,"Center/Attr/Grid")
    self.AttrClone = UIUtils.FindGo(self.Trans,"Center/Attr/Grid/default")
    self.ItemTrs =  UIUtils.FindTrans(self.Trans,"Center/Up/Item")
    self.BlessSlider = UIUtils.FindCom(self.Trans,"Center/Up/Bless","UISlider")
    self.BlessLab = UIUtils.FindLabel(self.Trans,"Center/Up/Bless/Label")
    self.FightLab = UIUtils.FindLabel(self.Trans,"Center/Up/Fight")
    self.ActiveButton = UIUtils.FindBtn(self.Trans,"Center/Up/ActiveButton")
    self.ChangeModelButton = UIUtils.FindBtn(self.Trans,"Center/Up/ChangeModelButton")
    self.UpButton = UIUtils.FindBtn(self.Trans,"Center/Up/UpButton")
    self.Scrollview = UIUtils.FindScrollView(self.Trans,"Left/Panel")
    self.IsMaxLevelGo = UIUtils.FindGo(self.Trans,"Center/Up/ManJi")
    self.ActiveRed = UIUtils.FindGo(self.Trans,"Center/Up/ActiveButton/RedPoint")
    self.UpRed = UIUtils.FindGo(self.Trans,"Center/Up/UpButton/RedPoint")
    self.EquipTrs = UIUtils.FindTrans(self.Trans,"Left/Equip")
    self.BackTexture = UIUtils.FindTex(self.Trans,"BgTexture")
    self.Skin = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Center/UIRoleSkinCompoent"),"Funcell.GameUI.Form.UIPlayerSkinCompoent");
    if self.Skin then
        local type = FSkinTypeCode.Player
        if self.Form ~= NatureEnum.Wing and self.Form ~= NatureEnum.Mount then
            type = FSkinTypeCode.Custom
        end
        self.Skin:OnFirstShow(self.this, type)
    end
end

--注册UI上面的事件，比如点击事件等
function UINatureFashionForm:RegUICallback()
	self.CloseBtn.onClick:Clear();
	EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))
	self.ActiveButton.onClick:Clear();
	EventDelegate.Add(self.ActiveButton.onClick, Utils.Handler(self.OnClickActiveBtn, self))
	self.ChangeModelButton.onClick:Clear();
	EventDelegate.Add(self.ChangeModelButton.onClick, Utils.Handler(self.OnClickChangeModelBtn, self))
	self.UpButton.onClick:Clear();
	EventDelegate.Add(self.UpButton.onClick, Utils.Handler(self.OnClickUpBtn, self))
end


--点击界面上关闭按钮
function UINatureFashionForm:OnClickCloseBtn()
	self:OnClose(nil, nil)
end

--激活按钮
function UINatureFashionForm:OnClickActiveBtn()
    GameCenter.NatureSystem:ReqNatureFashionUpLevel(self.Form,self.CurSelectModel)
end

--切换模型按钮
function UINatureFashionForm:OnClickChangeModelBtn()
    GameCenter.NatureSystem:ReqNatureModelSet(self.Form,self.CurSelectModel)
end

--升级按钮
function UINatureFashionForm:OnClickUpBtn()
    GameCenter.NatureSystem:ReqNatureFashionUpLevel(self.Form,self.CurSelectModel)
end


--设置模型翅膀
function UINatureFashionForm:SetModel(model)
    if model ~= 0 then
        if self.Form == NatureEnum.Mount then --坐骑数据
            self.Skin:SetEquip(FSkinPartCode.Mount,model)
            self.Skin:SetCameraSize(GameCenter.NatureSystem.NatureMountData:Get3DUICamerSize(model))
        elseif self.Form == NatureEnum.Wing then --翅膀数据
            self.Skin:SetEquip(FSkinPartCode.Wing,model)
            self.Skin:SetCameraSize(GameCenter.NatureSystem.NatureWingsData:Get3DUICamerSize(model))
        elseif self.Form == NatureEnum.Talisman then --法器数据
            self.Skin:SetEquip(FSkinPartCode.Body,model)
            self.Skin:SetCameraSize(GameCenter.NatureSystem.NatureTalismanData:Get3DUICamerSize(model))
        elseif self.Form == NatureEnum.Magic then --阵道数据
            self.Skin:SetEquip(FSkinPartCode.Body,model)
            self.Skin:SetCameraSize(GameCenter.NatureSystem.NatureMagicData:Get3DUICamerSize(model))
        elseif self.Form == NatureEnum.Weapon then --神兵数据
            self.Skin:SetEquip(FSkinPartCode.Body,model)
        end
        self.Skin.EnableDrag = true
    else
        Debug.LogError("!!!!!!!!!!!Model ID is 0")
    end
end

--设置穿戴图片
function UINatureFashionForm:SetEquipInfo(go)
    self.EquipTrs.parent = go.transform
    self.EquipTrs.localScale = Vector3.one
    self.EquipTrs.localPosition = Vector3(73,20,0)
    self.EquipTrs.gameObject:SetActive(true)
end

--设置左边列表
function UINatureFashionForm:InitLeftList()
    if self.FashionBase.FishionList then
        self.DicGo:Clear()
        local _listobj = NGUITools.AddChilds(self.LeftGrid.gameObject,self.LeftClone,#self.FashionBase.FishionList)
        for i=1,#self.FashionBase.FishionList do
            local _go = _listobj[i-1]
            local _info = self.FashionBase.FishionList[i]
            local _icon = UnityUtils.RequireComponent(_go.transform:Find("Icon"),"Funcell.GameUI.Form.UIIconBase")
            local _name = UIUtils.FindLabel(_go.transform,"Name")
            _name.text = _info.Name
            _icon:UpdateIcon(_info.Icon)
            self:SetLeftInfo(_go,_info)
            self.DicGo:Add(_info.ModelId,_go)
            if _info.ModelId == self.FashionBase.CurModel then
                self:SetEquipInfo(_go)
            end
            UIEventListener.Get(_go).parameter = _info.ModelId
            UIEventListener.Get(_go).onClick = Utils.Handler( self.OnClickLeftBtn,self)
            local _uitoggle = _go.transform:GetComponent("UIToggle")
            if i == 1 then
                _uitoggle:Set(true)
                self:OnClickLeftBtn(_go)
            else
                _uitoggle:Set(false)
            end
        end
        if #self.FashionBase.FishionList > 0 and self.IsInit then
            self.LeftGrid:Reposition()
            self.Scrollview:ResetPosition()
        end
    end
end

--克隆星星
function UINatureFashionForm:CloneStar(grid,clone,num,level)
    local _listobj = NGUITools.AddChilds(grid.gameObject,clone,num)
    for i=1,num do
        local _spr = _listobj[i-1].transform:GetComponent("UISprite")
        _spr.enabled = level >= i
    end
    if self.IsInit then
        grid:Reposition()
    end
end

--设置会变得左侧属性
function UINatureFashionForm:SetLeftInfo(go,info)
    local _hit = UIUtils.FindGo(go.transform,"UpSprite")
    _hit:SetActive(info.IsRed)
    local _stargrid = UIUtils.FindGrid(go.transform,"Grid")
    local _stargo = UIUtils.FindGo(go.transform,"Grid/Star")
    local _active = UIUtils.FindGo(go.transform,"NotActive")
    _active:SetActive(not info.IsActive)
    _stargrid.gameObject:SetActive(info.IsActive)
    if info.IsActive then
        self:CloneStar(_stargrid,_stargo,info.MaxLevel,info.Level)
    end
end

--点击左侧列表
function UINatureFashionForm:OnClickLeftBtn(go)
    local _modelId = UIEventListener.Get(go).parameter
    if self.CurSelectModel ~= _modelId then
        self.CurSelectModel = _modelId
        local _info = self.FashionBase:GetFashionInfo(self.CurSelectModel)
        if _info then
            self:SetAttrList(_info)
            self:SetButton(_info)
            self:SetModelChangeButton(_info.IsActive)
            self:SetItemInfo(_info)
            self:SetSlider(_info)
            self:SetModel(_info.ModelId)
        end
    end
end

--设置属性
function UINatureFashionForm:SetAttrList(info)
    local _attrlist = info.AttrList
    local _listobj = NGUITools.AddChilds(self.AttrGrid.gameObject,self.AttrClone,#_attrlist)
    for i = 1,#_attrlist do
        local _go = _listobj[i-1]
        local _info = _attrlist[i]
        local _up =  UIUtils.FindGo(_go.transform,"Sprite")
        local _value = UIUtils.FindLabel(_go.transform,"ValueLabel")
        local _addvalue =UIUtils.FindLabel(_go.transform,"Sprite/AddValueLabel")
        local _nameLab = UIUtils.FindLabel(_go.transform,"Label")
        if _info.AddAttr == 0 then
            _up:SetActive(false)
        else
            _up:SetActive(true)
        end
        _value.text = tostring(_info.Attr)
        _addvalue.text = tostring(_info.AddAttr)
        _nameLab.text = BattlePropTools.GetBattlePropName(_info.AttrID)
    end
    if self.IsInit then
        self.AttrGrid:Reposition()
    end
end

--设置按钮
function UINatureFashionForm:SetButton(info)
    local _isshow = info.IsRed and info.Level < info.MaxLevel
    NGUITools.SetButtonGrayAndNotOnClick(self.ActiveButton.transform,not _isshow)
    NGUITools.SetButtonGrayAndNotOnClick(self.UpButton.transform,not _isshow)
    self.ActiveButton.gameObject:SetActive(not info.IsActive)
    self.UpButton.gameObject:SetActive(info.IsActive)
    self.ActiveRed:SetActive(info.IsRed)
    self.UpRed:SetActive(info.IsRed)
end

--设置切换模型按钮
function UINatureFashionForm:SetModelChangeButton(isactive)
    self.ChangeModelButton.gameObject:SetActive(isactive and self.FashionBase.CurModel ~= self.CurSelectModel)
    for k, v in pairs(self.DicGo) do
        if k == self.FashionBase.CurModel then
            self:SetEquipInfo(v)
            return
        end
    end
end

--返回化形信息函数
function UINatureFashionForm:UpDateFashion(model)
    if self.CurSelectModel == model then
        local _info = self.FashionBase:GetFashionInfo(model)
        if _info then
            self:SetAttrList(_info)
            self:SetButton(_info)
            self:SetSlider(_info)
            local _go = self.DicGo[model]
            if _go then
               self:SetLeftInfo(_go,_info)
            end
        end
    end
end

--红点提示
function UINatureFashionForm:UpDateRedEvent(functioninfo,sender)
    if functioninfo.ID == self.FunctionStartId then
        local _fashioninfo = self.FashionBase:GetFashionInfo(self.CurSelectModel)
        self:SetButton(_fashioninfo)
        for k, v in pairs(self.DicGo) do
            local _info = self.FashionBase:GetFashionInfo(k)
            self:SetLeftInfo(v,_info)
        end
    end
end

--返回切换模型
function UINatureFashionForm:UpDateChangeModel(type)
     if type == self.Form then
        self:SetModelChangeButton(true)
     end
end

--设置道具显示
function UINatureFashionForm:SetItemInfo(info)
    local _item = UIItem:New(self.ItemTrs)
    _item:InItWithCfgid(info.Item, 1,true)
    _item:BindBagNum("%d")
    _item.IsShowTips = true
end

--设置进度条
function UINatureFashionForm:SetSlider(info)
    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(info.Item)
    self.BlessSlider.value = info.Level >= info.MaxLevel and 1 or _haveNum / info.NeedItemNum
    self.BlessLab.text = info.Level >= info.MaxLevel and "-/-" or string.format("%d/%d",_haveNum,info.NeedItemNum)
    self.FightLab.text = tostring(info.Fight)
    self.IsMaxLevelGo:SetActive(info.Level >= info.MaxLevel)
end

--加载texture
function UINatureFashionForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

return UINatureFashionForm