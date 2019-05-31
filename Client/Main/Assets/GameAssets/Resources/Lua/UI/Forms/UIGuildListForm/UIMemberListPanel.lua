------------------------------------------------
--作者： 何健
--日期： 2019-05-14
--文件： UIMemberListPanel.lua
--模块： UIMemberListPanel
--描述： 成员列表排行子界面
------------------------------------------------
local UIMemberRankItem =  require "UI.Forms.UIGuildListForm.UIMemberRankItem"
local UIMemberListItem = require "UI.Forms.UIGuildListForm.UIMemberListItem"

local UIMemberListPanel = {
    Go = nil,
    Trans = nil,
    ScrollView = nil,
    Grid = nil,
    Tabel = nil,
    LineGo1 = nil,
    LineGo2 = nil,
    LineGo3 = nil,
    RankItem1 = nil,
    RankItem2 = nil,
    RankItem3 = nil,
    ListGo = nil
}

--创建一个新的对象
function UIMemberListPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIMemberListPanel:FindAllComponents()
    self.Grid = UIUtils.FindGrid(self.Trans, "ListScroll/Table/Grid")
    self.Table = UIUtils.FindTable(self.Trans, "ListScroll/Table")
    self.ScrollView = UIUtils.FindScrollView(self.Trans, "ListScroll")
    self.LineGo1 = UIUtils.FindGo(self.Trans, "ListScroll/Table/Line1")
    self.LineGo2 = UIUtils.FindGo(self.Trans, "ListScroll/Table/Line2")
    self.LineGo3 = UIUtils.FindGo(self.Trans, "ListScroll/Table/Line3")
    self.ListGo = UIUtils.FindGo(self.Trans, "ListScroll/Table/Grid/UIItem")
    self.RankItem1 = UIMemberRankItem:OnFirstShow(UIUtils.FindTrans(self.Trans, "ListScroll/Table/Rank1"))
    self.RankItem2 = UIMemberRankItem:OnFirstShow(UIUtils.FindTrans(self.Trans, "ListScroll/Table/Rank2"))
    self.RankItem3 = UIMemberRankItem:OnFirstShow(UIUtils.FindTrans(self.Trans, "ListScroll/Table/Rank3"))
 end

  --打开界面
  function UIMemberListPanel:Open()
    self.Go:SetActive(true)
    self:OnRefreshForm(GameCenter.GuildSystem.GuildMemberList)
 end

 --关闭界面
 function UIMemberListPanel:Close()
    self.Go:SetActive(false)
 end

 function UIMemberListPanel:OnRefreshForm(info)
     self.LineGo1:SetActive(false)
     self.LineGo2:SetActive(false)
     self.LineGo3:SetActive(false)
     self.RankItem1.Go:SetActive(false)
     self.RankItem2.Go:SetActive(false)
     self.RankItem3.Go:SetActive(false)
     self.Grid.gameObject:SetActive(false)

     if info.Count > 0 then
        self.RankItem1.Go:SetActive(true)
        local _list = List:New()
        _list:Add(info[0])
        self.RankItem1:OnUpdateItem(_list, DataConfig.DataGuildTitle[101])
     end
     if info.Count > 1 then
        self.RankItem2.Go:SetActive(true)
        self.LineGo1:SetActive(true)
        local _list = List:New()
        for i = 1, 3 do
            if info.Count > i then
                _list:Add(info[i])
            end
        end
        self.RankItem2:OnUpdateItem(_list, DataConfig.DataGuildTitle[102])
     end
     if info.Count > 4 then
        self.RankItem3.Go:SetActive(true)
        self.LineGo2:SetActive(true)
        local _list = List:New()
        for i = 4, 9 do
            if info.Count > i then
                _list:Add(info[i])
            end
        end
        self.RankItem3:OnUpdateItem(_list, DataConfig.DataGuildTitle[106])
     end
     if info.Count > 10 then
        self.LineGo3:SetActive(true)
        self.Grid.gameObject:SetActive(true)
        for i = 0, self.Grid.transform.childCount - 1 do
            local _go = nil
            _go = self.Grid.transform:GetChild(i)
            _go.gameObject:SetActive(false)
        end
        for i = 10, info.Count - 1 do
            local _go = nil
            if i >= self.Grid.transform.childCount + 10 then
                local childTrans = GameObject.Instantiate(self.ListGo).transform
                childTrans.parent = self.Grid.transform
                UnityUtils.ResetTransform(childTrans)
                _go = UIMemberListItem:OnFirstShow(childTrans)
            else
                _go = UIMemberListItem:OnFirstShow(self.Grid.transform:GetChild(i - 10))
            end
            if _go ~= nil then
                _go:OnUpdateItem(info[i], false)
                _go.Go:SetActive(true)
            end
        end
        self.Grid.repositionNow = true
     end
     self.Table.repositionNow = true
     self.ScrollView:ResetPosition()
 end
return UIMemberListPanel