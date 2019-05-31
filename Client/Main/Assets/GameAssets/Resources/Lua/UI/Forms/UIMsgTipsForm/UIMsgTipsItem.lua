------------------------------------------------
--作者： dhq
--日期： 2019-03-25
--文件： MsgTipsItem.lua
--模块： MsgTipsItem
--描述： 右下角的经验获得提示框和打怪物品获得框的Item类
------------------------------------------------

local ItemBase = CS.Funcell.Code.Logic.ItemBase
local GameUICenter = CS.Funcell.Code.Center.GameUICenter

local UIMsgTipsItem = 
{
    --移动距离
    CN_FLOAT_DISTANCE = 100,
    -- 父类
    Parent = nil,
    --当前对象GameObject
    GO = nil,
    --记录下当前是哪一个
    TransId = nil,
    --当前对象的Transfrom
    Trans = nil,
    BaseWidget = nil,
    --文本显示
    Desc = nil,
    IconDescribe = nil,
    IconTrans = nil,
    Quality = nil,

    LifeTimer = 0,
    IsMoving = false,
    MoveDir = Vector3.zero,
    MoveTargetPos = Vector3.zero,
    ColorMsg = Color.white
}

--创建新的对象
function UIMsgTipsItem:New(parent, trans, transId)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.GO = trans.gameObject
    _m.TransId = transId
    _m.Parent = parent
    _m:FindAllComponents()
    return _m
end

--查找并赋值组件
function UIMsgTipsItem:FindAllComponents()
    local _trans = self.Trans
    self.BaseWidget = _trans:GetComponent("UIWidget")
    --不带Item的控件
    self.Desc = UIUtils.FindLabel(_trans,"Tips")
    --带Item的文字控件
    self.IconDescribe = UIUtils.FindLabel(_trans,"Icon/Tips")
    self.IconTrans = UIUtils.FindTrans(_trans,"Icon")
    self.Quality = UIUtils.FindTrans(_trans,"Icon/Quality")
    self.ColorMsg = self.Desc.color
    --AddAlphaAnimation(nil, 0, 1, 0.3)
end

function UIMsgTipsItem:Update()
    if self.Parent ~= nil then
        if (self.IsMoving) then
            local tmpPos = self.Trans.localPosition
            tmpPos = tmpPos + self.MoveDir * Time.deltaTime * self.CN_FLOAT_DISTANCE
            local newDir = (self.MoveTargetPos - tmpPos).normalized
            if (Vector3:Dot(newDir, self.MoveDir) <= 0) then
                self.Trans.localPosition = self.MoveTargetPos
                self.IsMoving = false
            else
                self.Trans.localPosition = tmpPos
            end
        end
    
        if self.Parent.CSForm.IsVisible == true then
            self.LifeTimer =  self.LifeTimer + Time.deltaTime
            if (self.LifeTimer >= self.Parent.LifeTime) then
                self.Parent:OnClose()
                self.Parent:OnItemDeactive(self)
            end
        end 
    end
end

function UIMsgTipsItem:Show(itemBase, startPos)
    local _name = nil
    local _count = 0
    local _quality = QualityCode.Golden
    if (itemBase ~= nil) then
        _count = itemBase.Count
        local item1 = itemBase
        local equip1 = itemBase
        if (item1 ~= item1) then
            _name = item1.Name
            _quality = item1.ItemInfo.Color
        elseif (equip1 ~= nil) then
            _name = equip1.Name
            _quality = equip1.ItemInfo.Quality
        end
        local _spr = nil
        if self.IconTrans ~= nil then
            _spr = Utils.RequireUISprite(self.IconTrans.gameObject)
        end
        local _item = DataConfig.DataItem.Get(itemBase.CfgID)
        local _equip = DataConfig.DataEquip.Get(itemBase.CfgID)
        if (_item ~= nil or _equip ~= nil) then
            local _icon = nil
            if _item == nil then
                _icon = _equip.Icon
            else
                _icon = _item.Icon
            end
            self.IconTrans.gameObject:SetActive(true)
            local _callBack = function()
                if _spr ~= nil then
                    _spr.atlas = GameUICenter.UIIconAltasManager:GetAltasWithIconId(_icon, nil)
                    _spr.spriteName = _icon
                end
            end
            GameUICenter.UIIconAltasManager:GetAltasWithIconId(_icon, _callBack)
            local qualtyName = ItemBase:GetQualitySpriteName(_quality)
            local qualitySpr = Utils.RequireUISprite(_quality.gameObject)
            --local qualitySpr = UnityUtils.RequireComponent<UISprite>(_quality.gameObject)
            if (qualitySpr ~= nil) then
                qualitySpr.spriteName = qualtyName
            end
        end
    end
    self.Desc.gameObject:SetActive(false)
    -- 4. 设置内容
    local _descMsg = string.Format("%s", _name)
    self.IconDescribe.color = ItemBase:GetQualityColor(_quality)
    self.IconDescribe.text = _descMsg
    -- 5. 设置到起点
    self.Trans.localPosition = startPos
    self.IsMoving = false
    self.LifeTimer = 0
    self.BaseWidget.alpha = 0
    self.CSForm:Show(self.Parent)
    --self.Parent:OnOpen()
    --Open()
end

function UIMsgTipsItem:Show(msg, startPos)
    self.IconTrans.gameObject:SetActive(false)
    self.Desc.gameObject:SetActive(true)
    self.Desc.text = msg
    self.Trans.localPosition = startPos
    self.IsMoving = false
    self.LifeTimer = 0
    self.BaseWidget.alpha = 0
    self.CSForm:Show(self.Parent)
    --self.Parent:OnOpen()
    --Open()
end

function UIMsgTipsItem:MoveTo(pos)
    if (self.Trans.localPosition ~= pos) then
        self.MoveTargetPos = pos
        self.MoveDir = (self.MoveTargetPos - self.Trans.localPosition).normalized
        self.IsMoving = true
    end
end

return UIMsgTipsItem