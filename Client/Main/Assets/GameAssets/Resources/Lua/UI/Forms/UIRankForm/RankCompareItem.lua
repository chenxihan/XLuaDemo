------------------------------------------------
--作者： 王圣
--日期： 2019-04-30
--文件： RankCompareItem.lua
--模块： RankCompareItem
--描述： 排行榜行属性对比组件
------------------------------------------------

-- c#类
local RankCompareItem = {
    FuncId = 0,
    Trans = nil,
    --spr
    Icon = nil,
    --btn
    UpBtn = nil,
    --slider
    MyProcess = nil,
    OtherProcess = nil,
    --label
    MyValue = nil,
    OtherValue = nil,
    NameLabel = nil,
}

function RankCompareItem:New(trans)
    if not trans then
        return nil
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m:FindAllComponent()
    return _m
end

function RankCompareItem:FindAllComponent()
    self.Icon = UIUtils.RequireUIIconBase(self.Trans:Find("Icon"))
    self.UpBtn = UIUtils.RequireUIButton(self.Trans:Find("Upbtn"))
    UIUtils.AddBtnEvent(self.UpBtn,self.OnClickUpBtn,self)
    self.MyProcess = UIUtils.RequireUISlider(self.Trans:Find("Bar2"))
    self.OtherProcess = UIUtils.RequireUISlider(self.Trans:Find("Bar1"))
    self.MyValue = UIUtils.RequireUILabel(self.Trans:Find("Bar2/Value"))
    self.OtherValue = UIUtils.RequireUILabel(self.Trans:Find("Bar1/Value"))
    self.NameLabel = UIUtils.RequireUILabel(self.Trans:Find("Name"))
end

function RankCompareItem:SetData(data)
    self.FuncId = data.FuncId
    self.MyValue.text = tostring(data.OwenParam)
    self.OtherValue.text = tostring(data.OtherParam)
    if data.OtherParam ~= 0 then
        self.MyProcess.value = data.OwenParam/data.OtherParam
        self.OtherProcess.value = 1
    else
        if data.OwenParam == 0 then
            self.MyProcess.value = 0
        else
            self.MyProcess.value = 1
        end
        self.OtherProcess.value = 0
    end
    --设置图标
    self.Icon:UpdateIcon(data.IconId)
    --设置名字
    self.NameLabel.text = data.Name
end

function RankCompareItem:OnClickUpBtn()
--打开FuncId对应的功能UI
    GameCenter.MainFunctionSystem:DoFunctionCallBack(self.FuncId)
    GameCenter.PushFixEvent(UIEventDefine.UI_RANK_FORM_CLOSE)
end

function RankCompareItem:Destory()
    CS.UnityEngine.Object.Destory(self.Trans.gameObject)
end
return RankCompareItem
