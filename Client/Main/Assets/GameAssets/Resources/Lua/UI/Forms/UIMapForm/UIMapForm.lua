------------------------------------------------
--作者： _SqL_
--日期： 2019-04-16
--文件： UIMapForm.lua
--模块： UIMapForm
--描述： 地图窗体
------------------------------------------------
-- Lua 引用
local UIMapGoldMonsterRoot = require("UI.Forms.UIMapForm.UIMapRoot.UIMapGoldMonsterRoot")
local NpcRoot = require("UI.Forms.UIMapForm.UIMapRoot.UIMapNpcRoot")
local UIMapTeleportRoot = require("UI.Forms.UIMapForm.UIMapRoot.UIMapTeleportRoot")
local UIMapTeamRoot = require("UI.Forms.UIMapForm.UIMapRoot.UIMapTeamRoot")
local UIMapPathPointRoot = require("UI.Forms.UIMapForm.UIMapRoot.UIMapPathPointRoot")

-- C# 引用
local UIUtility = CS.Funcell.Plugins.Common.UIUtility

local UIMapForm = {
    -- 返回按钮
    BackBtn = nil,
    -- 区域地图按钮
    CampMapBtn = nil,
    -- 位置坐标Label
    PositionLabel = nil,
    -- 玩家本地位置显示
    LocalPlayerIcon = nil,
    -- MiniMap Texture
    MiniMapTexture = nil,
    -- MiniMap Btn
    MiniMapBtn = nil,
    -- MiniMap 背景
    MiniMapBG = nil,
    -- BG
    BackGround = nil,
    -- 黄金刷怪Root
    GoldMonsterRoot = nil,
    -- Npc Root
    NpcRoot = nil,
    -- 传送点Root
    TeleportRoot = nil,
    -- Team Toot
    TeamRoot = nil,
    -- 寻路点 Root
    PathPointRoot = nil,

    -- MapObjInfo
    MapObjInfo = nil,
    -- 是否刷新
    IsRefresh = false,

    -- LoadFinished
    LoadFinished = false,
    -- Mini MapInfo
    MiniMapInfo = nil,
    -- SceneSize
    SceneSize = Vector2.zero,
    AnimMudle = nil,
    --地图ui大小
    MapUiSize = nil,
    -- 摄像机角度偏向值
    CameraYaw = 0.0,
    -- minimap tex 缩放值
    MiniMapTexScale = 1,
}

function UIMapForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UI_MAP_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UI_MAP_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDTAE_MAPUI, self.OnChangeMapUpdateUI);
end

function UIMapForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UIMapForm:FindAllComponents()
    local _trans = self.CSForm.transform
    
    self.CloseBtn = _trans:Find("Center/CloseBtn"):GetComponent("UIButton")
    self.CampMapBtn = _trans:Find("Center/CampBtn"):GetComponent("UIButton")
    self.MiniMapBG = _trans:Find("Center/Map/MiniMapBG"):GetComponent("UITexture")
    self.MiniMapTexture = _trans:Find("Center/Map/MiniMapTexture"):GetComponent("UITexture")
    self.BackGround = _trans:Find("Center/BackGroud"):GetComponent("UITexture")
    self.PosLabel = _trans:Find("Center/PosLabel"):GetComponent("UILabel")
    self.MiniMapBtn = self.MiniMapTexture.transform:GetComponent("UIButton")
    self.LocalPlayerIcon = _trans:Find("Center/LocalPlayer/localres").gameObject
    
    local _goldMonsterRoot = _trans:Find("Center/GoldMonsterRoot")
    self.GoldMonsterRoot = UIMapGoldMonsterRoot:New(self, _goldMonsterRoot)
    local _npcRoot = _trans:Find("Center/NpcRoot")
    self.NpcRoot = NpcRoot:New(self, _npcRoot)
    local _telepoetRoot = _trans:Find("Center/TeleportRoot")
    self.TeleportRoot = UIMapTeleportRoot:New(self, _telepoetRoot)
    local _teamRoot = _trans:Find("Center/TeamRoot")
    self.TeamRoot = UIMapTeamRoot:New(self, _teamRoot)
    local _pathPointRoot = _trans:Find("Center/PathPointRoot")
    self.PathPointRoot = UIMapPathPointRoot:New(self, _pathPointRoot)
    
    self.MapUiSize = Vector2(self.MiniMapTexture.localSize.x * self.MiniMapTexScale,
                            self.MiniMapTexture.localSize.y * self.MiniMapTexScale)

    self.AnimMudle = UIAnimationModule(_trans)
    self.AnimMudle:AddAlphaAnimation()
end

function UIMapForm:RegUICallback()
    self.CloseBtn.onClick:Clear()
    self.CampMapBtn.onClick:Clear()
    self.MiniMapBtn.onClick:Clear()
    EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClose, self))
    EventDelegate.Add(self.CampMapBtn.onClick, Utils.Handler(self.OnClickCampMap, self))
    EventDelegate.Add(self.MiniMapBtn.onClick, Utils.Handler(self.OnClickMiniMap, self))
end

function UIMapForm:SetCaremaYaw()
    local _mapId = GameCenter.GameSceneSystem.ActivedScene.MapId
    local _cfg = DataConfig.DataMapsetting[_mapId]
    if _cfg then
        self.CameraYaw = _cfg.CamDefaultYaw
        self.MiniMapTexScale = _cfg.MiniMapScale
    else
        Debug.LogError("DataMapsetting not contains key = ", _mapId)
    end
end

function UIMapForm:OnChangeMapUpdateUI(obj, sender)
    if not self.CSForm.IsVisible then
        return
    end
    if GameCenter.GameSceneSystem.ActivedScene == nil then
        return
    end

    local _mapId = GameCenter.GameSceneSystem.ActivedScene.MapId
    local _info = GameCenter.PathFinderSystem:GetMapObjInfo(_mapId)
    if _info == nil then
        return
    end
    if self.MapObjInfo == nil or self.MapObjInfo.MapId ~= _mapId then
        self.IsRefresh = false
    end
    self:OnOpen( _info )
end

function UIMapForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:SetCaremaYaw()
    self.LoadFinished = false
    if obj == nil then
        local _mapId =  GameCenter.GameSceneSystem.ActivedScene.MapId
        self.MapObjInfo = GameCenter.PathFinderSystem:GetMapObjInfo(_mapId)
    else
        self.MapObjInfo = obj
    end
    self:RefreshMapInfo()
    self.AnimMudle:PlayEnableAnimation()
end

function UIMapForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

-- 初始化数据
function UIMapForm:RefreshMapInfo()
    self.MiniMapInfo = GameCenter.WorldMapInfoManager:GetMiniMapInfo(self.MapObjInfo.MapName)
    self.SceneSize = Vector2(self.MiniMapInfo.Size)

    local _miniMapTexPath = AssetUtils.GetImageAssetPath(ImageTypeCode.MiniMap,"tex_" .. self.MapObjInfo.MapName)
    local _backGroudTexPath = AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_worldmapback")
    local _mapBackGroundTexPaht = AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_worldmapback_1")
    self.CSForm:LoadTexture(self.MiniMapTexture, _miniMapTexPath)
    self.CSForm:LoadTexture(self.BackGround, _backGroudTexPath)
    self.CSForm:LoadTexture(self.MiniMapBG, _mapBackGroundTexPaht)
    -- minimaptex 的transform 根据配置设置
    UnityUtils.SetLocalPosition(self.MiniMapTexture.transform, self.MiniMapTexScale, self.MiniMapTexScale, self.MiniMapTexScale)

    self:SetMiniMapTexUVRect()
    self:LoadPlayerPosIcon()
    self.GoldMonsterRoot:LoadGoldMonster(GameCenter.GameSceneSystem.ActivedScene.MapId)
    self.NpcRoot:LoadNpc(self.MapObjInfo.NpcInfo:GetEnumerator())
    self.TeleportRoot:LoadTeleportPoint(self.MapObjInfo.TeleportInfo:GetEnumerator())
    self.LoadFinished = true
end

-- 设置minimap Rect
function UIMapForm:SetMiniMapTexUVRect()
    local _width = self.MiniMapTexture.width / 1024
    local _height = self.MiniMapTexture.height / 1024
    if _width >= 1.0 then
        _width = 1.0
    end
    if _height >= 1.0 then
        _height = 1.0
    end
    local _miniWidth = (1 - _width) / 2.0
    local _miniHeigth = (1 - _height) / 2.0
    -- self.MiniMapTexture.uvRect = Rect(_miniWidth, _miniHeigth, _width, _height)
    self.MiniMapTexture.uvRect = Rect(0, 0, 1, 1)
end

-- 载入主角位置图标
function UIMapForm:LoadPlayerPosIcon()
    local _p = GameCenter.GameSceneSystem.ActivedScene:GetLocalPlayer()
    if _p == nil then
        self.LocalPlayerIcon:SetActive(false)
        return
    end
    self.LocalPlayerIcon:SetActive(true)
end

function UIMapForm:Update()
    if not self.LoadFinished then
        return
    end
    if GameCenter.GameSceneSystem.ActivedScene ~= nil then
        local _p = GameCenter.GameSceneSystem.ActivedScene:GetLocalPlayer()
        if _p ~= nil then
            self.PosLabel.text = string.format( "%.0f %.0f", _p.Position2d.x, _p.Position2d.y)
            self.LocalPlayerIcon.transform.localPosition = self:WorldPosToMapPos(_p.Position)
            UIUtility.RotationToForward(self.LocalPlayerIcon.transform, 135 - _p.Facing)
            self.PathPointRoot:UpdatePathFindingPoint(_p)
        else
            self.PosLabel.text = ""
        end
        self.TeamRoot:ShowTeammateIcon(GameCenter.TeamSystem.MyTeamInfo.MemberList)
    end
end

-- 点击阵营地图按钮
function UIMapForm:OnClickCampMap()
    self:OnClose()
    GameCenter.PushFixEvent(UIEventDefine.UICampMapForm_OPEN)
end

-- 点击小地图的处理，根据点击位置计算移动的位置

function UIMapForm:OnClickMiniMap()
    if GameCenter.MandateSystem.IsRunning then
        GameCenter.MandateSystem:End()
    end
    local _pos = CS.NGUIMath.ScreenToPixels(CS.UICamera.currentTouch.pos, self.MiniMapTexture.transform);
    local _worldPos = UIUtility.MiniMapPosToWorldPos(
                                                    self.CameraYaw,
                                                    self.MapUiSize.x, self.MapUiSize.y,
                                                    self.SceneSize.x, self.SceneSize.y,
                                                    self.MiniMapInfo.CameraPosition.x, self.MiniMapInfo.CameraPosition.y,
                                                    _pos.x, _pos.y, _pos.z)

    if GameCenter.GameSceneSystem.ActivedScene == nil then
        return
    end
    local _p = GameCenter.GameSceneSystem.ActivedScene:GetLocalPlayer()
    if _p == nil then
        return;
    end
    _p.blackboard.MapMove:Write(self.MapObjInfo.MapID, _worldPos, 0.5, true);
end

-- 世界坐标转地图坐标
function UIMapForm:WorldPosToMapPos(worldPos)
    return UIUtility.WorldPosToMiniMapPos(
                                        self.CameraYaw,
                                        self.MapUiSize.x, self.MapUiSize.y,
                                        self.SceneSize.x, self.SceneSize.y,
                                        self.MiniMapInfo.CameraPosition.x, self.MiniMapInfo.CameraPosition.y,
                                        worldPos.x, worldPos.y, worldPos.z)
end

return UIMapForm