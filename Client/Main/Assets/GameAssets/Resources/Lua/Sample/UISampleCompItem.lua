------------------------------------------------
--==============================--
--作者： gzg
--日期： 2019-04-19 06:19:18
--文件： UISampleCompItem.lua
--模块： UISampleCompItem
--描述： 用于UICompContainer组件容器的Item示例,当创建一个Item的话,需要把下面的函数都复制过去.(必选)
--==============================--

local UISampleCompItem = {
    --当前Item的所有者对象
    Owner = nil,
    --当前Item关联的GameObject
    GO = nil,
    --当前Item关联的Transform
    Trans = nil,
    --当前Item使用数据对象.
    Data = nil,
}

--New函数
function UISampleCompItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.GO = trans.gameObject;
    _m.Trans = trans;
    _m:FindAllComponent();
    return _m;
end

--克隆一个对象
function UISampleCompItem:Clone()
    return UISampleCompItem:New(self.Owner, UnityUtils.Clone(self.GO).transform);
end

--设置Active
function UISampleCompItem:SetActive(active)
    self.GO:SetActive(active);
end

--设置数据或者配置文件
function UISampleCompItem:SetData(dat)
    self.Data = dat;
end
--创新数据
function UISampleCompItem:RefreshData()
    if(self.Data ~= nil) then
        --ToDo      
    else
        Debug.LogError("UIServerPairItem:当前数据为null");
    end
end
--设置名字
function UISampleCompItem:SetName(name)
    self.GO.name = name; 
end
return UISampleCompItem;