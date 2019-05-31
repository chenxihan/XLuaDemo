--作者： xc
--日期： 2019-04-24
--文件： UINatureModelShowForm.lua
--模块： UINatureModelShowForm
--描述： 造化面板外形
------------------------------------------------
--引用

local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools
local BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools

local UINatureModelShowForm = {
    Form = NatureEnum.Begin,
    FunctionStartId = 0,
    BaseInfo = nil, --模型数据根据FORM不同区分
    CloseBtn = nil,
    Skin = nil, --通用模型数据
    LeftGrid = nil, --左边列表节点
    LeftClone = nil, --左边列表克隆体
    AttrGrid = nil, --属性列表节点
    AttrClone = nil,--属性列表克隆体
    ChangeModelButton = nil, --切换模型按钮
    Scrollview = nil, --左边滑动列表
    IsInit = true, --是否初始化
    CurSelectModel = 0, --当前模型选择
    BackTexture = nil, --Texture
}

function UINatureModelShowForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UINatureModelShowForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UINatureModelShowForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_FASHION_CHANGEMODEL,self.UpDateChangeModel)
end

function UINatureModelShowForm:OnOpen(obj, sender)
    self.Form = obj
    self.CSForm:Show(sender)
end

function UINatureModelShowForm:UpDateInfo()
    if self.Form == NatureEnum.Mount then --坐骑数据
        self.BaseInfo = GameCenter.NatureSystem.NatureMountData.super
    elseif self.Form == NatureEnum.Wing then --翅膀数据
        self.BaseInfo = GameCenter.NatureSystem.NatureWingsData.super
    elseif self.Form == NatureEnum.Talisman then --法器数据
        self.BaseInfo = GameCenter.NatureSystem.NatureTalismanData.super
    elseif self.Form == NatureEnum.Magic then --阵道数据
        self.BaseInfo = GameCenter.NatureSystem.NatureMagicData.super
    elseif self.Form == NatureEnum.Weapon then --神兵数据
        self.BaseInfo = GameCenter.NatureSystem.NatureWeaponData.super
    end
    self.FunctionStartId = FunctionStartIdCode.__CastFrom(self.Form)
end

function UINatureModelShowForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UINatureModelShowForm:OnShowAfter()
    self:LoadTextures()
end

function UINatureModelShowForm:OnShowBefore()
    self:UpDateInfo()
    self:InitLeftList()
    self:SetAttrList()
    self.IsInit = false
end


function UINatureModelShowForm:OnHideBefore()
    self.IsInit = true
    self.CurSelectModel = 0
    if self.Skin then
        self.Skin:ResetSkin()
    end
end


function UINatureModelShowForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"Top/closeButton")
    self.LeftGrid = UIUtils.FindGrid(self.Trans,"Left/Panel/Grid")
    self.LeftClone = UIUtils.FindGo(self.Trans,"Left/Panel/Grid/default")
    self.AttrGrid = UIUtils.FindGrid(self.Trans,"Center/Attr/Grid")
    self.AttrClone = UIUtils.FindGo(self.Trans,"Center/Attr/Grid/default")
    self.ChangeModelButton = UIUtils.FindBtn(self.Trans,"Center/ChangeModelButton")
    self.Scrollview = UIUtils.FindScrollView(self.Trans,"Left/Panel") 
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
function UINatureModelShowForm:RegUICallback()
	self.CloseBtn.onClick:Clear();
	EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))
	self.ChangeModelButton.onClick:Clear();
	EventDelegate.Add(self.ChangeModelButton.onClick, Utils.Handler(self.OnClickChangeModelBtn, self))
end


--点击界面上关闭按钮
function UINatureModelShowForm:OnClickCloseBtn()
	self:OnClose(nil, nil)
end

--切换模型按钮
function UINatureModelShowForm:OnClickChangeModelBtn()
    GameCenter.NatureSystem:ReqNatureModelSet(self.Form,self.CurSelectModel)
end

--设置模型翅膀
function UINatureModelShowForm:SetModel(model)
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


--设置左边列表
function UINatureModelShowForm:InitLeftList()
    if self.BaseInfo.ModelList then
        local _listobj = NGUITools.AddChilds(self.LeftGrid.gameObject,self.LeftClone,#self.BaseInfo.ModelList)
        for i=1,#self.BaseInfo.ModelList do
            local _go = _listobj[i-1]
            local _info = self.BaseInfo.ModelList[i]
            local _name = UIUtils.FindLabel(_go.transform,"Name")
            local _stage = UIUtils.FindLabel(_go.transform,"Stage")
            _name.text = _info.Name
            _stage.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("MOUNT_GROWUP_LAYER"),_info.Stage)
            UIEventListener.Get(_go).parameter = _info
            UIEventListener.Get(_go).onClick = Utils.Handler( self.OnClickLeftBtn,self)
            local _uitoggle = _go.transform:GetComponent("UIToggle")
            if i == 1 then
                _uitoggle:Set(true)
                self:OnClickLeftBtn(_go)
            else
                _uitoggle:Set(false)
            end
        end
        if #self.BaseInfo > 0 and self.IsInit then
            self.LeftGrid:Reposition()
            self.Scrollview:ResetPosition()
        end
    end
end

--点击左侧列表
function UINatureModelShowForm:OnClickLeftBtn(go)
    local _info = UIEventListener.Get(go).parameter
    if self.CurSelectModel ~= _info.Modelid then
        self.CurSelectModel = _info.Modelid
        self:SetModelChangeButton(_info.IsActive)
        self:SetModel(_info.Modelid)
    end
end

--设置属性
function UINatureModelShowForm:SetAttrList()
    local _attrlist = self.BaseInfo.AttrList
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

--设置切换模型按钮
function UINatureModelShowForm:SetModelChangeButton(isactive)
    self.ChangeModelButton.gameObject:SetActive(isactive and self.BaseInfo.CurModel ~= self.CurSelectModel)
end

--返回切换模型
function UINatureModelShowForm:UpDateChangeModel(type)
     if type == self.Form then
        self:SetModelChangeButton(true)
     end
end

--加载texture
function UINatureModelShowForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

return UINatureModelShowForm