------------------------------------------------
--作者： yangqf
--日期： 2019-05-06
--文件： PlayerShiHaiSystem.lua
--模块： PlayerShiHaiSystem
--描述： 玩家识海系统
------------------------------------------------

local RedPointItemCondition = CS.Funcell.Code.Logic.RedPointItemCondition;
local RedPointCustomCondition = CS.Funcell.Code.Logic.RedPointCustomCondition;

local PlayerShiHaiSystem = {
    --当前等级
    CurCfgID = 0,
    --当前万妖塔等级
    CurWYTLevel = 0,
};

function PlayerShiHaiSystem:ResShiHaiData(msg)
    self.CurCfgID = msg.cfgId;
    self.CurWYTLevel = msg.layer;
    self:RefreshRedPointData();
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_PLAYER_SHIHAI);
end

function PlayerShiHaiSystem:RefreshRedPointData()
    local _copyData = GameCenter.CopyMapSystem:FindCopyDataByType(CopyMapTypeEnum.TowerCopy);
    if _copyData == nil then
        return;
    end

    local _curCfg = DataConfig.DataPlayerShiHai[self.CurCfgID];
    if _curCfg == nil then
        return
    end

    --清除掉所有条件
    GameCenter.RedPointSystem:CleraFuncCondition(FunctionStartIdCode.PlayerJingJie);

    local _curItem = Utils.SplitStrByTableS(_curCfg.NeedItem);
    local _conditions = List:New();
    --物品条件
    for i = 1, #_curItem do
        _conditions:Add(RedPointItemCondition(_curItem[i][1], _curItem[i][2]));
    end
    _conditions:Add(RedPointCustomCondition(_curCfg.NeedCopyLevel < _copyData.CurLevel));
    --调用lua专用条件接口
    GameCenter.RedPointSystem:LuaAddFuncCondition(FunctionStartIdCode.PlayerJingJie, 0, _conditions);
end

function PlayerShiHaiSystem:ReqShiHaiData()
    GameCenter.Network.Send("MSG_ShiHai.ReqShiHaiData", {})
end

function PlayerShiHaiSystem:ReqLevelUP()
    GameCenter.Network.Send("MSG_ShiHai.ReqUpLevel", {})
end

return PlayerShiHaiSystem;