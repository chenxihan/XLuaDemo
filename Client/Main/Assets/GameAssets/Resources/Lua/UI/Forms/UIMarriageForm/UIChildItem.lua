------------------------------------------------
--作者： dhq
--日期： 2019-05-16
--文件： UIChildItem.lua
--模块： UIChildItem
--描述： 仙娃界面左边的滑动列表项
------------------------------------------------

local UIChildItem = {
    --root
    RootGo = nil,
    Trans = nil,
    Info = nil,
    -- 图标
    IconBase = nil,
    -- 名字
    NameLabel = nil,
    -- 激活状态
    StatesLabel = nil,
}

function UIChildItem:New(go)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result:OnFirstShow();
    return _result
end

function UIChildItem:OnFirstShow()
    local _iconSpr = UIUtils.FindSpr(self.Trans, "Icon");
    self.IconBase = UnityUtils.RequireComponent(_iconSpr.transform, "Funcell.GameUI.Form.UIIconBase")
    self.NameLabel = UIUtils.FindLabel(self.Trans, "Name");
    self.StatesLabel = UIUtils.FindLabel(self.Trans, "States");
end

--刷新
function UIChildItem:Refresh(info)
    self.Info = info;
    if self.Info ~= nil then
        self.IconBase:UpdateIcon(self.Info.IconId)
        -- 名字
        self.NameLabel.text = self.Info.Name
        -- 激活状态
        if self.Info.States == 1 then
            self.StatesLabel.text = "激活"
            self.StatesLabel.color = Color.green
        elseif self.Info.States == 2 then
            self.StatesLabel.text = "已激活"
            self.StatesLabel.color = Color.white
        else
            self.StatesLabel.text = "未激活"
            self.StatesLabel.color = Color.red
        end
    end
end

return UIChildItem