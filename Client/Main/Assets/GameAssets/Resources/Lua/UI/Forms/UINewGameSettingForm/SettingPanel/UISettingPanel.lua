------------------------------------------------
--作者： gzg
--日期： 2019-05-07
--文件： UISettingPanel.lua
--模块： UISettingPanel
--描述： 游戏设置的面板
------------------------------------------------
local UIToggleGroup = require("UI.Components.UIToggleGroup");
--展示角色最大数量
local L_CN_MaxPlayerCount = 30;
local L_CN_MinPlayerCount = 4;


--定义设置的面板
local UISettingPanel = {
    IsVisibled = false,
    OwnerForm = nil,
    Trans = nil,

    --背景音乐的音量调整
    MusicProgressBar = nil,    
    --音效的音量调整
    SFXProgressBar = nil,
    --展示玩家数量的调整
    ShowNumProgressBar = nil,

    --背景音乐开关
    MusicToggleGroup = nil,
    --声效开关
    SFXToggleGroup = nil,
    --视野远近开关
    ViewToggleGroup = nil,
    --品质开关
    QualityToggleGroup = nil,
    --选择目标开关
    TargetToogleGroup = nil,
    --挂机开关
    OnHookToogleGroup = nil,
    --离线时间
    OffLineLabel = nil,
    --离线挂机的按钮
    OffLineBtn = nil,
    --头像
    HeadIcon = nil,
    --账号信息
    AccountLabel = nil,
    --服务器信息
    ServerLabel = nil,
    --退出按钮
    ExitGameBtn = nil,
    --公告按钮
    NoticeBtn = nil,
    --反馈按钮
    FeedBackBtn = nil,
    --关闭按钮
    CloseBtn = nil,
};

--声明局部变量,各种开关的属性处理
local L_MusicToggleProp,L_SFXToggleProp,L_ViewToggleProp,L_QualityToggleProp,L_TargetToggleProp,L_OnHookToggleProp;

function UISettingPanel:Initialize(owner,trans)
    self.OwnerForm = owner;
    self.Trans = trans;
    self:FindAllComponents();
    self:RegUICallback();
    return self;
end


--查找所有组件
function UISettingPanel:FindAllComponents()
    local _myTrans = self.Trans;
    self.MusicToggleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"Content/Left/Music"),0,L_MusicToggleProp);
    self.SFXToggleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"Content/Left/SFX"),0,L_SFXToggleProp);
    self.ViewToggleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"Content/Left/View"),1000,L_ViewToggleProp);
    self.QualityToggleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"Content/Left/Quality"),1001,L_QualityToggleProp);
    self.TargetToogleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"Content/Left/Target"),1002,L_TargetToggleProp);
    self.OnHookToogleGroup = UIToggleGroup:New(self,UIUtils.FindTrans(_myTrans,"Content/Right/OnHook"),0,L_OnHookToggleProp);    
    self.OffLineLabel = UIUtils.FindLabel(_myTrans,"Content/Right/OffLine/Text");
    self.OffLineBtn = UIUtils.FindBtn(_myTrans,"Content/Right/OffLine/AddBtn");
    self.ExitGameBtn = UIUtils.FindBtn(_myTrans,"Content/Bottom/ExitGameBtn");
    self.NoticeBtn = UIUtils.FindBtn(_myTrans,"Content/Bottom/NoticeBtn");
    self.FeedBackBtn = UIUtils.FindBtn(_myTrans,"Content/Bottom/FeedBackBtn");
    self.AccountLabel = UIUtils.FindLabel(_myTrans,"Content/Bottom/Account/Text");
    self.ServerLabel = UIUtils.FindLabel(_myTrans,"Content/Bottom/Server/Text");
    self.HeadIcon = UIUtils.FindSpr(_myTrans,"Content/Bottom/Head/Icon");
    self.CloseBtn = UIUtils.FindBtn(_myTrans,"Top/CloseBtn");
    self.MusicProgressBar = UIUtils.FindSlider(_myTrans,"Content/Left/Music/ProgressBar");
    self.SFXProgressBar = UIUtils.FindSlider(_myTrans,"Content/Left/SFX/ProgressBar");
    self.ShowNumProgressBar = UIUtils.FindSlider(_myTrans,"Content/Left/ShowNum/ProgressBar");
end

--绑定UI组件的回调函数
function UISettingPanel:RegUICallback()
   UIUtils.AddBtnEvent(self.OffLineBtn,self.OnClickOffLineBtn,self);
   UIUtils.AddBtnEvent(self.ExitGameBtn,self.OnClickExitGameBtn,self);
   UIUtils.AddBtnEvent(self.NoticeBtn,self.OnClickNoticeBtn,self);
   UIUtils.AddBtnEvent(self.FeedBackBtn,self.OnClickFeedBackBtn,self);
   UIUtils.AddBtnEvent(self.CloseBtn,self.OnClickCloseBtn,self);

   UIUtils.AddOnChangeEvent(self.MusicProgressBar,self.OnMusicProgressBarChanged,self);
   UIUtils.AddOnChangeEvent(self.SFXProgressBar,self.OnSFXProgressBarChanged,self);
   UIUtils.AddOnChangeEvent(self.ShowNumProgressBar,self.OnShowNumProgressBarChanged,self);
end

function UISettingPanel:Show()
    self.IsVisibled = true;    
    self.Trans.gameObject:SetActive(true);
    self:Refresh();
end

function UISettingPanel:Hide()
    self.IsVisibled = false;
    self.Trans.gameObject:SetActive(false);
end

function UISettingPanel:Refresh()
    self.MusicToggleGroup:Refresh();
    self.SFXToggleGroup:Refresh();
    self.ViewToggleGroup:Refresh();
    self.QualityToggleGroup:Refresh();
    self.TargetToogleGroup:Refresh();
    self.OnHookToogleGroup:Refresh();
    
    --设置离线挂剩余时间显示
    if (GameCenter.MandateSystem.OffLineLeftTime > 0) then    
        local d,h,m,s = Time.SplitTime(GameCenter.MandateSystem.OffLineLeftTime);
        self.OffLineLabel.text = DataConfig.DataMessageString.Get("C_GUAJIDAOJISHI", h+d*24, m, s);  
    else    
        self.OffLineLabel.text = DataConfig.DataMessageString.Get("C_GUAJIDAOJISHIFEN"); 
    end

    local lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if lp ~= nil then
        self.AccountLabel.text = lp.Name;
    else
        self.AccountLabel.text = "(未知)";
    end
    local si = GameCenter.ServerListSystem.LastEnterServer;
    if si ~= nil then
        self.ServerLabel.text = si.Name;
    else
        self.ServerLabel.text = "(未知)";
    end
    self.HeadIcon.spriteName = CommonUtils.GetPlayerHeaderSpriteName(lp.Level, UnityUtils.GetObjct2Int(lp.Occ));

    --展示人数
    local _count = GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MaxShowPlayerCount);      
    self.ShowNumProgressBar.value = _count/L_CN_MaxPlayerCount;
    --背景音乐
    local _mv = GameCenter.GameSetting:GetSetting(GameSettingKeyCode.BGMusicVolume);
    self.MusicProgressBar.value = math.min(1,math.max(0,_mv/100));
    --其他音效
    _mv = GameCenter.GameSetting:GetSetting(GameSettingKeyCode.SoundVolume);
    self.SFXProgressBar.value = math.min(1,math.max(0,_mv/100));

end

--点击离线时间按钮
function UISettingPanel:OnClickOffLineBtn()
    --先查找背包里面有没有该道具
    if (GameCenter.ItemContianerSystem:GetItemCountFromCfgId(50059) > 0) then
    
        local list = GameCenter.ItemContianerSystem:GetItemListByCfgid(ContainerType.ITEM_LOCATION_BAG, 50059);
        if list ~= nil and list.Count > 0 then
            GameCenter.PushFixEvent(UIEventDefine.UIITEMGET_TIPS_OPEN, list[0]);
        end
    else
        --弹出道具获取途径
        GameCenter.ItemQuickGetSystem:OpenItemQuickGetForm(50059);
    end
end

--点击切换到登陆的按钮
function UISettingPanel:OnClickExitGameBtn()
    GameCenter.GameSceneSystem:ReturnToLogin();
end
--点击公告按钮
function UISettingPanel:OnClickNoticeBtn()
    GameCenter.PushFixEvent(UIEventDefine.UI_LOGIN_NOTICE_OPEN, NoticeType.Action);
end
--点击反馈按钮
function UISettingPanel:OnClickFeedBackBtn()
    self.OwnerForm:ShowFeedBackPanel();
end

--点击关闭按钮
function UISettingPanel:OnClickCloseBtn()
    self.OwnerForm:OnClose();
end

--背景音乐
function UISettingPanel:OnMusicProgressBarChanged()
    local _v = math.floor( self.MusicProgressBar.value * 100+0.5);
    GameCenter.GameSetting:SetSetting(GameSettingKeyCode.BGMusicVolume, _v, false);
end

--音效
function UISettingPanel:OnSFXProgressBarChanged()
    local _v = math.floor( self.SFXProgressBar.value * 100 + 0.5);
    GameCenter.GameSetting:SetSetting(GameSettingKeyCode.SoundVolume, _v, false);
end

--玩家数量
function UISettingPanel:OnShowNumProgressBarChanged()
    local _count = math.floor(L_CN_MaxPlayerCount * self.ShowNumProgressBar.value+0.5);
    if (_count < L_CN_MinPlayerCount) then
        _count = L_CN_MinPlayerCount;
    end    
    GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MaxShowPlayerCount, _count, false);
end

--==内部变量以及函数的定义==--
--背景音乐开关的属性
L_MusicToggleProp = {    
    [1] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.EnableBGMusic) > 0;
        end,
        Set = function(checked)
            GameCenter.GameSetting:SetSetting(GameSettingKeyCode.EnableBGMusic, checked and 1 or 0, false);
        end
    }
};
--声效开关
L_SFXToggleProp = {    
    [1] = {
        Get = function()
           return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.EnableSound) > 0;
        end,
        Set = function(checked)
            GameCenter.GameSetting:SetSetting(GameSettingKeyCode.EnableSound, checked and 1 or 0, false);
        end
    }
};

--视野远近开关
L_ViewToggleProp = {    
    --远视野
    [1] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.EnableFarView) == 1;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.EnableFarView, 1, false);
            end
        end
    },
    --近视野
    [2] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.EnableFarView) == 0;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.EnableFarView, 0, false);
            end
        end
    }
};

--选人品质的开关
L_QualityToggleProp = {    
    --低品质
    [1] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.QualityLevel) == 2;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.QualityLevel, 2 , false);
            end
        end
    },
    --中品质
    [2] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.QualityLevel) == 1;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.QualityLevel, 1, false);
            end
        end
    },
    --高品质
    [3] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.QualityLevel) == 0;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.QualityLevel, 0, false);
            end
        end
    }
};

--技能目标的自动选择
L_TargetToggleProp = {    
    --最近目标
    [1] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.SelectPRI) == 0;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.SelectPRI, 0, false);
            end
        end
    },
    --优先玩家
    [2] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.SelectPRI) == 1;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.SelectPRI, 1, false);
            end
        end
    },
    --优先怪物
    [2] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.SelectPRI) == 2;
        end,
        Set = function(checked)
            if checked then
                GameCenter.GameSetting:SetSetting(GameSettingKeyCode.SelectPRI, 2, false);
            end
        end
    }
};

--挂机设置
L_OnHookToggleProp = {    
    --自动反击
    [1] = {
         Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateAutoStrikeBack) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateAutoStrikeBack, checked and 1 or 0, false);
         end
    },
    --自动复活
    [2] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateReborn) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateReborn, checked and 1 or 0, false);
         end
    },
    --点击移动
    [3] = {
         Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.CheckGroundMove) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.CheckGroundMove, checked and 1 or 0, false);
         end
    },
    --原地打坐
    [4] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.SitDownByLocal) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.SitDownByLocal, checked and 1 or 0, false);
         end
    },
    --屏蔽玩家
    [5] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateShowOtherPlayer) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateShowOtherPlayer, checked and 1 or 0, false);
         end
    },
    --屏蔽怪物
    [6] = {
         Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateShowMonster) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateShowMonster, checked and 1 or 0, false);
         end
    },
    --自动吞噬金色1星装备
    [7] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateAutoEatEquip) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateAutoEatEquip, checked and 1 or 0, false);
         end
    },
    --自动确认进入队伍
    [8] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateAutoJoinTeam) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateAutoJoinTeam, checked and 1 or 0, false);
         end
    },
    --自动补足挂机时间
    [9] = {
        Get = function()
            return GameCenter.GameSetting:GetSetting(GameSettingKeyCode.MandateAutoAddTime) > 0;
         end,
         Set = function(checked)
             GameCenter.GameSetting:SetSetting(GameSettingKeyCode.MandateAutoAddTime, checked and 1 or 0, false);
         end
    }
};

return UISettingPanel;
