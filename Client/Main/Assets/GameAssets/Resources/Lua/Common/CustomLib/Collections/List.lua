------------------------------------------------
--作者： xihan
--日期： 2019-04-11
--文件： List.lua
--模块： List
--描述： 列表
------------------------------------------------
local List = {}
List.__index = List

--创建一个新的list。obj 可 nil, isNotCopy 默认深度拷贝
function List:New(obj, isNotCopy)
    local _list = nil
    if obj ~= nil then
        if type(obj) =="table" then
            _list = isNotCopy and obj or Utils.DeepCopy(obj)
        else
            _list = {}
            for i = 0, obj.Count - 1 do
                table.insert(_list, obj[i])
            end
        end
    else
        _list = {}
    end
    setmetatable(_list, List)
    return _list
end


--增加一个item
function List:Add(item, index)
    if index then
        table.insert(self, index, item)
    else
        table.insert(self, item)
    end
end
--向……末尾，添加数组
function List:AddRange(tb)
    for i=1, #tb do
        table.insert(self, tb[i])
    end
end
--清除所有
function List:Clear()
    local _count = self:Count()
    for i=_count, 1, -1 do
        table.remove(self)
    end
end
--是否包含该item
function List:Contains(item)
    local _count = self:Count()
    for i=1, _count do
        if self[i] == item then
            return true
        end
    end
    return false
end
--item的数量
function List:Count()
    return #self
end
--按照predicate(item)函数，查找符合要求的item
function List:Find(predicate)
    if (predicate == nil or type(predicate) ~= "function") then
        Debug.LogError('predicate is invalid!')
        return
    end
    local _count = self:Count()
    for i=1,_count do
        if predicate(self[i]) then
            return self[i]
        end
    end
    return nil
end

--返回列表中首次出现该item的索引，从1开始，如没有则返回0
function List:IndexOf(item)
    local _count = self:Count()
    for i=1,_count do
        if self[i] == item then
            return i
        end
    end
    return 0
end
--返回列表中最后一个该item的索引，从1开始，如没有则返回0
function List:LastIndexOf(item)
    local _count = self:Count()
    for i=_count,1,-1 do
        if self[i] == item then
            return i
        end
    end
    return 0
end
--将item插入列表索引index的位置，后面的依次向后从新排列
function List:Insert(item, index)
    table.insert(self, index, item)
end
--从列表中删除元素（相同的item都会被删除）
function List:Remove(item)
    local _idx = self:LastIndexOf(item)
    if (_idx > 0) then
        table.remove(self, _idx)
        self:Remove(item)
    end
end
--删除并返回列表指定index的元素，其后的元素会被前移。如果省略键参数，则从最后一个元素删起。
function List:RemoveAt(index)
    return table.remove(self, index)
end
--按comparison(a,b)函数进行排序，若comparison为nil 对给定的表进行升序排序。
function List:Sort(comparison)
    if comparison == nil then
        table.sort(self)
        return
    end
    if  type(comparison) ~= "function" then
        Debug.LogError('comparison is invalid')
        return
    end
    table.sort(self, comparison)
end

-- 判断两个数组是否相等
function List:Equal(targetList)
    if targetList ~= nil then
        for i = 1, #targetList do
            if not self:Contains(targetList[i]) then
                return false
            end
        end
    end
    return #targetList == #self
end

return List