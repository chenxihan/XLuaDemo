------------------------------------------------
--作者： _SqL_
--日期： 2019-04-17
--文件： UIMapTeamRoot.lua
--模块： UIMapTeamRoot
--描述： Team Root
------------------------------------------------
local UIMapCommonItem = require("UI.Forms.UIMapForm.UIMapItem.UIMapCommonItem")

local UIMapTeamRoot = {
    Owner = nil,
    -- 当前对像的Transform
    Trans =nil,
    -- leader Trans
    TeamLeaderTrans = nil,
    -- 队友 Trans
    TeammateResTrans = nil,
    -- 父节点Transform
    ParentNodeTrans = nil,
    -- 队伍最大队员数量
    TeammatesMaxCount = nil,
    -- leader item
    LeaderItem = nil,
    -- 队友item 容器
    TeammateItemComContaner = Dictionary:New(),
}

-- 初始化
function UIMapTeamRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:Init()
    self:LoadTeammateIcon()
    return self
end

function UIMapTeamRoot:FindAllComponents()
    self.ParentNodeTrans = self.Trans:Find("All")
    self.TeamLeaderTrans = self.Trans:Find("teamleader")
    self.TeammateResTrans = self.Trans:Find("All/teamres")
end

function UIMapTeamRoot:Init()
    self.TeammatesMaxCount = tonumber(DataConfig.DataGlobal[1482].Params)
end

-- 载入队友Icon
function UIMapTeamRoot:LoadTeammateIcon()
    -- 添加leader item
    local _leaderItem = UIMapCommonItem:New(self.TeamLeaderTrans)
    _leaderItem:Close()
    self.LeaderItem = _leaderItem

    -- 添加队友 item
    for i = 0, self.TeammatesMaxCount - 1 do
        local _item = nil
        if i < self.ParentNodeTrans.childCount then
            _item = UIMapCommonItem:New(self.ParentNodeTrans:GetChild(i))
        else
            _item = UIMapCommonItem:Clone(self.TeammateResTrans.gameObject, self.ParentNodeTrans)
        end
        _item:Close()
        self.TeammateItemComContaner:Add(i, _item)
    end
end

-- 显示 队友 icon
function UIMapTeamRoot:ShowTeammateIcon(info)
    local _index = 0
    for i = 0, info.Count - 1 do
        local _obj = nil
        if info[i].IsLeader then
            self.LeaderItem:SetInfo(info[i].PlayerName, self.Owner:WorldPosToMapPos(Vector3(info[i].CurPos.x, 0, info[i].CurPos.y)))
        else
            if _index > self.TeammatesMaxCount - 1 then
                Debug.LogError("超出最大队友数量")
                return
            end
            self.TeammateItemComContaner[_index]:SetInfo(info[i].PlayerName, self.Owner:WorldPosToMapPos(Vector3(info[i].CurPos.x, 0, info[i].CurPos.y)))
            _index = _index + 1
        end
    end
end

return UIMapTeamRoot