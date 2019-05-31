
------------------------------------------------
--作者： 王圣
--日期： 2019-05-18
--文件： UIDuoBaoRankRewardItem.lua
--模块： UIDuoBaoRankRewardItem
--描述： 福地夺宝排行奖励Item
------------------------------------------------

-- c#类
local UIDuoBaoRankRewardItem = {
    Trans = nil,
    Index = 0,
    ItemGrid = nil,
    TempItem = nil,
    ItemList = List:New(),
}

function UIDuoBaoRankRewardItem:New(trans,index)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Index = index
    _m.ItemGrid = UIUtils.RequireUIGrid(trans:Find("ItemGrid"))
    for i = 1,_m.ItemGrid.transform.childCount-1 do
        local item = UIUtils.RequireUIItem(_m.ItemGrid.transform.GetChild(i))
        _m.ItemList:Add(item)
    end
    _m.TempItem = trans:Find("ItemGrid/TempItem")
    _m.TempItem.gameObject:SetActive(false)
    return _m
end

function UIDuoBaoRankRewardItem:SetItem(str)
    for i = 1,#self.ItemList do
        self.ItemList[i].gameObject:SetActive(false)
    end
    local list = Utils.SplitStr(str,';')
    for i = 1,#list do
        local item = nil
        if i> #self.ItemList then
            local go = UIUtility.Clone(self.TempItem.gameObject)            
            item = UIUtils.RequireUIItem(go.transform)
            item.gameObject:SetActive(true)
            self.ItemList:Add(item)
        else
            item = self.ItemList[i]
            item.gameObject:SetActive(true)
        end
        local dataList = Utils.SplitStr(list[i],'_')
        local id = tonumber(dataList[1])
        local num = tonumber(dataList[2])
        item:InitializationWithIdAndNum(id,num)
    end
    self.ItemGrid.repositionNow = true
end
return UIDuoBaoRankRewardItem