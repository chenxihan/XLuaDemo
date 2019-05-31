------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： Main.lua
--模块： Main
--描述： Lua的脚本的启动文件
------------------------------------------------
local Main = {}
Profiler = require("Common.ExternalLib.Profiler")

--主入口函数。从这里开始lua逻辑
function Main.Start(startTime)
	Profiler.Start()
	-- [vscode_debug]
	require("LuaDebug")("localhost",7003)
	require("Global.Enum")
	require("Global.Global")

	-- Debug.IsLogging = false
	-- [当前内存分配]
	Debug.Log("total memory:", Memory:Total())
	Debug.Log(Memory:Snapshot())
	Debug.Log("=======================[Main.Start]============================")	
	Time.Start(startTime);
end

--创建核心系统
function Main.NewCoreSystem()
	GameCenter:NewCoreSystem()
end
--核心系统初始化
function Main.CoreInitialize()
	GameCenter:CoreInitialize()
end
--核心系统卸载
function Main.CoreUninitialize()
	GameCenter:CoreUninitialize()
end

--创建逻辑系统
function Main.NewLogicSystem()
	GameCenter:NewLogicSystem()
end
--逻辑系统初始化
function Main.LogicInitialize()
	GameCenter:LogicInitialize()
end
--逻辑系统卸载
function Main.LogicUninitialize()
	GameCenter:LogicUninitialize()
end

--更新心跳
function Main.Update(deltaTime)
	Time.SetDeltaTime(deltaTime);
	KeyCodeSystem.Update()
	GameCenter:Update(deltaTime)
	LuaBehaviourManager:Update(deltaTime)
end

function Main.LateUpdate(deltaTime)
	GameCenter:LateUpdate(deltaTime)
end

function Main.FixedUpdate(fixedDeltaTime)
	GameCenter:FixedUpdate(fixedDeltaTime)
end

--创建ui对应的lua控制脚本（c#端调用）
function Main.CreateLuaUIScript(name, gobj)
	GameCenter.UIFormManager:CreateLuaUIScript(name, gobj)
end

--处理服务器发来的消息
function Main.DoResMessage(msgid, bytes)
	GameCenter.Network.DoResMessage(msgid, bytes)
end

--获取所有Lua端的消息ID
function Main.GetResLuaMsgIDs()
	return GameCenter.Network.GetResLuaMsgIDs()
end

--判断是否有某个事件
function Main.HasEvent(eID)
	return UILuaEventDefine.HasEvent(eID)
end

--窗体关闭时,是否删除ui预制件
function Main.IsDestroyPrefabOnClose()
	return AppConfig.IsDestroyPrefabOnClose
end

--是否加载Lua配置
function Main.IsLoadLuaConfig()
	return AppConfig.IsLoadLuaConfig
end

--是否走lua逻辑
function Main.IsLoadLuaLogic()
	return AppConfig.IsLoadLuaLogic
end

--是否运行分析工具
function Main.IsRuntimeProfiler()
	return AppConfig.IsRuntimeProfiler
end

--是否记录的耗时写文件
function Main.IsRecordWriteFile()
	return AppConfig.IsRecordWriteFile
end

--是否收集消耗时间
function Main.IsCollectRecord()
	return AppConfig.IsCollectRecord
end

--c#获取lua配置后，是否释放lua配置的内存
function Main.IsFreeLuaCfg()
	return AppConfig.IsFreeLuaCfg
end

--打印配置表加载耗时
function Main.TimeRecordPrint()
	CS.Funcell.Code.Logic.TimeRecord.Print()
end

--是否需要重新加载界面
function Main.IsRenewForm(name)
	return GameCenter.UIFormManager:IsRenew(name)
end

--重新加载界面
function Main.RenewForm(name,paths)
	if not GameCenter.UIFormManager then
		return
	end
	GameCenter.UIFormManager:DestroyForm(name)
	GameCenter.UIFormManager:AddRenewForm(name)
	for i=0,paths.Length-1 do
		Utils.RemoveRequiredByName(paths[i])
	end
end

--重新加载逻辑系统
function Main.RenewSystem(name,paths)
	GameCenter[string.format("%sSystem", name)] = nil
	for i=0,paths.Length-1 do
		-- Debug.Log("==============>>    ",paths[i])
		Utils.RemoveRequiredByName(paths[i])
	end
	GameCenter[string.format("%sSystem", name)] = require(string.format("Logic.%s.%sSystem", name, name))
end

--进入场景回调
function Main.OnEnterScene(mapID)
	--通知地图逻辑系统进入场景
	if GameCenter.MapLogicSystem ~= nil then
		GameCenter.MapLogicSystem:OnEnterScene(mapID)
	end
end

--离开场景回调
function Main.OnLeaveScene()
	--通知地图逻辑系统离开场景
	if GameCenter.MapLogicSystem ~= nil then
		GameCenter.MapLogicSystem:OnLeaveScene()
	end
end

return Main