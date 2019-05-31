------------------------------------------------
--作者： 何健
--日期： 2019-05-21
--文件： UIGuildRepertorySetPanel.lua
--模块： UIGuildRepertorySetPanel
--描述： 宗派仓库设置面板
------------------------------------------------

local UIGuildRepertorySetPanel = {
    Trans = nil,
    Go = nil,
    LevelDic = Dictionary:New(),
    QualityDic = Dictionary:New(),
    StarDic = Dictionary:New()
}

--创建一个新的对象
function UIGuildRepertorySetPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

--查找UI上各个控件
function UIGuildRepertorySetPanel:FindAllComponents()
    self.DefaultGo = UIUtils.FindGo(self.Trans, "DefaultLabel")
    local _trans = UIUtils.FindTrans(self.Trans, "LevelTable")
    for i = 0, _trans.childCount - 1 do
        local btn = _trans:GetChild(i):GetComponent("UIButton")
        UIUtils.AddBtnEvent(btn, self.OnClikLevelItem, self);
        local go = UIUtils.FindGo(btn.transform, "Select")
        self.LevelDic:Add(btn, go)
    end

    _trans = UIUtils.FindTrans(self.Trans, "QualityTable")
    for i = 0, _trans.childCount - 1 do
        local btn = _trans:GetChild(i):GetComponent("UIButton")
        UIUtils.AddBtnEvent(btn, self.OnClikQualityItem, self);
        local go = UIUtils.FindGo(btn.transform, "Select")
        self.QualityDic:Add(btn.name, go)
    end

    _trans = UIUtils.FindTrans(self.Trans, "StarTable")
    for i = 0, _trans.childCount - 1 do
        local btn = _trans:GetChild(i):GetComponent("UIButton")
        UIUtils.AddBtnEvent(btn, self.OnClikStarItem, self);
        local go = UIUtils.FindGo(btn.transform, "Select")
        self.StarDic:Add(btn, go)
    end

    local _btn = UIUtils.FindBtn(self.Trans, "SaveBtn")
    UIUtils.AddBtnEvent(_btn, self.OnSaveBtnClick, self)
    _btn = UIUtils.FindBtn(self.Trans, "CenterCloseBtn")
    UIUtils.AddBtnEvent(_btn, self.Close, self)
end

function UIGuildRepertorySetPanel:Open()
    self.Go:SetActive(true)
    self:RefreshForm()
end
function UIGuildRepertorySetPanel:Close()
    self.Go:SetActive(false)
end

function UIGuildRepertorySetPanel:RefreshForm()
    for k, v in pairs(self.LevelDic) do
        local _Num = tonumber(k.name)
        v:SetActive(GameCenter.GuildRepertorySystem.LevelList:Contains(_Num))
    end
    for k, v in pairs(self.QualityDic) do
        local _Num = tonumber(k)
        v:SetActive(GameCenter.GuildRepertorySystem.QualityList:Contains(_Num))
    end
    for k, v in pairs(self.StarDic) do
        local _Num = tonumber(k.name)
        v:SetActive(GameCenter.GuildRepertorySystem.StarList:Contains(_Num))
    end
end

--保存设置
function UIGuildRepertorySetPanel:OnSaveBtnClick()
    local _req = {}
    local _temp = {}
    for k, v in pairs(self.StarDic) do
        if v.activeSelf then
            local _Num = tonumber(k.name)
            table.insert( _temp, _Num )
        end
    end
    _req.diamondList = _temp
    _temp = {}
    for k, v in pairs(self.QualityDic) do
        if v.activeSelf then
            local _Num = tonumber(k.name)
            table.insert( _temp, _Num )
        end
    end
    _req.qualityList = _temp
    _temp = {}
    for k, v in pairs(self.LevelDic) do
        if v.activeSelf then
            local _Num = tonumber(k.name)
            table.insert( _temp, _Num )
        end
    end
    _req.gradeList = _temp
    GameCenter.Network.Send("MSG_Guild.ReqGuildStoreCleanCondition", _req)
    self:Close()
end

function UIGuildRepertorySetPanel:OnClikLevelItem()
    local _btn = CS.UIButton.current
    if self.LevelDic:ContainsKey(_btn) then
        self.LevelDic[_btn]:SetActive(not self.LevelDic[_btn].activeSelf)
    end
end
function UIGuildRepertorySetPanel:OnClikQualityItem()
    local _btnName = CS.UIButton.current.name
    if self.QualityDic:ContainsKey(_btnName) then
        self.QualityDic[_btnName]:SetActive(not self.QualityDic[_btnName].activeSelf)
    end
end
function UIGuildRepertorySetPanel:OnClikStarItem()
    local _btn = CS.UIButton.current
    if self.StarDic:ContainsKey(_btn) then
        self.StarDic[_btn]:SetActive(not self.StarDic[_btn].activeSelf)
    end
end
return UIGuildRepertorySetPanel