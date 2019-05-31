------------------------------------------------
--作者： 何健
--日期： 2019-05-13
--文件： UIGuildListPanel.lua
--模块： UIGuildListPanel
--描述： 宗派列表排行子界面
------------------------------------------------

local UIGuildListItem = require "UI.Forms.UIGuildListForm.UIGuildListItem"
local UIGuildRankRewardItem = require "UI.Forms.UIGuildListForm.UIGuildRankRewardItem"

local UIGuildListPanel ={
    Go = nil,
    Trans = nil,
    --宗派列表滑动区 显示前三名
    GuildList = nil,
    GuildList2 = nil,--       // 帮会列表滑动区 显示三名以后的宗派
    Table = nil,
    --帮会列表滑动区
    GuildView = nil,
    --分隔线
    LineGo = nil,
    RankGrid = nil,
    RankGo = nil,
    GuildItemGo = nil
}

--创建一个新的对象
function UIGuildListPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIGuildListPanel:FindAllComponents()
    self.GuildList = UIUtils.FindGrid(self.Trans, "ListScroll/Table/Grid1")
    self.GuildList2 = UIUtils.FindGrid(self.Trans, "ListScroll/Table/Grid2")
    self.Table = UIUtils.FindTable(self.Trans, "ListScroll/Table")
    self.GuildView = UIUtils.FindScrollView(self.Trans, "ListScroll")
    self.LineGo = UIUtils.FindGo(self.Trans, "ListScroll/Table/Sprite")
    self.RankGrid = UIUtils.FindGrid(self.Trans, "Grid")
    self.RankGo = UIUtils.FindGo(self.Trans, "Grid/UIItem")
    self.GuildItemGo = UIUtils.FindGo(self.Trans, "ListScroll/Table/Grid1/UIItem")
 end

 --打开界面
 function UIGuildListPanel:Open()
    self.Go:SetActive(true)
    self:OnRefreshForm()
 end

 --关闭界面
 function UIGuildListPanel:Close()
    self.Go:SetActive(false)
 end

 --更新界面显示
 function UIGuildListPanel:OnRefreshForm()
    self:OnRefruseGuildList()
    self:OnRefruseRankList()
 end

 --更新宗派列表
 function UIGuildListPanel:OnRefruseGuildList()
    local _info = GameCenter.GuildSystem.GuildRecommentList
    for i = 0, self.GuildList.transform.childCount - 1 do
        local _go = self.GuildList.transform:GetChild(i).gameObject
        _go:SetActive(false)
    end
    local _index = 0
    if _info.Count >= 3 then
        _index = 3
    else
        _index = _info.Count
    end
    local _go = nil
    for i = 0, _index - 1 do
        if i >= self.GuildList.transform.childCount then
            local childTrans = GameObject.Instantiate(_go.Go).transform
            childTrans.parent = self.GuildList.transform
            UnityUtils.ResetTransform(childTrans)
            _go = UIGuildListItem:OnFirstShow(childTrans)
        else
            _go = UIGuildListItem:OnFirstShow(self.GuildList.transform:GetChild(i))
        end
        if _go ~= nil then
            _go:OnUpdateItem(_info[i])
            _go.Go:SetActive(true)
        end
    end

    if _info.Count > 3 then
        self.LineGo:SetActive(true)
        self.GuildList2.gameObject:SetActive(true)
        for i = 0, self.GuildList2.transform.childCount - 1 do
            local _trans = self.GuildList2.transform:GetChild(i)
            _trans.gameObject:SetActive(false)
        end
        for i = 3, _info.Count - 1 do
            if i >= self.GuildList2.transform.childCount + 3 then
                local childTrans = GameObject.Instantiate(_go.Go).transform
                childTrans.parent = self.GuildList2.transform
                UnityUtils.ResetTransform(childTrans)
                _go = UIGuildListItem:OnFirstShow(childTrans)
            else
                _go = UIGuildListItem:OnFirstShow(self.GuildList2.transform:GetChild(i - 3))
            end
            if _go ~= nil then
                _go:OnUpdateItem(_info[i])
                _go.Go:SetActive(true)
            end
        end
    else
        self.LineGo:SetActive(false)
        self.GuildList2.gameObject:SetActive(false)
    end

    self.GuildList.repositionNow = true
    self.GuildList2.repositionNow = true
    self.Table.repositionNow = true
 end

 --更新排行奖励
 function UIGuildListPanel:OnRefruseRankList()
    local _dataDic = Dictionary:New()
    local _dic = Dictionary:New()
    local _index = 0
    for _,v in pairs(DataConfig.DataGuildTitle) do
        if v.Group == 1 and _dataDic:ContainsKey(v.Title) == false then
            _dataDic:Add(v.Title, v)
            _dic:Add(v.Rankmix, v.Rankmax)
            _index = v.Rankmix
        end
        if _dataDic:ContainsKey(v.Title) and _dic:ContainsKey(_index) then
            _dic[_index] = v.Rankmax
        end
    end
    for i = 0, self.RankGrid.transform.childCount - 1 do
        local _trans = self.RankGrid.transform:GetChild(i)
        _trans.gameObject:SetActive(false)
    end
    _index = 1
    for _,v in pairs(_dataDic) do
        local _go = nil
        if _index > self.RankGrid.transform.childCount then
            _go = UIGuildRankRewardItem:Clone(self.RankGo, self.RankGrid.transform)
        else
            _go = UIGuildRankRewardItem:OnFirstShow(self.RankGrid.transform:GetChild(_index - 1))
        end
        if _go ~= nil then
            _go:OnUpdateItem(v, v.Rankmix, _dic[v.Rankmix])
            _go.Go:SetActive(true)
        end
        _index = _index + 1
    end
    self.RankGrid.repositionNow = true
 end
return UIGuildListPanel