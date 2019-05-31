------------------------------------------------
--作者： gzg
--日期： 2019-04-9
--文件： UICompContainer.lua
--模块： UICompContainer
--描述： UI组件容器,用于不定长度的组件列表
------------------------------------------------

local UICompContainer = {
    --空闲队列new List<TUI>();
    FreeList = List:New(),

    --使用的队列 new Dictionary<TData, TUI>();
    UsedDict = Dictionary:New(),

    --模板
    Template = nil,

    --新的对象回调
    NewCallBack = nil,
}


--创建一个实例
function UICompContainer:New()
    local _m = Utils.DeepCopy(self);
    return _m;
end

--设置创建一个新的对象回调 MyAction<TUI>
function UICompContainer:SetNewCallBack(callBack)
    self.NewCallBack = callBack;
end

--清理
function UICompContainer:Clear()
    self.FreeList:Clear();
    self.UsedDict:Clear();
    self.Template = nil;
    self.NewCallBack = nil;
end

--添加新的组件TUI compInfo
function UICompContainer:AddNewComponent(compInfo)
    self.FreeList:Add(compInfo);
    compInfo:SetActive(false);
    if (self.FreeList:Count() == 1) then
        self:SetTemplate();
    end
end

--设置模板TUI btn
function UICompContainer:SetTemplate(btn)
    self.Template = btn;
    if (btn == nil) then
        if (self.FreeList:Count() > 0) then
            self.Template = self.FreeList[1];
        end
    end
end

--把所有的组件都体会到Free队列
function UICompContainer:EnQueueAll()
    if (self.UsedDict:Count() > 0) then
        self.UsedDict:ForeachReverse(function(_, v)
            v:SetActive(false);
            v:SetName("_");
            self.FreeList:Add(v,1);
        end)
        self.UsedDict:Clear();
    end
end

--把某个对象回退掉队列中TData type
function UICompContainer:EnQueue(type)
    local btn = self.UsedDict[type];
    if btn ~= nil then
        btn:SetActive(false);
        btn:SetName("_");
        self.FreeList:Add(btn);
    end
    self.UsedDict[type] = nil;
end

--从队列中获取一个TData type
--return TUI
function UICompContainer:DeQueue(type)
    local result = nil;
    local cnt = self.FreeList:Count();
    if (cnt > 0) then
        --从空闲表中读取第一个
        result = self.FreeList:RemoveAt(1);
    else
        if (self.Template ~= nil) then
            result = self.Template:Clone();
            if (self.NewCallBack ~= nil) then
                self.NewCallBack(result);
            end
        end
    end

    if (result ~= nil) then
        result:SetData(type);
        result:SetActive(true);
        self.UsedDict[type] = result;
    end
    return result;
end

--获取使用的UI对象TData type
--return TUI
function UICompContainer:GetUsedUI(type)
    return self.UsedDict[type];
end

--获取正在被使用的组件的数量
function UICompContainer:GetUsedCount()
    return self.UsedDict:Count();
end


-- 重新刷新所有对象的数据
function UICompContainer:RefreshAllUIData()
    for k, v in pairs(self.UsedDict) do
        v:RefreshData();
    end   
end

return UICompContainer;