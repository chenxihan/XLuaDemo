------------------------------------------------
--作者： _SqL_
--日期： 2019-04-16
--文件： UIMapNpcRoot.lua
--模块： UIMapNpcRoot
--描述： Npc Root
------------------------------------------------
local UIMapCommonItem = require("UI.Forms.UIMapForm.UIMapItem.UIMapCommonItem")

local UIMapNpcRoot = {
    Owner = nil,
    -- 当前对像的Transform
    Trans =nil,
    -- 怪物显示Icon
    MonsterIcon = nil;
    -- 怪物Icon 父节点Transform
    ParentNodeTrans = nil,
}

-- 初始化
function UIMapNpcRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIMapNpcRoot:FindAllComponents()
    self.ParentNodeTrans = self.Trans:Find("All")
    self.MonsterIcon = self.Trans:Find("All/npcres").gameObject
end

-- 载入黄Npc怪点的位置
function UIMapNpcRoot:LoadNpc(npcInfo)
    for i = 0, self.ParentNodeTrans.childCount - 1 do
        if self.ParentNodeTrans:GetChild(i) ~= nil then
            self.ParentNodeTrans:GetChild(i).gameObject:SetActive(false)
        end
    end

    local _index = 0
    local _iter = npcInfo
    while _iter:MoveNext() do
        local _info  = _iter.Current
        if self:IsShowNpcIcon( _info.Key ) then
            local _item = nil
            if _index < self.ParentNodeTrans.childCount then
                _item = UIMapCommonItem:New(self.ParentNodeTrans:GetChild(_index))
            else
                _item = UIMapCommonItem:Clone(self.MonsterIcon, self.ParentNodeTrans)
            end

            _item:SetInfo(DataConfig.DataNpc[ _info.Key ].Name, self.Owner:WorldPosToMapPos(_info.Value.Pos))
            _index = _index + 1
        end
    end
end

-- 是否显示Npc icon
function UIMapNpcRoot:IsShowNpcIcon(npcId)
    local _npcCfg = DataConfig.DataNpc[ npcId ]
    if _npcCfg == nil then
        return false
    end

    if _npcCfg.TaskShow and _npcCfg.TaskShow ~= "" then
        local _taskShowCfg = Utils.SplitStr(_npcCfg.TaskShow,";")
        if _taskShowCfg ~= nil and #_taskShowCfg > 0 then
            for k, v in pairs(_taskShowCfg) do
                local _strs = Utils.SplitStr(v,"_")
                if _strs ~= nil and #_strs >= 2 then
                    local _taskId = tonumber(_strs[2])
                    if _taskId then
                        return GameCenter.TaskManager:IsHaveTask(_taskId)
                    else
                        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MAPFORM_TASKSHOWCUOWU"))
                    end
                end
            end
        end
        return false
    end
    return true
end

return UIMapNpcRoot