------------------------------------------------
--==============================--
--作者： gzg
--日期： 2019-05-13
--文件： UIFeedBackItem.lua
--模块： UIFeedBackItem
--描述： 反馈信息的展示Item
--==============================--

local UIFeedBackItem = {
    --当前Item的所有者对象
    Owner = nil,
    --当前Item关联的GameObject
    GO = nil,
    --当前Item关联的Transform
    Trans = nil,
    --当前Item使用数据对象.
    Data = nil,

    --左边GM的信息Go
    LeftGo = nil,
    --右边我的信息Go
    RightGo = nil,
    --时间Go
    TimeGo = nil,
    --左边GM信息Label
    LeftLabel = nil,
    --左边GM信息的背景
    LeftBackSprite = nil,    
    --右边我的信息Label
    RightLabel = nil,
    --右边我的信息背景
    RightBackSprite = nil,
    --时间
    TimeLabel = nil,
}

--New函数
function UIFeedBackItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.GO = trans.gameObject;
    _m.Trans = trans;
    _m:FindAllComponent();
    return _m;
end

function UIFeedBackItem:FindAllComponent()
    local _myTrans = self.Trans;
    self.LeftGo = UIUtils.FindGo(_myTrans,"Left");
    self.RightGo = UIUtils.FindGo(_myTrans,"Right");
    self.TimeGo = UIUtils.FindGo(_myTrans,"Time");
    self.LeftLabel = UIUtils.FindLabel(_myTrans,"Left/Container/Text");
    self.LeftBackSprite = UIUtils.FindSpr(_myTrans,"Left/Container/Back");
    self.RightLabel = UIUtils.FindLabel(_myTrans,"Right/Container/Text");
    self.RightBackSprite = UIUtils.FindSpr(_myTrans,"Right/Container/Back");
    self.TimeLabel = UIUtils.FindLabel(_myTrans,"Time/Text");
end

--克隆一个对象
function UIFeedBackItem:Clone()
    local _go = GameObject.Instantiate(self.GO);
    local _trans = _go.transform;
    _trans.parent = self.Trans.parent;
    UnityUtils.ResetTransform(_trans);
    return UIFeedBackItem:New(self.Owner, _trans);
end

--设置Active
function UIFeedBackItem:SetActive(active)
    self.GO:SetActive(active);
end

--设置数据或者配置文件
function UIFeedBackItem:SetData(dat)
    self.Data = dat;
end
--创新数据
function UIFeedBackItem:RefreshData()
    if(self.Data ~= nil) then
       if self.Data.Sender == 0 then           
            self.LeftGo:SetActive(false);
            self.RightGo:SetActive(false);
            self.TimeGo:SetActive(true);
            self.TimeLabel.text = self.Data.Content;
       else
            if self.Data.Sender == 1 then
                self.LeftGo:SetActive(true);
                self.RightGo:SetActive(false);
                self.TimeGo:SetActive(false);
                self.LeftLabel.text = self.Data.Content;               
            else
                self.LeftGo:SetActive(false);
                self.RightGo:SetActive(true);
                self.TimeGo:SetActive(false);
                self.RightLabel.text = self.Data.Content;
            end
       end  
    else
        Debug.LogError("UIServerPairItem:当前数据为null");
    end
end
--设置名字
function UIFeedBackItem:SetName(name)
    self.GO.name = name; 
end
return UIFeedBackItem;