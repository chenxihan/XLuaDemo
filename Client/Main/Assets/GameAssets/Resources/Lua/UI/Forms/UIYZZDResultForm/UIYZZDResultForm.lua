------------------------------------------------
--作者： yangqf
--日期： 2019-5-6
--文件： UIYZZDResultForm.lua
--模块： UIYZZDResultForm
--描述： 勇者之巅单层结算界面
------------------------------------------------

--//模块定义
local UIYZZDResultForm = {
    --标题
    TitleLabel = nil,
    --时间
    TimeLabel = nil,
    --计时器
    Timer = 0.0,
    --上一次更新的时间
    FrontUpdateTime = -1,
}

--继承Form函数
function UIYZZDResultForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIYZZDResultForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIYZZDResultForm_CLOSE,self.OnClose)
end

function UIYZZDResultForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.TitleLabel = UIUtils.FindLabel(self.Trans, "Title");
    self.TimeLabel = UIUtils.FindLabel(self.Trans, "Time");
end

function UIYZZDResultForm:OnShowAfter()
end

function UIYZZDResultForm:OnHideBefore()
end

--开启事件
function UIYZZDResultForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)

    local _msg = obj
    if _msg ~= nil then
        self.Timer = _msg.remainTime;
        self.TitleLabel.text = DataConfig.DataMessageString.Get("C_YZZDCOPY_SUCCRESULT", _msg.curFloor);
        self.FrontUpdateTime = -1;
    else
        self:OnClose(nil, nil);
    end
end

--关闭事件
function UIYZZDResultForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UIYZZDResultForm:Update(dt)
    if self.Timer >= 0.0 then
        self.Timer = self.Timer - dt;
        local _curTime = math.floor(self.Timer)
        if _curTime < 0.0 then
            self:OnClose(nil, nil);
        else
            if _curTime ~= self.FrontUpdateTime then
                self.FrontUpdateTime = _curTime;
                self.TimeLabel.text = DataConfig.DataMessageString.Get("C_YZZDCOPY_REMAINTIME", _curTime);
            end
        end
    end
end

return UIYZZDResultForm;