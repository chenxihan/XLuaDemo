------------------------------------------------
--作者： 何健
--日期： 2019-05-14
--文件： UIGuildWelfareItem.lua
--模块： UIGuildWelfareItem
--描述： 宗派活动子控件
------------------------------------------------
local UIItem = require "UI.Components.UIItem"

local UIGuildWelfareItem = {
    Trans = nil,
    Go = nil,
    --名字
    NameLabel = nil,
    --描述
    DescLabel = nil,
    --按钮显示文字
    BtnNameLabel = nil,
    Btn = nil,
    BtnGo = nil,
    Icon = nil,
    Table = nil,
    TableGo = nil,
    TableTrans = nil,
    RewardTipsGo = nil,
    Item = nil,
    DataInfo = nil
}
local GuildWelfareBtnEnum ={
    OpenForm = 1
}

--创建一个新的对象
function UIGuildWelfareItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end
 --创建一个新的对象
function UIGuildWelfareItem:New(go)
    local _m = Utils.DeepCopy(self)
    _m.Trans = go.transform
    _m.Go = go
    _m:FindAllComponents()
    return _m
 end

 --克隆一个对象
function UIGuildWelfareItem:Clone()
    local _trans = UnityUtils.Clone(self.Go)
    return UIGuildWelfareItem:New(_trans)
end

 --查找UI上各个控件
 function UIGuildWelfareItem:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "NameLabel")
    self.DescLabel = UIUtils.FindLabel(self.Trans, "DscLabel")
    self.Btn = UIUtils.FindBtn(self.Trans, "Btn")
    self.BtnGo = UIUtils.FindGo(self.Trans, "Btn")
    self.BtnNameLabel = UIUtils.FindLabel(self.Trans, "Btn/Label")
    self.Icon = UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Icon"), "Funcell.GameUI.Form.UIIconBase")
    self.Item = UIItem:New(UIUtils.FindTrans(self.Trans, "Table/1"))
    self.RewardTipsGo = UIUtils.FindGo(self.Trans, "RewardDscLabel")
    self.Table = UIUtils.FindTable(self.Trans, "Table")
    self.TableGo = UIUtils.FindGo(self.Trans, "Table")
    self.TableTrans = UIUtils.FindTrans(self.Trans, "Table")

    UIUtils.AddBtnEvent(self.Btn, self.OnClickBtn, self)
 end

  --更新物品
  function UIGuildWelfareItem:OnUpdateItem(info)
    if info == nil then
        Debug.LogError("加载错误，数据为空")
        return
    end
    self.DataInfo = info
    self.NameLabel.text = info.Name
    self.DescLabel.text = info.Describe
    if info.ButtonName == nil or info.ButtonName == "" or info.Function == nil or info.Function == "" then
        self.BtnGo:SetActive(false)
    else
        self.BtnGo:SetActive(true)
        self.BtnNameLabel.text = info.ButtonName
    end
    self.Icon:UpdateIcon(info.Icon)
    if info.RewardItem ~= nil and info.RewardItem ~= "" then
        self.TableGo:SetActive(true)
        self.RewardTipsGo:SetActive(true)
        for i = 0, self.TableTrans.childCount - 1 do
            self.TableTrans:GetChild(i).gameObject:SetActive(false)
        end
        local _array = Utils.SplitStr(info.RewardItem, ";")
        for i = 1, #_array do
            local _single = Utils.SplitStr(_array[i], "_")
            if #_single == 2 then
                local _item = nil
                if i > self.TableTrans.childCount then
                    _item = self.Item:Clone()
                else
                    _item = UIItem:New(self.TableTrans:GetChild(i - 1))
                end
                if _item ~= nil then
                    _item.RootGO:SetActive(true)
                    _item:InItWithCfgid(tonumber(_single[1]), tonumber(_single[2]), false, false)
                end
            end
        end
        self.Table.repositionNow = true
    else
        self.TableGo:SetActive(false)
        self.RewardTipsGo:SetActive(false)
    end
 end

 function UIGuildWelfareItem:OnClickBtn()
    if self.DataInfo == nil then
        Debug.LogError("加载错误，数据为空")
        return
    end
    if self.DataInfo.Function ~= nil and self.DataInfo.Function ~= "" then
        local _array = Utils.SplitStr(self.DataInfo.Function, "_")
        if #_array == 2 then
            local _btnType = tonumber(_array[1])
            local _function = tonumber(_array[2])
            local _CSfunction = FunctionStartIdCode.__CastFrom(_function)
            if _btnType == GuildWelfareBtnEnum.OpenForm then
                if _CSfunction == FunctionStartIdCode.GuildActiveBaby then
                    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GUILD_ACTIVEBABY_OPEN)
                else
                    GameCenter.MainFunctionSystem:DoFunctionCallBack(_CSfunction, nil)
                end
            end
        end
    end
 end
return  UIGuildWelfareItem