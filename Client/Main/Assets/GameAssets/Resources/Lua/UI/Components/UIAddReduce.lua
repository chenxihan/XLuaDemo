------------------------------------------------
--作者： 何健
--日期： 2019-05-24
--文件： UIAddReduce.lua
--模块： UIAddReduce
--描述： 带加减按钮的数字输入公用控件
------------------------------------------------

local UIAddReduce = {
    Trans = nil,
    Go = nil,
    ValueLabel = nil,
    InputBtn = nil,
    --加
    AddBtn = nil,
    AddBtnGo = nil,
    --减
    SubBtn = nil,
    --计时，用于长按加减时响应
    DeltaTime = 0.0,
    --是否长按状态
    IsPress = false,
    IsAddBtn = false,
    -- 点击输入框的回调
    OnClickInputFunc = nil,
    -- 长按按钮的回调,第一个参数true为加按钮,false为减按钮
    OnUpdateValueFunc = nil,
}
--创建一个新的对象
function UIAddReduce:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    LuaBehaviourManager:Add(_m.Trans, _m)
    return _m
end

--查找控件
function UIAddReduce:FindAllComponents()
    self.ValueLabel = UIUtils.FindLabel(self.Trans, "LevelLabel")
    self.InputBtn = UIUtils.FindBtn(self.Trans, "LevelLabel")
    self.AddBtn = UIUtils.FindBtn(self.Trans, "AddBtn")
    self.AddBtnGo = UIUtils.FindGo(self.Trans, "AddBtn")
    self.SubBtn = UIUtils.FindBtn(self.Trans, "JianBtn")

    UIUtils.AddBtnEvent(self.InputBtn, self.OnClickInputBtn, self)
    UIEventListener.Get(self.AddBtnGo).onPress = Utils.Handler(self.OnPressBtn, self)
    UIEventListener.Get(self.SubBtn.gameObject).onPress = Utils.Handler(self.OnPressBtn, self)
end

--绑定回调
function UIAddReduce:SetCallBack(clickFunc, inputFunc)
    self.OnUpdateValueFunc = clickFunc
    self.OnClickInputFunc = inputFunc
end

function UIAddReduce:Update()
    if self.IsPress then
        self.DeltaTime = self.DeltaTime + Time.GetDeltaTime()
        if self.DeltaTime >= 0.15 then
            self.DeltaTime = 0.0
            self.OnUpdateValueFunc(self.IsAddBtn)
        end
    end
end

--设置输入框的文字显示
function UIAddReduce:SetValueLabel(text)
    self.ValueLabel.text = text
end

function UIAddReduce:OnPressBtn(go, state)
    self.DeltaTime = 0.0
    self.IsPress = state
    self.IsAddBtn = go == self.AddBtnGo
    if (self.IsPress == false) then
        self.OnUpdateValueFunc(self.IsAddBtn)
    end
end
function UIAddReduce:OnClickInputBtn(go)
    if self.OnClickInputFunc ~= nil then
        self.OnClickInputFunc()
    end
end
return UIAddReduce