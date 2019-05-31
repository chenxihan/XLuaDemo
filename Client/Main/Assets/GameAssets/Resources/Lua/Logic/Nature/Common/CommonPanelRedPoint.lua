------------------------------------------------
--作者： xc
--日期： 2019-04-18
--文件： CommonPanelRedPoint.lua
--模块： CommonPanelRedPoint
--描述： 通用面板内部红点
------------------------------------------------
--引用

local RedData = require "Logic.Nature.Common.CommonPanelRedData"

local CommonPanelRedPoint = {
    ButtinInfoList = nil, --界面内按钮,储存CommonPanelRedData
}
CommonPanelRedPoint.__index = CommonPanelRedPoint

function CommonPanelRedPoint:New()
    local _M = Utils.DeepCopy(self)
    _M.ButtinInfoList = List:New()
    return _M
end

--添加一个按钮红点数据
function CommonPanelRedPoint:Add(functionid,trs,dataid,isgary)
    local _Id = Utils.GetEnumNumber(tostring(functionid))
    local _info = RedData:New(_Id,trs,dataid,isgary)
    self.ButtinInfoList:Add(_info)
end

--初始化注册红点变更消息
function CommonPanelRedPoint:Initialize()
    self.UpDateRedEvent = Utils.Handler(self.UpDateRed, self)
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_FUNCTION_UPDATE, self.UpDateRedEvent)
    for i = 1,#self.ButtinInfoList do
        local _info = self.ButtinInfoList[i]
        _info:RefreshInfo()
    end
end

--反初始化注册红点变更消息
function CommonPanelRedPoint:UnInitialize()
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_FUNCTION_UPDATE, self.UpDateRedEvent)
end

--红点检测
function CommonPanelRedPoint:UpDateRed(functioninfo,sender)
    for i = 1,#self.ButtinInfoList do
        local _info = self.ButtinInfoList[i]
        local type = FunctionStartIdCode.__CastFrom(_info.FunctionStartId)
        if type == functioninfo.ID then
            _info:RefreshInfo()
        end
    end
end


return CommonPanelRedPoint