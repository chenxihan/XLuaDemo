------------------------------------------------
--作者： gzg
--日期： 2019-04-09
--文件： UIAreaButtonItemData.lua
--模块： UIAreaButtonItemData
--描述： 窗体按钮的对象的数据
------------------------------------------------
local UIAreaButtonItemData = {    
    GroupID = nil,
    Name = nil,
    IsSelected = nil,   
}
--每页显示最大服务器个数
local CN_MAX_SHOW_SERVER = 10;
function UIAreaButtonItemData:New(id,name)
    local _m = Utils.DeepCopy(self);
    _m.GroupID = id;
    _m.Name = name;
    _m.IsSelected = false;
    return _m;
end

--获取数据
function UIAreaButtonItemData:Convert(groupList)  
    local _result = {};    
    local _c = groupList.Count;
    for i = 0, _c - 1 do        
        table.insert(_result,self:New(i,string.format("%d-%d区", i * CN_MAX_SHOW_SERVER + 1, ( i + 1 ) * CN_MAX_SHOW_SERVER )));
    end  
    return _result;
end

return UIAreaButtonItemData;


