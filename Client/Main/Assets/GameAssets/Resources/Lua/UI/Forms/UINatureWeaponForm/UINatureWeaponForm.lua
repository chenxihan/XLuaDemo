------------------------------------------------
--作者： xc
--日期： 2019-04-28
--文件： UINatureWeaponForm.lua
--模块： UINatureWeaponForm
--描述： 造化翅膀面板
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

local UINatureWeaponForm = {
    RedPoint = nil, --面板红点组件
    UIListMenu = nil, --分页组件
    Form = -1, --分页类型

    TrainGo = nil, --第一个分页
    TrainBreakGo = nil, --第二个分页
    OneKeyButton = nil, --分页1中，一键升级按钮
    UpLevelButton = nil, --分页1中，升级按钮
    FishionButton= nil, --化形按钮
    ModelShowButton = nil, --模型外显按钮
    BreakButton = nil, --突破按钮
    SkillTrans = nil, --技能节点
    SkillsInfo = nil, --技能组件信息
    PlayerSkin = nil, --玩家模型
    ModelName = nil, --模型名字
    FightLab = nil, --战力显示

    AttrGrid = nil, --属性显示节点
    AttrClone = nil, --属性克隆体

    Effect = nil, --升级特效

    ItemGrid = nil, --升级所需物体
    ItemClone= nil, --升级所需物体
    
    ItemBreakGrid = nil, --升级所需物体
    ItemBreakClone= nil, --升级所需物体
    ItemOdds = nil, --升级成功率
    ItemBreakOdds = nil, -- 突破成功率

    CurShowModel = 0, --当前显示模型

    LeftModelButton = nil, --向左边翻页的模型按钮
    RightModelButton = nil, --向右边翻页的模型按钮
    ShowModelButton = nil, --切换显示模型的按钮

    IsMaxGo = nil, --满级图片
    IsMaxBreakGo = nil, --突破满级

    ProssLevelLab = nil, --进度条旁边等级

    IsInit = true, --是否初始化
}


function UINatureWeaponForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINatureWeaponForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UINatureWeaponForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_WEAPON_INIT, self.UpDateWeaponInfo)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_WEAPON_UPLEVEL, self.UpDateWeaponUpLevel)
    self:RegisterEvent(LogicEventDefine.NATURE_EVENT_FASHION_CHANGEMODEL, self.UpDateChangeModel)
end
--打开
function UINatureWeaponForm:OnOpen(obj, sender)
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
function UINatureWeaponForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UINatureWeaponForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
    self:InitRedPoint()
end

function UINatureWeaponForm:OnShowBefore()
    if  GameCenter.NatureSystem.NatureWeaponData.Cfg == nil then 
        return
    end
    self.RedPoint:Initialize()
    self.CurShowModel = GameCenter.NatureSystem.NatureWeaponData.super:GetCurShowModel()
    self:SetModel() --刷新模型
    self:SetItem()
    self:RefreshLevelInfo()
    self.IsInit = false
end

--刷新界面数据
function UINatureWeaponForm:RefreshLevelInfo()
    self.SkillsInfo:RefreshSkill(GameCenter.NatureSystem.NatureWeaponData.super.SkillList) --刷新技能显示
    self:SetAttr() --刷新属性显示
    self:SetModelButton()
    self:SetMaxLevel()
    self:SetSlider()
    self:SetFight()
end

--查找组件
function UINatureWeaponForm:FindAllComponents()
    self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Right/UIListMenu"))
    self.UIListMenu:AddIcon(NatureSubEnum.Drug,DataConfig.DataMessageString.Get("NATURWEAPONTYPETWO"),FunctionStartIdCode.NatureWeaponBreak)
    self.UIListMenu:AddIcon(NatureSubEnum.BaseUpLevel,DataConfig.DataMessageString.Get("NATURWEAPONTYPEONE"),FunctionStartIdCode.NatureWeaponLevel)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self.ItemGrid =  UIUtils.FindGrid(self.Trans,"Right/Train/DownSprite/Goods")
    self.ItemClone =  UIUtils.FindGo(self.Trans,"Right/Train/DownSprite/Goods/default")
    self.ItemBreakGrid =  UIUtils.FindGrid(self.Trans,"Right/TrainBreak/DownSprite/Goods")
    self.ItemBreakClone =  UIUtils.FindGo(self.Trans,"Right/TrainBreak/DownSprite/Goods/default")
    self.TrainGo = UIUtils.FindGo(self.Trans,"Right/Train")
    self.TrainBreakGo = UIUtils.FindGo(self.Trans,"Right/TrainBreak")
    self.OneKeyButton = UIUtils.FindBtn(self.Trans,"Right/Train/Bottom/OneKey")
    self.UpLevelButton = UIUtils.FindBtn(self.Trans,"Right/Train/Bottom/Uplevel")
    self.BreakButton = UIUtils.FindBtn(self.Trans,"Right/TrainBreak/BreakButton")
    self.FishionButton = UIUtils.FindBtn(self.Trans,"Center/HuanBtn")
    self.ModelShowButton = UIUtils.FindBtn(self.Trans,"Center/ModelShowBtn")
    self.AttrGrid = UIUtils.FindGrid(self.Trans,"Right/UpSprite/Panel/Grid")
    self.AttrClone = UIUtils.FindGo(self.Trans,"Right/UpSprite/Panel/Grid/default")
    self.SkillTrans =  UIUtils.FindTrans(self.Trans,"Skill/ListPanel/Grid")
    self.SkillsInfo = NatureSkillSet:New(self.SkillTrans)
    self.PlayerSkin = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Center/UIRoleSkinCompoent"),"Funcell.GameUI.Form.UIPlayerSkinCompoent");
    if self.PlayerSkin then
        self.PlayerSkin:OnFirstShow(self.this, FSkinTypeCode.Custom)
    end
    local _effectNode =  UIUtils.FindTrans(self.Trans,"Center/UIVfxSkin")
    self.Effect = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Right/TrainBreak/Effect"),"NatureVfxEffect")
    self.Effect:Init()
    self.Effect.Node2 = _effectNode
    self.LeftModelButton = UIUtils.FindBtn(self.Trans,"Center/LeftModelButton")
    self.RightModelButton = UIUtils.FindBtn(self.Trans,"Center/RightModelButton")
    self.ShowModelButton = UIUtils.FindBtn(self.Trans,"Center/ShowButton")
    self.IsMaxGo =  UIUtils.FindGo(self.Trans,"Right/Train/ManJi")
    self.IsMaxBreakGo =  UIUtils.FindGo(self.Trans,"Right/TrainBreak/ManJi")
    self.ProssLevelLab = UIUtils.FindLabel(self.Trans,"Right/Train/LevelLabel")
    self.ItemOdds = UIUtils.FindLabel(self.Trans,"Right/Train/SuccessOdds")
    self.ItemBreakOdds = UIUtils.FindLabel(self.Trans,"Right/TrainBreak/SuccessOdds")
    self.ModelName = UIUtils.FindLabel(self.Trans,"Center/Name")
    self.FightLab = UIUtils.FindLabel(self.Trans,"Center/Fight")
end

--注册UI上面的事件，比如点击事件等
function UINatureWeaponForm:RegUICallback()
	self.OneKeyButton.onClick:Clear()
	EventDelegate.Add(self.OneKeyButton.onClick, Utils.Handler(self.OnClickOneKey, self))
	self.UpLevelButton.onClick:Clear()
	EventDelegate.Add(self.UpLevelButton.onClick, Utils.Handler(self.OnClickUpLevel, self))
	self.BreakButton.onClick:Clear()
	EventDelegate.Add(self.BreakButton.onClick, Utils.Handler(self.OnClickBreak, self))
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
end

function UINatureWeaponForm:OnHideBefore()
    if self.PlayerSkin then
        self.PlayerSkin:ResetSkin()
    end
    self.UIListMenu:SetSelectByIndex(-1)
    self.IsInit = true
    self.RedPoint:UnInitialize()
end

--分页选择
function UINatureWeaponForm:OnMenuSelect(id, sender)
    self.Form = id
    if sender then
        if id == NatureSubEnum.BaseUpLevel then
            self.TrainGo:SetActive(true)
        else
            self.TrainBreakGo:SetActive(true)
        end
    else
        if id == NatureSubEnum.BaseUpLevel then
            self.TrainGo:SetActive(false)
        else
            self.TrainBreakGo:SetActive(false)
        end
    end
end

--点击左边
function UINatureWeaponForm:OnClickLeft()
    local _lastmodel = GameCenter.NatureSystem.NatureWeaponData.super:GetLastModel(self.CurShowModel)
    if _lastmodel ~= 0 then
        self.CurShowModel = _lastmodel
        self:SetModel()
        self:SetModelButton()
    end
end

--点击右边
function UINatureWeaponForm:OnClickRight()
    local _lastmodel = GameCenter.NatureSystem.NatureWeaponData.super:GetNextModel(self.CurShowModel)
    if _lastmodel ~= 0 then
        self.CurShowModel = _lastmodel
        self:SetModel()
        self:SetModelButton()
    end
end

--点击切换模型
function UINatureWeaponForm:OnClickShowModel()
    GameCenter.NatureSystem:ReqNatureModelSet(NatureEnum.Weapon,self.CurShowModel)
end

--按钮点击事件一键升级
function UINatureWeaponForm:OnClickOneKey()
    self:SendUpLevel(true,false)
end

--按钮点击事件升级
function UINatureWeaponForm:OnClickUpLevel()
    self:SendUpLevel(false,false)
end

--按钮点击事件升级
function UINatureWeaponForm:OnClickBreak()
    if GameCenter.NatureSystem.NatureWeaponData:GetAttrIsBreak() then
        self:SendUpLevel(false,true)
    else
        local _itemlist = GameCenter.NatureSystem.NatureWeaponData.BreakItem
        for i=1,#_itemlist do
            if GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_itemlist[i].ItemID) < _itemlist[i].ItemExp then
                local _itemDb = DataConfig.DataItem[_itemlist[i].ItemID]
                local _messagestr = DataConfig.DataMessageString.Get("NATUREWEAPON_BREAKTIPS")
                GameCenter.MsgPromptSystem:ShowMsgBox(_messagestr, function(code)      
                            if (code == MsgBoxResultCode.Button2) then
                                
                            end
                    end)
                break
            end
        end
    end
end

function UINatureWeaponForm:SendUpLevel(isonekey,isbreak)
    GameCenter.NatureSystem:ReqNatureUpLevel(NatureEnum.Weapon,isbreak and 1 or 0,isonekey)
end

--时装按钮
function UINatureWeaponForm:OnClickFishion()
    GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Weapon)
end

--模型外显按钮
function UINatureWeaponForm:OnClickModelShow()
    GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Weapon)
end

--添加红点进入RedPoint组件
function UINatureWeaponForm:InitRedPoint()
    self.RedPoint = CommonPanelRedPoint:New()
    self.RedPoint:Add(FunctionStartIdCode.NatureWeaponLevel,self.OneKeyButton.transform,NatureSubEnum.Begin,true)
    self.RedPoint:Add(FunctionStartIdCode.NatureWeaponLevel,self.UpLevelButton.transform,NatureSubEnum.Begin,true)
    self.RedPoint:Add(FunctionStartIdCode.NatureWeaponFashion,self.FishionButton.transform,NatureSubEnum.Begin,false)
    self.RedPoint:Add(FunctionStartIdCode.NatureWeaponBreak,self.BreakButton.transform,NatureSubEnum.Begin,false)
end

--设置进度条
function UINatureWeaponForm:SetSlider()
    self.ProssLevelLab.text = tostring(GameCenter.NatureSystem.NatureWeaponData.super.Level)
end

--设置是否满级
function UINatureWeaponForm:SetMaxLevel()
    self.IsMaxGo.gameObject:SetActive(GameCenter.NatureSystem.NatureWeaponData:IsMaxLevel())
    self.IsMaxBreakGo.gameObject:SetActive(GameCenter.NatureSystem.NatureWeaponData:IsMaxLevel())
end

--设置模型翅膀
function UINatureWeaponForm:SetModel()
    if self.CurShowModel ~= 0 then
        self.PlayerSkin:SetEquip(FSkinPartCode.Body,self.CurShowModel)
        self.PlayerSkin:SetLocalScale(180);
        self.PlayerSkin:SetCameraSize(GameCenter.NatureSystem.NatureWeaponData:Get3DUICamerSize(self.CurShowModel))
        self.PlayerSkin.EnableDrag = true
        self.ModelName.text = GameCenter.NatureSystem.NatureWeaponData.super:GetModelsName(self.CurShowModel)
    else
        Debug.LogError("!!!!!!!!!!!Model ID is 0")
    end
end

--设置模型切换按钮状态
function UINatureWeaponForm:SetModelButton()
    local _isleft = GameCenter.NatureSystem.NatureWeaponData.super:GetNotLeftButton(self.CurShowModel)
    local _isright = GameCenter.NatureSystem.NatureWeaponData.super:GetNotRightButton(self.CurShowModel)
    self.LeftModelButton.gameObject:SetActive(_isleft)
    self.RightModelButton.gameObject:SetActive(_isright)
    self.ShowModelButton.gameObject:SetActive(self.CurShowModel ~= GameCenter.NatureSystem.NatureWeaponData.super.CurModel)
end

--设置属性
function UINatureWeaponForm:SetAttr()
    local _attrlist = GameCenter.NatureSystem.NatureWeaponData.super.AttrList
    local _listobj = NGUITools.AddChilds(self.AttrGrid.gameObject,self.AttrClone,#_attrlist)
    for i = 1,#_attrlist do
        local _go = _listobj[i-1]
        local _info = _attrlist[i]
        local _ismax = UIUtils.FindGo(_go.transform,"Max")
        local _slider =UIUtils.FindCom(_go.transform,"Bless","UISlider")
        local _nameLab = UIUtils.FindLabel(_go.transform,"Label")
        local _slidertex = UIUtils.FindLabel(_go.transform,"Bless/Label")
        local _maxvalue = _info.AddAttr - _info.AttrMin
        local _curvalue = _info.Attr - _info.AttrMin
        _slider.value = _curvalue / _maxvalue
        _slidertex.text = string.format( "%d/%d",_info.Attr,_info.AddAttr)
        _ismax:SetActive(_info.Attr>=_info.AddAttr)
        _nameLab.text = BattlePropTools.GetBattlePropName(_info.AttrID)
    end
    if self.IsInit then
        self.AttrGrid:Reposition()
    end
end

--设置道具显示
function UINatureWeaponForm:SetItem()
    local _itemlist = GameCenter.NatureSystem.NatureWeaponData.super.ItemList
    local _listobj = NGUITools.AddChilds(self.ItemGrid.gameObject,self.ItemClone,#_itemlist)
    for i=1,#_itemlist do
        local _go = _listobj[i-1]
        local _info = _itemlist[i]
        local _item =  UIItem:New(_go.transform)
        _item:InItWithCfgid(_info.ItemID,_info.ItemExp,true)
        _item:BindBagNum()
        _item.IsShowTips = true
    end
    self.ItemGrid:Reposition()
    self.ItemOdds.text = string.format( "%d%%",GameCenter.NatureSystem.NatureWeaponData.Cfg.ActiveProbability / 100) 
    self.ItemBreakOdds.text = string.format( "%d%%",GameCenter.NatureSystem.NatureWeaponData.Cfg.LevelUpProbability / 100) 
    local _itemlist1 = GameCenter.NatureSystem.NatureWeaponData.BreakItem
    local _listobj1 = NGUITools.AddChilds(self.ItemBreakGrid.gameObject,self.ItemBreakClone,#_itemlist1)
    for i=1,#_itemlist1 do
        local _go = _listobj1[i-1]
        local _info = _itemlist1[i]
        local _item = UIItem:New(_go.transform)
        _item:InItWithCfgid(_info.ItemID,_info.ItemExp,true)
        _item:BindBagNum()
        _item.IsShowTips = true
    end
    self.ItemBreakGrid:Reposition()
end

--播放特效
function UINatureWeaponForm:PlayerVfx()
    if self.Effect then
        self.Effect:Play()
    end
end

--设置战斗力
function UINatureWeaponForm:SetFight()
    self.FightLab.text = tostring(GameCenter.NatureSystem.NatureWeaponData.super.Fight)
end

--网络消息过来刷新面板
function UINatureWeaponForm:UpDateWeaponInfo()
    self.CurShowModel = GameCenter.NatureSystem.NatureWeaponData.super.GetCurShowModel()
    self:SetModel() --刷新模型
    self:SetItem()
    self:RefreshLevelInfo()
end

--网络消息升级
function UINatureWeaponForm:UpDateWeaponUpLevel(oldlevel,sender)
    self:RefreshLevelInfo()
    if oldlevel < GameCenter.NatureSystem.NatureWeaponData.super.Level then
        self:PlayerVfx()
    end
end

--网络消息切换模型
function UINatureWeaponForm:UpDateChangeModel(type)
    if type == NatureEnum.Weapon  then
        self:SetModelButton()
    end
end

--更新特效
function UINatureWeaponForm:Update(dt)
    if self.Effect then
        self.Effect:Tick(dt)
    end
end

return UINatureWeaponForm