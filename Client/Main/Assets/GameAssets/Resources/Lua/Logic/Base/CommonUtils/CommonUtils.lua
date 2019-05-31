------------------------------------------------
--作者： 王圣
--日期： 2019-05-24
--文件： CommonUtils.lua
--模块： CommonUtils
--描述： 常用的工具类--这里集合一些通用的逻辑方法.
------------------------------------------------

local CommonUtils = {
}
local L_DianFeng_Lv = 370
 
--是否巅峰等级
function CommonUtils.IsDFLevel(level)
    return level > L_DianFeng_Lv
end

--获取巅峰等级
function CommonUtils.TryGetDFLevel(level)
    if level > L_DianFeng_Lv then
        return true, level-L_DianFeng_Lv
    end
    return false,level
end

--获取等级描述
function CommonUtils.GetLevelDesc(level)
    local _outLevel = 0
    local _isDianFeng = false
    _isDianFeng, _outLevel = CommonUtils.TryGetDFLevel(level)
    if _isDianFeng then
        return string.format( "%s%s",DataConfig.DataMessageString.Get("C_TEXT_DIANFENG"), tostring(_outLevel) )
    else
        return tostring(_outLevel)
    end
end

--获取玩家头像的图标名字
function CommonUtils.GetPlayerHeaderSpriteName(level,occ)
    -- if CommonUtils.IsDFLevel(level) then
    --     return string.format( "head_%s_1",occ )
    -- else
    --     return string.format( "head_%s",occ )
    -- end
    return string.format( "head_%s",occ )
end

--获取等级的背景SpriteName
function CommonUtils.GetMainPlayerBgSpriteName(level)
    -- if CommonUtils.IsDFLevel(level) then
    --     return "main_player_back_1"
    -- else
    --     return "main_player_back"
    -- end
    return "main_player_back"
end

--获取等级的背景SpriteName
function CommonUtils.GetLevelBgSpriteName(level)
    if CommonUtils.IsDFLevel(level) then
            return "main_level_back_1"
         else
            return "main_level_back"
        end
end

function CommonUtils.ConvertParamStruct(mark,value)
    local ret = nil
    if mark == 0 then
        ret = value
    elseif mark == 1 then
        ret = DataConfig.DataMessageString.GetByKey(tonumber(value));
    elseif mark == 2 then
        ret = GameCenter.LanguageConvertSystem:ConvertLan(value);
    end
end

function CommonUtils.ParseColor24(text,offset)
    local r = CommonUtils.HexToDecimal(string.sub(text,offset,offset) << 4) | CommonUtils.HexToDecimal(string.sub(text,offset+1,offset+1))
    local g = CommonUtils.HexToDecimal(string.sub(text,offset + 2,offset + 2) << 4) | CommonUtils.HexToDecimal(string.sub(text,offset+3,offset+3))
    local b = CommonUtils.HexToDecimal(string.sub(text,offset + 4,offset + 4) << 4) | CommonUtils.HexToDecimal(string.sub(text,offset+5,offset+5))
    local f = 1/255
    return Color(f*r,f*g,f*b)
end

function CommonUtils.HexToDecimal(ch)
    if ch == '0'then
        return 0x0
    elseif ch == '1' then
        return 0x1
    elseif ch == '2' then
        return 0x1
    elseif ch == '3' then
        return 0x1
    elseif ch == '4' then
        return 0x1
    elseif ch == '5' then
        return 0x1
    elseif ch == '6' then
        return 0x1
    elseif ch == '7' then
        return 0x1
    elseif ch == '8' then
        return 0x1
    elseif ch == '9' then
        return 0x1
    elseif ch == 'a' or ch == 'A' then
        return 0xA
    elseif ch == 'b' or ch == 'B' then
        return 0xB
    elseif ch == 'c' or ch == 'C' then
        return 0xC
    elseif ch == 'd' or ch == 'D' then
        return 0xD
    elseif ch == 'e' or ch == 'E' then
        return 0xE
    elseif ch == 'f' or ch == 'F' then
        return 0xF
    end
end
return CommonUtils