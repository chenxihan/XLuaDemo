------------------------------------------------
--作者： xc
--日期： 2019-04-25
--文件： UINatureMagicForm.lua
--模块： UINatureMagicForm
--描述： 造化阵法面板
------------------------------------------------
--引用
local CommonPanelRedPoint = require "Logic.Nature.Common.CommonPanelRedPoint"
local NatureSkillSet = require "Logic.Nature.NatureSkillSet"
local UIPlayerSkinCompoent = CS.Funcell.GameUI.Form.UIPlayerSkinCompoent
local BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools
local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIItem = require "UI.Components.UIItem"

local UINatureMagicForm = {
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
    FightLab = nil, --战力

    ItemSelectNameLab = nil, --道具选择后名字显示
    CurSelectItemId = 0, --当前选择道具ID

    Effect = nil, --升级特效

    CurShowModel = 0, --当前显示模型

    LeftModelButton = nil, --向左边翻页的模型按钮
    RightModelButton = nil, --向右边翻页的模型按钮
    ShowModelButton = nil, --切换显示模型的按钮

    IsMaxGo = nil, --满级图片

    ProssSlider = nil, --进度条显示
    ProssLevelLab = nil, --进度条旁边等级
    ProssLab = nil , --进度条文字

    DrugGrid = nil, --吃果子节点
    DrugClone = nil, --吃果子克隆体
    DrugScrollView = nil, --吃果子滑动列表
    IsInit = true, --是否初始化
}


function UINatureMagicForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINatureMagicForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UINatureMagicForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MAGIC_INIT,self.UpDateMagicInfo)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MAGIC_UPLEVEL, self.UpDateMagicUpLevel)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_FASHION_CHANGEMODEL, self.UpDateChangeModel)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_MAGIC_UPDATEDRUG, self.UpDateChangeDrug)
end
--打开
function UINatureMagicForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.Form = -1;
	if obj then
		self.Form = obj;
    end
 
    if self.Form == -1 then
        self.Form = NatureSubEnum.BaseUpLevel
    end
	self.UIListMenu:SetSelectById(self.Form)
end
--关闭
function UINatureMagicForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UINatureMagicForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
    self:InitRedPoint()
end

function UINatureMagicForm:OnShowBefore()
    if  GameCenter.NatureSystem.NatureMagicData.Cfg == nil then 
        return
    end
    self.RedPoint:Initialize()
    self.CurShowModel = GameCenter.NatureSystem.NatureMagicData.super:GetCurShowModel()
    self:SetModel() --刷新模型
    self:SetItem()
    self:RefreshLevelInfo()
    self:SetDrugInfo()
    self.IsInit = false
end

--刷新界面数据
function UINatureMagicForm:RefreshLevelInfo()
    self.SkillsInfo:RefreshSkill(GameCenter.NatureSystem.NatureMagicData.super.SkillList) --刷新技能显示
    self:SetAttr() --刷新属性显示
    self:SetModelButton()
    self:SetMaxLevel()
    self:SetSlider()
    self:SetFight()
end

--查找组件
function UINatureMagicForm:FindAllComponents()
    self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Right/UIListMenu"))
    self.UIListMenu:AddIcon(NatureSubEnum.Drug,DataConfig.DataMessageString.Get("NATUREMAGICTYPETWO"),FunctionStartIdCode.NatureMagicDrug)
    self.UIListMenu:AddIcon(NatureSubEnum.BaseUpLevel,DataConfig.DataMessageString.Get("NATURECULTIVATE"),FunctionStartIdCode.NatureMagicLevel)
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
    self.ItemSelectNameLab = UIUtils.FindLabel(self.Trans,"Right/Train/DownSprite/SelectLabel")
    self.SkillTrans =  UIUtils.FindTrans(self.Trans,"Skill/ListPanel/Grid")
    self.SkillsInfo = NatureSkillSet:New(self.SkillTrans)
    self.PlayerSkin = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Center/UIRoleSkinCompoent"),"Funcell.GameUI.Form.UIPlayerSkinCompoent");
    if self.PlayerSkin then
        self.PlayerSkin:OnFirstShow(self.this, FSkinTypeCode.Custom)
    end
    local _effectNode =  UIUtils.FindTrans(self.Trans,"Center/UIVfxSkin")
    self.Effect = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Right/Train/Effect"),"NatureVfxEffect")
    self.Effect:Init()
    self.Effect.Node2 = _effectNode
    self.LeftModelButton = UIUtils.FindBtn(self.Trans,"Center/LeftModelButton")
    self.RightModelButton = UIUtils.FindBtn(self.Trans,"Center/RightModelButton")
    self.ShowModelButton = UIUtils.FindBtn(self.Trans,"Center/ShowButton")
    self.IsMaxGo =  UIUtils.FindGo(self.Trans,"Right/Train/ManJi")
    self.ProssSlider = UIUtils.FindCom(self.Trans,"Right/Train/Bless","UISlider")
    self.ProssLab =UIUtils.FindLabel(self.Trans,"Right/Train/Bless/Label")
    self.ProssLevelLab = UIUtils.FindLabel(self.Trans,"Right/Train/LevelLabel")
    self.DrugGrid = UIUtils.FindGrid(self.Trans,"Right/Drug/Panel/Grid")
    self.DrugClone = UIUtils.FindGo(self.Trans,"Right/Drug/Panel/Grid/default")
    self.DrugScrollView = UIUtils.FindCom(self.Trans,"Right/Drug/Panel","UIScrollView")
    self.ModelName = UIUtils.FindLabel(self.Trans,"Center/Name")
    self.FightLab = UIUtils.FindLabel(self.Trans,"Center/Fight")
end

--注册UI上面的事件，比如点击事件等
function UINatureMagicForm:RegUICallback()
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
    UIEventListener.Get(self.ItemSelectNameLab.gameObject).onClick = Utils.Handler( self.OnClickCoin,self)
end

function UINatureMagicForm:OnHideBefore()
    if self.PlayerSkin then
        self.PlayerSkin:ResetSkin()
    end
    self.UIListMenu:SetSelectByIndex(-1)
    self.IsInit = true
    self.RedPoint:UnInitialize()
end

--分页选择
function UINatureMagicForm:OnMenuSelect(id, sender)
    self.Form = id
    if sender then
        if id == NatureSubEnum.BaseUpLevel then
            self.TrainGo:SetActive(true)
        else
            self.DrugGo:SetActive(true)
        end
    else
        if id == NatureSubEnum.BaseUpLevel then
            self.TrainGo:SetActive(false)
        else
            self.DrugGo:SetActive(false)
        end
    end
end

--点击左边
function UINatureMagicForm:OnClickLeft()
    local _lastmodel = GameCenter.NatureSystem.NatureMagicData.super:GetLastModel(self.CurShowModel)
    if _lastmodel ~= 0 then
        self.CurShowModel = _lastmodel
        self:SetModel()
        self:SetModelButton()
    end
end

--点击右边
function UINatureMagicForm:OnClickRight()
    local _lastmodel = GameCenter.NatureSystem.NatureMagicData.super:GetNextModel(self.CurShowModel)
    if _lastmodel ~= 0 then
        self.CurShowModel = _lastmodel
        self:SetModel()
        self:SetModelButton()
    end
end

--点击切换模型
function UINatureMagicForm:OnClickShowModel()
    GameCenter.NatureSystem:ReqNatureModelSet(NatureEnum.Magic,self.CurShowModel)
end

--按钮点击事件一键升级
function UINatureMagicForm:OnClickOneKey()
    self:SendUpLevel(true)
end

--按钮点击事件升级
function UINatureMagicForm:OnClickUpLevel()
    self:SendUpLevel(false)
end

function UINatureMagicForm:SendUpLevel(isonekey)
    if self.CurSelectItemId ~= 0 then
        local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.CurSelectItemId)
        if _haveNum > 0 then
            --发送消息
            GameCenter.NatureSystem:ReqNatureUpLevel(NatureEnum.Magic,self.CurSelectItemId,isonekey)
        else       
            local _itemDb = DataConfig.DataItem[self.CurSelectItemId]
            local _messagestr = DataConfig.DataMessageString.Get("Item_Not_Enough")
            _messagestr = UIUtils.CSFormat(_messagestr,_itemDb.Name)
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
function UINatureMagicForm:OnClickFishion()
    GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Magic)
end

--模型外显按钮
function UINatureMagicForm:OnClickModelShow()
    GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Magic)
end


--添加红点进入RedPoint组件
function UINatureMagicForm:InitRedPoint()
    self.RedPoint = CommonPanelRedPoint:New()
    self.RedPoint:Add(FunctionStartIdCode.NatureMagicLevel,self.OneKeyButton.transform,NatureSubEnum.Begin,true)
    self.RedPoint:Add(FunctionStartIdCode.NatureMagicLevel,self.UpLevelButton.transform,NatureSubEnum.Begin,true)
    self.RedPoint:Add(FunctionStartIdCode.NatureMagicFashion,self.FishionButton.transform,NatureSubEnum.Begin,false)
end

--设置进度条
function UINatureMagicForm:SetSlider()
    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.CurSelectItemId)
    self.ProssSlider.value = _haveNum / GameCenter.NatureSystem.NatureMagicData.Cfg.Progress
    self.ProssLab.text = string.format("%d/%d",_haveNum,GameCenter.NatureSystem.NatureMagicData.Cfg.Progress)
    self.ProssLevelLab.text = tostring(GameCenter.NatureSystem.NatureMagicData.super.Level)
end

--设置是否满级
function UINatureMagicForm:SetMaxLevel()
    self.IsMaxGo.gameObject:SetActive(GameCenter.NatureSystem.NatureMagicData:IsMaxLevel())
end

--设置模型翅膀
function UINatureMagicForm:SetModel()
    if self.CurShowModel ~= 0 then
        self.PlayerSkin:SetEquip(FSkinPartCode.Body,self.CurShowModel)
        self.PlayerSkin:SetLocalScale(180);
        self.PlayerSkin:SetCameraSize(GameCenter.NatureSystem.NatureMagicData:Get3DUICamerSize(self.CurShowModel))
        self.PlayerSkin.EnableDrag = true
        self.ModelName.text = GameCenter.NatureSystem.NatureMagicData.super:GetModelsName(self.CurShowModel)
    else
        Debug.LogError("!!!!!!!!!!!Model ID is 0")
    end
end

--设置模型切换按钮状态
function UINatureMagicForm:SetModelButton()
    local _isleft = GameCenter.NatureSystem.NatureMagicData.super:GetNotLeftButton(self.CurShowModel)
    local _isright = GameCenter.NatureSystem.NatureMagicData.super:GetNotRightButton(self.CurShowModel)
    self.LeftModelButton.gameObject:SetActive(_isleft)
    self.RightModelButton.gameObject:SetActive(_isright)
    self.ShowModelButton.gameObject:SetActive(self.CurShowModel ~= GameCenter.NatureSystem.NatureMagicData.super.CurModel)
end

--设置属性
function UINatureMagicForm:SetAttr()
    local _attrlist = GameCenter.NatureSystem.NatureMagicData.super.AttrList
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
function UINatureMagicForm:SetDrugInfo()
    local _druglist = GameCenter.NatureSystem.NatureMagicData.super.DrugList
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
function UINatureMagicForm:OnClickDrugBtn(go)
    local _itemId = UIEventListener.Get(go).parameter
    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_itemId)
    if _haveNum > 0 then
       GameCenter.NatureSystem:ReqNatureDrug(NatureEnum.Magic,_itemId)
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
function UINatureMagicForm:SetItem()
    local _itemlist = GameCenter.NatureSystem.NatureMagicData.super.ItemList
    self.CurSelectItemId = _itemlist[1].ItemID
    local _itemDb = DataConfig.DataItem[self.CurSelectItemId]
    if _itemDb then
        local _messagestr = DataConfig.DataMessageString.Get("NATUREMAGICSELECTTABLE")
        _messagestr = UIUtils.CSFormat(_messagestr,_itemDb.Name)
        self.ItemSelectNameLab.text = _messagestr
    else
        self.ItemSelectNameLab.text = ""
    end
end

--点击货币
function UINatureMagicForm:OnClickCoin(go)
    local _itemDb = ItemBase.CreateItemBase(self.CurSelectItemId)
    GameCenter.ItemTipsMgr:ShowTips(_itemDb, go, ItemTipsLocation.Defult, false)
end

--播放特效
function UINatureMagicForm:PlayerVfx()
    if self.Effect then
        self.Effect:Play()
    end
end

--设置战斗力
function UINatureMagicForm:SetFight()
    self.FightLab.text = tostring(GameCenter.NatureSystem.NatureMagicData.super.Fight)
end

--网络消息过来刷新面板
function UINatureMagicForm:UpDateMagicInfo()
    self.CurShowModel = GameCenter.NatureSystem.NatureMagicData.super.GetCurShowModel()
    self:SetModel() --刷新模型
    self:SetItem()
    self:RefreshLevelInfo()
    self:SetDrugInfo()
end

--网络消息升级
function UINatureMagicForm:UpDateMagicUpLevel(oldlevel,sender)
    self:RefreshLevelInfo()
    if oldlevel < GameCenter.NatureSystem.NatureMagicData.super.Level then
        self:PlayerVfx()
    end
end

--网络消息切换模型
function UINatureMagicForm:UpDateChangeModel(type)
    if type == NatureEnum.Magic then
        self:SetModelButton()
    end
end

--网络消息更新果子信息
function UINatureMagicForm:UpDateChangeDrug()
    self:SetFight()
    self:SetDrugInfo()
end

--更新特效
function UINatureMagicForm:Update(dt)
    if self.Effect then
        self.Effect:Tick(dt)
    end
end

return UINatureMagicForm