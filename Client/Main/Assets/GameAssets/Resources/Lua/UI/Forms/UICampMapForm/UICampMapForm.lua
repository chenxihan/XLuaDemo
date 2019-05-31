------------------------------------------------
--作者： _SqL_
--日期： 2019-04-19
--文件： UICampMapForm.lua
--模块： UICampMapForm
--描述： 区域地图窗体
------------------------------------------------

local UICampMapForm = {
    SceneMapBtn = nil,                     -- 场景地图按钮
    CloseBtn = nil,                        -- 返回按钮
    CampOneTrans = nil,                    -- 阵营1 Trans
    CampTwoTrans = nil,                    -- 阵营2 Trans
    HeadTrans = nil,                       -- 玩家头像Trans
    HeadIconSprite = nil,                  -- 玩家头像Icon
    TweenPosComp = nil,                    -- TweenPosition 组件 = nil, 头像动画

    MapBtnParentTrans = nil,               -- 题图按钮父节点
    MapBtnList = List:New(),         -- 地图按钮List
    MapBtnTexDic = Dictionary:New(), -- 地图按钮贴图显示
    AnimMoudle = nil,

    MapTexPathIndex = {1,2,3,4,5,6,7,9,10,11,12,8,13},
}

function  UICampMapForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UICampMapForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UICampMapForm_CLOSE,self.OnClose)
end

function UICampMapForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UICampMapForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)

    self:SetCamp()
    self:LoadMapBackTexture()
    self:ShowPlayerIcon()
    self.AnimMoudle:PlayEnableAnimation()
end

function UICampMapForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

function UICampMapForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.CloseBtn = _trans:Find("BackGroud/Texture/CloseBtn"):GetComponent("UIButton")
    self.SceneMapBtn = _trans:Find("AreaBtn"):GetComponent("UIButton")
    self.HeadTrans = _trans:Find("BackGroud/JianTouSprite")
    self.HeadIconSprite = self.HeadTrans:GetComponent("UISprite")
    self.TweenPosComp = self.HeadTrans:GetComponent("TweenPosition")
    self.CampOneTrans = _trans:Find("MapTexture/Camp1")
    self.CampTwoTrans = _trans:Find("MapTexture/Camp2")

    self.MapBtnParentTrans = _trans:Find("BackGroud/MapTexs")
    for i = 0, self.MapBtnParentTrans.childCount -1 do
        local _tex = self.MapBtnParentTrans:GetChild(i):GetComponent("UITexture")   
        for j = 0, _tex.transform.childCount - 1 do
            local _child = _tex.transform:GetChild(j)
            local _btn = _child:GetComponent("UIButton")
            if _btn ~= nil then
                self.MapBtnList:Add(_btn)
            else
                _child:GetComponent("UITexture").color = Color.white
                self.MapBtnTexDic:Add(_tex, _child:GetComponent("UITexture"))
            end
        end
    end

    self.AnimMoudle = UIAnimationModule(_trans)
    self.AnimMoudle:AddAlphaAnimation()
end

function UICampMapForm:OnRegUICallBack()
    self.SceneMapBtn.onClick:Clear()
    self.CloseBtn.onClick:Clear()
    EventDelegate.Add( self.SceneMapBtn.onClick, Utils.Handler(self.OnSceneMapBtnOnClick,self))
    EventDelegate.Add( self.CloseBtn.onClick, Utils.Handler(self.OnCLose,self))
    for k, v in pairs(self.MapBtnList) do
        UIEventListener.Get(v.gameObject).onClick = nil
        UIEventListener.Get(v.gameObject).onPress = nil

        local _names = Utils.SplitStr(v.transform.parent.name, "_")
        if _names:Count() <= 1 then
            v.transform.parent:GetComponent("UITexture").color = Color.gray
        else
            UIEventListener.Get(v.gameObject).onClick = Utils.Handler(self.OnMapBtnClick,self)
            UIEventListener.Get(v.gameObject).onPress = Utils.Handler(self.OnClickPressMapBtn,self)
        end
    end
end

-- 设置阵营
function UICampMapForm:SetCamp()
    -- 阵营表修改 临时这样修改
    -- if GameCenter.GameSceneSystem:GetLocalPlayer().PropMoudle.BirthGroup == 1 then
    if true then
        self.CampOneTrans.gameObject:SetActive(true)
        self.CampTwoTrans.gameObject:SetActive(false)
    else
        self.CampOneTrans.gameObject:SetActive(false)
        self.CampTwoTrans.gameObject:SetActive(true)
    end
end

-- load map 图片
function UICampMapForm:LoadMapBackTexture()
    local _trans = self.CSForm.transform
    local _mapTex = _trans:Find("MapTexture"):GetComponent("UITexture")
    local _backTex = _trans:Find("BackGroud/Texture"):GetComponent("UITexture")
    local _worldMapBackTex = _trans:Find("BackGroud"):GetComponent("UITexture")

    self.CSForm:LoadTexture(_mapTex, AssetUtils.GetImageAssetPath(ImageTypeCode.MiniMap, "tex_worldmap"))
    self.CSForm:LoadTexture(_backTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_worldmapback_1"))
    self.CSForm:LoadTexture(_worldMapBackTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI,"tex_worldmapback"))

    for i=1, self.MapBtnTexDic:Count() do
        local _pathName = "tex_worldmap_" .. tostring(self.MapTexPathIndex[i])
        local _texPath = AssetUtils.GetImageAssetPath(ImageTypeCode.UI, _pathName)
        local _btnTex = self.MapBtnParentTrans:GetChild( i - 1 ):GetComponent("UITexture")
        local _mapMiaoBianTex = self.MapBtnTexDic[_btnTex]
        self.CSForm:LoadTexture(_btnTex, _texPath)
        self.CSForm:LoadTexture(_mapMiaoBianTex, _texPath)
        _mapMiaoBianTex.gameObject:SetActive(false)
    end
end

-- 切换为场景地图
function UICampMapForm:OnSceneMapBtnOnClick()
    self:OnClose()
    GameCenter.PushFixEvent(UIEventDefine.UI_MAP_OPEN,
        GameCenter.PathFinderSystem:GetMapObjInfo(
        GameCenter.GameSceneSystem:GetActivedMapID()))
end

-- 地图按钮
function UICampMapForm:OnMapBtnClick(go)
    local _names = Utils.SplitStr(go.transform.parent.name, "_")
    local _mapId = 0
    local _currMapId = GameCenter.GameSceneSystem.ActivedScene.Cfg.MapId
    if _names:Count() == 2 then
        _mapId = tonumber( _names[2] )
    elseif #_names == 3 then
        local _campId = 1 -- GameCenter.GameSceneSystem:GetLocalPlayer().PropMoudle.BirthGroup  临时修改
        if _campId == 1 then
            _mapId = tonumber( _names[2] )
        else
            _mapId = tonumber( _names[3] )
        end
    else
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("CAMPMAP_WEIKAIFANG"))
        return
    end

    if _mapId == _currMapId then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("CAMPMAP_HAVAINMAP"))
    else
        local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
        if _p == nil then
            return
        end
        local _level = _p.Level
        local cfg = DataConfig.DataMapsetting[_mapId]
        if cfg ~= nil then
            if _level < cfg.LevelMin then
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("C_CAMP_TASK_LEVELERROR"))
                return
            end
            if GameCenter.HuSongSystem.ModelId ~= 0 then
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("Escorting_Cant_Do_This_Operation"))
                return
            end
            self:OnClose()
            _p:Action_CrossMapTran(_mapId)
        end
    end
 end

function UICampMapForm:OnClickPressMapBtn(go, state)
    local _miaoBianTran = nil
    local _parent = go.transform.parent:GetComponent("UITexture")
    
    if self.MapBtnTexDic[_parent] ~= nil then
        _miaoBianTran = self.MapBtnTexDic[_parent]
    end
    if state then
        UnityUtils.SetLocalScale(go.transform.parent,1.1, 1.1, 1.0)
        _parent.depth = _parent.depth + 2
        _miaoBianTran.depth = _miaoBianTran.depth + 2
    else
        UnityUtils.SetLocalScale(go.transform.parent,0, 0, 0)
        _parent.depth = _parent.depth - 2
        _miaoBianTran.depth = _miaoBianTran.depth - 2
    end
    if _miaoBianTran ~= nil then
        _miaoBianTran.gameObject:SetActive(state)
    end
end

--  显示玩家所在地图
function UICampMapForm:ShowPlayerIcon()
    local _isFind = false
    local _pos = Vector3.zero
    local _mapId = tostring( GameCenter.GameSceneSystem.ActivedScene.Cfg.MapId )
    for k, v in pairs( self.MapBtnTexDic ) do
        if string.find( k.transform.name, _mapId ) ~= nil then
            _isFind = true
            _pos = Vector3(k.transform.localPosition)
        end
    end
    if _isFind then
        local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
        if _p == nil then
            self.HeadTrans.gameObject:SetActive(false)
        else
            self.HeadTrans.gameObject:SetActive(true)
            self.HeadIconSprite.spriteName = CommonUtils.GetPlayerHeaderSpriteName( _p.Level, _p.Occ )
            self.HeadTrans.localPosition = _pos
        end
    else
        self.HeadTrans.gameObject:SetActive(false)
    end
    UnityUtils.SetTweenPositionFrom(self.TweenPosComp, _pos.x, _pos.y, _pos.z)
    UnityUtils.SetTweenPositionTo(self.TweenPosComp, _pos.x, _pos.y + 10, _pos.z)
end

return UICampMapForm