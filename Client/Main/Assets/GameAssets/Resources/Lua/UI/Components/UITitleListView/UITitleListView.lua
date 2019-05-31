--==============================--
--作者： xihan
--日期： 2019-05-24
--文件： UITitleListView.lua
--模块： UITitleListView
--描述： 下拉菜单列表
--1.根节点上需要ScorllView组件；不需要排序组件UITable或UIGrid;
--2.ItemGobjList：每一级子物体列表，如果有3个就会按数据生成3级列表，自动获取每级列表高度；
--3.DataDict：数据结构为树结构，如果没有用Dictionary存取，会将key按index存取；
--4.刷新：刷新节点RefreshNode、刷新所有节点RefreshAllNode、刷新当前选中信息RefreshSelectInfo；
--5.支持：设置上一个大菜单自动收回 SetAudoShrink；
--6.支持：通过keyQueue选中对应的按钮SelectNode(keyQueue)，可以实现外部代码调用点击按钮；
--7.特殊支持：设置只创建第一层，不创建子节点的keys，SetIgnoreKeys,eg:SetIgnoreKeys({0}) 第一层key为0不创建子节点；
--8.特殊支持：设置默认节点，切换大节点时，显示默认的界面 SetDefaultNode
--==============================--

local UITitleListView = {
    --根节点
    RootTrans = nil,
    --itemGobjList
    ItemGobjList = nil,
    --数据
    DataDict = nil,
    --创建按钮回调(item)
    OnCreatFinshedCallBack = nil,
    --设置菜单回调
    OnSetTitleListCallBack = nil,
    --点击按钮回调(item, isSelect)
    OnClickCallBack = nil,

    --itemTransPool
    ItemTransPool = nil,
    --UIScrollView组件
    ScrollView = nil,
    --各gobj的大小
    SizeList = nil,
    --Panel开始位置Y值
    StartPosY = nil,

    --使用中的Node树结构
    -- {  [1] = {  Item = item, --当前Item
    --             IsSelect = false, --是否被选中
    --             StartPos = 0, --开始位置
    --             EndPos = 0, --最终的位置
    --             IsIgnore = false, --创建时是否忽略
    --             ParentNode = Node, --父节点
    --             Sub = {[1] = Node, ...} --子节点
    --           },...
    --     },...
    -- }
    UseNodeDic = nil,
    --当前选择的node
    CurSelectNode = nil,
    --上一个选择的node
    PreSelectNode = nil,
    --当前选择的第一层节点
    CurSelectFristLayerNode = nil,
    --大菜单是否自动收回
    IsShrink = true,
    --只创建第一层，不创建子节点的keys
    IgnoreKeys = nil,
    --切换大节点时，是否显示默认的界面
    IsShowDefaultChangeBigNode = false,
    --默认节点
    DefaultKeyQueue = nil,
}
--创建完成回调
local L_CreatFinshedCallBack = nil;
--点击回调
local L_ClickCallBack = nil;
--获取一个新的节点的Transform
local L_GetNewTans = nil;
--创建所有节点
local L_CreateAllNode = nil;
--设置显隐
local L_SetVisible = nil;
--初始化对象池
local L_InitPool = nil;
--计算所有位置
local L_CalculateAllPos = nil;
--设置所有位置
local L_SetAllPos = nil;
--获取节点
local L_GetNode = nil;
--是否是只创建第一层，不创建子节点的key
local L_IsIgnoreByKey = nil;
--显示选择的节点信息
local L_SelectNode = nil;
--创建完成回调
L_CreatFinshedCallBack = function (self, node)
    return self.OnCreatFinshedCallBack(node.Item);
end

--设置节点回调
L_SetTitleListCallBack = function (self, node)
    return self.OnSetTitleListCallBack(node.Item);
end

--点击回调
L_ClickCallBack = function (self, node, isSetDefault)
    --如果是第一层
    if not node.ParentNode then
        if self.CurSelectFristLayerNode then
            if self.CurSelectFristLayerNode ~= node and not isSetDefault then
                self.CurSelectFristLayerNode = node;
                --节点需要自动收缩
                if self.IsShrink then
                    for _,v in pairs(self.UseNodeDic) do
                        if node ~= v then
                            v.IsSelect = false;
                        end
                    end
                end
                --需要切换到默认节点
                if self.DefaultKeyQueue then
                    L_SelectNode(self, self.DefaultKeyQueue, true);
                end
            end
        else
            self.CurSelectFristLayerNode = node;
        end
    end

    --如果有子节点，展开或关闭子节点
    if node.Sub and not L_IsIgnoreByKey(self, node.Item.Key) then
        node.IsSelect = not node.IsSelect;
        L_CalculateAllPos(self);
        L_SetAllPos(self);
        self.ScrollView:ResetPosition();
    --如果没有子节点并且不是当前选中的节点，执行OnClickCallBack回调
    elseif self.CurSelectNode ~= node then
        self.PreSelectNode = self.CurSelectNode;
        self.CurSelectNode = node;
        local _isSelectParentNode = (not self.PreSelectNode) or (not self.PreSelectNode.ParentNode) or  (self.PreSelectNode.ParentNode ~= self.CurSelectNode.ParentNode);

        local function ClickCallBack(node, isSelect)
            if node then
                node.IsSelect = isSelect;
                self.OnClickCallBack(node.Item, isSelect);
                if _isSelectParentNode then
                    ClickCallBack(node.ParentNode, isSelect);
                end
            end
        end
        ClickCallBack(self.PreSelectNode, false);
        ClickCallBack(self.CurSelectNode, true);
    end
end

--获取一个新的节点的Transform
L_GetNewTans = function (self, layer)
    local _trans = nil;
    if self.ItemTransPool[layer]:Count() > 0 then
        _trans = self.ItemTransPool[layer][1];
        table.remove(self.ItemTransPool[layer], 1);
    else
        _trans = UnityUtils.Clone(self.ItemGobjList[layer]).transform;
    end

    return _trans;
end

--创建所有节点
L_CreateAllNode = function (self, UseNodeDic, dataDict, keyQueue, parentNode, IsIgnore)
    local _layer = #keyQueue + 1;
    local function Create(k, v)
        local _curKeyQueue = Utils.DeepCopy(keyQueue);
        table.insert(_curKeyQueue, k);
        local _item = {};
        --特殊处理（key为0时，不创建子节点的gobj）
        if not IsIgnore then
            local _trans = L_GetNewTans(self, _layer);
            _item.Trans = _trans;
        end

        _item.Layer = _layer;
        _item.Key = k;
        _item.Data = v;
        _item.KeyQueue = _curKeyQueue;

        local _node = nil;
        if _layer + 1 > #self.ItemGobjList or not next(v) then
            _node ={Item = _item, StartPos = 0, EndPos = 0, IsIgnore = IsIgnore, ParentNode = parentNode};
        else
            _node ={Item = _item, StartPos = 0, EndPos = 0, Sub = Dictionary:New(), IsIgnore = IsIgnore, ParentNode = parentNode};
            L_CreateAllNode(self, _node.Sub, v, _curKeyQueue, _node, IsIgnore or (_layer == 1 and L_IsIgnoreByKey(self, k)));
        end
        if not IsIgnore then
            L_CreatFinshedCallBack(self, _node);
            L_SetTitleListCallBack(self, _node);
        end
        --注册点击事件
        if _item.Trans then
            UIUtils.AddBtnEvent(UIUtils.RequireUIButton(_item.Trans), L_ClickCallBack, self, _node);
        end
        UseNodeDic:Add(k, _node);
    end

    --如果是字典就按key、value创建
    if getmetatable(dataDict) == Dictionary then
        dataDict:Foreach(function(k, v)
            Create(k, v);
        end)
    --如果不是字典会对key进行升序排序
    else
        local _keys = {}
        for k,_ in pairs(dataDict) do
            table.insert(_keys, k);
        end
        table.sort(_keys);
        for i=1,#_keys do
            Create(_keys[i], dataDict[_keys[i]]);
        end
    end
end

--设置显隐
L_SetVisible = function (self, trans, isVisible)
    trans.gameObject:SetActive(isVisible);
end

--是否是只创建第一层，不创建子节点的key
L_IsIgnoreByKey = function (self, key)
    if self.IgnoreKeys then
        for _,v in pairs(self.IgnoreKeys) do
            if v == key then
                return true;
            end
        end
    end
end

--初始化对象池
L_InitPool = function (self)
    local itemGobjList = self.ItemGobjList;
    local rootTrans = self.RootTrans;
    self.ItemTransPool = Dictionary:New();
    local _parent = rootTrans.parent;
    local _names = {};
    for i=1,#itemGobjList do
        self.ItemTransPool:Add(i,List:New());
        _names[i] = itemGobjList[i].name;
    end
    local function FindChild(parentTrans)
        for i=1,#_names do
            local _name = _names[i];
            local _baseTrans = itemGobjList[i].transform;
            for j = parentTrans.childCount - 1, 0, -1 do
                local _trans = parentTrans:GetChild(j);
                if _baseTrans ~= _trans then
                    if string.find(_trans.gameObject.name, _name) then
                        self.ItemTransPool[i]:Add(_trans);
                        L_SetVisible(self, _trans, false);
                    end
                end
            end
        end
    end
    FindChild(rootTrans);
end

--计算所有位置
L_CalculateAllPos = function (self)
    local _curPos = self.StartPosY;
    local _sizeList = self.SizeList;

    local function CalculatePos(DataDict)
        DataDict:Foreach(function(_, v)
            if not v.IsIgnore then
                local _item =  v.Item;
                v.EndPos = _curPos;
                _curPos = _curPos - _sizeList[_item.Layer];
                if v.Sub and v.IsSelect then
                    CalculatePos(v.Sub);
                end
            end
        end)
    end
    CalculatePos(self.UseNodeDic);
end

--设置所有位置
L_SetAllPos = function (self)
    local function SetPos(DataDict, isSelect)
        DataDict:Foreach(function(_, v)
            local _item =  v.Item;
            if _item.Trans then
                L_SetVisible(self, _item.Trans, isSelect);
                if isSelect then
                    UnityUtils.SetLocalPosition(_item.Trans, 0, v.EndPos, 0);
                end
                if v.Sub then
                    SetPos(v.Sub, v.IsSelect);
                end
            else
                print(_,v.Item.Layer)
            end
        end)
    end
    SetPos(self.UseNodeDic, true);
end

--通过keyQueue获取节点
L_GetNode = function (self, keyQueue)
    if type(keyQueue) == "table" and #keyQueue > 0 then
        local _node = self.UseNodeDic[keyQueue[1]]
        for i=2,#keyQueue do
            _node = _node.Sub[keyQueue[i]]
        end
        return _node;
    end
end

--显示节点信息
L_SelectNode = function(self, keyQueue, isSetDefault)
    if type(keyQueue) == "table" and #keyQueue > 0 then
        local _node = self.UseNodeDic[keyQueue[1]]
        _node.IsSelect = false;
        L_ClickCallBack(self, _node, isSetDefault);
        for i=2,#keyQueue do
            if _node.Sub then
                _node = _node.Sub[keyQueue[i]]
                _node.IsSelect = false;
                L_ClickCallBack(self, _node, isSetDefault);
            else
                Debug.LogTable(keyQueue,"Error [parameters Invalid]")
            end
        end
        return _node;
    end
end


--rootTrans：父节点，itemGobjList：每一级子物体列表，dataDict：数据，creatFinshedCallBack：创建按钮回调(Item)，onClickCallBack：点击回调
function UITitleListView:New(rootTrans, itemGobjList, dataDict, onCreatFinshedCallBack, onClickCallBack, onSetTitleListCallBack)
    --1.拷贝对象
    local _newTable = Utils.DeepCopy(self);
    _newTable.RootTrans = rootTrans;
    _newTable.ItemGobjList = itemGobjList;
    _newTable.DataDict = dataDict;
    _newTable.OnCreatFinshedCallBack = onCreatFinshedCallBack or function() end;
    _newTable.OnClickCallBack = onClickCallBack or function() end;
    _newTable.OnSetTitleListCallBack = onSetTitleListCallBack or function() end;
    return _newTable;
end

--初始化
function UITitleListView:Init()
    local _rootTrans = self.RootTrans;
    local _itemGobjList = self.ItemGobjList;
    --2.初始化对象池
    L_InitPool(self);
    --3.获取控件相关数据
    self.ScrollView = UIUtils.RequireUIScrollView(_rootTrans);
    self.ScrollView:ResetPosition();

    self.SizeList = List:New();
    for i=1,#_itemGobjList do
        self.SizeList:Add(UIUtils.GetSizeY(_itemGobjList[i].transform));
        _itemGobjList[i]:SetActive(false);
    end
    self.StartPosY = UIUtils.RequireUIPanel(_rootTrans):GetViewSize().y * 0.5 - self.SizeList[1] * 0.5;
    Debug.Log("panel的顶部的起始位置：",self.StartPosY);
    Debug.LogTable(self.SizeList,"SizeList");
    --4.创建所有Item
    self.UseNodeDic = Dictionary:New();
    L_CreateAllNode(self, self.UseNodeDic, self.DataDict, {});
    -- Debug.LogTable(self.UseNodeDic,"UseNodeDic")
    --5.设置初始位置
    L_CalculateAllPos(self);
    L_SetAllPos(self);
end

--通过keyQueue获取对应的Item
function UITitleListView:GetItem(keyQueue)
    local _node = L_GetNode(self, keyQueue);
    if _node then
        return _node.Item;
    end
end

--通过keyQueue选中对应的按钮
function UITitleListView:SelectNode(keyQueue)
    L_SelectNode(self, keyQueue);
end

--设置默认节点，切换大节点时，显示默认的界面
function UITitleListView:SetDefaultNode(keyQueue)
    self.DefaultKeyQueue = keyQueue
end

--刷新节点
function UITitleListView:RefreshNode(keyQueue)
    local _node = L_GetNode(self, keyQueue);
    if _node then
        L_SetTitleListCallBack(self, _node);
    end
end

--刷新所有节点
function UITitleListView:RefreshAllNode()
    local function RefreshNode(DataDict)
        DataDict:Foreach(function(_, v)
            --特殊处理（key为0时，不计算子节点位置）
            if not v.IsIgnore then
                L_SetTitleListCallBack(self, v);
                if v.Sub then
                    RefreshNode(v.Sub);
                end
            end
        end)
    end
    RefreshNode(self.UseNodeDic);
end

--刷新当前选中信息
function UITitleListView:RefreshSelectInfo()
    if self.CurSelectNode then
        self.OnClickCallBack(self.CurSelectNode.Item, true);
    end
end

--设置上一个大菜单自动收回
function UITitleListView:SetAudoShrink(isShrink)
    self.IsShrink = isShrink;
end

--设置只创建第一层，不创建子节点的keys
function UITitleListView:SetIgnoreKeys(keys)
    self.IgnoreKeys = keys;
end

--开始展开列表
local function PlayAnimation(Item);

end

--关闭当前展开的列表
local function CloseAnimation(Item);

end

return UITitleListView