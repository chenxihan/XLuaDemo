------------------------------------------------
--==============================--
--作者： xihan
--日期： 2019-05-24
--文件： UIAchievementSmallItem.lua
--模块： UIAchievementSmallItem
--描述： 成就Item
--==============================--

local UIAchievementSmallItem = {
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
    --描述
    DescLable  = nil,
    --uiitem
    UIItem = nil,
    --按钮
    Button = nil,
    --按钮
    ButtonGO = nil,
    --红点
    RedPointGO = nil,
    --已领取
    GetedGO = nil,
    --未完成
    UnfinishedGO = nil,
}

--New函数
function UIAchievementSmallItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.GO = trans.gameObject;
    _m.Trans = trans;
    _m:FindAllComponent();
    return _m;
end

--查找组件
function UIAchievementSmallItem:FindAllComponent()
    local _myTrans = self.Trans;
    self.ProgressBar = UIUtils.FindProgressBar(_myTrans,"Progress");
    self.ProLable = UIUtils.FindLabel(_myTrans,"ProLable");
    self.NameLable = UIUtils.FindLabel(_myTrans,"Name");
    self.DescLable = UIUtils.FindLabel(_myTrans,"Desc");
    self.UIItem = UIUtils.RequireUIItem(UIUtils.FindTrans(_myTrans,"UIItem"));
    self.Button = UIUtils.FindBtn(_myTrans,"Button");
    self.ButtonGO = self.Button.gameObject;
    self.RedPointGO = UIUtils.FindGo(_myTrans,"RedPoint");
    self.GetedGO = UIUtils.FindGo(_myTrans,"Geted");
    self.UnfinishedGO = UIUtils.FindGo(_myTrans,"Unfinished");
    UIUtils.AddBtnEvent(self.Button, self.OnClickCallBack, self);
end

--克隆一个对象
function UIAchievementSmallItem:Clone()
    local _go = GameObject.Instantiate(self.GO);
    local _trans = _go.transform;
    _trans.parent = self.Trans.parent;
    UnityUtils.ResetTransform(_trans);
    return UIAchievementSmallItem:New(self.Owner, _trans);
end

--设置Active
function UIAchievementSmallItem:SetActive(active)
    self.GO:SetActive(active);
end

--设置数据或者配置文件
function UIAchievementSmallItem:SetData(data)
    self.Data = data;
end
--创新数据
function UIAchievementSmallItem:RefreshData()
    if(self.Data ~= nil) then
        local _data = self.Data;
        local _dataAchievementItem = _data.DataAchievementItem;

        self.GetedGO:SetActive(_data.State == AchievementState.Finish);
        self.UnfinishedGO:SetActive(_data.State == AchievementState.None);
        self.ButtonGO:SetActive(_data.State == AchievementState.CanGet);
        self.NameLable.text = _dataAchievementItem.Name;
        self.DescLable.text = _dataAchievementItem.Instructions;
        self.UIItem:InitializationWithIdAndNum(_data.AwardItemId,_data.AwardItemCount)

        if _data.State == AchievementState.None then
            -- self.ProgressBar.value = GameCenter.VariableSystem.GetVariableShowProgress(_data.FunctionId,_data.Count);
            local _item = GameCenter.AchievementSystem.UnfinishedAchievementInfoDic[_data.Id];
            local _value = _item and _item.pro or 0;
            _value = math.Clamp(_value/_data.Count, 0, 1);
            -- local _value = GameCenter.VariableSystem.GetVariableShowProgress(_data.FunctionId,_data.Count);
            self.ProLable.text = math.floor(_value*100) .. "%";
            self.ProgressBar.value = _value;
        else
            self.ProgressBar.value = 1;
            --FunctionVariableIdCode.PlayerTaskID:
            if _data.FunctionId == 2 then 
                self.ProLable.text = "";
            --FunctionVariableIdCode.ActivateTitle
            elseif _data.FunctionId == 10 then
                self.ProLable.text = "1/1";
            else
                self.ProLable.text = string.format( "%s/%s",_data.Count, _data.Count);
            end
        end

        self.RedPointGO:SetActive(_data.State == AchievementState.CanGet)
        self:SetName(self.Data.Id);
    else
        Debug.LogError("UIAchievementSmallItem:当前数据为nill");
    end
end

--设置名字
function UIAchievementSmallItem:SetName(name)
    self.GO.name = name;
end

--点击领取
function UIAchievementSmallItem:OnClickCallBack()
    GameCenter.AchievementSystem:SendGetMsg(self.Data.Id)
end

return UIAchievementSmallItem;