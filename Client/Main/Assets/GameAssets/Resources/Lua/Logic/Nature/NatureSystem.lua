--作者： xc
--日期： 2019-04-17
--文件： NatureSystem.lua
--模块： NatureSystem
--描述： 造化面板通用数据
------------------------------------------------
--引用

local WingsData = require "Logic.Nature.NatureWingsData"
local TalismanData = require "Logic.Nature.NatureTalismanData"
local MagicData = require "Logic.Nature.NatureMagicData"
local WeaponData = require "Logic.Nature.NatureWeaponData"
local MountData = require "Logic.Nature.NatureMountData"

local NatureSystem = {
    NatureDrugDir = nil,--吃药配置表所有数据 k是各系统类型 
    NatureDrugItemMax = nil,--各系统的道具ID最多升级多少
    NatureWingsData = nil, --翅膀数据
    NatureTalismanData = nil, --法器数据
    NatureMagicData = nil ,--阵法数据
    NatureWeaponData = nil ,--神兵数据 
    NatureMountData = nil ,--坐骑数据
}


function NatureSystem:Initialize()
    self.NatureDrugDir = Dictionary:New()
    self.NatureDrugItemMax = Dictionary:New()
    self.NatureWingsData = WingsData:New()
    self.NatureWingsData:Initialize()
    self.NatureTalismanData = TalismanData:New()
    self.NatureTalismanData:Initialize()
    self.NatureMagicData = MagicData:New()
    self.NatureMagicData:Initialize()
    self.NatureWeaponData = WeaponData:New()
    self.NatureWeaponData:Initialize()
    self.NatureMountData = MountData:New()
    self.NatureMountData:Initialize()
    self:InitConfig()
end

function NatureSystem:UnInitialize()
    self.NatureWingsData:UnInitialize()
    self.NatureWingsData = nil
    self.NatureTalismanData:UnInitialize()
    self.NatureTalismanData = nil
    self.NatureMagicData:UnInitialize()
    self.NatureMagicData = nil
    self.NatureWeaponData:UnInitialize()
    self.NatureWeaponData = nil
    self.NatureMountData:UnInitialize()
    self.NatureMountData = nil
end

--初始化配置表
function NatureSystem:InitConfig()
	--初始化吃果子信息
	for k, v in pairs(DataConfig.DataNatureAtt) do
        if not self.NatureDrugDir:ContainsKey(v.Type) then
            if v.Level == 0 then          
                local _list = List:New()
                _list:Add(v)
                self.NatureDrugDir:Add(v.Type, _list)
            end
        else
            if v.Level == 0 then       
                self.NatureDrugDir[v.Type]:Add(v)
            end
        end
        if not self.NatureDrugItemMax:ContainsKey(v.Type) then
            local _dic = Dictionary:New()
            _dic:Add(v.ItemId,v.Level)
            self.NatureDrugItemMax:Add(v.Type,_dic)
        else
            if self.NatureDrugItemMax[v.Type]:ContainsKey(v.ItemId) then
                if self.NatureDrugItemMax[v.Type][v.ItemId] < v.Level  then
                    self.NatureDrugItemMax[v.Type][v.ItemId] = v.Level
                end
            else
                self.NatureDrugItemMax[v.Type]:Add(v.ItemId,v.Level)
            end
        end
    end
    for k, v in pairs(self.NatureDrugDir) do
        v:Sort(
                function(a,b)
                    return tonumber(a.Position) < tonumber(b.Position)
                end
            )
    end
end 

--通过类型和道具ID得到单个吃药的最大等级
function NatureSystem:GetDrugItemMax(type,item)
    local _maxlv = 0
    if self.NatureDrugItemMax:ContainsKey(type) then
        if self.NatureDrugItemMax[type]:ContainsKey(item) then
            _maxlv = self.NatureDrugItemMax[type][item]
        end
    end
    return _maxlv
end

--接受返回造化面板信息
function NatureSystem:ResNatureInfo(msg)
    if msg.natureType == NatureEnum.Mount then --坐骑数据
        self.NatureMountData:InitWingInfo(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MOUNT_INIT)
    elseif msg.natureType == NatureEnum.Wing then --翅膀数据
        self.NatureWingsData:InitWingInfo(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_WING_INIT)
    elseif msg.natureType == NatureEnum.Talisman then --法器数据
        self.NatureTalismanData:InitWingInfo(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_TALISMAN_INIT)
    elseif msg.natureType == NatureEnum.Magic then --阵道数据
        self.NatureMagicData:InitWingInfo(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MAGIC_INIT)
    elseif msg.natureType == NatureEnum.Weapon then --神兵数据    
        self.NatureWeaponData:InitWingInfo(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_WEAPON_INIT)
    end
end

--返回使用物品升级
function NatureSystem:ResNatureUpLevel(msg)
    if msg.natureType == NatureEnum.Mount then --坐骑数据  
        local _oldlevel = self.NatureMountData.super.Level
        self.NatureMountData:UpDateUpLevel(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MOUNT_UPLEVEL,_oldlevel)
    elseif msg.natureType ==NatureEnum.Wing then --翅膀数据
        local _oldlevel = self.NatureWingsData.super.Level
        self.NatureWingsData:UpDateUpLevel(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_WING_UPLEVEL,_oldlevel)
    elseif msg.natureType == NatureEnum.Talisman then --法器数据
        local _oldlevel = self.NatureTalismanData.super.Level
        self.NatureTalismanData:UpDateUpLevel(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_TALISMAN_UPLEVEL,_oldlevel)
    elseif msg.natureType == NatureEnum.Magic then --阵道数据  
        local _oldlevel = self.NatureMagicData.super.Level
        self.NatureMagicData:UpDateUpLevel(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MAGIC_UPLEVEL,_oldlevel)
    elseif msg.natureType == NatureEnum.Weapon then --神兵数据
        local _oldlevel = self.NatureWeaponData.super.Level
        self.NatureWeaponData:UpDateUpLevel(msg)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_WEAPON_UPLEVEL,_oldlevel)
    end
end

--返回设置模型
function NatureSystem:ResNatureModelSet(msg)
    if msg.natureType == NatureEnum.Mount then --坐骑数据
        self.NatureMountData:UpDateModelId(msg.modelId)
    elseif msg.natureType == NatureEnum.Wing then --翅膀数据
        self.NatureWingsData:UpDateModelId(msg.modelId)
    elseif msg.natureType == NatureEnum.Talisman then --法器数据
        self.NatureTalismanData:UpDateModelId(msg.modelId) 
    elseif msg.natureType == NatureEnum.Magic then --阵道数据
        self.NatureMagicData:UpDateModelId(msg.modelId) 
    elseif msg.natureType == NatureEnum.Weapon then --神兵数据
        self.NatureWeaponData:UpDateModelId(msg.modelId) 
    end
    GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_FASHION_CHANGEMODEL,msg.natureType)
end

--返回吃果子信息
function NatureSystem:ResNatureDrug(msg)
    if msg.natureType == NatureEnum.Mount then --坐骑数据
        self.NatureMountData:UpDateGrugInfo(msg.druginfo)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MOUNT_UPDATEDRUG)
    elseif msg.natureType == NatureEnum.Wing then --翅膀数据
        self.NatureWingsData:UpDateGrugInfo(msg.druginfo)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_WING_UPDATEDRUG)
    elseif msg.natureType == NatureEnum.Talisman then --法器数据
        self.NatureTalismanData:UpDateGrugInfo(msg.druginfo)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_TALISMAN_UPDATEDRUG)
    elseif msg.natureType == NatureEnum.Magic then --阵道数据
        self.NatureMagicData:UpDateGrugInfo(msg.druginfo)
        GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MAGIC_UPDATEDRUG)
    elseif msg.natureType == NatureEnum.Weapon then --神兵数据

    end
end

--返回化形升级结果
function NatureSystem:ResNatureFashionUpLevel(msg)
    if msg.natureType == NatureEnum.Mount then --坐骑数据
        self.NatureMountData:UpDateFashionInfo(msg.info)
    elseif msg.natureType == NatureEnum.Wing then --翅膀数据
        self.NatureWingsData:UpDateFashionInfo(msg.info)
    elseif msg.natureType == NatureEnum.Talisman then --法器数据
        self.NatureTalismanData:UpDateFashionInfo(msg.info)
    elseif msg.natureType == NatureEnum.Magic then --阵道数据
        self.NatureMagicData:UpDateFashionInfo(msg.info)
    elseif msg.natureType == NatureEnum.Weapon then --神兵数据
        self.NatureWeaponData:UpDateFashionInfo(msg.info)
    end
    GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_WING_UPDATEFASHION,msg.info.id)
end

--坐骑返回结果
function NatureSystem:ResNatureMountBaseLevel(msg)
    local _oldlevel = self.NatureMountData.BaseCfg.Id
    self.NatureMountData:UpDateBaseAttr(msg)
    GameCenter.PushFixEvent(LogicEventDefine.NATURE_EVENT_MOUNT_UPDATEEQUIP ,_oldlevel)
end

--发送升级消息
function NatureSystem:ReqNatureUpLevel(type,itemid,isonekey)
    GameCenter.Network.Send("MSG_Nature.ReqNatureUpLevel",{
        natureType = type,
        itemid = itemid,
        isOneKeyUp = isonekey
    })
end

--发送消息设置模型
function NatureSystem:ReqNatureModelSet(type,model)
    GameCenter.Network.Send("MSG_Nature.ReqNatureModelSet",{
        natureType = type,
        modelId = model
    })
end

--发送消息请求基本数据
function NatureSystem:ReqNatureInfo(type)
    GameCenter.Network.Send("MSG_Nature.ReqNatureInfo",{
        natureType = type,
    })
    
end

--发送吃果子信息
function NatureSystem:ReqNatureDrug(type,item)
    GameCenter.Network.Send("MSG_Nature.ReqNatureDrug",{
        natureType = type,
        itemid = item
    })
end

--请求化形升级激活
function NatureSystem:ReqNatureFashionUpLevel(type,modelid)
    GameCenter.Network.Send("MSG_Nature.ReqNatureFashionUpLevel",{
        natureType = type,
        id = modelid
    })
end

--吃装备
function NatureSystem:ReqNatureMountBaseLevel(onlyinfo,iteminfo)
    GameCenter.Network.Send("MSG_Nature.ReqNatureMountBaseLevel",{
        itemOnlyInfo = onlyinfo,
        itemModelInfo = iteminfo
    })
end

return NatureSystem