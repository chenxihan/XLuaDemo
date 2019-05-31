------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： RedPacketLogInfo.lua
--模块： RedPacketLogInfo
--描述： 红包日志数据模型
------------------------------------------------

local RedPacketLogInfo = {
    --  1 首冲 2 累充 3 每日首冲 4 每日累充 5 玩家手动发的红包 6,7,8,9 表示玩家发红包
    Reason = 0,
    -- 发送的时间(单位：秒)
    SendTime = 0,
    -- 充值的数量
    Value = 0,
    -- 角色ID值
    RoleID = 0,
    -- 角色名字
    RoleName = nil,
    -- 火钻数量
    Huozhuang = 0,
}

function RedPacketLogInfo:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function RedPacketLogInfo:NewWithMsg(msg)
    local _m = Utils.DeepCopy(self)
    _m.SendTime = msg.sendtime
    _m.Reason = msg.reason
    _m.Value = msg.value
    _m.RoleID = msg.roleId
    _m.RoleName = msg.roleName
    _m.Huozhuang = msg.huozhuang
    return _m
end
return RedPacketLogInfo