------------------------------------------------
--作者： gzg
--日期： 2019-04-3
--文件： UIServerItemPanelData.lua
--模块： UIServerItemPanelData
--描述： 服务器列表的服务器Item的数据
------------------------------------------------
local UIServerItemData = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerItemData");

--定义个一对的ServerItem数据
local UIServerItemPairData = {
    SortID = 0,
    Left = nil,
    Right = nil,
}

--创建一个数据对
function UIServerItemPairData:New(sid,ser1,ser2)
    local _m = Utils.DeepCopy(self);
    _m.SortID = sid;
    _m.Left = UIServerItemData:NewForServerInfo(ser1);
    if(ser2 ~= nil) then
        _m.Right = UIServerItemData:NewForServerInfo(ser2);
    else
        _m.Right = nil;
    end

    return _m;
end
--把ServerList转换为PanelData的List
function UIServerItemPairData:ConvertList(serverList)
    local _result = {};
    local _len = serverList.Count;
    for i = 0, _len - 1, 2 do        
        if(i < _len - 1) then
            table.insert(_result, self:New(i, serverList[i], serverList[i+1]));
        else
            table.insert(_result, self:New(i, serverList[i], nil));
        end
    end
    return _result;
end

return UIServerItemPairData;
