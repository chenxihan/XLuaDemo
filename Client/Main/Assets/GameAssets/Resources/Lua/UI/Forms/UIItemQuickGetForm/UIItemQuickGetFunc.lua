------------------------------------------------
--作者： yangqf
--日期： 2019-05-30
--文件： UIItemQuickGetFunc.lua
--模块： UIItemQuickGetFunc
--描述： 物品快速获取的功能条目
------------------------------------------------

local UIItemQuickGetFunc = {
    --父UI
    Parent = nil,
    --根节点
    RootGo = nil,
    RootTrans = nil,
    --按钮
    Btn = nil,
    --功能名字
    FuncName = nil,
    --未开启标志
    NotOpenGo = nil,

    --功能id
    FuncId = 0,
    --功能参数
    FuncParam = nil,
}

function UIItemQuickGetFunc:New(trans, parent)
    local _result = Utils.DeepCopy(UIItemQuickGetFunc);
    _result.Parent = parent;
    _result.RootGo = trans.gameObject;
    _result.RootTrans = trans;
    _result.Btn = UIUtils.FindBtn(trans, "Back");
    _result.FuncName = UIUtils.FindLabel(trans, "Back/Desc");
    _result.NotOpenGo = UIUtils.FindGo(trans, "Back/NotOpen");
    UIUtils.AddBtnEvent( _result.Btn, _result.OnBtnClick, _result);
    return _result;
end

function UIItemQuickGetFunc:Refresh(funcId, name, param)
    self.FuncId = funcId;
    self.FuncParam = param;
    self.FuncName.text = name;
    local _funcIsVisable = GameCenter.MainFunctionSystem:FunctionIsVisible(funcId);
    self.NotOpenGo:SetActive(_funcIsVisable == false);

end

function UIItemQuickGetFunc:OnBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(self.FuncId, self.FuncParam);
    self.Parent:OnClose(nil, nil);
end

return UIItemQuickGetFunc;