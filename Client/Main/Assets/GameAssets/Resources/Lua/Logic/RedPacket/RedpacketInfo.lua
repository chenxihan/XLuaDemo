------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： RedpacketInfo.lua
--模块： RedpacketInfo
--描述： 红包数据模型
------------------------------------------------

local RedpacketInfo = {
    -- 红包实例ID
    RpID = 0,
    -- 红包总价值
    MaxValue = 0,
    -- 红包剩余个数
    CurNum = 0,
    -- 红包的总个数
    MaxNum = 0,
    -- 发送的时间(单位：秒)
    SendTime = 0,
    -- 角色ID值
    RoleID = 0,
    -- 角色名字
    RoleName = nil,
    -- 红包注释
    Demo = nil,
    -- 是否已经领取过
    Mark = false,
    -- 归属类型 1 自有红包， 2 公会红包
    OwnType = 1
}

function RedpacketInfo:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function RedpacketInfo:NewWithMSG(Msg)
    local _m = Utils.DeepCopy(self)
    _m.RpID = Msg.rpId
    _m.MaxValue = Msg.maxValue
    _m.CurNum = Msg.curnum
    _m.MaxNum = Msg.maxnum
    _m.SendTime = Msg.sendtime
    _m.RoleID = Msg.roleId
    _m.RoleName = Msg.roleName
    _m.Demo = Msg.demo
    _m.Mark = Msg.mark
    _m.OwnType = Msg.owntype
    return _m
end
return RedpacketInfo