------------------------------------------------
--作者： 何健
--日期： 2019-05-7
--文件： UIGuildBuildItem.lua
--模块： UIGuildBuildItem
--描述： 宗派建筑单个控件，用于加载单个建筑名，图片，红点设置
------------------------------------------------

local UIGuildBuildItem = {
    RootTrans = nil,
    RootGo = nil,
    BuildNameLabel = nil,
    RedPointGo = nil,
    Texture = nil,
    Parent = nil,
}

function UIGuildBuildItem:New(res, par)
    local _M = Utils.DeepCopy(self)
    _M.RootTrans = res
    _M.RootGo = res.gameObject
    _M.Parent = par
    _M:FindAllComponents()
    return _M
end

--查找UI上各个控件
function UIGuildBuildItem:FindAllComponents()
    self.BuildNameLabel = UIUtils.FindLabel(self.RootTrans, "Name")
    self.RedPointGo = UIUtils.FindGo(self.RootTrans, "Red")
    self.Texture = self.RootTrans:GetComponent("UITexture")
    local _button = self.RootTrans:GetComponent("UIButton")
    UIUtils.AddBtnEvent(_button, self.OnButtonClick, self)
end

function UIGuildBuildItem:Clone()
    local _go = GameObject.Instantiate(self.RootGo)
    local _trans = _go.transform
    _trans.parent = self.RootTrans.parent
    UnityUtils.ResetTransform(_trans)
    return UIGuildBuildItem:New(_trans)
end

function UIGuildBuildItem:OnButtonClick()
    local _buildID = tonumber(self.RootTrans.name)
    if _buildID == GuildBuildEnum.GuildBase then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GUILD_OPENBUILDUPPANEL)
    elseif _buildID == GuildBuildEnum.GuildShrine then
        GameCenter.PushFixEvent(UIEventDefine.UIGuildDonateForm_OPEN, nil, self.Parent.CSForm)
    elseif _buildID == GuildBuildEnum.GuildScience then
        GameCenter.FactionSkillSystem:ReqFactionSkilList()
    end
end

function UIGuildBuildItem:OnSetRedPoint(isShow)
    self.RedPointGo:SetActive(isShow)
end

--刷新、填充数据
function UIGuildBuildItem:OnRefruseForm()
    local _buildID = tonumber(self.RootTrans.name)
    local _buildLevel = GameCenter.GuildSystem.BuildLvDic[_buildID]
    local _configID = _buildID * 10000 + _buildLevel
    local _config = DataConfig.DataGuildUp[_configID]
    if _config ~= nil then
        GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, _config.Resources), Utils.Handler(self.LoadTexFinish, self))
        self.BuildNameLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("RANK_JILEVEL"), _buildLevel) .. GameCenter.GuildSystem:OnGetBuildName(_buildID)
        self.RedPointGo:SetActive(false)
    end
    if _buildID == GuildBuildEnum.GuildShrine then
        self.RedPointGo:SetActive(GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.GuildTabDonate))
    elseif _buildID == GuildBuildEnum.GuildBase then
        self.RedPointGo:SetActive(GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.GuildBuildLvUp))
    elseif _buildID == GuildBuildEnum.GuildScience then
        self.RedPointGo:SetActive(GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.GuildSkill))
    end
end
function UIGuildBuildItem:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end
return  UIGuildBuildItem