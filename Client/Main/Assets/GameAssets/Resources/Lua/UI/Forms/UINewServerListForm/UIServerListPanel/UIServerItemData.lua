------------------------------------------------
--作者： gzg
--日期： 2019-04-3
--文件： UIServerItemData.lua
--模块： UIServerItemData
--描述： 服务器列表的服务器Item的数据
------------------------------------------------
--定义个服务器数据
local UIServerItemData = {
    ServerID = 0,
    Name = "",
    Area = "",    
    Flag = 0,
    Status = 0,
    HasRole = false,
    IsSelected = false,
}
--创建一个新的对象
function UIServerItemData:New(sid,name,area,flag,status,hasRole)
    --Debug.LogError(flag);
    --Debug.LogError(status);
    local _m = Utils.DeepCopy(self);
    _m.ServerID = sid;
    _m.Name = name;
    _m.Area = area;
    _m.Flag = flag;
    _m.Status = status;
    _m.HasRole = hasRole;
    return _m;
end

--根据ServerDataInfo转换为UIServerItemData
function UIServerItemData:NewForServerInfo(sinfo)
   return UIServerItemData:New(sinfo.ServerId,
                                    sinfo.Name,
                                    string.format("[%d区]",sinfo.ServerId),
                                    sinfo.Flag,
                                    sinfo.Status,
                                    sinfo.HasRole
                                );
end

return UIServerItemData;