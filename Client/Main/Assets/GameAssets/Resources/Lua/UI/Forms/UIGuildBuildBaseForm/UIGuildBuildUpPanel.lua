------------------------------------------------
--作者： 何健
--日期： 2019-05-18
--文件： UIGuildBuildUpPanel.lua
--模块： UIGuildBuildUpPanel
--描述： 宗派建筑升级
------------------------------------------------

local UIGuildBuildUpPanel ={
    Go = nil,
    Trans = nil,
    --升级按钮
    LvUpBtn = nil,
    --关闭按钮
    CloseBtn = nil,
    --建筑列表
    BuildBtnList = List:New(),
    BuildNameList = List:New(),
    BuildRedGoList = List:New(),
    --建筑描述
    DesLabel = nil,
    --帮会资金
    GuildMoneyLabel = nil,
    --升级花费资金
    CostMoneyLabel = nil,
    --升级条件描述
    UpDesLabel = nil,
    --名字
    NameLabel = nil,
    Texture = nil,
    --当前选中的建筑
    CurrentType = 0,
}

--创建一个新的对象
function UIGuildBuildUpPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
function UIGuildBuildUpPanel:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "Center/NameLabel")
    self.DesLabel = UIUtils.FindLabel(self.Trans, "Center/DesLabel")
    self.UpDesLabel = UIUtils.FindLabel(self.Trans, "Center/CostDesLabel")
    self.GuildMoneyLabel = UIUtils.FindLabel(self.Trans, "Center/MyMoneyLabel")
    self.CostMoneyLabel = UIUtils.FindLabel(self.Trans, "Center/CostMoneyLabel")
    self.Texture = UIUtils.FindTex(self.Trans, "Center/Texture")
    self.LvUpBtn = UIUtils.FindBtn(self.Trans, "Bottom/LvUpBtn")
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CloseBtn")
    UIUtils.AddBtnEvent(self.CloseBtn, self.Close, self)
    UIUtils.AddBtnEvent(self.LvUpBtn, self.OnLvUpBtnClick, self)
    local _BtnTrans = UIUtils.FindTrans(self.Trans, "Center/BtnList")
    if _BtnTrans ~= nil then
        for i = 0, _BtnTrans.childCount - 1 do
            local _path = string.format("Center/BtnList/%d", i + 1)
            self.BuildBtnList:Add(UIUtils.FindBtn(self.Trans, _path))
            _path = string.format("Center/BtnList/%d/Sprite", i + 1)
            self.BuildRedGoList:Add(UIUtils.FindGo(self.Trans, _path))
            _path = string.format("Center/BtnList/%d/Label", i + 1)
            self.BuildNameList:Add(UIUtils.FindLabel(self.Trans, _path))
            UIUtils.AddBtnEvent(self.BuildBtnList[i + 1], self.OnBuildBtnClick, self)
        end
    end
    local _global = DataConfig.DataGlobal[1145]
    if _global ~= nil then
        local _icon = UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Center/MyMoneyLabel/Icon"), "Funcell.GameUI.Form.UIIconBase")
        _icon:UpdateIcon(tonumber(_global.Params))
        _icon = UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Center/CostMoneyLabel/Icon"), "Funcell.GameUI.Form.UIIconBase")
        _icon:UpdateIcon(tostring(_global.Params))
    end
end

 --打开界面
function UIGuildBuildUpPanel:Open()
    self.Go:SetActive(true)
    self.CurrentType = 1
    self:OnRefreshForm()
end

 --关闭界面
function UIGuildBuildUpPanel:Close()
    self.Go:SetActive(false)
end
  --建筑按钮点击
function UIGuildBuildUpPanel:OnBuildBtnClick()
    self.CurrentType = tonumber(CS.UIButton.current.name)
    self:OnRefreshForm()
end
  --升级按钮点击
function UIGuildBuildUpPanel:OnLvUpBtnClick()
    GameCenter.GuildSystem:ReqUpBuildingLevel(self.CurrentType)
end

 --更新界面显示
function UIGuildBuildUpPanel:OnRefreshForm()
    self:OnSetCost()
    self:OnSetFormValue()
    self:OnSetMoney()
    self:OnSetWarning()
end

 --设置升级条件
function UIGuildBuildUpPanel:OnSetCost()
    if GameCenter.GuildSystem.BuildLvDic.Count <= 0 then
        return
    end
    local _guildLv = GameCenter.GuildSystem.GuildInfo.lv
    local _item = DataConfig.DataGuildUp[self.CurrentType * 10000 + _guildLv]
    if _item == nil then
        return
    end
    local _strBuilder = ""
    local _strArr =  Utils.SplitStr(_item.Other, ";")
    if #_strArr > 0 then
        for i = 1, #_strArr do
            local _buildArr = Utils.SplitStr(_strArr[i], "_")
            if #_buildArr == 2 then
                if #_strBuilder > 0 then
                    _strBuilder = _strBuilder .. ","
                end
                local _iType = tonumber(_buildArr[1])
                local _iValue = tonumber(_buildArr[2])
                if GameCenter.GuildSystem.BuildLvDic.Count > 0 and GameCenter.GuildSystem.BuildLvDic[_iType - 64] < _iValue then
                    _strBuilder = _strBuilder .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_GUILD_BUILDINGLVUPCOST"), "FF0000",
                        GameCenter.GuildSystem:OnGetBuildName(_iType-64), _iValue)
                else
                    _strBuilder = _strBuilder .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_GUILD_BUILDINGLVUPCOST"), "FFFFFF",
                        GameCenter.GuildSystem:OnGetBuildName(_iType-64), _iValue)
                end
            end
        end
        self.UpDesLabel.text = _strBuilder
    else
        self.UpDesLabel.text = DataConfig.DataMessageString.Get("C_GUILD_LEVELMAX")
    end
end

 --设置描述、名字
function UIGuildBuildUpPanel:OnSetFormValue()
    if GameCenter.GuildSystem.BuildLvDic.Count <= 0 then
        return
    end
    for i = 1, #self.BuildBtnList do
        if i == self.CurrentType then
            self.BuildBtnList[i].isEnabled = false
        else
            self.BuildBtnList[i].isEnabled = true
            self.BuildNameList[i].text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_GUILD_BUILDINGNAME5"), GameCenter.GuildSystem:OnGetBuildName(i),
            GameCenter.GuildSystem.BuildLvDic[i])
        end
    end
    local _guildLv = GameCenter.GuildSystem.GuildInfo.lv
    local _item = DataConfig.DataGuildUp[self.CurrentType * 10000 + _guildLv]
    if _item == nil then
        return
    end
    self.DesLabel.text = _item.FunctionalDescribe
    self.NameLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_GUILD_BUILDINGNAME5"), GameCenter.GuildSystem:OnGetBuildName(self.CurrentType),
    GameCenter.GuildSystem.BuildLvDic[self.CurrentType])
    GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, _item.Resources), Utils.Handler(self.LoadTexFinish,self))
end
  --设置公会资金及消耗资金
function UIGuildBuildUpPanel:OnSetMoney()
    if GameCenter.GuildSystem.BuildLvDic.Count <= 0 then
        return
    end
    local _guildLv = GameCenter.GuildSystem.GuildInfo.lv
    local _item = DataConfig.DataGuildUp[self.CurrentType * 10000 + _guildLv]
    if _item == nil then
        return
    end
    if GameCenter.GuildSystem.GuildInfo.guildMoney < _item.NeedNum then
        self.CostMoneyLabel.color = Color.red
    else
        self.CostMoneyLabel.color = Color.white
    end
    self.CostMoneyLabel.text = tostring(_item.NeedNum)
    self.GuildMoneyLabel.text = tostring(GameCenter.GuildSystem.GuildInfo.guildMoney)
end
   --设置红点
function UIGuildBuildUpPanel:OnSetWarning()
    for i = 1, #self.BuildBtnList do
        self.BuildRedGoList[i]:SetActive(GameCenter.GuildSystem:OnChargeCanUp(i))
    end
end

function UIGuildBuildUpPanel:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end
return UIGuildBuildUpPanel