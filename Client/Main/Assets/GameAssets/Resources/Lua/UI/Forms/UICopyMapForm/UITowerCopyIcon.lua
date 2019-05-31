------------------------------------------------
--作者： yangqf
--日期： 2019-04-28
--文件： UITowerCopyIcon.lua
--模块： UITowerCopyIcon
--描述： 爬塔副本分页
------------------------------------------------

--关卡头像
local UITowerCopyIcon = {
    --icon
    Icon = nil,
    --level
    LevelLabel = nil,
}

function UITowerCopyIcon:New(trans)
    local _result = Utils.DeepCopy(UITowerCopyIcon)
    _result.Icon = UnityUtils.RequireComponent(trans, "Funcell.GameUI.Form.UIIcon")
    _result.LevelLabel = UIUtils.FindLabel(trans, "Label")
    return _result
end

function UITowerCopyIcon:Refresh(levelCfg, curLevel)
    self.Icon:UpdateIcon(levelCfg.ShowIcon)
    self.Icon.IconSprite.IsGray = (curLevel <= levelCfg.Num)
end

return UITowerCopyIcon