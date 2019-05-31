------------------------------------------------
--作者： 何健
--日期： 2019-05-21
--文件： UIGuildSubmitPanel.lua
--模块： UIGuildSubmitPanel
--描述： 宗派仓库捐献面板
------------------------------------------------

local UIGuildSubmitPanel = {
    Trans = nil,
    Go = nil,
    --仓库捐献界面默认展示的：当前无可捐献装备
    DefaultGo = nil,
    --装备捐献的滑动窗
    CenterScrollView = nil,
    --装备捐献的网格
    CenterGrid = nil,
    CenterGridGo = nil,
    CenterGridTrans = nil,
    TempItem = nil,
    ShowItemList = List:New(),
    SelectList = List:New()
}

--创建一个新的对象
function UIGuildSubmitPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

--查找UI上各个控件
function UIGuildSubmitPanel:FindAllComponents()
    self.DefaultGo = UIUtils.FindGo(self.Trans, "DefaultLabel")
    self.CenterScrollView = UIUtils.FindScrollView(self.Trans, "ItemContaner/CenterScrollView")
    self.CenterGrid = UIUtils.FindGrid(self.Trans, "ItemContaner/CenterScrollView/CenterGrid")
    self.CenterGridGo = UIUtils.FindGo(self.Trans, "ItemContaner/CenterScrollView/CenterGrid")
    self.CenterGridTrans = UIUtils.FindTrans(self.Trans, "ItemContaner/CenterScrollView/CenterGrid")

    local _btn = UIUtils.FindBtn(self.Trans, "DonateBtn")
    UIUtils.AddBtnEvent(_btn, self.OnDonateBtnClick, self)
    _btn = UIUtils.FindBtn(self.Trans, "CenterCloseBtn")
    UIUtils.AddBtnEvent(_btn, self.Close, self)
end

--克隆一个格子
function UIGuildSubmitPanel:Clone()
    local childTrans = GameObject.Instantiate(self.TempItem).transform
    childTrans.parent = self.CenterGridTrans
    UnityUtils.ResetTransform(childTrans)
    return  UnityUtils.RequireComponent(childTrans, "Funcell.GameUI.Form.UIPlayerBagItem")
end

function UIGuildSubmitPanel:Open()
    self.Go:SetActive(true)
    self:RefreshGrid()
end
function UIGuildSubmitPanel:Close()
    self.SelectList:Clear()
    self:ClearItems()
    self.Go:SetActive(false)
end

--捐献过后的回调，从主界面调过来
function UIGuildSubmitPanel:OnSumbitResult(list)
    for idIndex = 0, list.Count - 1 do
        if self.SelectList:Contains(list[idIndex]) then
            self.SelectList:Remove(list[idIndex])
        end
        for i = 1, #self.ShowItemList do
            if self.ShowItemList[i].ItemInfo ~= nil and self.ShowItemList[i].ItemInfo.DBID == list[idIndex] then
                self.ShowItemList[i]:UpdateItem(nil)
            end
        end
    end
end

--捐献按钮点击
function UIGuildSubmitPanel:OnDonateBtnClick()
    local _req = {}

    if #self.SelectList > 0 then
        _req.itemId = self.SelectList
        _req.type = 1
        GameCenter.Network.Send("MSG_Guild.ReqGuildStoreHouseOperation", _req)
    else
        GameCenter.MsgPromptSystem:ShowPrompt("当前未选中任何装备，请选择后再捐献")
    end
end

--格子点击，做选中处理
function UIGuildSubmitPanel:OnClikSubmitItem(obj)
    local _tmpBpItem = UnityUtils.RequireComponent(obj.transform, "Funcell.GameUI.Form.UIPlayerBagItem")
    if _tmpBpItem ~= nil and _tmpBpItem.ItemInfo ~= nil then
        if self.SelectList:Contains(_tmpBpItem.ItemInfo.DBID) then
            self.SelectList:Remove(_tmpBpItem.ItemInfo.DBID)
            _tmpBpItem:SelectItem(false)
        else
            self.SelectList:Add(_tmpBpItem.ItemInfo.DBID)
            _tmpBpItem:SelectItem(true)
        end
    end
end

--隐藏所有格子
function UIGuildSubmitPanel:ClearItems()
    for i = 1, #self.ShowItemList do
        self.ShowItemList[i].gameObject:SetActive(false)
    end
    self.ShowItemList:Clear()
end

--刷新格子
function UIGuildSubmitPanel:RefreshGrid()
    self:ClearItems()
    local _items = GameCenter.GuildRepertorySystem:GetCanSubmitItems()

    if _items.Count == 0  then
        self.DefaultGo:SetActive(true)
        return;
    else
        self.DefaultGo:SetActive(false)
    end
    -- 计算显示的格子总数，要比显示的物品多一行
    local count = _items.Count / self.CenterGrid.maxPerLine
    if (_items.Count % self.CenterGrid.maxPerLine > 0) then
        count = count + 2
    else
        count = count + 1
    end
    count = count * self.CenterGrid.maxPerLine
    -- //最少显示3排
    if count < self.CenterGrid.maxPerLine * 3 then
        count = self.CenterGrid.maxPerLine * 3
    end
    for i = 0, count - 1 do
        local _go = nil
        if self.CenterGridTrans.childCount <= i then
            _go = self:Clone()
        else
            _go = UnityUtils.RequireComponent(self.CenterGridTrans:GetChild(i), "Funcell.GameUI.Form.UIPlayerBagItem")
        end
        _go.gameObject:SetActive(true)
        local _drag = UnityUtils.RequireComponent(_go.transform, "UIDragScrollView")
        _drag.scrollView = self.CenterScrollView
        self.ShowItemList:Add(_go)
        _go.IsOpened = true
        if i < _items.Count then
            _go:UpdateItem(_items[i])
            _go.SingleClick = Utils.Handler(self.OnClikSubmitItem, self)
        else
            _go:UpdateItem(nil)
        end
    end

    self.CenterGrid:Reposition()
    self.CenterScrollView:ResetPosition()
end

function UIGuildSubmitPanel:SetTempItem(go)
    self.TempItem = go
end
return UIGuildSubmitPanel