------------------------------------------------
--作者： xihan
--日期： 2019-04-11
--文件： Dictionary.lua
--模块： Dictionary
--描述： 字典
------------------------------------------------
local Dictionary = {};
Dictionary.__index = Dictionary;
local L_Keys = setmetatable({},{__mode = "k"});

Dictionary.__newindex = function(t, k, v)
    L_Keys[t]:Add(k);
    rawset(t, k, v);
end

--创建一个新的Dictionary。tb 可 nil, isNotCopy 默认深度拷贝
function Dictionary:New(tb, isNotCopy)
    local _dict = nil;
    local _isDict = false;
    if tb ~= nil and type(tb) =="table" then
        if isNotCopy then
            _dict = tb;
        else
            _dict = Utils.DeepCopy(tb);
            if getmetatable(_dict) == Dictionary then
                _isDict = true;
            end
        end
    else
        _dict = {};
    end

    if not _isDict then
        setmetatable(_dict, Dictionary);
        _dict:_OnCopyAfter_()
    end
    return _dict;
end

--拷贝之后处理的
function Dictionary:_OnCopyAfter_()
    L_Keys[self] = List:New();
    for k,_ in pairs(self) do
        L_Keys[self]:Add(k)
    end
    if #L_Keys[self] > 0 then
        local _type = type(L_Keys[self][1]);
        if _type == "string" or _type == "number" then
            table.sort(L_Keys[self])
        end
    end
end

--是否包含key
function Dictionary:ContainsKey(key)
    return not(not self[key])
end
--是否包含value
function Dictionary:ContainsValue(value)
    for _, v in pairs(self) do
        if v == value then
            return true
        end
    end
    return false
end
--获取所有key
function Dictionary:GetKeys()
    -- local _keys = {}
    -- for k, _ in pairs(self) do
    --     table.insert(_keys,k)
    -- end
    -- return _keys
    return L_Keys[self];
end
--item数量
function Dictionary:Count()
    -- return Utils.GetTableLens(self)
    return #L_Keys[self];
end
--增加一个 key - value
function Dictionary:Add(key, value)
    if self:ContainsKey(key) then
        Debug.LogError("The key is already in the dictionary! key:", key)
        return
    end
    self[key] = value
end
--移除一个 key - value
function Dictionary:Remove(key)
    if self:ContainsKey(key) then
        self[key] = nil
        L_Keys[self]:Remove(key);
    end
end
--清除所有
function Dictionary:Clear()
    for k, _ in pairs(self) do
        self[k] = nil;
    end
    L_Keys[self]:Clear();
end

--添加里一个字典
function Dictionary:AddRange(tb)
    if (tb == nil or type(tb) ~= "table") then
        Debug.LogError('table is invalid!')
        return
    end
    for k, v in pairs(tb) do
        self:Add(k, v)
    end
end

--按key顺利遍历[无法中断]
function Dictionary:Foreach(func)
    local _keys = L_Keys[self];
    for i=1,#_keys do
        func(_keys[i],self[_keys[i]]);
    end
end

--按key顺利遍历[中断遍历 return "break"]
function Dictionary:ForeachCanBreak(func)
    local _keys = L_Keys[self];
    for i=1,#_keys do
        if func(_keys[i],self[_keys[i]]) == "break" then
            break;
        end
    end
end

--按key反顺遍历[无法中断]
function Dictionary:ForeachReverse(func)
    local _keys = L_Keys[self];
    for i=#_keys, 1, -1 do
        func(_keys[i],self[_keys[i]]);
    end
end

--按key反顺遍历[中断遍历 return "break"]
function Dictionary:ForeachReverseCanBreak(func)
    local _keys = L_Keys[self];
    for i=#_keys, 1, -1 do
        if func(_keys[i],self[_keys[i]]) == "break" then
            break;
        end
    end
end

--排序[按value排序]
function Dictionary:SortValue(func)
    local _keys = L_Keys[self];
    table.sort(_keys,function(a, b)
        return func(self[a], self[b]);
    end)
end

--排序[按key排序]
function Dictionary:SortKey(func)
    local _keys = L_Keys[self];
    table.sort(_keys,function(a, b)
        return func(a, b);
    end)
end

--查找
function Dictionary:Get(key)
    return self[key]
end

return Dictionary