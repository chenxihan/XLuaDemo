------------------------------------------------
--作者： gzg
--日期： 2019-04-3
--文件： UINewServerListForm.lua
--模块： UINewServerListForm
--描述： 服务器列表窗体
------------------------------------------------
local UIAreaButtonListPanel = require("UI.Forms.UINewServerListForm.UIAreaButtonListPanel.UIAreaButtonListPanel");
local UIServerListPanel = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerListPanel");
local UIServerCharListPanel = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerCharListPanel");
local UIServerItemData = require("UI.Forms.UINewServerListForm.UIServerListPanel.UIServerItemData");

--模块定义
local  UINewServerListForm = {
    --返回按钮
    BackBtn = nil,
    --标题，当前选中的服务器名
    TitleLabel = nil,
    --区域按钮列表Panel
    AreaButtonListPanel = nil,
    --服务器列表Panel
    ServerListPanel = nil,
    --背景纹理
    BgTexture = nil,

}

--继承Form函数
function UINewServerListForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISERVERLISTFORM_OPEN, self.OnOpen);
    self:RegisterEvent(UIEventDefine.UISERVERLISTFORM_CLOSE, self.OnClose);
end

function UINewServerListForm:OnFirstShow()
    self:FindAllComponents();
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBGBtnClick, self)
    self.CSForm.UIRegion = UIFormRegion.TopRegion;
end

function UINewServerListForm:OnShowBefore()
    self:LoadTexture(self.BgTexture,ImageTypeCode.UI,"bag_secon");
end

function UINewServerListForm:OnShowAfter()
    --Debug.LogError("UINewServerListForm:OnShowAfter");
    --判断是否有存在角色的服务器
    local groupID = 1;
    if GameCenter.ServerListSystem.ExistRoleList.Count > 0 then
        groupID = -1;
    elseif GameCenter.ServerListSystem.RecommendList.Count > 0 then
        groupID = -2;
    end
    self.AreaButtonListPanel:Refresh(GameCenter.ServerListSystem.GroupedList,groupID);
    self:RefreshServerList(groupID);    
    self:OnServerItemClick(UIServerItemData:NewForServerInfo(GameCenter.ServerListSystem.LastEnterServer));
end

function UINewServerListForm:OnHideBefore()
    self.ServerListPanel.CharListPanel:Hide();
end

--查找所有列表
function UINewServerListForm:FindAllComponents()
    local _myTrans = self.Trans;

    self.BgTexture = UIUtils.FindTex(_myTrans,"BGList/BgTexture");
    self.BackBtn = _myTrans:Find("Top/CloseBtn"):GetComponent("UIButton");
    self.TitleLabel = _myTrans:Find("Top/Title"):GetComponent("UILabel");
    local _serverListPanel = _myTrans:Find("Content/Right/ServerItemList/Panel/ServerGrid");
    local _hidePanel = _myTrans:Find("Content/Right/ServerItemList/Panel/Hide");
    local _charListPanel = _hidePanel:GetChild(0);
    local _btnListTrans = _myTrans:Find("Content/Left");
    self.AreaButtonListPanel = UIAreaButtonListPanel:Initialize(self,_btnListTrans);
    self.ServerListPanel = UIServerListPanel:Initialize(self,_serverListPanel,UIServerCharListPanel:Initialize(self,_charListPanel,_serverListPanel,_hidePanel));
    -- body
    --self.CSForm.UIRegion = UIFormRegion.TopRegion;
    -- self.BackBtnTrans = _myTrans:Find("AllBGContainer/CloseBtn")
    -- local pos = self.BackBtnTrans.localPosition
    -- LuaBehaviourManager:Add(self.BackBtnTrans, {Update=function()
    --     Debug.Log("==================")
    -- end})
end

--点击背景按钮
function UINewServerListForm:OnBGBtnClick()
    self.ServerListPanel.CharListPanel:Hide();
    self:OnClose();
end
--刷新服务器列表
function UINewServerListForm:RefreshServerList(groupID)
   if groupID == -1 then
      self.ServerListPanel:Refresh(GameCenter.ServerListSystem.ExistRoleList);  
   elseif groupID == -2 then
      self.ServerListPanel:Refresh(GameCenter.ServerListSystem.RecommendList);  
   else
      self.ServerListPanel:Refresh(GameCenter.ServerListSystem.GroupedList[groupID]);
   end 
end

--当选择角色Item
function UINewServerListForm:OnCharItemClick(serID,charID)    
    GameCenter.LoginSystem:ConnectGameServer(serID,charID);    
end

--服务器Item被点击
function UINewServerListForm:OnServerItemClick(serdata)
    self.TitleLabel.text = string.format("%s %s",serdata.Area,serdata.Name);
end

--服务器ID被选择
function UINewServerListForm:OnChooseServerID(serID)
    GameCenter.ServerListSystem.ChooseGameServerID = serID;
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UIENTERGAMEFORM_REFRESH);
    self.ServerListPanel.CharListPanel:Hide();
    self:OnClose();
end
return UINewServerListForm;