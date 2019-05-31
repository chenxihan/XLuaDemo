------------------------------------------------
--作者： yangqf
--日期： 2019-05-21
--文件： UIStarCopyIcon.lua
--模块： UIStarCopyIcon
--描述： 星级副本奖励的icon
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--关卡头像
local UIStarCopyIcon = {
    --按钮
    Btn = nil,
    --背景图片
    BackTex = nil,
    --星星
    Stars = nil,
    --副本名字
    Name = nil,
    --选择go
    SelectGo = nil,
    --父UI
    Parent = nil,
    --form根节点
    RootForm = nil,
    --副本配置
    CopyCfg = nil,
}

function UIStarCopyIcon:New(trans, parent, rootForm)
    local _result = Utils.DeepCopy(UIStarCopyIcon);
    _result.Parent = parent;
    _result.RootForm = rootForm;
    _result.Btn = trans:GetComponent("UIButton");
    UIUtils.AddBtnEvent(_result.Btn, _result.OnBtnClick, _result);
    _result.BackTex = UIUtils.FindTex(trans, "BackTex");
    _result.Stars = {};
    for i = 1, 3 do
        _result.Stars[i] = UIUtils.FindGo(trans, string.format("Star%d",i));
    end
    _result.Name = UIUtils.FindLabel(trans, "Name");
    _result.SelectGo = UIUtils.FindGo(trans, "Select");
    return _result;
end

function UIStarCopyIcon:Refresh(copyData)
    self.CopyCfg = copyData.CopyCfg;
    self.RootForm.CSForm:LoadTexture(self.BackTex, self.CopyCfg.PictureRes);
    self.Name.text = self.CopyCfg.DuplicateName;
    for i = 1, 3 do
        self.Stars[i]:SetActive(i <= copyData.CurStar);
    end
end

function UIStarCopyIcon:OnBtnClick()
    self.Parent:SetSelectCopy(self);
end

function UIStarCopyIcon:SetSelect(b)
    self.SelectGo:SetActive(b);
end

return UIStarCopyIcon;