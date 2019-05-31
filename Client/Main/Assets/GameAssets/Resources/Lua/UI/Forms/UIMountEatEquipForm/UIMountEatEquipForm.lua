------------------------------------------------
--作者： xc
--日期： 2019-05-06
--文件： UIMountEatEquipForm.lua
--模块： UIMountEatEquipForm
--描述： 坐骑吃装备面板
------------------------------------------------

local Mathf = CS.UnityEngine.Mathf
local NGUITools = CS.NGUITools
local UIEventListener = CS.UIEventListener

local UIMountEatEquipForm = {
    ItemObj = nil,        --格子模板
    ScorllView = nil,     --滑动
    Grid = nil,           --网格
    --品质组件--------------------------------------------
    QualityBtn = nil,
    QualityLabel = nil,
    QualityTrans = nil,
    QualityZhankaiGo = nil,  --按钮展开图示
    QualityShouqiGo = nil,   --按钮收起图示
    --等级组件--------------------------------------------
    LevelBtn = nil,
    LevelLabel = nil,
    LevelTrans = nil,
    LevelZhankaiGo = nil,  --按钮展开图示
    LevelShouqiGo = nil,   --按钮收起图示
    EatBtn = nil,   --吞噬按钮
    ExpLabel = nil,
    CloseBtn = nil,
    BackBtn = nil,
    SelectBtn = nil,
    SelectGo = nil,
    LevelClose = nil,
    QualityClose = nil,

    CurQuality = 0,
    CurLevel = 0,
    CurSelectList = Dictionary:New(),
    BackTexture = nil, --Texture
}

function UIMountEatEquipForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMountEatEquipForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIMountEatEquipForm_CLOSE, self.OnClose)
end

function UIMountEatEquipForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UIMountEatEquipForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UIMountEatEquipForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
    self.CSForm:AddAlphaAnimation()
end

function UIMountEatEquipForm:OnShowAfter()
    self:LoadTextures()
end

function UIMountEatEquipForm:OnShowBefore()
    self:OnInitForm()
end

-- 注册UI上面的事件，比如点击事件等
function UIMountEatEquipForm:RegUICallback()

    self.QualityBtn.onClick:Clear()
    EventDelegate.Add(self.QualityBtn.onClick, Utils.Handler(self.OnBtnQuality, self))

    self.LevelBtn.onClick:Clear()
    EventDelegate.Add(self.LevelBtn.onClick, Utils.Handler(self.OnBtnLevel, self))

    self.EatBtn.onClick:Clear()
    EventDelegate.Add(self.EatBtn.onClick, Utils.Handler(self.OnBtnEat, self))

    self.SelectBtn.onClick:Clear()
    EventDelegate.Add(self.SelectBtn.onClick, Utils.Handler(self.OnSelectBtnClick, self))

    self.CloseBtn.onClick:Clear()
    EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))

    self.BackBtn.onClick:Clear()
    EventDelegate.Add(self.BackBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))

    UIEventListener.Get(self.LevelClose).onClick = Utils.Handler( self.OnClickLevelClose,self)
    UIEventListener.Get(self.QualityClose).onClick = Utils.Handler( self.OnClickQualityClose,self)
end

function UIMountEatEquipForm:FindAllComponents()
    self.BackBtn = UIUtils.FindBtn(self.Trans,"Box")
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"Back/CloseBtn")
    self.ExpLabel = UIUtils.FindLabel(self.Trans,"Center/ExpNum")
    self.EatBtn = UIUtils.FindBtn(self.Trans,"Center/EatBtn")
    self.ItemObj = UIUtils.FindTrans(self.Trans,"Center/Scroll/Grid/UIItem")
    self.Grid = UIUtils.FindGrid(self.Trans,"Center/Scroll/Grid")
    self.ScorllView = UIUtils.FindCom(self.Trans,"Center/Scroll","UIScrollView")
    self.SelectGo = UIUtils.FindTrans(self.Trans,"Center/SelectBtn/Select")
    self.SelectBtn = UIUtils.FindBtn(self.Trans,"Center/SelectBtn")
    self.LevelClose = UIUtils.FindGo(self.Trans,"Center/Panel/LevelClose")
    self.QualityClose = UIUtils.FindGo(self.Trans,"Center/QualityGrop/Container")


    self.QualityBtn = UIUtils.FindBtn(self.Trans,"Center/QualityBtn")
    self.QualityLabel = UIUtils.FindLabel(self.Trans,"Center/QualityBtn/Name")
    self.QualityTrans = UIUtils.FindTrans(self.Trans,"Center/QualityGrop")
    self.QualityZhankaiGo = UIUtils.FindGo(self.Trans,"Center/QualityBtn/zhankai")
    self.QualityShouqiGo = UIUtils.FindGo(self.Trans,"Center/QualityBtn/shouhui")
    local _trans = UIUtils.FindTrans(self.Trans,"Center/QualityGrop/Table")
    for i = 0,_trans.childCount - 1 do
        local _button = _trans:GetChild(i).gameObject
        UIEventListener.Get(_button).onClick = Utils.Handler( self.OnBtnQualitySelect,self)
    end
    self.LevelBtn = UIUtils.FindBtn(self.Trans,"Center/LevelBtn")
    self.LevelLabel =  UIUtils.FindLabel(self.Trans,"Center/LevelBtn/Name")
    self.LevelTrans = UIUtils.FindTrans(self.Trans,"Center/LevelGrop")
    self.LevelZhankaiGo = UIUtils.FindGo(self.Trans,"Center/LevelBtn/zhankai")
    self.LevelShouqiGo = UIUtils.FindGo(self.Trans,"Center/LevelBtn/shouhui")
    self.BackTexture = UIUtils.FindTex(self.Trans,"BgTexture")
    _trans = UIUtils.FindTrans(self.Trans,"Center/LevelGrop/Table")
    for i = 0,_trans.childCount - 1 do
        local _button = _trans:GetChild(i).gameObject
        UIEventListener.Get(_button).onClick = Utils.Handler( self.OnBtnLevelSelect,self)
    end
end

function UIMountEatEquipForm:OnClickCloseBtn()
    self:OnClose(nil)
end

-- 品质按钮点击， 打开或关闭品质选择列表
function UIMountEatEquipForm:OnBtnQuality()
    local _active = self.QualityTrans.gameObject.activeSelf
    self.QualityTrans.gameObject:SetActive(not _active)
    self.QualityZhankaiGo:SetActive(_active)
    self.QualityShouqiGo:SetActive(not _active)
    self.QualityClose:SetActive(not _active)
end

--品质选择
function UIMountEatEquipForm:OnBtnQualitySelect(go)
    self.CurQuality = tonumber(go.name)
    self.QualityLabel.text = UIUtils.FindLabel(go.transform,"Name").text
    self:OnBtnQuality()
    self:OnUpdateItemList()
end

-- 等级按钮点击， 打开或关闭品质选择列表
function UIMountEatEquipForm:OnBtnLevel()
    local _active = self.LevelTrans.gameObject.activeSelf
    self.LevelTrans.gameObject:SetActive(not _active)
    self.LevelZhankaiGo:SetActive(_active)
    self.LevelShouqiGo:SetActive(not _active)
    self.LevelClose:SetActive(not _active)
end

function UIMountEatEquipForm:OnClickQualityClose(go)
    self:OnBtnQuality()
end

function UIMountEatEquipForm:OnClickLevelClose(go)
    self:OnBtnLevel()
end

---等级选择
function UIMountEatEquipForm:OnBtnLevelSelect(go)
    self.CurLevel = tonumber(go.name)
    self.LevelLabel.text = UIUtils.FindLabel(go.transform,"Name").text
    self:OnBtnLevel()
    self:OnUpdateItemList()
end

--列表物品点击 可能是装备也可能是物品
function UIMountEatEquipForm:OnItemClick(obj)
    local _item = UnityUtils.RequireComponent( obj.transform,"Funcell.GameUI.Form.UISelectEquipItem")
    if _item then
        if _item.ItemInfo then
            if self.CurSelectList:ContainsKey(_item.ItemInfo.DBID) then
                _item:SelectItem(false)
                self.CurSelectList:Remove(_item.ItemInfo.DBID)
            else
                _item:SelectItem(true)
                self.CurSelectList:Add(_item.ItemInfo.DBID, _item.ItemInfo)
            end
        end
    end
    self:OnUpdateExp()
end

-- 吞噬按钮点击
function UIMountEatEquipForm:OnBtnEat()
    if self.CurSelectList:Count() > 0 then
        local _onlylist = List:New()
        local _itemList = List:New()
        for k, v in pairs(self.CurSelectList) do
            if v.Type == ItemType.Equip then
                local _item = {
                    itemOnlyId = v.DBID,
                    num = v.Count
                }
                _onlylist:Add(_item)
            else
                local _item = {
                    itemModelId = v.CfgID,
                    num = v.Count
                }
                _itemList:Add(_item)
            end
        end
        GameCenter.NatureSystem:ReqNatureMountBaseLevel(_onlylist,_itemList)
    else 
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("C_UI_EQUIP_EQUIPEATNOEQUIP"))
    end
    self:OnClose(nil)
end

--选中一钻装备选择框点击
function UIMountEatEquipForm:OnSelectBtnClick()
    self.SelectGo.gameObject:SetActive(not self.SelectGo.gameObject.activeSelf)
    self:OnUpdateItemList()
end

function UIMountEatEquipForm:OnInitForm()
    self.CurLevel = 999
    self.CurQuality = 4
    self.SelectGo.gameObject:SetActive(false)
    self:OnUpdateItemList()
    self.QualityLabel.text = DataConfig.DataMessageString.Get("C_UI_EQUIP_EQUIPEATVIOEQUIP")
    self.LevelLabel.text = DataConfig.DataMessageString.Get("C_UI_EQUIP_EQUIPEATALLLEVEL")
    self.QualityTrans.gameObject:SetActive(false)
    self.QualityZhankaiGo:SetActive(true)
    self.QualityShouqiGo:SetActive(false)
    self.LevelTrans.gameObject:SetActive(false)
    self.LevelZhankaiGo:SetActive(true)
    self.LevelShouqiGo:SetActive(false)
    self.QualityClose:SetActive(false)
    self.LevelClose:SetActive(false)
end

--刷新物品列表，同时根据当前选择的筛选条件选中物品
function  UIMountEatEquipForm:OnUpdateItemList()
    self.CurSelectList:Clear()
    local _listequip = GameCenter.EquipmentSystem:GetEquipCanEat()
    local _list = List:New()
    for i=0, _listequip.Count-1 do
        _list:Add(_listequip[i])
    end
    self:OnGetStoneByBag(_list)
    local _panel = self.ScorllView:GetComponent("UIPanel")
    local maxCell = _panel.height // self.Grid.cellHeight
    maxCell = maxCell * self.Grid.maxPerLine
    for  i = 1, maxCell do
        if self.Grid.transform.childCount < i then
            NGUITools.AddChild(self.Grid.gameObject, self.ItemObj.gameObject)
        end
        local _item = UnityUtils.RequireComponent(self.Grid.transform:GetChild(i - 1),"Funcell.GameUI.Form.UISelectEquipItem")
        if #_list >= i then
            _item:UpdateItem(_list[i])
            _item:SelectItem(false)
            _item.SingleClick = Utils.Handler(self.OnItemClick, self)
            if _list[i].Type == ItemType.Equip then
                --local _info = cast(_list[i],typeof(CS.Funcell.Code.Logic.Equipment))
                _item:SelectItem(self:OnChargeEquipCanSelect( _list[i]))
            else
                self.CurSelectList:Add(_list[i].DBID, _list[i])
                _item:SelectItem(true)
            end
        else
            _item:UpdateItem(nil)
            _item:SelectItem(false)
            _item.SingleClick =  Utils.Handler(self.OnItemClick, self)
        end
    end
    self:OnUpdateExp()
    self.Grid:Reposition()
    self.ScorllView:ResetPosition()
end

-- 更新吞噬获得经验值
function  UIMountEatEquipForm:OnUpdateExp()
    local _count = 0
    for k, v in pairs(self.CurSelectList) do
        if v.Type == ItemType.Equip then
            --local _info = cast(v,typeof(CS.Funcell.Code.Logic.Equipment))
            _count = _count + v.ItemInfo.SealExp
        else
            _count =_count + GameCenter.NatureSystem.NatureMountData:GetItemExp(v.CfgID) * v.Count
        end
    end
    self.ExpLabel.text = tostring(_count)
end

function  UIMountEatEquipForm:OnGetStoneByBag(list)
    if list == nil then
        list = List:New()
    end
    local _eatList = GameCenter.NatureSystem.NatureMountData.BaseItemList
    for i=1,#_eatList do     
        local _itemList = GameCenter.ItemContianerSystem:GetItemListByCfgid(ContainerType.ITEM_LOCATION_BAG,_eatList[i].ItemID)
        if _itemList.Count > 0 then
            for j = 0,_itemList.Count - 1 do
                list:Add(_itemList[j])
            end
        end
    end
end

--判断装备是否需要选中
function  UIMountEatEquipForm:OnChargeEquipCanSelect(equip)
    if self.CurQuality ~= 0 and self.CurLevel ~= 0 then
        if self.CurLevel == 999 then
            if (equip.ItemInfo.Quality <= self.CurQuality and self:OnChargeEquipDia(equip)) then
                self.CurSelectList:Add(equip.DBID, equip)
                return true
            end
        else
            if (equip.ItemInfo.Quality <= self.CurQuality and equip.ItemInfo.Grade <= self.CurLevel and self:OnChargeEquipDia(equip))
            then
                self.CurSelectList:Add(equip.DBID, equip)
                return true
            end
        end
    end
    return false
end

--判断是否选中带钻装备
function  UIMountEatEquipForm:OnChargeEquipDia(equip)
    if equip.ItemInfo.DiamondNumber > 1 then
        return false
    elseif equip.ItemInfo.DiamondNumber == 1 then
        if not self.SelectGo.gameObject.activeSelf then
            return false
        end
    end
    return true
end

--加载texture
function UIMountEatEquipForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_secon"))
end

return UIMountEatEquipForm