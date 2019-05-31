------------------------------------------------
--作者： xc
--日期： 2019-04-11
--文件： UITransferForm.lua
--模块： UITransferForm
--描述： 转职面板
------------------------------------------------
--引用

local PlayerSkillSystemStatic = CS.Funcell.Code.Logic.PlayerSkillSystem
local UIItem = require "UI.Components.UIItem"
local NGUITools = CS.NGUITools
local BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools

local UITransferForm = {
    ItemList = {}, --显示道具
    TargetList = {}, --
    GoldList = {}, --Gloab表中花费的钱
    DelaTime = 2,--时间
    VfxOverTime = 10,--特效结束时间
    Texture = nil, --贴图
    Skin = nil, --模型
    AttackValue = nil,--属性值
    AttackGrid = nil, --属性GRID
    CloseBtn= nil,--关闭按钮
    OldHead = nil,--头像及名字
    NextHead = nil,
    OldName = nil,
    NextName = nil,
    TransferDes= nil,--升级描述
    UIItem_0 = nil,--道具按钮
	UIItem_1 = nil,
	UIItem_2 = nil,
	UIItem_3 = nil,
	TransferTrask = nil,--转职任务按钮
	Transfer =  nil,--转职按钮
	Right = nil,
	Left = nil,
	Panel =  nil,
	TipsNextHead =  nil, --点击技能的TIPS头像
	TipsTransferDes = nil, --点击技能的TIPS说明
    TipsAttackValue = nil, --成功以后面板的信息节点
    TipsAttackGrid = nil,
	TipsNextName =nil, 
	CloseTips = nil, 
	VfxNode = nil, 
	SkillDes = nil, 
	Des = nil, 
	CloseBox = nil, 
	Lv =nil,   --转职等级
	LeftName = nil, 
	RightName = nil, 
	TaskDes = nil, --任务描述
    Max = nil, 
    Vfx = nil,
    SkipTask = nil,
    ItemDicGo = Dictionary:New(), --储存道具GO
}

--继承Form函数
function UITransferForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UITransferForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UITransferForm_CLOSE, self.OnClose)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_TRANSFER_RESULT_UPDATE,self.OnUpdateTransfer)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_TASKCHANG, self.TaskChangeUpdate)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_ISTASKFINISH, self.IsTaskFinish)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_RESUME_ALL_FORM, self.CloseTopUI)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_TRANSFER_SUCCESS, self.TransferSuccess)
end

function UITransferForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UITransferForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UITransferForm:OnFirstShow()
	self:FindAllComponents()
    self:RegUICallback()
    self.CSForm:AddAlphaAnimation()
    self.CSForm:AddPositionAnimation(280, 0, self.Left)
    self.CSForm:AddPositionAnimation(-280, 0, self.Right)
    local _globalCfg = DataConfig.DataGlobal[1295].Params
    if _globalCfg then
        local _strs = Utils.SplitStr(_globalCfg,";")
        for i=1,#_strs do
            local param = tonumber(_strs[i])  and tonumber(_strs[i]) or -1
            table.insert( self.GoldList, param )
        end
    end
    self.IsFullScreen = true
end

function UITransferForm:OnShowAfter()
    self:OnUpdateTransfer(true)
    self.DelaTime = 2
    self.VfxOverTime = 10
    self.CSForm:LoadTexture(self.Texture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_skillback"))
end


function UITransferForm:OnHideBefore()
    self.Skin:ResetSkin()
    self.CSForm:UnloadTexture(self.Texture)
end 

function UITransferForm:OnHideAfter()
    self:UnInitVariable()
end

function UITransferForm:UnInitVariable()
    self.ItemList = {}
    if self.TargetList then      
        for i=1,#self.TargetList do
            if self.TargetList[i] then
                self.TargetList[i]:Release()
            end
        end
    end
    self.TargetList = {}
end

function UITransferForm:InitVariable()
    self.ItemList = {}
    table.insert( self.ItemList, self.UIItem_0.transform )
    table.insert( self.ItemList, self.UIItem_1.transform )
    table.insert( self.ItemList, self.UIItem_2.transform )
    table.insert( self.ItemList, self.UIItem_3.transform )
    self.TargetList = {}
    self:DeleteVfx();
end

function UITransferForm:FindAllComponents()
	self.AttackValue = UIUtils.FindGo(self.Trans,"Left/ChangeContainer/AttributeBg/Attribute/Clone")
    self.AttackGrid =  UIUtils.FindGrid(self.Trans,"Left/ChangeContainer/AttributeBg/Attribute")
	self.CloseBtn = self.Trans:Find("Top/TitleBG/AnimPanel/CloseBtn"):GetComponent("UIButton")
	self.OldHead = self.Trans:Find("Left/ChangeContainer/OldHead"):GetComponent("UIButton")
	self.NextHead = self.Trans:Find("Left/ChangeContainer/NextHead"):GetComponent("UIButton")
	self.OldName = self.Trans:Find("Left/ChangeContainer/OldHead/OldName"):GetComponent("UILabel")
	self.NextName = self.Trans:Find("Left/ChangeContainer/NextHead/NextName"):GetComponent("UILabel")
	self.TransferDes = self.Trans:Find("Left/ChangeContainer/TransferDes"):GetComponent("UILabel")
	self.UIItem_0 = self.Trans:Find("Left/Goods/UIItem_0"):GetComponent("UIButton")
	self.UIItem_1 = self.Trans:Find("Left/Goods/UIItem_1"):GetComponent("UIButton")
	self.UIItem_2 = self.Trans:Find("Left/Goods/UIItem_2"):GetComponent("UIButton")
	self.UIItem_3 = self.Trans:Find("Left/Goods/UIItem_3"):GetComponent("UIButton")
	self.TransferTrask = self.Trans:Find("Left/TransferTrask"):GetComponent("UIButton")
	self.Transfer = self.Trans:Find("Left/Transfer"):GetComponent("UIButton")
	self.Right = self.Trans:Find("Right")
	self.Left = self.Trans:Find("Left")

	self.Panel = self.Trans:Find("Center/Panel"):GetComponent("UIPanel")
	self.TipsNextHead = self.Trans:Find("Center/Panel/SuccessTips/TipsNextHead"):GetComponent("UISprite")
	self.TipsTransferDes = self.Trans:Find("Center/Panel/SuccessTips/TipsTransferDes"):GetComponent("UILabel")
	self.TipsAttackValue =UIUtils.FindGo(self.Trans,"Center/Panel/SuccessTips/AttributeBg/Attribute/Clone")
    self.TipsAttackGrid =  UIUtils.FindGrid(self.Trans,"Center/Panel/SuccessTips/AttributeBg/Attribute")
	self.TipsNextName = self.Trans:Find("Center/Panel/SuccessTips/TipsNextHead/TipsNextName"):GetComponent("UILabel")
	self.CloseTips = self.Trans:Find("Center/Panel/SuccessTips/CloseTips"):GetComponent("UIButton")
	self.VfxNode = self.Trans:Find("Center/Vfx"):GetComponent("UIPanel")
	self.SkillDes = self.Trans:Find("Left/ChangeContainer/SkillDes"):GetComponent("UISprite")
	self.SkillDes.gameObject:SetActive(false)
	self.Des = self.Trans:Find("Left/ChangeContainer/SkillDes/Scroll/Des"):GetComponent("UILabel")
	self.CloseBox = self.Trans:Find("Left/ChangeContainer/SkillDes/CloseBox"):GetComponent("UIButton")
	self.Lv = self.Trans:Find("Left/ChangeContainer/ChangeTitle/Lv"):GetComponent("UILabel")
	self.LeftName = self.Trans:Find("Left/ChangeContainer/ChangeTitle/LeftName"):GetComponent("UILabel")
	self.RightName = self.Trans:Find("Left/ChangeContainer/ChangeTitle/RightName"):GetComponent("UILabel")
	self.TaskDes = self.Trans:Find("Left/TaskDes"):GetComponent("UILabel")
	self.Max = self.Trans:Find("Left/Max"):GetComponent("UISprite")
    self.Skin = UIUtils.RequireUIRoleSkinCompoent(self.Trans:Find("Right/UIRoleSkinCompoent"))
    if self.Skin then
        self.Skin:OnFirstShow(self.this, FSkinTypeCode.Player);
    end
	self.Texture = self.Trans:Find("Center/Texture"):GetComponent("UITexture")
	self.SkipTask = self.Trans:Find("Left/SkipTask"):GetComponent("UIButton")
end

function UITransferForm:RegUICallback()
    self.CloseBtn.onClick:Clear();EventDelegate.Add(self.CloseBtn.onClick,Utils.Handler(self.OnClickCloseBtn,self) )
    self.TransferTrask.onClick:Clear();EventDelegate.Add(self.TransferTrask.onClick,Utils.Handler(self.OnClickTransferTrask,self) )
    self.Transfer.onClick:Clear();EventDelegate.Add(self.Transfer.onClick,Utils.Handler(self.OnClickTransfer,self) )
    self.CloseTips.onClick:Clear(); EventDelegate.Add(self.CloseTips.onClick,Utils.Handler(self.OnCloseTips,self) )
    self.OldHead.onClick:Clear(); EventDelegate.Add(self.OldHead.onClick,Utils.Handler(self.OnClickSkill,self) )
    self.NextHead.onClick:Clear(); EventDelegate.Add(self.NextHead.onClick,Utils.Handler(self.OnClickTallent,self) )
    self.CloseBox.onClick:Clear(); EventDelegate.Add(self.CloseBox.onClick,Utils.Handler(self.OnClickSkillDes,self) )
    self.SkipTask.onClick:Clear();EventDelegate.Add(self.SkipTask.onClick,Utils.Handler(self.OnClickSkipTask,self) )
end

function UITransferForm:DeleteVfx()
    if self.Vfx then
        self.Vfx:Destroy()
        self.Vfx = nil
    end
end

--界面按钮
function UITransferForm:OnCloseTips()
    if self.Panel.gameObject.activeSelf then
        self.Panel.gameObject:SetActive(false)
        self:DeleteVfx()
    end
    self:OnClose(nil)
end

function UITransferForm:OnClickCloseBtn()
    self:OnClose(nil)
end

function UITransferForm:OnClickTransferTrask()
    if not GameCenter.TransferSystem.TransferData.CanTransfer then
        local _lv = GameCenter.GameSceneSystem:GetLocalPlayerLevel()
        if _lv < (GameCenter.TransferSystem.TransferData.Cfg  and GameCenter.TransferSystem.TransferData.Cfg.LevelCap or 0) then
            local _messagestr = DataConfig.DataMessageString.Get("TRANSFERFORM_XUYAOXXJILINGQUZHUANZHIRENWU")
            local _messagevalue =  CommonUtils.GetLevelDesc(GameCenter.TransferSystem.TransferData.Cfg and GameCenter.TransferSystem.TransferData.Cfg.LevelCap or 0)
            _messagestr = UIUtils.CSFormat(_messagestr,_messagevalue)
            GameCenter.MsgPromptSystem:ShowMsgBox(_messagestr, 
                function(code)
                    if code == MsgBoxResultCode.Button2 then

                    end
                end)
            return;
        end
    end
    local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
    if _p then
        if _p.Level >= GameCenter.TransferSystem.TransferData.NextCfg.Level then
            local _camp = 0
            local _nextTaskid = 0
            if GameCenter.TransferSystem.TransferData.IsAccessTask 
            then
                GameCenter.TaskManager:StarTask(GameCenter.TaskManager:GetTransferTask())
                self:OnClose(nil);
            else
                if UnityUtils.USE_NEW_CFG() then
                    local _tasks = GameCenter.TransferSystem.TransferData.NextCfg.Task
                    for i=1,#_tasks do
                        if _camp == _tasks[i].Camp then
                            _nextTaskid = _tasks[i].NextTaskID
                            break
                        end
                    end
                else
                    local _strs = Utils.SplitStr(GameCenter.TransferSystem.TransferData.NextCfg.Task,';')
                    for i=1,#_strs do
                        local _values = Utils.SplitStr(_strs[i],'_')
                        _nextTaskid = tonumber(_values[2]) and tonumber(_values[2]) or -1
                        break
                    end
                end
                --当前等级等于转职等级才能领取任务
                GameCenter.TaskManager:AutoAccessTask(_nextTaskid);
                self:OnClose(nil);
            end
        end
    end
end

function UITransferForm:OnClickTransfer()
    GameCenter.TransferSystemMsg:ReqChangeJob()
end

function UITransferForm:OnClickGoTo()
    if self.TargetList then
        for i=1,#self.TargetList do
            if self.TargetList[i].Targ == GameCenter.TransferSystem.SelectTag then
                GameCenter.MainFunctionSystem.DoFunctionCallBack(self.TargetList[i].UIID, nil)
                self:OnClose(nil)
            end
        end
    end
end


function UITransferForm:OnClickSkill()
	local _cfg = GameCenter.TransferSystem.TransferData.NextCfg
	if _cfg then
		local _skillCfg = DataConfig.DataSkill[_cfg.SkillID]
        if _skillCfg then
			local _cellSkillCfg = DataConfig.DataPlayerSkill[_skillCfg.CellId]
            if _cellSkillCfg then
				local _cellCfg = PlayerSkillSystemStatic.FindCellCfg(_cellSkillCfg.Pos)
				if _cellCfg then				
					local _damage = 0
					local _cellInst = GameCenter.PlayerSkillSystem:GetCellInst(_skillCfg.CellId)
					if _cellInst then
						_damage = _cellInst.CellLevel * _skillCfg.DamageUp + _skillCfg.DamageBase
					else
						_damage = _skillCfg.DamageUp + _skillCfg.DamageBase
					end
					self.Des.text = string.format(_cellCfg.BaseBranch.Desc, _damage)
					self.Des.gameObject:SetActive(true)
				end
			end
		end
    end
    if self.SkillDes then
        self.SkillDes.gameObject:SetActive(true)
    end
end

function UITransferForm:OnClickTallent()
    local _cfg = GameCenter.TransferSystem.TransferData.NextCfg 
    if _cfg then
        local _skillCfg = DataConfig.DataSkill[_cfg.TalentID]     
        if _skillCfg then
            self.Des.text = _skillCfg.Desc
            self.Des.gameObject:SetActive(true)
        end
    end
    if self.SkillDes then
        self.SkillDes.gameObject:SetActive(true)
    end
end

function UITransferForm:OnClickSkillDes()
    if self.SkillDes then
        self.SkillDes.gameObject:SetActive(false)
    end
end

function UITransferForm:OnClickSkipTask()
    if GameCenter.TransferSystem.TransferData.NextCfg then
        if GameCenter.TransferSystem.TransferData.NextCfg.GenderClass <= #self.GoldList then
            local _messagestr = DataConfig.DataMessageString.Get("TASK_CHANGEJOB_ONEKEY_TISHI")
            local _messagevalue = self.GoldList[GameCenter.TransferSystem.TransferData.NextCfg.GenderClass]
            _messagestr = UIUtils.CSFormat(_messagestr,_messagevalue, GameCenter.TransferSystem.TransferData.NextCfg.GenderClass)
            GameCenter.MsgPromptSystem:ShowMsgBox(_messagestr, function(code)      
                        if (code == MsgBoxResultCode.Button2) then
                            GameCenter.TaskManagerMsg:ReqQuickFinish(TaskType.ZhuanZhi)
                        end
                end)
        end
    end
end
--end 

--更新转职结果
function UITransferForm:OnUpdateTransfer(obj, sender)
	local _task = GameCenter.TaskManager:GetTransferTask()
    if _task then
        self.SkipTask.gameObject:SetActive(_task.TransferData.Cfg.CanSkip == 1 and true or false)
    else
        self.SkipTask.gameObject:SetActive(false)
    end 

    if (self.Panel) then
        self.Panel.gameObject:SetActive(false)
    end 
    GameCenter.TransferSystem:SetData()
    if obj ~= nil then
        if obj then
            self:InitVariable()
            self:SetHead()
            self:SetGoods()
            if GameCenter.TransferSystem.TransferData.IsMaxTransfer then
                if GameCenter.TransferSystem.TransferData.Cfg ~= nil then
                    self:SetModel(GameCenter.TransferSystem.TransferData.Cfg.Model)
                end
            else
                if GameCenter.TransferSystem.TransferData.NextCfg ~= nil then
                    self:SetModel(GameCenter.TransferSystem.TransferData.NextCfg.Model)
                end
            end
            self:SetTitleDes()
            self:SetButtons()
            self:SetAttributeArea()
        end
    end
end

--转职成功
function UITransferForm:TransferSuccess(obj, sender)
    self:PlayVfx()
end

--任务改变更新
function UITransferForm:TaskChangeUpdate(obj, sender)
    local _task = GameCenter.TaskManager:GetTransferTask()
    if _task then
        self.SkipTask.gameObject:SetActive(_task.TransferData.Cfg.CanSkip == 1 and true or false)
    else
        self.SkipTask.gameObject:SetActive(false)
    end
    if self.Panel then
        self.Panel.gameObject:SetActive(false)
    end
    GameCenter.TransferSystem:SetData()
    self:SetButtons()
    self:SetGoods()
end

--完成任务更新
function UITransferForm:IsTaskFinish(obj, sender)
    local _result = obj
    if _result then
        local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
        if not _p then
            return
        end
        local _camp = 0
        local _nextTaskid = 0
        if UnityUtils.USE_NEW_CFG()  then
            local _tasks = GameCenter.TransferSystem.TransferData.NextCfg.Task
            for i=1,#_tasks do
                if _camp == _tasks[i].Camp then
                    _nextTaskid = _tasks[i].NextTaskID;
                    break
                end
            end
        end

        if _result.isFinish then
            local type = TaskType.__CastFrom(_result.type)
            if type ~= TaskType.ZhuanZhi then
               return
            end

            local _cfg = DataConfig.DataTaskGender[_result.taskId]

            if not _cfg then
                return 
            end

            local _Tasktype = TaskBeHaviorType.__CastFrom(_cfg.TaskType)
            if TaskBeHaviorType.Talk ~= _Tasktype then
                GameCenter.TransferSystem.TransferData.CanTransfer = true
            else
                GameCenter.TransferSystem.TransferData.CanTransfer = false;
            end

        elseif not _result.isFinish then

            if GameCenter.TaskManager.TaskContainer:Find(_nextTaskid) then
                GameCenter.TransferSystem.TransferData.IsAccessTask = true
            end

        end
        self:SetButtons()
    end
end

function UITransferForm:CloseTopUI(obj, sender)
    self:OnCloseTips()
end


function UITransferForm:SetHeadInfo(skillCfg,head,name,hander)
    if skillCfg then
        local _iconId = skillCfg.Icon
        name.text = skillCfg.Name
        local _icon = UIUtils.RequireUISprite(head.transform:Find("Icon"))
        if _icon then
            _icon.spriteName = string.format("skill_%s", _iconId);
        end
        if hander then
            hander()
        end
    end
end

--设置头像信息
function UITransferForm:SetHead()
    if not GameCenter.TransferSystem.TransferData.IsMaxTransfer then
        local _cfg = GameCenter.TransferSystem.TransferData.NextCfg
        if _cfg then
            local _skillCfg = DataConfig.DataSkill[_cfg.SkillID]
            self:SetHeadInfo(_skillCfg,self.OldHead,self.OldName)
        end

        if _cfg then
            local _skillCfg = DataConfig.DataSkill[_cfg.TalentID]
            self:SetHeadInfo(_skillCfg,self.NextHead,self.NextName,
            function()
                self.TransferDes.text = _cfg.Des
            end)
        end

        _cfg = GameCenter.TransferSystem.TransferData.Cfg;
        if _cfg then
            local _skillCfg = DataConfig.DataSkill[_cfg.TalentID]
            self:SetHeadInfo(_skillCfg,self.TipsNextHead,self.TipsNextName,
            function()
                self.TipsTransferDes.text = _cfg.Des
            end)
        end
    else
        local _cfg = GameCenter.TransferSystem.TransferData.Cfg;
        if _cfg then
            local _skillCfg = DataConfig.DataSkill[_cfg.TalentID]
            self:SetHeadInfo(_skillCfg,self.OldHead,self.OldName)
        end
        if _cfg then
            local _skillCfg = DataConfig.DataSkill[_cfg.TalentID]
            self:SetHeadInfo(_skillCfg,self.NextHead,self.NextName,
            function()
                self.TransferDes.text = _cfg.Des
            end)
        end
    end
end

--设置道具
function UITransferForm:SetGoods()
    if not GameCenter.TransferSystem.TransferData.IsMaxTransfer then
        if not GameCenter.TransferSystem.TransferData then
            return
        end
        if UnityUtils.USE_NEW_CFG() then
            local _upitems = GameCenter.TransferSystem.TransferData.NextCfg.UpItemInfo;
            for i=1,#_upitems do
                if i <= #self.ItemList then
                    self:SetItem(self.ItemList[i], _upitems[i].Id, _upitems[i].Num);
                end
            end
        else
            local _cs = {';','_'}
            local _list = Utils.SplitStrByTableS(GameCenter.TransferSystem.TransferData.NextCfg.UpItemInfo,_cs);
            local _count = 0
            for i=1,#_list do
                if #_list[i] ~= 2 then
                    break
                end
                _count = _count + 1
                self.ItemList[_count].gameObject:SetActive(true)
                if i <= #self.ItemList then
                    self:SetItem(self.ItemList[i], _list[i][1], _list[i][2]);
                end
            end
            for i=_count + 1,#self.ItemList do
                self.ItemList[i].gameObject:SetActive(false)
            end
        end
    else
        for i=1,#self.ItemList do
            self.ItemList[i].gameObject:SetActive(true)
        end
    end
end

function UITransferForm:SetItem(trans,id,num)
    if trans then
        local _item = self.ItemDicGo[trans]
        if _item == nil then
            _item = UIItem:New(trans)
            self.ItemDicGo[trans] = _item
        end
        if _item then
            _item:InItWithCfgid(id,num,true)
            _item:BindBagNum()
            _item.IsShowTips = false
        end
    end
end

--设置界面等级名字信息等
function UITransferForm:SetTitleDes()
	if not GameCenter.TransferSystem.TransferData.IsMaxTransfer then
		if GameCenter.TransferSystem.TransferData.Cfg and GameCenter.TransferSystem.TransferData.NextCfg then
			self.Lv.text = GameCenter.TransferSystem.TransferData.NextCfg.GenderNum
			self.LeftName.text = GameCenter.TransferSystem.TransferData.Cfg.Name
			self.RightName.text = GameCenter.TransferSystem.TransferData.NextCfg.Name
			self.LeftName.gameObject:SetActive(true)
			self.RightName.gameObject:SetActive(true)
		end
	else
		if GameCenter.TransferSystem.TransferData.Cfg then
			self.Lv.text = GameCenter.TransferSystem.TransferData.Cfg.GenderNum
		end
		self.LeftName.gameObject:SetActive(false)
		self.RightName.gameObject:SetActive(false)
	end
end

--设置按钮状态
function UITransferForm:SetButtons()
    if GameCenter.TransferSystem.TransferData.IsMaxTransfer then
		self.Transfer.gameObject:SetActive(false)
		self.TransferTrask.gameObject:SetActive(false)
		self.TaskDes.text = ""
        self.Max.gameObject:SetActive(true)
    else
        self.Max.gameObject:SetActive(false);
        if not GameCenter.TransferSystem.TransferData.CanTransfer then
            --显示接取任务
            self.Transfer.gameObject:SetActive(false);
            self.TransferTrask.gameObject:SetActive(true);
            if not GameCenter.TransferSystem.TransferData.IsAccessTask then
                local _messagestr =DataConfig.DataMessageString.Get("TRANSFERFORM_XUYAOXXJILINGQUZHUANZHIRENWU")
                local _messagevalue = CommonUtils.GetLevelDesc(GameCenter.TransferSystem.TransferData.Cfg ~= nil and GameCenter.TransferSystem.TransferData.Cfg.LevelCap or 0)
                _messagestr = UIUtils.CSFormat(_messagestr,_messagevalue)
                self.TaskDes.text = _messagestr
            else
                local _task = GameCenter.TaskManager:GetTransferTask()
                if _task then
                    local behavior = GameCenter.TaskBeHaviorManager:GetBehavior(_task.Data.Id)
                    if behavior then
                        self.TaskDes.text = behavior.UiDes;
                    end
                end
            end
        else
            self.Transfer.gameObject:SetActive(true);
            self.TransferTrask.gameObject:SetActive(false);
            self.TaskDes.text = DataConfig.DataMessageString.Get("TRANSFERFORM_KEYIZHUANZHI")
        end
	end
end 

--设置模型
function UITransferForm:SetModel(star)
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    if _lp then
        local _modelId= 0
        local _occ = Utils.GetEnumNumber(tostring(_lp.Occ))
        if _lp.FashionBodyModelID > 0 then
            _modelId = RoleVEquipTool.GetFashionModelID(_occ, _lp.FashionBodyModelID, star)
        else
            _modelId = RoleVEquipTool.GetBodyModelID(_occ, _lp.BodyModelID, star)
        end
        self.Skin:SetEquip(FSkinPartCode.Body, _modelId);
        self.Skin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetLPWeaponModel())
        self.Skin:SetEquip(FSkinPartCode.Wing, RoleVEquipTool.GetLPWingModel())
        local _vfxId = GameCenter.TransferSystem:GetModelCfgId(_occ, _lp.PropMoudle.GradeLevel)
        if _vfxId ~= 0 then
            self.Skin:SetEquip(FSkinPartCode.TransVfx, _vfxId)
        end
        self.Skin:SetLocalScale(180)
        self.Skin.NormalRot = 160
        self.Skin:ResetRot()
    end
end

--设置属性
function UITransferForm:SetAttribute(type, value,go,tipsgo)
    local _value = UIUtils.FindLabel(go.transform,"Value")
    _value.text = tostring(value)
    local _name = go.transform:GetComponent("UILabel")
    _name.text = BattlePropTools.GetBattlePropName(type)
    local _tipsvalue = UIUtils.FindLabel(tipsgo.transform,"Value")
    _tipsvalue.text = tostring(value)
    local _tipsname = tipsgo.transform:GetComponent("UILabel")
    _tipsname.text = BattlePropTools.GetBattlePropName(type)
end

--设置属性区域
function UITransferForm:SetAttributeArea()
	local _cfg = nil
	if(not GameCenter.TransferSystem.TransferData.Cfg and GameCenter.TransferSystem.TransferData.IsMaxTransfer) then
		--显示转已经达到顶峰的界面
		_cfg = GameCenter.TransferSystem.TransferData.Cfg;
		if _cfg then
			local _cs = {';', '_'}
            local _list = Utils.SplitStrByTableS(_cfg.AttributeValu, _cs)
            local _listobj = NGUITools.AddChilds(self.AttackGrid.gameObject,self.AttackValue,#_list)
            local _listobjtips = NGUITools.AddChilds(self.TipsAttackGrid.gameObject,self.TipsAttackValue,#_list)
			for i = 1, #_list do
                if #_list[i] ~= 2 then
                    Debug.LogError(string.format("ChangeJob Table Attribute Configuration Error, CfgId = %d", GameCenter.TransferSystem.TransferData.NextCfgId))
					break
				end
				if i <= #self.ItemList then
					self:SetAttribute(_list[i][1],0,_listobj[i - 1],_listobjtips[i - 1]);
				end
			end
		end
	elseif GameCenter.TransferSystem.TransferData.NextCfg then
        _cfg = GameCenter.TransferSystem.TransferData.NextCfg;
        if UnityUtils.USE_NEW_CFG() then
            local _attrs = GameCenter.TransferSystem.TransferData.NextCfg.AttributeValue;
            local _listobj = NGUITools.AddChilds(self.AttackGrid.gameObject,self.AttackValue,#_attrs)
            local _listobjtips = NGUITools.AddChilds(self.TipsAttackGrid.gameObject,self.TipsAttackValue,#_attrs)
            for i = 1,#_attrs do
                self:SetAttribute(_attrs[i].Id, _attrs[i].Value,_listobj[i - 1], _listobjtips[i - 1]);
            end
        end
        if _cfg and GameCenter.TransferSystem.TransferData.Cfg then
            local _cs = {';', '_'}
			local _list = Utils.SplitStrByTableS(_cfg.AttributeValue, _cs)
            local _list1 = Utils.SplitStrByTableS(GameCenter.TransferSystem.TransferData.Cfg.AttributeValue, _cs)
            local _listobj = NGUITools.AddChilds(self.AttackGrid.gameObject,self.AttackValue,#_list)
            local _listobjtips = NGUITools.AddChilds(self.TipsAttackGrid.gameObject,self.TipsAttackValue,#_list)
            for i=1,#_list do
                if #_list[i] ~= 2 then
                    Debug.LogError(string.format("ChangeJob Table Attribute Configuration Error, CfgId = %d", GameCenter.TransferSystem.TransferData.NextCfgId));
					break
                end
                if i <= #_list1 then
                    self:SetAttribute(_list[i][1], _list[i][2] - _list1[i][2],_listobj[i - 1],_listobjtips[i - 1]);
                end
            end
        end
    end
    self.AttackGrid:Reposition()
    self.TipsAttackGrid:Reposition()
end

function UITransferForm:PlayVfx()
	self.Vfx = CS.Funcell.Core.Asset.FGameObjectVFX(ModelTypeCode.UIVFX, 95);
	self.Vfx:SetParent(self.VfxNode.transform, true);
	self.Vfx:SetLayer(LayerUtils.UITop, true);
	self.Vfx:Play(1);
	self._showTips = true;
end

function UITransferForm:Update()
    if self._showTips then
        if self.DelaTime > 0 then
            self.DelaTime = self.DelaTime - Time.DeltaTime
        else
            self.DelaTime = 2
            self.Panel.gameObject:SetActive(true)
            self._showTips = false
        end
    end
    if self.Vfx then
        if self.VfxOverTime > 0 then
            self.VfxOverTime = self.VfxOverTime - Time.DeltaTime
        else
            self.VfxOverTime = 10
            if self.Panel.gameObject.activeSelf then
                self.Panel.gameObject:SetActive(false)
                self:DeleteVfx()
                self:OnClose(nil)
            end
        end
    end
end

return UITransferForm