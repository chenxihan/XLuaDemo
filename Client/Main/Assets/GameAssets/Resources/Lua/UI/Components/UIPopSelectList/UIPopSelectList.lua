------------------------------------------------
--作者： 何健
--日期： 2019-05-21
--文件： UIPopSelectList.lua
--模块： UIPopSelectList
--描述： 点击按钮弹出列表选中item后，item的值赋给按钮，即简单的下拉菜单
------------------------------------------------
local PopItem = require "UI.Components.UIPopSelectList.PopItem"
local UIPopSelectList = {
    Trans = nil,
    Go = nil,
    TextLabel = nil,
    MainBtn = nil,
    PopParentGo = nil,
    PopScroll = nil,
    PopGrid = nil,
    PopGridTrans = nil,
    PopTempItemGo = nil,
    -- 列表数据
    DataList = List:New(),
    -- 弹出窗的item列表
    PopItemList = List:New(),
    -- 当前选中的数据索引
    CurSelectIndex = -1,
    -- 选中结果回调
    OnSelectCallBack = nil,
    IsInit = false
}

function UIPopSelectList:OnFirstShow(trans)
    local _M = Utils.DeepCopy(self)
    _M.Trans = trans
    _M.Go = trans.gameObject
    _M:FindAllComponents()
    LuaBehaviourManager:Add(_M.Trans, _M)
    return _M
end

function UIPopSelectList:FindAllComponents()
    if self.IsInit then
        return
    end
    self.TextLabel = UIUtils.FindLabel(self.Trans, "Text")
    self.MainBtn = self.Trans:GetComponent("UIButton")
    self.PopParentGo = UIUtils.FindGo(self.Trans, "PopWidget")
    self.PopScroll = UIUtils.FindScrollView(self.Trans, "PopWidget/ScrollView")
    self.PopGrid = UIUtils.FindGrid(self.Trans, "PopWidget/ScrollView/Grid")
    self.PopGridTrans = UIUtils.FindTrans(self.Trans, "PopWidget/ScrollView/Grid")
    self.PopTempItemGo = UIUtils.FindGo(self.Trans, "PopWidget/ScrollView/Grid/PopBtnItem")
    if self.PopTempItemGo ~= nil then
        self.PopTempItemGo:SetActive(false)
    end
    self.PopParentGo:SetActive(false)
    UIUtils.AddBtnEvent(self.MainBtn, self.OnClickMainBtn, self)

    self.IsInit = true
end
function UIPopSelectList:SetData(dataList)
    self:Clear()
    if dataList == nil then
        return
    end
    if dataList.Count == 0 then
        return
    end
    self.TextLabel.text = dataList[1].Text
    self.CurSelectIndex = 1

    for i = 1, #dataList do
        local _popItemIns = nil
        self.DataList:Add(dataList[i])
        if i > self.PopGridTrans.childCount then
            _popItemIns = UnityUtils.Clone(self.PopTempItemGo)
        else
            _popItemIns = self.PopGridTrans:GetChild(i-1).gameObject
        end
        _popItemIns:SetActive(true)
        local _dragView = UnityUtils.RequireComponent(_popItemIns.transform, "UIDragScrollView")
        _dragView.scrollView = self.PopScroll

        local popItemScript = PopItem:NewWithGo(_popItemIns)
        popItemScript:SetText(dataList[i].Text, i)
        popItemScript:SetOnClickCallback(Utils.Handler(self.OnPopItemClick, self))

        self.PopItemList:Add(popItemScript);
    end
end
function UIPopSelectList:Clear()
    for i = 1, #self.PopItemList do
        self.PopItemList[i].Go:SetActive(false)
    end
    self.PopItemList:Clear()
    self.DataList:Clear()
end

--根据索引选中
function UIPopSelectList:SetSelect(index)
    self:OnPopItemClick(index)
end

--返回当前选中的索引
function UIPopSelectList:GetSelectedIndex()
    return self.CurSelectIndex
end

--设置选择结果回调函数
function UIPopSelectList:SetOnSelectCallback(func)
    self.OnSelectCallBack = func
end
function UIPopSelectList:OnDestroy()
    CS.UICamera.RemoveGenericEventHandler(self.Go)
end
function UIPopSelectList:RemoveCameraClickEvent()
    LuaDelegateManager.Remove(CS.UICamera, "onClick", self.OnUICameraEventListener, self)
end
function UIPopSelectList:AddCameraClickEvent()
    LuaDelegateManager.Add(CS.UICamera, "onClick", self.OnUICameraEventListener, self)
end
function UIPopSelectList:OnUICameraEventListener(curObj)
    if curObj ~= nil then
        if not self:IsUIInMyUI(curObj) then
            self:PopDownWidget()
        end
    end
end
function UIPopSelectList:IsUIInMyUI(go)
    if go == nil then
        return false
    end
    if go == self.Go then
        return true
    end
    if (CS.Funcell.Core.Base.UnityUtils.CheckChild(self.Trans, go.transform)) then
        return true
    end
    return false
end

function UIPopSelectList:OnClickMainBtn()
    if self.PopParentGo.activeSelf then
        self:PopDownWidget()
    else
        self:PopUpWidget()
    end
end

function UIPopSelectList:OnPopItemClick(index)
    if #self.DataList == 0 then
        return;
    end
    self.TextLabel.text = self.DataList[index].Text
    self.CurSelectIndex = index
    self:OnSelectFinish(index)
    self:PopDownWidget()
end

function UIPopSelectList:PopUpWidget()
    self.PopParentGo:SetActive(true)
    self.PopGrid:Reposition()

    -- 打开弹出列表时，才注册相机点击事件
    self:AddCameraClickEvent()
    self.PopScroll:ResetPosition()
end

function UIPopSelectList:PopDownWidget()
    self.PopParentGo:SetActive(false)

    -- 关闭列表，移除点击事件
    self:RemoveCameraClickEvent()
end

function UIPopSelectList:OnSelectFinish(index)
    if self.OnSelectCallBack ~= nil then
        self.OnSelectCallBack(index, self.DataList[index])
    end
    self:PopDownWidget()
end
return UIPopSelectList