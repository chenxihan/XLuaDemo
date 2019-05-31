
------------------------------------------------
--作者： 王圣
--日期： 2019-05-17
--文件： UIFuDiDuoBaoForm.lua
--模块： UIFuDiDuoBaoForm
--描述： 宗派福地夺宝
------------------------------------------------

-- c#类
local UIDuoBaoDes = require "UI.Forms.UIFuDiDuoBaoForm.UIDuoBaoDes"
local UIFuDiDuoBaoForm = {
    DesCount = 4,
    CloneId = 20101,
    CurScore = 0,
    TimeLabel = nil,
    GoToBtn = nil,
    CloseBtn = nil,
    ItemGrid = nil,
    TempItem = nil,
    DesList = List:New(),
    ItemList = List:New(),
}
--继承Form函数
function UIFuDiDuoBaoForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIFuDiDuoBaoForm_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFuDiDuoBaoForm_Close,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIDUOBAO,self.OnUpdate)
end

function UIFuDiDuoBaoForm:OnFirstShow()
    self:FindAllComponents()
end

function UIFuDiDuoBaoForm:OnShowAfter()
    
end

function UIFuDiDuoBaoForm:OnHideBefore()
    
end

function UIFuDiDuoBaoForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:SetForm()
    GameCenter.FuDiSystem:ReqSnatchPanel()
end

function UIFuDiDuoBaoForm:OnUpdate(obj,sender)
    if obj ~= nil then
        self.CurScore = obj
    end
    local globCfg = DataConfig.DataGlobal[1501]
    if globCfg ~= nil then
        local list = Utils.SplitStr(globCfg.Params,';')
        local min = 0
        local max = 0
        for i = 1,#list do
            if i< #self.DesList then
                self.DesList[i].Select.gameObject:SetActive(false)
            end
            local subList = Utils.SplitStr(list[i],'_')
            min = tonumber(subList[1])
            max = tonumber(subList[2])
            if self.CurScore>=min and self.CurScore<=max then
                if i< #self.DesList then
                    self.DesList[i].Select.gameObject:SetActive(true)
                end 
            end
        end
    end
end

function UIFuDiDuoBaoForm:OnClickClose()
    self:OnClose()
end

--点击前往副本
function UIFuDiDuoBaoForm:OnClickGoTo()
    GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(self.CloneId);
end

function UIFuDiDuoBaoForm:FindAllComponents()
    for i = 1,self.DesCount do
        local path = string.format( "Center/Sprite/Grid/Des_%s",i-1)
        local trans = self.Trans:Find(path)
        local des = UIDuoBaoDes:New(trans)
        self.DesList:Add(des)
    end
    self.TimeLabel = UIUtils.RequireUILabel(self.Trans:Find("Center/Sprite/Time"))
    self.GoToBtn = UIUtils.RequireUIButton(self.Trans:Find("Center/GoTo"))
    UIUtils.AddBtnEvent(self.GoToBtn,self.OnClickGoTo,self)
    self.ItemGrid = UIUtils.RequireUIGrid(self.Trans:Find("Center/Sprite/Reward/BRGrid"))
    for i = 1,self.ItemGrid.transform.childCount-1 do
        local item = UIUtils.RequireUIItem(self.ItemGrid.transform.GetChild(i))
        self.ItemList:Add(item)
    end
    self.TempItem = self.Trans:Find("Center/Sprite/Reward/BRGrid/TempItem")
    self.TempItem.gameObject:SetActive(false)
    self.CloseBtn = UIUtils.RequireUIButton(self.Trans:Find("Right/Close"))
    UIUtils.AddBtnEvent(self.CloseBtn,self.OnClickClose,self)
end

function UIFuDiDuoBaoForm:SetForm()
    --设置描述
    self.DesList[1].DesLabel.text = DataConfig.DataMessageString.Get("GUILD_SCORE_DES1")
    self.DesList[2].DesLabel.text = DataConfig.DataMessageString.Get("GUILD_SCORE_DES2")
    self.DesList[3].DesLabel.text = DataConfig.DataMessageString.Get("GUILD_SCORE_DES3")
    self.DesList[4].DesLabel.text = DataConfig.DataMessageString.Get("GUILD_SCORE_DES4")
    --设置奖励
    for i = 1,#self.ItemList do
        self.ItemList[i].gameObject:SetActive(false)
    end
    local cfg = DataConfig.DataDaily[19]
    local list = Utils.SplitStr(cfg.Reward,'_')
    if list ~= nil then
        for i = 1,#list do
            local item = nil
            if i> #self.ItemList then
                local go = UIUtility.Clone(self.TempItem.gameObject)
                item = UIUtils.RequireUIItem(go.transform)
                self.ItemList:Add(item)
            else
                item = self.ItemList[i]
            end
            item.gameObject:SetActive(true)
            local id = tonumber(list[i])
            item:InitializationWithIdAndNum(id,0)
        end
    end
    self.ItemGrid.repositionNow = true
end
return UIFuDiDuoBaoForm