------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UIGuildEnemyForm.lua
--模块： UIGuildEnemyForm
--描述： 工会仇人面板
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UIGuildEnemyForm = {
   CloseBtn = nil,
   BackGroundTex = nil,
   ListPanel = nil,
   Item = nil,
   AnimModule = nil,
}

function  UIGuildEnemyForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIGuildEnemyForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIGuildEnemyForm_CLOSE,self.OnClose)
end

function UIGuildEnemyForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UIGuildEnemyForm:OnHideAfter()
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
end

function UIGuildEnemyForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModule = UIAnimationModule(_trans)
    self.AnimModule:AddAlphaAnimation()
    self.CloseBtn = UIUtils.FindBtn(_trans, "Center/CloseBtn")
    self.BackGroundTex = UIUtils.FindTex(_trans, "Center/BG")
    self.Item = UIUtils.FindTrans(_trans, "Center/listPanel/Grid/Item")
    self.ListPanel = UIUtils.FindTrans(_trans, "Center/listPanel/Grid")
end

function UIGuildEnemyForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)

end

-- 刷新工会仇人列表
function UIGuildEnemyForm:RefreshGuildEnemyList()
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

-- 设置工会仇人数据
function UIGuildEnemyForm:SetData(trans, info)
    UIUtils.FindLabel(trans, "Name").text = info.Name
    UIUtils.FindLabel(trans, "Lv").text = info.Lv
    UIUtils.FindLabel(trans, "KillNum").text = info.KillNum
    UIUtils.FindLabel(trans, "KillCount").text = info.KillCount
    UIUtils.FindLabel(trans, "Server").text = info.Server

    local _heacTrans = UIUtils.FindTrans(trans, "HeadBack/UIPlayerHead")
    local _icon = UnityUtils.RequireComponent(_heacTrans, "Funcell.GameUI.Form.UIPlayerHead")
    _icon:SetInfo(true, info.PlayerId, Utils.GetEnumNumber(tostring(info.Career)), info.Lv)
    if info.IsEnemy then
        UIUtils.FindTrans(trans, "IsEnemy").gameObject:SetActive(true)
        UIUtils.FindTrans(trans, "AddEnemy").gameObject:SetActive(false)
    else
        UIUtils.FindTrans(trans, "IsEnemy").gameObject:SetActive(false)
        UIUtils.FindTrans(trans, "AddEnemy").gameObject:SetActive(true)
        UIUtils.AddBtnEvent(UIUtils.FindBtn(trans, "AddEnemy"),self.OnAddEnemyClick,self,{Id = info.PlayerId})
    end
    trans.gameObject:SetActive(true)
end

function UIGuildEnemyForm:OnAddEnemyClick(data)
    if data then
        GameCenter.FriendSystem:AddConfirmation(FriendType.Enemy, data.Id)
    end
end

function UIGuildEnemyForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BackGroundTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
end

function UIGuildEnemyForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    self:RefreshGuildEnemyList()
    self.AnimModule:PlayEnableAnimation()
end

function UIGuildEnemyForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

function UIGuildEnemyForm:Clone(obj, parent)
    local _go = GameObject.Instantiate(obj).transform
    if parent then
        _go:SetParent(parent)
    end
    UnityUtils.ResetTransform(_go)
    return _go
end

return UIGuildEnemyForm