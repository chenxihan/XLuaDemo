------------------------------------------------
--作者： dhq
--日期： 2019-05-18
--文件： UIAppointmentTimeItem.lua
--模块： UIAppointmentTimeItem
--描述： 预约的Item类
------------------------------------------------

local UIAppointmentTimeItem = {
    --root
    RootGo = nil,
    Trans = nil,
    Parent = nil,
    Info = nil,
    -- 预约时间
    TimeLabel = nil,
    -- 预约状态
    StatesLabel = nil,
    -- 选中的背景
    SelectedBg = nil,
}

function UIAppointmentTimeItem:New(go, parent)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result.Parent = parent;
    _result:OnFirstShow();
    return _result
end

function UIAppointmentTimeItem:OnFirstShow()
    self.TimeLabel = UIUtils.FindLabel(self.Trans, "Time");
    self.StatesLabel = UIUtils.FindLabel(self.Trans, "States");
    self.SelectedBg = UIUtils.FindSpr(self.Trans, "SelectedBg");
    self.SelectedBg.gameObject:SetActive(false)
end

--刷新
function UIAppointmentTimeItem:Refresh(info)
    self.Info = info;
    if self.Info ~= nil then
        self.TimeLabel.text = "16:30-16:45"
        if self.Info.States == 0 then
            self.StatesLabel.text = "已过期"
            self.SelectedBg.gameObject:SetActive(true)
        else
            self.StatesLabel.text = "可预约"
        end
    end
end

return UIAppointmentTimeItem