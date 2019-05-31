------------------------------------------------
--作者： xc
--日期： 2019-04-18
--文件： CommonPanelRedData.lua
--模块： CommonPanelRedData
--描述： 通用面板内部红点数据,注意使用此脚本按钮下面比如要有RedPoint名称的红点
------------------------------------------------

local NGUITools = CS.NGUITools

local CommonPanelRedData = {
    FunctionStartId = 0, --FunctionStartIdCode
    NotRedIsGray = false, --没有红点的时候置灰按钮
    RedGo = nil, --红点gameObejct
    DataId = 0, --分页ID
    Trans = nil,--节点
}
CommonPanelRedData.__index = CommonPanelRedData

function CommonPanelRedData:New(functionStartId,trs,dataid,isgray)
    local _M = Utils.DeepCopy(self)
    _M.FunctionStartId = functionStartId
    _M.Trans = trs
    _M.NotRedIsGray = isgray
    _M.DataId = dataid
    _M.RedGo = trs:Find("RedPoint").gameObject
    return _M
end

function CommonPanelRedData:RefreshInfo()
    local _red = false
    if self.DataId == 0 then
        _red = GameCenter.RedPointSystem:FuncConditionsIsReach(self.FunctionStartId)
    else
        _red = GameCenter.RedPointSystem:OneConditionsIsReach(self.FunctionStartId,self.DataId)
    end
    self.RedGo:SetActive(_red)
    if self.NotRedIsGray then
            NGUITools.SetButtonGrayAndNotOnClick(self.Trans,not _red)
    else
        NGUITools.SetButtonGrayAndNotOnClick(self.Trans,false)
    end
end

return CommonPanelRedData