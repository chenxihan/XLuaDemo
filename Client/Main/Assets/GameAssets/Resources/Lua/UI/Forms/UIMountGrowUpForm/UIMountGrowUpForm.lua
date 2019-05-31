------------------------------------------------
--作者： xc
--日期： 2019-05-06
--文件： UIMountGrowUpForm.lua
--模块： UIMountGrowUpForm
--描述： 造化坐骑面板
------------------------------------------------
--引用
local CommonPanelRedPoint = require "Logic.Nature.Common.CommonPanelRedPoint"
local NatureSkillSet = require "Logic.Nature.NatureSkillSet"
local UIPlayerSkinCompoent = CS.Funcell.GameUI.Form.UIPlayerSkinCompoent
local BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools
local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UIItem = require "UI.Components.UIItem"

local UIMountGrowUpForm = {
    RedPoint = nil, --面板红点组件
    UIListMenu = nil, --分页组件
    Form = -1, --分页类型

    TrainGo = nil, --第一个分页
    DrugGo = nil, --第二个分页
    OneKeyButton = nil, --分页1中，一键升级按钮
    UpLevelButton = nil, --分页1中，升级按钮
    FishionButton= nil, --化形按钮
    ModelShowButton = nil, --模型外显按钮
    SkillTrans = nil, --技能节点
    SkillsInfo = nil, --技能组件信息
    PlayerSkin = nil, --玩家模型
    ModelName = nil, --模型名字

    AttrGrid = nil, --属性显示节点
    AttrClone = nil, --属性克隆体

    ItemGrid = nil, --道具显示节点
    ItemClone = nil, --道具克隆体
    ItemSelectTrs = nil, --道具选择框
    ItemSelectNameLab = nil, --道具选择后名字显示
    CurSelectItemId = 0, --当前选择道具ID
    FightLab = nil, --战力显示

    Effect = nil, --升级特效
    
    EffectBase = nil, --升级特效

    CurShowModel = 0, --当前显示模型

    LeftModelButton = nil, --向左边翻页的模型按钮
    RightModelButton = nil, --向右边翻页的模型按钮
    ShowModelButton = nil, --切换显示模型的按钮

    IsMaxGo = nil, --满级图片

    ProssSlider = nil, --进度条显示
    ProssLab = nil , --进度条文字

    DrugGrid = nil, --吃果子节点
    DrugClone = nil, --吃果子克隆体
    DrugScrollView = nil, --吃果子滑动列表
    IsInit = true, --是否初始化

    EatEquipButton = nil, --吞噬按钮
    BassAttrGo = nil, --基础属性分页
    IsBaseMaxGo = nil, --基础属性满级
    ProssBaseSlider = nil, --基础属性进度条显示
    ProssBaseLevelLab = nil, --基础属性进度条旁边等级
    ProssBaseLab = nil , --基础属性进度条文字
    BaseAttrGrid = nil, --基础属性列表
    BaseAttrClone = nil, ---基础属性克隆体
    BaseStarGrid = nil, --基础星星
    BaseStarClone = nil, --基础星星克隆体
    StageLab = nil, --阶数文字
    
    ItemDicKeyGo = Dictionary:New() --储存道具和gameobject
}


function UIMountGrowUpForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMountGrowUpForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIMountGrowUpForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MOUNT_INIT,self.UpDateWingInfo)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MOUNT_UPLEVEL, self.UpDateWingUPLEVEL)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_FASHION_CHANGEMODEL,self.UpDateChangeModel)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MOUNT_UPDATEDRUG, self.UpDateChangeDrug)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MOUNT_UPDATEEQUIP,self.UpDateEatEquip)
end
--打开
function UIMountGrowUpForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.Form = -1;
	if obj then
		self.Form = obj;
    end
 
    if self.Form == -1 then
        self.Form = NatureSubEnum.MountEatEquip
    end
	self.UIListMenu:SetSelectById(self.Form)
end
--关闭
function UIMountGrowUpForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UIMountGrowUpForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
    self:InitRedPoint()
end

function UIMountGrowUpForm:OnShowBefore()
    if  GameCenter.NatureSystem.NatureMountData.Cfg == nil or GameCenter.NatureSystem.NatureMountData.BaseCfg == nil then 
        return
    end
    self.RedPoint:Initialize()
    self.CurShowModel = GameCenter.NatureSystem.NatureMountData.super:GetCurShowModel()
    self:SetModel() --刷新模型
    self:SetItem()
    self:RefreshLevelInfo()
    self:RefreshBaseLevelInfo()
    self:SetDrugInfo()
    self.IsInit = false
end

--刷新界面数据
function UIMountGrowUpForm:RefreshLevelInfo()
    self.SkillsInfo:RefreshSkill(GameCenter.NatureSystem.NatureMountData.super.SkillList) --刷新技能显示
    self:SetAttr() --刷新属性显示
    self:SetModelButton()
    self:SetMaxLevel()
    self:SetSlider()
    self:SetFight()
end

--刷新坐骑基础属性
function UIMountGrowUpForm:RefreshBaseLevelInfo()
    self:SetBaseAttr()
    self:SetBaseSlider()
    self:SetMaxBaseLevel()
end

--查找组件
function UIMountGrowUpForm:FindAllComponents()
    self.UIListMenu =  UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Right/UIListMenu"))
    self.UIListMenu:AddIcon(NatureSubEnum.Drug,DataConfig.DataMessageString.Get("NATUREMOUNTTYPETWO"),FunctionStartIdCode.MountDrug)
    self.UIListMenu:AddIcon(NatureSubEnum.BaseUpLevel,DataConfig.DataMessageString.Get("NATURECULTIVATE"),FunctionStartIdCode.MountLevel)
    self.UIListMenu:AddIcon(NatureSubEnum.MountEatEquip,DataConfig.DataMessageString.Get("NATUREMOUNTTYPEONE"),FunctionStartIdCode.MountBaseAttr)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self.TrainGo = UIUtils.FindGo(self.Trans,"Right/Train")
    self.DrugGo = UIUtils.FindGo(self.Trans,"Right/Drug")
    self.OneKeyButton = UIUtils.FindBtn(self.Trans,"Right/Train/Bottom/OneKey")
    self.UpLevelButton = UIUtils.FindBtn(self.Trans,"Right/Train/Bottom/Uplevel")
    self.FishionButton = UIUtils.FindBtn(self.Trans,"Center/HuanBtn")
    self.ModelShowButton = UIUtils.FindBtn(self.Trans,"Center/ModelShowBtn")
    self.AttrGrid = UIUtils.FindGrid(self.Trans,"Right/Train/UpSprite/Panel/Grid")
    self.AttrClone = UIUtils.FindGo(self.Trans,"Right/Train/UpSprite/Panel/Grid/default")
    self.ItemGrid = UIUtils.FindGrid(self.Trans,"Right/Train/DownSprite/Goods")
    self.ItemClone = UIUtils.FindGo(self.Trans,"Right/Train/DownSprite/Goods/default")
    self.ItemSelectTrs = UIUtils.FindTrans(self.Trans,"Right/Train/DownSprite/SelectImg")
    self.ItemSelectNameLab = UIUtils.FindLabel(self.Trans,"Right/Train/DownSprite/SelectLabel")
    self.SkillTrans =  UIUtils.FindTrans(self.Trans,"Skill/ListPanel/Grid")
    self.SkillsInfo = NatureSkillSet:New(self.SkillTrans)
    self.PlayerSkin = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Center/UIRoleSkinCompoent"),"Funcell.GameUI.Form.UIPlayerSkinCompoent");
    if self.PlayerSkin then
        self.PlayerSkin:OnFirstShow(self.this, FSkinTypeCode.Player)
    end
    local _effectNode =  UIUtils.FindTrans(self.Trans,"Center/UIVfxSkin")
    self.Effect = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Right/Train/Effect"),"NatureVfxEffect")
    self.Effect:Init()
    self.Effect.Node2 = _effectNode
    self.EffectBase = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Right/BaseAttr/Effect"),"NatureVfxEffect")
    self.EffectBase:Init()
    self.EffectBase.Node2 = _effectNode
    self.LeftModelButton = UIUtils.FindBtn(self.Trans,"Center/LeftModelButton")
    self.RightModelButton = UIUtils.FindBtn(self.Trans,"Center/RightModelButton")
    self.ShowModelButton = UIUtils.FindBtn(self.Trans,"Center/ShowButton")
    self.IsMaxGo =  UIUtils.FindGo(self.Trans,"Right/Train/ManJi")
    self.ProssSlider = UIUtils.FindCom(self.Trans,"Right/Train/Bless","UISlider")
    self.ProssLab = UIUtils.FindLabel(self.Trans,"Right/Train/Bless/Label")
    self.DrugGrid = UIUtils.FindGrid(self.Trans,"Right/Drug/Panel/Grid")
    self.DrugClone = UIUtils.FindGo(self.Trans,"Right/Drug/Panel/Grid/default")
    self.DrugScrollView = UIUtils.FindCom(self.Trans,"Right/Drug/Panel","UIScrollView")
    self.ModelName = UIUtils.FindLabel(self.Trans,"Center/Name")
    self.FightLab = UIUtils.FindLabel(self.Trans,"Center/Fight")
    self.EatEquipButton = UIUtils.FindBtn(self.Trans,"Right/BaseAttr/Bottom/EatEquip")
    self.BassAttrGo = UIUtils.FindGo(self.Trans,"Right/BaseAttr")
    self.IsBaseMaxGo = UIUtils.FindGo(self.Trans,"Right/BaseAttr/ManJi")
    self.ProssBaseSlider = UIUtils.FindCom(self.Trans,"Right/BaseAttr/Bless","UISlider")
    self.ProssBaseLab = UIUtils.FindLabel(self.Trans,"Right/BaseAttr/Bless/Label")
    self.ProssBaseLevelLab = UIUtils.FindLabel(self.Trans,"Right/BaseAttr/LevelLabel") 
    self.BaseAttrGrid = UIUtils.FindGrid(self.Trans,"Right/BaseAttr/UpSprite/Panel/Grid")
    self.BaseAttrClone = UIUtils.FindGo(self.Trans,"Right/BaseAttr/UpSprite/Panel/Grid/default")
    self.BaseStarGrid = UIUtils.FindGrid(self.Trans,"Center/Grid")
    self.BaseStarClone = UIUtils.FindGo(self.Trans,"Center/Grid/Star")
    self.StageLab = UIUtils.FindLabel(self.Trans,"Center/Stage")
end

--注册UI上面的事件，比如点击事件等
function UIMountGrowUpForm:RegUICallback()
	self.OneKeyButton.onClick:Clear()
	EventDelegate.Add(self.OneKeyButton.onClick, Utils.Handler(self.OnClickOneKey, self))
	self.UpLevelButton.onClick:Clear()
	EventDelegate.Add(self.UpLevelButton.onClick, Utils.Handler(self.OnClickUpLevel, self))
	self.FishionButton.onClick:Clear()
	EventDelegate.Add(self.FishionButton.onClick, Utils.Handler(self.OnClickFishion, self))
	self.ModelShowButton.onClick:Clear()
	EventDelegate.Add(self.ModelShowButton.onClick, Utils.Handler(self.OnClickModelShow, self))
	self.LeftModelButton.onClick:Clear()
	EventDelegate.Add(self.LeftModelButton.onClick, Utils.Handler(self.OnClickLeft, self))
	self.RightModelButton.onClick:Clear()
	EventDelegate.Add(self.RightModelButton.onClick, Utils.Handler(self.OnClickRight, self))
	self.ShowModelButton.onClick:Clear()
	EventDelegate.Add(self.ShowModelButton.onClick, Utils.Handler(self.OnClickShowModel, self))
	self.EatEquipButton.onClick:Clear()
	EventDelegate.Add(self.EatEquipButton.onClick, Utils.Handler(self.OnClickEatEquip, self))
end

function UIMountGrowUpForm:OnHideBefore()
    if self.PlayerSkin then
        self.PlayerSkin:ResetSkin()
    end
    self.UIListMenu:SetSelectByIndex(-1)
    self.IsInit = true
    self.RedPoint:UnInitialize()
end

--分页选择
function UIMountGrowUpForm:OnMenuSelect(id, sender)
    self.Form = id
    if sender then
        if id == NatureSubEnum.BaseUpLevel then
            self.TrainGo:SetActive(true)
        elseif id == NatureSubEnum.Drug then
            self.DrugGo:SetActive(true)
        else
            self.BassAttrGo:SetActive(true)
        end
    else
        if id == NatureSubEnum.BaseUpLevel then
            self.TrainGo:SetActive(false)
        elseif id == NatureSubEnum.Drug then
            self.DrugGo:SetActive(false)
        else
            self.BassAttrGo:SetActive(false)
        end
    end
end

--点击左边
function UIMountGrowUpForm:OnClickLeft()
    local _lastmodel = GameCenter.NatureSystem.NatureMountData.super:GetLastModel(self.CurShowModel)
    if _lastmodel ~= 0 then
        self.CurShowModel = _lastmodel
        self:SetModel()
        self:SetModelButton()
    end
end

--点击右边
function UIMountGrowUpForm:OnClickRight()
    local _lastmodel = GameCenter.NatureSystem.NatureMountData.super:GetNextModel(self.CurShowModel)
    if _lastmodel ~= 0 then
        self.CurShowModel = _lastmodel
        self:SetModel()
        self:SetModelButton()
    end
end

--点击切换模型
function UIMountGrowUpForm:OnClickShowModel()
    GameCenter.NatureSystem:ReqNatureModelSet(NatureEnum.Mount,self.CurShowModel)
end

--吃装备按钮
function UIMountGrowUpForm:OnClickEatEquip()
    GameCenter.PushFixEvent(UIEventDefine.UIMountEatEquipForm_OPEN)
end

--按钮点击事件一键升级
function UIMountGrowUpForm:OnClickOneKey()
    self:SendUpLevel(true)
end

--按钮点击事件升级
function UIMountGrowUpForm:OnClickUpLevel()
    self:SendUpLevel(false)
end

function UIMountGrowUpForm:SendUpLevel(isonekey)
    if self.CurSelectItemId ~= 0 then
        local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.CurSelectItemId)
        if _haveNum > 0 then
            --发送消息
            GameCenter.NatureSystem:ReqNatureUpLevel(NatureEnum.Mount,self.CurSelectItemId,isonekey)
        else       
            local _itemDb = DataConfig.DataItem[self.CurSelectItemId]
            local _messagestr = DataConfig.DataMessageString.Get("Item_Not_Enough")
            _messagestr = UIUtils.CSFormat( _messagestr,_itemDb.Name )
            GameCenter.MsgPromptSystem:ShowMsgBox(_messagestr, function(code)      
                        if (code == MsgBoxResultCode.Button2) then
                            
                        end
                end)
        end
    else
        Debug.LogError("Select ItemId Is 0")
    end
end

--时装按钮
function UIMountGrowUpForm:OnClickFishion()
    GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Mount)
end

--模型外显按钮
function UIMountGrowUpForm:OnClickModelShow()
    GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Mount)
end

--添加红点进入RedPoint组件
function UIMountGrowUpForm:InitRedPoint()
    self.RedPoint = CommonPanelRedPoint:New()
    self.RedPoint:Add(FunctionStartIdCode.MountLevel,self.OneKeyButton.transform,NatureSubEnum.Begin,true)
    self.RedPoint:Add(FunctionStartIdCode.MountLevel,self.UpLevelButton.transform,NatureSubEnum.Begin,true)
    self.RedPoint:Add(FunctionStartIdCode.MountDrug,self.FishionButton.transform,NatureSubEnum.Begin,false)
    self.RedPoint:Add(FunctionStartIdCode.MountEatEquip,self.EatEquipButton.transform,NatureSubEnum.Begin,true)
end

--设置基础等级精度条
function UIMountGrowUpForm:SetBaseSlider()
    self.ProssBaseSlider.value = GameCenter.NatureSystem.NatureMountData.BaseExp / GameCenter.NatureSystem.NatureMountData.BaseCfg.Progress
    self.ProssBaseLab.text = string.format("%d/%d",GameCenter.NatureSystem.NatureMountData.BaseExp,GameCenter.NatureSystem.NatureMountData.BaseCfg.Progress)
    self.ProssBaseLevelLab.text = tostring(GameCenter.NatureSystem.NatureMountData.BaseCfg.Id)
end

--克隆星星
function UIMountGrowUpForm:CloneStar(max,curstar)
    local _listobj = NGUITools.AddChilds(self.BaseStarGrid.gameObject,self.BaseStarClone,max)
    for i=1,max do
        local _spr = _listobj[i-1].transform:GetComponent("UISprite")
        _spr.enabled = curstar >= i
    end
    if self.IsInit then
        self.BaseStarGrid:Reposition()
    end
    self.StageLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("MOUNT_GROWUP_LAYER"),GameCenter.NatureSystem.NatureMountData.Cfg.Steps)
end

--设置基础属性显示
function UIMountGrowUpForm:SetBaseAttr()
    local _attrlist = GameCenter.NatureSystem.NatureMountData.BaseAttrList
    local _listobj = NGUITools.AddChilds(self.BaseAttrGrid.gameObject,self.BaseAttrClone,#_attrlist)
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
        self.BaseAttrGrid:Reposition()
    end
end

--设置基础是否满级
function UIMountGrowUpForm:SetMaxBaseLevel()
    self.IsBaseMaxGo.gameObject:SetActive(GameCenter.NatureSystem.NatureMountData:IsBaseMaxLevel())
end


--设置进度条
function UIMountGrowUpForm:SetSlider()
    self.ProssSlider.value = GameCenter.NatureSystem.NatureMountData.super.CurExp / GameCenter.NatureSystem.NatureMountData.Cfg.Progress
    self.ProssLab.text = string.format("%d/%d",GameCenter.NatureSystem.NatureMountData.super.CurExp,GameCenter.NatureSystem.NatureMountData.Cfg.Progress)
    self:CloneStar(GameCenter.NatureSystem.NatureMountData:GetCurMaxStar(),GameCenter.NatureSystem.NatureMountData.Cfg.Star)
end

--设置是否满级
function UIMountGrowUpForm:SetMaxLevel()
    self.IsMaxGo.gameObject:SetActive(GameCenter.NatureSystem.NatureMountData:IsMaxLevel())
end

--设置模型翅膀
function UIMountGrowUpForm:SetModel()
    if self.CurShowModel ~= 0 then
        self.PlayerSkin:SetEquip(FSkinPartCode.Mount,self.CurShowModel)
        self.PlayerSkin:SetLocalScale(180);
        self.PlayerSkin:SetCameraSize(GameCenter.NatureSystem.NatureMountData:Get3DUICamerSize(self.CurShowModel))
        self.PlayerSkin.EnableDrag = true
        self.ModelName.text = GameCenter.NatureSystem.NatureMountData.super:GetModelsName(self.CurShowModel)
    else
        Debug.LogError("!!!!!!!!!!!Model ID is 0")
    end
end

--设置模型切换按钮状态
function UIMountGrowUpForm:SetModelButton()
    local _isleft = GameCenter.NatureSystem.NatureMountData.super:GetNotLeftButton(self.CurShowModel)
    local _isright = GameCenter.NatureSystem.NatureMountData.super:GetNotRightButton(self.CurShowModel)
    self.LeftModelButton.gameObject:SetActive(_isleft)
    self.RightModelButton.gameObject:SetActive(_isright)
    self.ShowModelButton.gameObject:SetActive(self.CurShowModel ~= GameCenter.NatureSystem.NatureMountData.super.CurModel)
end

--设置属性
function UIMountGrowUpForm:SetAttr()
    local _attrlist = GameCenter.NatureSystem.NatureMountData.super.AttrList
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

--设置吃果子信息
function UIMountGrowUpForm:SetDrugInfo()
    local _druglist = GameCenter.NatureSystem.NatureMountData.super.DrugList
    local _listobj = NGUITools.AddChilds(self.DrugGrid.gameObject,self.DrugClone,#_druglist)
    for i=1,#_druglist do
        local _go = _listobj[i-1]
        local _info = _druglist[i]
        local _name =  UIUtils.FindLabel(_go.transform,"Name")
        local _stage = UIUtils.FindLabel(_go.transform,"Stage")
        local _arrti = UIUtils.FindLabel(_go.transform,"Arrti")
        local _bless = UIUtils.FindCom(_go.transform,"Bless","UISlider")
        local _upSprite = UIUtils.FindGo(_go.transform,"UpSprite")
        local _blessLab = UIUtils.FindLabel(_go.transform,"Bless/Label")

        local _item = UIItem:New(UIUtils.FindTrans(_go.transform,"default"))
        local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_info.ItemId)
        _item:InItWithCfgid(_info.ItemId, 1,true)
        _item:BindBagNum("%d")
        if _haveNum > 0 then
            UIEventListener.Get(_item.gameObject).parameter = _info.ItemId
            UIEventListener.Get(_item.gameObject).onClick = Utils.Handler( self.OnClickDrugBtn,self)
        end
        _upSprite:SetActive(_haveNum > 0)
        _item.IsShowTips = _haveNum == 0
        _name.text = _item.ShowItemData.Name
        _stage.text = UIUtils.CSFormat( DataConfig.DataMessageString.Get("NATURESTAGE"),_info.Level )
        _arrti.text = UIUtils.CSFormat( DataConfig.DataMessageString.Get("NATUREATTRADD"),BattlePropTools.GetBattlePropName(_info.PeiyangAtt[1]),tonumber(_info.PeiyangAtt[2]/100) )
        _bless.value = _info.EatNum / _info.LeveLimit
        _blessLab.text = string.format( "%d/%d",_info.EatNum ,_info.LeveLimit)
        local _prop = UIUtils.FindLabel(_go.transform,"Prop")
        local _prop1 = UIUtils.FindLabel(_go.transform,"Prop1")
        local _propvalue = UIUtils.FindLabel(_go.transform,"Prop/Value")
        local _propvalue1 =UIUtils.FindLabel(_go.transform,"Prop1/Value")
        for j=1,#_info.AttrList do
            if j == 1 then
                _prop.text = BattlePropTools.GetBattlePropName(_info.AttrList[j].AttrID)
                _propvalue.text = tostring(_info.AttrList[j].Attr)
            elseif j == 2 then               
                 _prop1.text = BattlePropTools.GetBattlePropName(_info.AttrList[j].AttrID)
                _propvalue1.text = tostring(_info.AttrList[j].Attr)
            end
        end
    end
    if #_druglist > 0 and self.IsInit then
        self.DrugGrid:Reposition()
        self.DrugScrollView:ResetPosition()
    end
end

--点击吃果子
function UIMountGrowUpForm:OnClickDrugBtn(go)
    local _itemId = UIEventListener.Get(go).parameter
    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_itemId)
    if _haveNum > 0 then
       GameCenter.NatureSystem:ReqNatureDrug(NatureEnum.Mount,_itemId)
    else
        local _itemDb = DataConfig.DataItem[_itemId]
        local _messagestr = DataConfig.DataMessageString.Get("Item_Not_Enough")
        _messagestr = UIUtils.CSFormat(_messagestr,_itemDb.Name)
        GameCenter.MsgPromptSystem:ShowMsgBox(_messagestr, function(code)      
                    if (code == MsgBoxResultCode.Button2) then
                        
                    end
            end)
    end
end

--设置道具显示
function UIMountGrowUpForm:SetItem()
    local _itemlist = GameCenter.NatureSystem.NatureMountData.super.ItemList
    local _listobj = NGUITools.AddChilds(self.ItemGrid.gameObject,self.ItemClone,#_itemlist)
    self.CurSelectItemId = 0
    for i=1,#_itemlist do
        local _go = _listobj[i-1]
        local _info = _itemlist[i]
        local _item = UIItem:New(_go.transform)
        local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_info.ItemID)
        _item:InItWithCfgid(_info.ItemID, 1,true)
        _item:BindBagNum("%d")
        _item.IsShowTips = false
        self.ItemDicKeyGo[_go] = _item
        UIEventListener.Get(_go).parameter = _info
        UIEventListener.Get(_go).onClick = Utils.Handler( self.OnClickItemBtn,self)
        if _haveNum ~= 0 and self.CurSelectItemId == 0 then
            self:OnClickItemBtn(_go)
            _item.IsShowTips = true
        end
    end
    if #_itemlist > 0 and self.CurSelectItemId == 0 then
        local _item = self.ItemDicKeyGo[_listobj[0]]
        _item.IsShowTips = true
        self:OnClickItemBtn(_listobj[0])
    end
    self.ItemGrid:Reposition()
    self.ItemSelectTrs.gameObject:SetActive(#_itemlist > 1)
end

--选择道具
function UIMountGrowUpForm:OnClickItemBtn(go)
    local _iteminfo = UIEventListener.Get(go).parameter
    local _item = self.ItemDicKeyGo[go]
    if self.CurSelectItemId == _iteminfo.ItemID then
        _item.IsShowTips = true
        _item:OnBtnItemClick()
        _item.IsShowTips = false
    else
        if self.ItemSelectTrs.gameObject.activeSelf then
            _item.IsShowTips = false
        else
            _item.IsShowTips = true
        end
        self.ItemSelectTrs.parent = go.transform
        self.ItemSelectTrs.localPosition = Vector3(0,0,0)
        self.ItemSelectTrs.localScale = Vector3.one
        self.CurSelectItemId = _iteminfo.ItemID
        local _messagestr = DataConfig.DataMessageString.Get("NATURE_USEITEM_TIPS")
        _messagestr = UIUtils.CSFormat(_messagestr,_item.ShowItemData.Name,_iteminfo.ItemExp)
        self.ItemSelectNameLab.text = _messagestr
    end
end

--设置战斗力
function UIMountGrowUpForm:SetFight()
    self.FightLab.text = tostring(GameCenter.NatureSystem.NatureMountData.super.Fight)
end

--播放特效
function UIMountGrowUpForm:PlayerVfx(isbasevfx)
    if isbasevfx then
        if self.EffectBase then
            self.EffectBase:Play()
        end
    else
        if self.Effect then
            self.Effect:Play()
        end
    end
end

--网络消息过来刷新面板
function UIMountGrowUpForm:UpDateWingInfo()
    self.CurShowModel = GameCenter.NatureSystem.NatureMountData.super.GetCurShowModel()
    self:SetModel() --刷新模型
    self:SetItem()
    self:RefreshLevelInfo()
    self:SetDrugInfo()
end

--网络消息升级
function UIMountGrowUpForm:UpDateWingUPLEVEL(oldlevel,sender)
    self:RefreshLevelInfo()
    if oldlevel < GameCenter.NatureSystem.NatureMountData.super.Level then
        self:PlayerVfx(false)
    end
end

--网络消息切换模型
function UIMountGrowUpForm:UpDateChangeModel(type)
    if type == NatureEnum.Mount  then
        self:SetModelButton()
    end
end

--网络消息更新果子信息
function UIMountGrowUpForm:UpDateChangeDrug()
    self:SetFight()
    self:SetDrugInfo()
end

--更新特效
function UIMountGrowUpForm:Update(dt)
    if self.Effect then
        self.Effect:Tick(dt)
    end
    if self.EffectBase then
        self.EffectBase:Tick(dt)
    end
end

--更新吃装备信息
function UIMountGrowUpForm:UpDateEatEquip(oldlevel,sender)
    self:RefreshBaseLevelInfo()
    self:SetFight()
    if oldlevel < GameCenter.NatureSystem.NatureMountData.Level then
        self:PlayerVfx(true)
    end
end

return UIMountGrowUpForm