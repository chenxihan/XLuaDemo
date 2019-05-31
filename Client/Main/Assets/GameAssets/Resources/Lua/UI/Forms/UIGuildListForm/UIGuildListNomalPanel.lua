------------------------------------------------
--作者： 何健
--日期： 2019-05-13
--文件： UIGuildListNomalPanel.lua
--模块： UIGuildListNomalPanel
--描述： 宗派列表排行子界面（非领地战时）
------------------------------------------------

local UIGuildListItem = require "UI.Forms.UIGuildListForm.UIGuildListItem"

local UIGuildListNomalPanel ={
    Go = nil,
    Trans = nil,
    --宗派列表滑动区 显示前三名
    Table = nil,
    --帮会列表滑动区
    GuildView = nil,
    GuildItemGo = nil
}

--创建一个新的对象
function UIGuildListNomalPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIGuildListNomalPanel:FindAllComponents()
    self.Table = UIUtils.FindTable(self.Trans, "ListScroll/Table")
    self.GuildView = UIUtils.FindScrollView(self.Trans, "ListScroll")
    self.GuildItemGo = UIUtils.FindGo(self.Trans, "ListScroll/Table/UIItem")
 end

 --打开界面
 function UIGuildListNomalPanel:Open()
    self.Go:SetActive(true)
    self:OnRefreshForm()
 end

 --关闭界面
 function UIGuildListNomalPanel:Close()
    self.Go:SetActive(false)
 end

 --更新界面显示
 function UIGuildListNomalPanel:OnRefreshForm()
    local _info = GameCenter.GuildSystem.GuildRecommentList
    for i = 0, self.Table.transform.childCount - 1 do
        local _go = self.Table.transform:GetChild(i).gameObject
        _go:SetActive(false)
    end

    local _go = nil
    for i = 0, _info.Count - 1 do
        if i >= self.Table.transform.childCount then
            local childTrans = GameObject.Instantiate(_go.Go).transform
            childTrans.parent = self.Table.transform
            UnityUtils.ResetTransform(childTrans)
            _go = UIGuildListItem:OnFirstShow(childTrans)
        else
            _go = UIGuildListItem:OnFirstShow(self.Table.transform:GetChild(i))
        end
        if _go ~= nil then
            _go:OnUpdateItem(_info[i])
            _go.Go:SetActive(true)
        end
    end

    self.Table.repositionNow = true
 end
return UIGuildListNomalPanel