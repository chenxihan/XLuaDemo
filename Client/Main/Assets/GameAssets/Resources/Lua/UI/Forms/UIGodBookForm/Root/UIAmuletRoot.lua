------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIAmuletRoot.lua
--模块： UIAmuletRoot
--描述： 符咒 Root
------------------------------------------------

local UIAmuletRoot = {
    Owner = nil,
    Trans = nil,
    -- 当前选中的符咒
    CurrAmulet = 0,
    -- 是否激活符咒 激活之后需要从新刷新符咒列表
    Active = false,
    -- 激活按钮
    ActiveBtn = nil,
    -- 属性item parent
    AttrListPanel = nil,
    -- 属性item
    AttrItemTrans = nil,
    -- 符咒tex 展示
    AmuletViewTex = nil,
    -- 符咒item trans
    AmuletItemTran = nil,
    -- 符咒item parent
    AmuletListPanel = nil,
    -- 符咒按钮dic
    AmuletBtnTransDic = Dictionary:New()
}

function  UIAmuletRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:SetAmuletBtn()
    return self
end

function UIAmuletRoot:FindAllComponents()
    self.ActiveBtn = UIUtils.FindBtn(self.Trans, "ActiveBtn")
    self.AttrListPanel = UIUtils.FindTrans(self.Trans, "ListPanel")
    self.AttrItemTrans = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.AmuletViewTex = UIUtils.FindTex(self.Trans, "AmuletShow")
    self.AmuletItemTran = UIUtils.FindTrans(self.Trans, "Amulets/ListPanel/Grid/Item")
    self.AmuletListPanel = UIUtils.FindTrans(self.Trans, "Amulets/ListPanel/Grid")
end

-- 设置符咒按钮
function UIAmuletRoot:SetAmuletBtn()
    self.AmuletBtnTransDic:Clear()
    local _index = 0
    local _keys = {}
    for k in pairs(DataConfig.DataAmulet) do
        table.insert( _keys, k )
        table.sort(_keys)
    end
    for i = 0, self.AmuletListPanel.childCount - 1 do
        self.AmuletListPanel:GetChild(i).gameObject:SetActive(false)
    end
    for i = 1, #_keys do
        if _index < self.AmuletListPanel.childCount then
            self:SetAmulet(self.AmuletListPanel:GetChild(_index), DataConfig.DataAmulet[_keys[i]])
        else
            self:SetAmulet(self:Clone(self.AmuletItemTran.gameObject, self.AmuletListPanel), DataConfig.DataAmulet[_keys[i]])
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.AmuletListPanel)
    UIUtils.AddBtnEvent(self.ActiveBtn, self.OnActivedBtnClick, self)
end

-- 设置符咒信息
function UIAmuletRoot:SetAmulet(trans, cfg)
    trans.gameObject:SetActive(true)
    local _amuletBtn = trans:GetComponent("UIButton")
    if GameCenter.GodBookSystem.OpenAmuletIdList:Contains(cfg.Id) then
        UIUtils.FindLabel(trans,"Name").text = cfg.Name
    else
        UIUtils.FindLabel(trans,"Name").text = "未激活"
    end
    UIUtils.AddBtnEvent(_amuletBtn, self.OnAmuletBtnClick, self, {id = cfg.Id})
    UIUtils.FindTrans(trans, "Select").gameObject:SetActive(false)
    self.AmuletBtnTransDic[cfg.Id] = trans
    self:SetRedPointView(cfg.Id)
end

-- 红点显示
function UIAmuletRoot:SetRedPointView(id)
    local _isShow = GameCenter.GodBookSystem:IsShowRedPoint(id) or GameCenter.GodBookSystem:GetAmuletActiveStatus(id)
    if _isShow then
        UIUtils.FindTrans(self.AmuletBtnTransDic[id], "RedPoint").gameObject:SetActive(true)
    else
        UIUtils.FindTrans(self.AmuletBtnTransDic[id], "RedPoint").gameObject:SetActive(false)
    end
end

-- 符咒按钮 事件
function UIAmuletRoot:OnAmuletBtnClick(data)
    local _openList = GameCenter.GodBookSystem.OpenAmuletIdList
    if _openList:Contains(data.id) then
        self:RefreshAmuletInfo(data.id)
    else
        local _cfg = DataConfig.DataAmulet[data.id]
        if _cfg.OpenCondition and _cfg.OpenCondition ~= "" then
            local _id = tonumber(Utils.SplitStr(_cfg.OpenCondition,"_")[2])
            local _data = DataConfig.DataAmulet[_id]
            if _data ~= nil then
                GameCenter.MsgPromptSystem:ShowPrompt(string.format("先激活 %s",_data.Name))
            else
                Debug.LogError("DataAmulet not contains key = %d", _id)
            end
        else
            local _lv = Utils.SplitStr(_cfg.Condition, "_")[2]
            GameCenter.MsgPromptSystem:ShowPrompt(string.format("%s 级解锁", _lv))
        end
    end
end

-- 激活符咒
function UIAmuletRoot:OnActivedBtnClick()
    if GameCenter.GodBookSystem:GetAmuletActiveStatus(self.CurrAmulet) then
        GameCenter.GodBookSystem:ReqActiveAmulet(self.CurrAmulet)
        self.Active = true
    else
        GameCenter.MsgPromptSystem:ShowPrompt("完成所有任务后可激活")
    end
end

-- 刷新符咒信息
function UIAmuletRoot:RefreshAmuletInfo(id)
    -- 激活符咒 会有新的符咒解锁 从新刷新符咒按钮
    if self.Active then
        self:SetAmuletBtn()
        self.Active = false
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_AMULETPANEL, id)
    if id ~= self.CurrAmulet then
        UIUtils.FindTrans(self.AmuletBtnTransDic[id], "Select").gameObject:SetActive(true)
        if self.CurrAmulet ~= 0 then
            UIUtils.FindTrans(self.AmuletBtnTransDic[self.CurrAmulet], "Select").gameObject:SetActive(false)
        end
        self.CurrAmulet = id
    end

    local _cfg = DataConfig.DataAmulet[id]
    local _info = GameCenter.GodBookSystem:GetAmuletInfo(id)
    self.Owner.CSForm:LoadTexture(self.AmuletViewTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, _cfg.Icon))

    if _info.Status then
        self.ActiveBtn.gameObject:SetActive(false)
        UIUtils.FindTrans(self.Trans, "Status").gameObject:SetActive(true)
    else
        self.ActiveBtn.gameObject:SetActive(true)
        UIUtils.FindTrans(self.Trans, "Status").gameObject:SetActive(false)
        if GameCenter.GodBookSystem:GetAmuletActiveStatus(id) then
            UIUtils.FindTrans(self.ActiveBtn.transform,"RedPoint").gameObject:SetActive(true)
        else
            UIUtils.FindTrans(self.ActiveBtn.transform,"RedPoint").gameObject:SetActive(false)
        end
    end
    self:SetAttibutes(Utils.SplitStr(_cfg.ActiveSkill, ";"))
end

-- 设置符咒的属性
function UIAmuletRoot:SetAttibutes(strs)
    local _count = 0
    local _career = Utils.GetEnumNumber(tostring(GameCenter.GameSceneSystem:GetLocalPlayer().PropMoudle.Occ))
    local _attributes = List:New()
    for i = 0, self.AttrListPanel.childCount - 1 do
        self.AttrListPanel:GetChild(i).gameObject:SetActive(false)
    end
    for i = 1, #strs do
        local _s = Utils.SplitStr(strs[i], "_")
        if tonumber(_s[1]) == _career then
            _attributes:Add(tonumber(_s[2]))
        end
    end
    local _index = 0
    for i = 1, _attributes:Count() do
        local _cfg = DataConfig.DataSkill[_attributes[i]]
        local _go = nil
        if _cfg ~= nil then
            if _index < self.AttrListPanel.childCount then
                _go = self.AttrListPanel:GetChild(_index)
            else
                _go = self:Clone(self.AttrItemTrans,self.AttrListPanel)
            end
            _go:GetComponent("UILabel").text = _cfg.Desc
            _go.gameObject:SetActive(true)
            _index = _index + 1
        end
    end
end

-- 设置 激活按钮红点
function UIAmuletRoot:SetActiveBtnRedPoint(evable)
    if self.CurrAmulet ~= 0 then
        self:SetRedPointView(self.CurrAmulet)
    end
    UIUtils.FindTrans(self.ActiveBtn.transform,"RedPoint").gameObject:SetActive(evable)
end

function UIAmuletRoot:Clone(obj, parent)
    local _go = GameObject.Instantiate(obj).transform
    if parent then
        _go:SetParent(parent)
    end
    UnityUtils.ResetTransform(_go)
    return _go
end

return UIAmuletRoot