------------------------------------------------
--作者： 何健
--日期： 2019-05-23
--文件： UIPlayerLevelLabel.lua
--模块： UIPlayerLevelLabel
--描述： 玩家等级的标签组件
------------------------------------------------

local UIPlayerLevelLabel = {
    Trans = nil,
    Go = nil,
    LevelLabel = nil,
    DfLevelLabel = nil,
    DfLevelIcon = nil,
    DfLevelGo = nil,
    LevelGo = nil,
}

--创建一个新的对象
function UIPlayerLevelLabel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

 --查找UI上各个控件
function UIPlayerLevelLabel:FindAllComponents()
    self.LevelLabel = UIUtils.FindLabel(self.Trans, "Level")
    self.LevelGo = UIUtils.FindGo(self.Trans, "Level")
    self.DfLevelGo = UIUtils.FindGo(self.Trans, "DFLevel")
    self.DfLevelIcon = UIUtils.FindSpr(self.Trans, "DFLevel/Icon")
    self.DfLevelLabel = UIUtils.FindLabel(self.Trans, "DFLevel/Text")
end

--  直接设置文本--不显示标记.
function UIPlayerLevelLabel:SetLabelText(text)
    if not self.LevelGo.activeSelf then
        self.LevelGo:SetActive(true)
    end
    if self.DfLevelGo.activeSelf then
        self.DfLevelGo:SetActive(false)
    end
    self.LevelLabel.text = text
end

-- 设置等级到标签,显示巅峰标记
function UIPlayerLevelLabel:SetLevel(level)
    local _dfLevel = 0
    local _isDf = false
    _dfLevel, _isDf = Utils.GetDfLevel(level)
    if _isDf then
        self.LevelGo:SetActive(false)
        self.DfLevelGo:SetActive(true)
        self.DfLevelLabel.text = tostring(_dfLevel)
    else
        self.LevelGo:SetActive(true)
        self.DfLevelGo:SetActive(false)
        self.LevelLabel.text = string.format("Lv.%d", level)
    end
end

-- 设置等级到标签,不过不带有任何巅峰的标记
function UIPlayerLevelLabel:SetLevelOutFlag(level)
    local _dfLevel = 0
    _dfLevel = Utils.GetDfLevel(level)
    if not self.LevelGo.activeSelf then
        self.LevelGo:SetActive(true)
    end
    if self.DfLevelGo.activeSelf then
        self.DfLevelGo:SetActive(false)
    end
    self.LevelLabel.text = tostring(_dfLevel)
end

function UIPlayerLevelLabel:SetColor(color)
    self.DfLevelLabel.color = color
    self.LevelLabel.color = color
end

function UIPlayerLevelLabel:SetIconIsGray(isGray)
    self.DfLevelIcon.IsGray = isGray
end
return UIPlayerLevelLabel