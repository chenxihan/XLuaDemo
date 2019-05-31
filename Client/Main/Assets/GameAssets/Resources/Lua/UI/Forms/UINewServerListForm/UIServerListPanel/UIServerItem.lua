------------------------------------------------
--作者： gzg
--日期： 2019-04-3
--文件： UIServerItem.lua
--模块： UIServerItem
--描述： 服务器列表的服务器器Item
------------------------------------------------
local ServerStatusCode = CS.Funcell.Code.Logic.ServerStatusCode
local ServerFlagCode = CS.Funcell.Code.Logic.ServerFlagCode

--模块定义
local UIServerItem = 
{
    --所有者
    Owner = nil,
    --数据
    Data = nil,
    --当前对象GameObject
    GO = nil,
    --当前对象的Transfrom
    Trans = nil,
    --区域描述
    AreaLabel = nil,
    --名字
    NameLabel = nil,
    --标记的对象
    FlagGo = nil,
    --标记描述: 新服,火爆,推荐
    FlagLabel = nil,
    --标记备注
    FlagBgSprite = nil,
    --状态图标: 拥挤,流畅,维护
    StatusIcon = nil,
    --当前对象的按钮
    ItemButton = nil,
    --被选择后的标记
    SelectedGO = nil,
    --是否有角色的标记
    HasRoleTagGO = nil,
};

--创建新的对象
function UIServerItem:New(owner,trans)
    local _m = Utils.DeepCopy(self);
    _m.Trans = trans;
    _m.GO = trans.gameObject;    
    _m.Owner = owner;
    _m:FindAllComponents();
    return _m;
end

--查找并赋值组件
function UIServerItem:FindAllComponents()
    local _trans = self.Trans;    
    self.AreaLabel = _trans:Find("AreaLabel"):GetComponent("UILabel");
    self.NameLabel = _trans:Find("NameLabel"):GetComponent("UILabel");
    self.FlagGo = _trans:Find("Flag").gameObject;
    self.FlagBgSprite = self.FlagGo:GetComponent("UISprite");
    self.FlagLabel = _trans:Find("Flag/FlagLabel"):GetComponent("UILabel");
    self.StatusIcon = _trans:Find("StateIcon"):GetComponent("UISprite");
    self.ItemButton = _trans:GetComponent("UIButton");
    self.SelectedGO = _trans:Find("SelectTag").gameObject;
    self.HasRoleTagGO = _trans:Find("HasRoleTag").gameObject;

    self.ItemButton.onClick:Clear();
    EventDelegate.Add(self.ItemButton.onClick, Utils.Handler(self.OnItemButtonClick,self));
end

--按钮点击的处理
function UIServerItem:OnItemButtonClick()    
    self.Owner:OnServerItemClick(self.Data);    
end

--刷新数据
function UIServerItem:Refresh(dat)
    self.Data = dat;
    if(self.Data ~= nil) then        
        self.GO:SetActive(true);
        self.AreaLabel.text = dat.Area;
        self.NameLabel.text = dat.Name;        
        self.FlagLabel.text = UIServerItem:GetFlagText(dat.Flag);
        self.FlagBgSprite.spriteName = UIServerItem:GetFlagBgSpriteName(dat.Flag);
        self.StatusIcon.spriteName =  UIServerItem:GetStatusSpriteName(dat.Status);
        self.StatusIcon.IsGray = (dat.Status == ServerStatusCode.SSC_MAINTAIN);
        self.SelectedGO:SetActive(dat.IsSelected);
        self.HasRoleTagGO:SetActive(dat.HasRole);
        self.FlagGo:SetActive(dat.Status ~= ServerStatusCode.SSC_MAINTAIN);
    else
        self.GO:SetActive(false);
    end
end

function UIServerItem:GetFlagText(flag)
   if flag == ServerFlagCode.SFC_NEW then
        return "新服";
   elseif flag == ServerFlagCode.SFC_RECOMMEND then
        return "热荐";
   else
        return "火爆";
   end  
end

function UIServerItem:GetFlagBgSpriteName(flag)
    if flag == ServerFlagCode.SFC_HOT then
        return "server_fiery";        
    elseif flag == ServerFlagCode.SFC_RECOMMEND then
        return "server_recommend";
    else
        return "server_new";
    end
end

function UIServerItem:GetStatusSpriteName(status)
    if status == ServerStatusCode.SSC_IDLE then
        return "server_fluent";
    else
        return "server_hot";
    end
end

return UIServerItem;