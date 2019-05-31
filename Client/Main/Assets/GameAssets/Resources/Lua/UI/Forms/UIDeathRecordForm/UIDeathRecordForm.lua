------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UIDeathRecordForm.lua
--模块： UIDeathRecordForm
--描述： 死亡记录面板
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UIDeathRecordForm = {
   CloseBtn = nil,
   BackGroundTex = nil,
   ListPanel = nil,
   Item = nil,
   AnimModule = nil,
}

function  UIDeathRecordForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIDeathRecordForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIDeathRecordForm_CLOSE,self.OnClose)
end

function UIDeathRecordForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UIDeathRecordForm:OnHideAfter()
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
end

function UIDeathRecordForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModule = UIAnimationModule(_trans)
    self.AnimModule:AddAlphaAnimation()
    self.CloseBtn = UIUtils.FindBtn(_trans, "Center/CloseBtn")
    self.BackGroundTex = UIUtils.FindTex(_trans, "Center/BG")
    self.Item = UIUtils.FindTrans(_trans, "Center/listPanel/Grid/Item")
    self.ListPanel = UIUtils.FindTrans(_trans, "Center/listPanel/Grid")
end

function UIDeathRecordForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)
end

function UIDeathRecordForm:RefreshDeathRecord()
    local _list = {}
    local _index = 0
    for i = 1, #_list do
        if _index <= self.ListPanel.childCount then
            self:SetData(self.ListPanel:GetChild(_index),_list[i])
        else
            self:SetData(self:Clone(self.Item,self.ListPanel),_list[i])
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
    UnityUtils.ScrollResetPosition(UIUtils.FindTrans(self.CSForm.transform, "Center/listPanel"))
end

function UIDeathRecordForm:SetData(trans, info)
    UIUtils.FindLabel(trans, "Name").text = info.Name
    UIUtils.FindLabel(trans, "Lv").text = info.Lv
    UIUtils.FindLabel(trans, "Record").text = info.Record

    local _heacTrans = UIUtils.FindTrans(trans, "HeadBack/UIPlayerHead")
    local _icon = UnityUtils.RequireComponent(_heacTrans, "Funcell.GameUI.Form.UIPlayerHead")
    _icon:SetInfo(true, info.PlayerId, Utils.GetEnumNumber(tostring(info.Career)), info.Lv)
    if info.IsEnemy then
        UIUtils.FindTrans(trans, "DeleteEnemy").gameObject:SetActive(true)
        UIUtils.FindTrans(trans, "AddEnemy").gameObject:SetActive(false)
        UIUtils.AddBtnEvent(UIUtils.FindBtn(trans, "DeleteEnemy"),self.OnDeleteEnemyClick,self,{Id = info.PlayerId})
    else
        UIUtils.FindTrans(trans, "DeleteEnemy").gameObject:SetActive(false)
        UIUtils.FindTrans(trans, "AddEnemy").gameObject:SetActive(true)
        UIUtils.AddBtnEvent(UIUtils.FindBtn(trans, "AddEnemy"),self.OnAddEnemyClick,self,{Id = info.PlayerId})
    end
    trans.gameObject:SetActive(true)
end

function UIDeathRecordForm:OnAddEnemyClick(data)
    if data then
        GameCenter.FriendSystem:AddConfirmation(FriendType.Enemy, data.Id)
    end
end

function UIDeathRecordForm:OnDeleteEnemyClick(data)
    if data then
        GameCenter.FriendSystem:DeleteConfirmation(FriendType.Enemy, data.Id)
    end
end

function UIDeathRecordForm:Clone(obj, parent)
    local _go = GameObject.Instantiate(obj).transform
    if parent then
        _go:SetParent(parent)
    end
    UnityUtils.ResetTransform(_go)
    return _go
end

function UIDeathRecordForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BackGroundTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
end

function UIDeathRecordForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    self:RefreshDeathRecord()
    self.AnimModule:PlayEnableAnimation()
end

function UIDeathRecordForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

return UIDeathRecordForm