------------------------------------------------
--作者： 何健
--日期： 2019-05-28
--文件： CheckRedPacketInfo.lua
--模块： CheckRedPacketInfo
--描述： 抢红包数据模型
------------------------------------------------

local CheckRedPacketInfo = {
    -- 角色ID值
    RoleID = 0,
    -- 角色名字
    RoleName = nil,
    -- 抢到的数量
    Rpvalue = 0,
}
function CheckRedPacketInfo:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function CheckRedPacketInfo:NewWithMsg(msg)
    local _m = Utils.DeepCopy(self)
    _m.RoleID = msg.roleId
    _m.RoleName = msg.roleName
    _m.Rpvalue = msg.rpvalue
    return _m
end
return CheckRedPacketInfo