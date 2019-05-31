------------------------------------------------
--作者： _SqL_
--日期： 2019-05-27
--文件： UILookOterPlayerForm.lua
--模块： UILookOterPlayerForm
--描述： 查看玩家信息form
------------------------------------------------
local UIPlayerEquipRoot = require "UI.Forms.UILookOterPlayerForm.Root.UIPlayerEquipRoot"
local UIPlayerPropertyRoot = require "UI.Forms.UILookOterPlayerForm.Root.UIPlayerPropertyRoot"
local UIPlayerPropertyData = require "UI.Forms.UILookOterPlayerForm.Common.UIPlayerPropertyData"

local UILookOterPlayerForm = {
    CloseBtn = nil,                             -- 关闭按钮
    AnimMudle = nil,                            -- 动画组件
    BgTex = nil,                                -- 背景Texture
    EquipRoot = nil,                            -- 准备root
    PropertyRoot = nil,                         -- 属性root
}

function UILookOterPlayerForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILookOterPlayerForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILookOterPlayerForm_CLOSE,self.OnClose)
end

function UILookOterPlayerForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILookOterPlayerForm:OnHideBefore()
    self.EquipRoot:RestSkinModel()
end

function UILookOterPlayerForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimMudle = UIAnimationModule(_trans)
    self.AnimMudle:AddAlphaAnimation()

    self.BgTex = UIUtils.FindTex(_trans, "Center/")
    self.CloseBtn = UIUtils.FindBtn(_trans, "Top/CloseBtn")
    local _et = UIUtils.FindTrans(_trans, "Left/EquipRoot")
    self.EquipRoot = UIPlayerEquipRoot:New(self, _et)
    local _pt = UIUtils.FindTrans(_trans, "Right/PropertyRoot")
    self.PropertyRoot = UIPlayerPropertyRoot:New(self, _pt)
end

function UILookOterPlayerForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
end

function UILookOterPlayerForm:NewPropertyList(list)
    local _array = List:New()
    for i = 0, list.Count - 1 do
        _array:Add(UIPlayerPropertyData:New(list[i]))
    end
    table.sort( _array, function(a, b) 
        return a.Sort < b.Sort
    end)
    return _array
end

function UILookOterPlayerForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BgTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

function UILookOterPlayerForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    if obj then
        self.EquipRoot:RefreshPlayerInfo(obj)
        self.PropertyRoot:RefreshPlayerProperty(self:NewPropertyList(obj.attList))
    end
    self.AnimMudle:PlayEnableAnimation()
end

function UILookOterPlayerForm:OnClose(obj, sender)
    self.CSForm:Hide()
end


return UILookOterPlayerForm