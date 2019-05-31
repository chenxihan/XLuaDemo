------------------------------------------------
--作者： yangqf
--日期： 2019-05-07
--文件： UISZZQRankItem.lua
--模块： UISZZQRankItem
--描述： 爬塔副本分页
------------------------------------------------

--排名item
local UISZZQRankItem = {
    --父UI
    Parent = nil,
    --root
    RootGo = nil,
    Trans = nil,
    --icon
    Icon = nil,
    --排名
    Rank = nil,
    --名字
    Name = nil,
    --等级
    Level = nil,
    --分数
    Score = nil,
    --战斗力
    FightPower = nil,
    --背景0
    Back0 = nil,
    --背景1
    Back1 = nil,
    --数据
    Info = nil,
    --当前阵营ID
    CampID = 0,
}

function UISZZQRankItem:New(trans, parent)
    local _result = Utils.DeepCopy(UISZZQRankItem);
    _result.Parent = parent;
    _result.RootGo = trans.gameObject;
    _result.Trans = trans;
    _result:OnFirstShow();
    return _result;
end

function UISZZQRankItem:OnFirstShow()
    self.Icon = UnityUtils.RequireComponent(self.Trans, "Funcell.GameUI.Form.UIIcon")
    self.Rank = UIUtils.FindLabel(self.Trans, "Rank");
    self.Name = UIUtils.FindLabel(self.Trans, "Name");
    self.Level = UIUtils.FindLabel(self.Trans, "Level");
    self.Score = UIUtils.FindLabel(self.Trans, "Score");
    self.FightPower = UIUtils.FindLabel(self.Trans, "FightPower");
    self.Back0 = UIUtils.FindGo(self.Trans, "Back0");
    self.Back1 = UIUtils.FindGo(self.Trans, "Back1");
end

--刷新
function UISZZQRankItem:Refresh(info, rank, iconID)
    self.Info = info;
    if self.Info ~= nil then
        self.Rank.text = tostring(rank);
        self.Name.text = info.name;
        self.Level.text = string.format("Lv.%d", info.lv);
        self.Score.text = tostring(info.points);
        self.FightPower.text = tostring(info.fight);
        self.CampID = info.camp;
        self.Icon:UpdateIcon(iconID);
    end
end

--设置索引
function UISZZQRankItem:SetIndex(index)
    if index < 0 then
        self.RootGo:SetActive(false);
    else
        self.RootGo:SetActive(true);
        self.Back0:SetActive(index % 2 == 0);
        self.Back1:SetActive(index % 2 ~= 0);
        self.Trans.localPosition = Vector3(-9.0, 318.0 - (index * 45.0), 0);
    end
end

return UISZZQRankItem;