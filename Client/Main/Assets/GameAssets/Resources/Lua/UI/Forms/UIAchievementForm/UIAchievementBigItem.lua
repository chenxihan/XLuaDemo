------------------------------------------------
--==============================--
--作者： xihan
--日期： 2019-05-26
--文件： UIAchievementBigItem.lua
--模块： UIAchievementBigItem
--描述： 成就Item
--==============================--

local UIAchievementBigItem = {
    --当前Item的所有者对象
    Owner = nil,
    --当前Item关联的GameObject
    GO = nil,
    --当前Item关联的Transform
    Trans = nil,
    --当前Item使用数据对象.
    Data = nil,
    --进度条
    ProgressBar = nil,
    --进度
    ProLable = nil,
    --名称
    NameLable = nil,
}

--New函数
function UIAchievementBigItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.GO = trans.gameObject;
    _m.Trans = trans;
    _m:FindAllComponent();
    return _m;
end

--查找组件
function UIAchievementBigItem:FindAllComponent()
    local _myTrans = self.Trans;
    self.ProgressBar = UIUtils.FindProgressBar(_myTrans,"Progress");
    self.ProLable = UIUtils.FindLabel(_myTrans,"Progress/Label");
    self.NameLable = UIUtils.FindLabel(_myTrans,"Name");
end

--设置Active
function UIAchievementBigItem:SetActive(active)
    self.GO:SetActive(active);
end

--设置数据或者配置文件
function UIAchievementBigItem:SetData(data)
    self.Data = data;
end
--创新数据
function UIAchievementBigItem:RefreshData()
    if(self.Data ~= nil) then
        local _data = self.Data;
        self.NameLable.text = _data.Name;
        local _count = GameCenter.AchievementSystem:GetFinishAcievementCountByType(_data.Type);
        self.ProLable.text = string.format( "(%s/%s)",_count,2000);
        self.ProgressBar.value = _count/2000;
    else
        Debug.LogError("UIAchievementBigItem:当前数据为nill");
    end
end

return UIAchievementBigItem;