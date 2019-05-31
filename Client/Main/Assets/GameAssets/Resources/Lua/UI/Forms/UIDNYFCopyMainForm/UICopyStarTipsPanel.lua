------------------------------------------------
--作者： yangqf
--日期： 2019-5-21
--文件： UICopyStarTipsPanel.lua
--模块： UICopyStarTipsPanel
--描述： 勇者之巅副本UI
------------------------------------------------

--//模块定义
local UICopyStarTipsPanel = {
    --当前transform
    Trans = nil,
    --当前Go
    Go = nil,
    --父
    Parent = nil,
    --form
    RootForm = nil,
    --1星
    Level1Go = nil,
    --2星
    Level2Go = nil,
    --3星
    Level3Go = nil,
    --描述
    DescLabel = nil,
    --开始trans
    StratTrans = nil,
    --中间trans
    CenterTrans = nil,
    --移动的trans
    MoveTrans = nil,
    --开始位置
    StartPos = nil,
    --中间位置
    CenterPos = nil,
    --结束位置
    EndPos = nil,
    --当前星级
    CurStar = 0,
    --是否正在播放动画
    IsPlayShowing = false,
    --动画计时器
    AnimTimer = 0.0,
    --上次更新的时间，单位秒
    FrontUpdateTime = -1,
    --3星的时间
    Star3Time = 0.0,
    --2星的时间
    Star2Time = 0.0,
    --移动到中间的时间
    MoveToCenterTime = 2.0,
    --中间停止的时间
    StopTime = 3.0,
    --移动到结束的时间
    MoveToEndTime = 2.0,
}

--查找控件
function UICopyStarTipsPanel:OnFirstShow(trans, parent, rootForm)
    self.Trans = trans;
    self.Go = self.Trans.gameObject;
    self.Parent = parent;
    self.RootForm = rootForm;

    self.Level1Go = UIUtils.FindGo(self.Trans, "Back/1");
    self.Level2Go = UIUtils.FindGo(self.Trans, "Back/2");
    self.Level3Go = UIUtils.FindGo(self.Trans, "Back/3");
    self.DescLabel = UIUtils.FindLabel(self.Trans, "Back/Desc");
    self.MoveTrans = UIUtils.FindTrans(self.Trans, "Back");
    self.StratTrans = UIUtils.FindTrans(self.Trans, "StartPos");
    self.CenterTrans = UIUtils.FindTrans(self.Trans, "CenterPos");

    self.StartPos = Vector3(self.StratTrans.localPosition);
    self.StartPos.z = 0.0;
    self.CenterPos = Vector3(self.CenterTrans.localPosition);
    self.CenterPos.z = 0.0;
    self.EndPos = Vector3(self.MoveTrans.localPosition);
    self.EndPos.z = 0.0;

    self.Go:SetActive(false);
    return self;
end

--打开界面
function UICopyStarTipsPanel:Show(copyCfg, start3Time, start2Time)
    self.Go:SetActive(true);

    self.CurStar = 1;
    self.Star3Time = tonumber(start3Time);
    self.Star2Time = tonumber(start2Time);
    if GameCenter.MapLogicSystem.ActiveLogic ~= nil and GameCenter.MapLogicSystem.ActiveLogic.RemainTime ~= nil then
        local _remainTime = GameCenter.MapLogicSystem.ActiveLogic.RemainTime;
        if _remainTime >= self.Star3Time then
            self.CurStar = 3;
        elseif _remainTime >= self.Star2Time then
            self.CurStar = 2;
        else
            self.CurStar = 1;
        end
    end

    self:PlayShowAnim();
end

--隐藏界面
function UICopyStarTipsPanel:Hide()
    self.Go:SetActive(false);
end

--展示出现动画
function UICopyStarTipsPanel:PlayShowAnim()
    self.IsPlayShowing = true;
    if self.CurStar == 3 then
        self.DescLabel.text = DataConfig.DataMessageString.Get("C_MANYPEOPCOPY_STAR3_DIAOLUO");
    elseif self.CurStar == 2 then
        self.DescLabel.text = DataConfig.DataMessageString.Get("C_MANYPEOPCOPY_STAR2_DIAOLUO");
    else
        self.DescLabel.text = DataConfig.DataMessageString.Get("C_MANYPEOPCOPY_STAR1_DIAOLUO");
    end
    self.Level1Go:SetActive(self.CurStar == 1);
    self.Level2Go:SetActive(self.CurStar == 2);
    self.Level3Go:SetActive(self.CurStar == 3);

    local _startPos = Vector3(self.StratTrans.localPosition);
    UnityUtils.SetLocalPosition(self.MoveTrans, _startPos.x, _startPos.y, _startPos.z);
    self.AnimTimer = 0.0;
end

--帧更新
function UICopyStarTipsPanel:Update(dt)
    if self.IsPlayShowing == true then
        self.AnimTimer = self.AnimTimer + dt;
        if self.AnimTimer <= self.MoveToCenterTime then
            local _curPos = Utils.Lerp(self.StartPos, self.CenterPos, self.AnimTimer / self.MoveToCenterTime);
            UnityUtils.SetLocalPosition(self.MoveTrans, _curPos.x, _curPos.y, _curPos.z);
        elseif self.AnimTimer <= (self.MoveToCenterTime + self.StopTime) then
            UnityUtils.SetLocalPosition(self.MoveTrans, self.CenterPos.x, self.CenterPos.y, self.CenterPos.z);
        elseif self.AnimTimer <= (self.MoveToCenterTime + self.StopTime + self.MoveToEndTime) then
            local _curPos = Utils.Lerp(self.CenterPos, self.EndPos, (self.AnimTimer - self.MoveToCenterTime - self.StopTime) / self.MoveToEndTime);
            UnityUtils.SetLocalPosition(self.MoveTrans, _curPos.x, _curPos.y, _curPos.z);
        else
            self.IsPlayShowing = false;
            UnityUtils.SetLocalPosition(self.MoveTrans, self.EndPos.x, self.EndPos.y, self.EndPos.z);
            self.FrontUpdateTime = -1;
        end
    elseif GameCenter.MapLogicSystem.ActiveLogic ~= nil and GameCenter.MapLogicSystem.ActiveLogic.RemainTime ~= nil then
        local _newStar = 0;
        local _remainTime = GameCenter.MapLogicSystem.ActiveLogic.RemainTime;
        local _iCurTime = 0;
        if _remainTime >= self.Star3Time then
            _newStar = 3;
            _iCurTime = math.floor(_remainTime - self.Star3Time);
        elseif _remainTime >= self.Star2Time then
            _newStar = 2;
            _iCurTime = math.floor(_remainTime - self.Star2Time);
        else
            _newStar = 1;
            _iCurTime = math.floor(_remainTime);
        end

        if _newStar ~= self.CurStar then
            self.CurStar = _newStar;
            self:PlayShowAnim();
        else
            if _iCurTime ~= self.FrontUpdateTime then
                self.FrontUpdateTime = _iCurTime;
                local _min = _iCurTime // 60;
                _iCurTime = _iCurTime - (_min * 60);
                if self.CurStar == 3 then
                    self.DescLabel.text = DataConfig.DataMessageString.Get("C_MANYPEOPCOPY_STAR3_TIME", _min, _iCurTime);
                elseif self.CurStar == 2 then
                    self.DescLabel.text = DataConfig.DataMessageString.Get("C_MANYPEOPCOPY_STAR2_TIME", _min, _iCurTime);
                else
                    self.DescLabel.text = DataConfig.DataMessageString.Get("C_MANYPEOPCOPY_STAR1_TIME", _min, _iCurTime);
                end
            end
        end
    end
end

return UICopyStarTipsPanel;