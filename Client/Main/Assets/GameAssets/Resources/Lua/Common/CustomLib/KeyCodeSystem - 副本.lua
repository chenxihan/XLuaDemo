------------------------------------------------
--作者：xihan
--日期：2019-04-03
--文件：KeyCodeSystem.lua
--模块：KeyCodeSystem
--描述：键盘快捷键监听系统
------------------------------------------------
local M = {}
local GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local KeyCode = CS.UnityEngine.KeyCode

-- local StringDefines2 = nil;

function M.Require()
	KeyCodeSystem = nil
	Utils.RemoveRequiredByName("Common.CustomLib.KeyCodeSystem")
	KeyCodeSystem = require("Common.CustomLib.KeyCodeSystem")
end

function M.Update(deltaTime)
	if GetKeyDown(KeyCode.N) then
		Debug.Log("=============[KeyCode.N]==================")
	elseif GetKeyDown(KeyCode.Y) then
		M.Require()
		Debug.Log("=============[KeyCode.Y]=================")
		KeyCodeSystem.Test()
	elseif GetKeyDown(KeyCode.Q) then
		Debug.Log("=============[KeyCode.Q]=================")
	elseif GetKeyDown(KeyCode.F) then
		M.Require();
		M.KeyCodeF();
	elseif GetKeyDown(KeyCode.G) then
		M.Require();
		M.KeyCodeG();
	elseif GetKeyDown(KeyCode.H) then
		M.Require();
		M.KeyCodeH();
	end
end

function M.KeyCodeF()
	Debug.Log("=============[MSG_Achievement.ResAchievementInfo]=================")
	GameCenter.Network.DoTest("MSG_Achievement.ResAchievementInfo",{finishIds = {101,102,5656888,101},canGetIds = {105,105,102,999659}})
	GameCenter.AchievementSystem:GetDataTypeDic()
	M.Test38()
end

function M.KeyCodeG()
	Debug.Log("=============[MSG_Achievement.ResGetAchievement]=================")
	GameCenter.Network.DoTest("MSG_Achievement.ResGetAchievement",{getIds = 201})
	M.Test38()
end

function M.KeyCodeH()
	Debug.Log("=============[MSG_Achievement.ResAddCanGetId]=================")
	GameCenter.Network.DoTest("MSG_Achievement.ResAddCanGetId",{canGetIds = {103,104}})
	M.Test38()
end

function M.Test()
	GameCenter.AchievementSystem:ClearUIdata();
end

function M.Test39()
	local _t = {{id = 2,value = 2},{id = 1,value = 2},{id = 3,value = 1}};
	table.sort(_t, function(a,b)
		if a.value == b.value then
			return a.id < b.id;
		else
			return a.value < b.value;
		end
	end)
	Debug.LogTable(_t)
end

function M.Test38()
	-- Debug.Log("length",Utils.length)
	Debug.LogTableWhite(GameCenter.AchievementSystem.DataTypeDic,"DataTypeDic")
	Debug.LogTableWhite(GameCenter.AchievementSystem.DataIdDic,"DataIDDic")
	Debug.LogTableWhite(GameCenter.AchievementSystem.FinishIdList,"FinishIdList")
	Debug.LogTableWhite(GameCenter.AchievementSystem.CanGetIdList,"CanGetIdList")
end
function M.Test37()
	local _mt = {}
	_mt.__index = _mt;
	_mt.a = 10;
	local _t = {}
	setmetatable(_t, _mt);
	local _t2 = {a = 10}
	local x = 0;
	local _time1 = os.clock()
	for i=1,1000000 do
		x = _t.a
	end
	print("metatable:",os.clock()-_time1)

	_time1 = os.clock()
	for i=1,1000000 do
		x = _t2.a
	end
	print("no metatable:",os.clock()-_time1)
end


function M.Test36()
	local _t = nil;
	local _x = {a = nil}
	collectgarbage("restart")
	collectgarbage("collect")
	collectgarbage("stop")
	local _c1 = collectgarbage("count")*1024;
	_t = {a = nil}
	_x.a = _t
	collectgarbage("collect")
	Debug.Log(collectgarbage("count")*1024-_c1);
end

function M.Test35()
	Profiler.Report("TOTAL")
end

local Memory = require("Common.ExternalLib.Memory")

function M.Test34()
	for k,v in pairs(perf) do
		Debug.Log(k,v)
	end
	Memory:Snapshot()
end

function M.Test33()
	local str = "AAAData/DataXXX"
	Debug.Log(string.find(str,"Data/Data"))

	Debug.Log(string.format("%02d",1))
end

function M.Test32()
	Debug.Log("New 0,0,0,0",Vector4(0,0,0,0))
	Debug.Log("New 0,0,0,0",Vector4.zero)
	Debug.Log("New 1,1,1,1",Vector4.one)

	Debug.Log("New 1,1,1,0",Vector4.one:Set(1,1,1,0))
	Debug.Log("New 1,1,1,1",Vector4.one:Get())

	Debug.Log("Magnitude 1",Vector4.one:Magnitude())
	Debug.Log("SqrMagnitude 1",Vector4.one:SqrMagnitude())

	Debug.Log("GetNormalize 1",Vector4.one:GetNormalize())

	Debug.Log("+ 1,1,1,1",Vector4.one+Vector4.zero)
	Debug.Log("- 0.8,0.8,0.8,0.8",Vector4.one-Vector4(0.2,0.2,0.2,0.2))
	Debug.Log("* 2,2,2,2",Vector4.one*2)
	Debug.Log("/ 0.5,0.5,0.5,0.5",Vector4.one/2)
end

function M.Test31()
	--时间戳（1971年1月2日0点0分0秒）
	Debug.Log(os.date("%X",57600))
end

function M.Test30()
	local H, S, V = Color.RGBToHSV(Color(0.9, 0.7, 0.1, 1.0));
	Debug.Log(H, S, V)
	Debug.Log(Color(0.5,0.5,0.5,0.5).gamma)
	Debug.Log(Color(0.5,0.5,0.5,0.5).linear)
	local Color = require("Common.CustomLib.Utility.Color")
	--Debug.Log( 1 and false or true)
	Debug.Log(Color(0.5,0.5,0.5,0.5):Gamma())
	Debug.Log(Color(0.5,0.5,0.5,0.5):Linear())
end

local Quaternion = require("Common.CustomLib.Utility.Quaternion")

--table结构pairs遍历
function M.Test29()
	local _t ={a = "a",b="b",c="c",[1]=1,[2]=2,[3]=3,[4]=4,}
	for k,v in pairs(_t) do
		print(k,v)
	end
end

local Vector3 = require("Common.CustomLib.Utility.Vector3")
--Quaternion
function M.Test28()
	--1.New
	local _qua = Quaternion(0,0.3826835,0,0.9238795)
	Debug.Log("[0,0.3826835,0,0.9238795] ==> ",_qua)
	--2.Set
	_qua:Set(0,0.7071068,0,0.7071068)
	Debug.Log("[0,0.7071068,0,0.7071068] ==> ",_qua)
	--3.get
	Debug.Log(_qua:Get())
	--4.Clone
	local _quaClone = _qua:Clone()
	Debug.Log("[0,0.7071068,0,0.7071068] ==> ",_quaClone)
	_qua:Set(0,0.3826835,0,0.9238795)
	Debug.Log("[0,0.3826835,0,0.9238795] ==> ",_qua)
	Debug.Log("Clone [0,0.7071068,0,0.7071068] ==> ",_quaClone)
	--5.NewByEuler
	Debug.Log("Euler{0,45,0}:	0,0.3826835,0,0.9238795 ==> ",Quaternion({x=0,y=45,z=0}))
	--6.NewByEuler
	Debug.Log("Euler{0,90,0}:	0,0.7071068,0,0.7071068 ==> ",Quaternion({x=0,y=90,z=0}))
	--7.GetNormalize
	Debug.Log("GetNormalize:	0,0.3826835,0,0.9238795 ==> ",_qua:GetNormalize())
	--8.Normalize
	Debug.Log("Normalize:	0,0.7071068,0,0.7071068 ==> ",_quaClone:Normalize())
	--9.SetIdentity
	Debug.Log("SetIdentity:	0,0,0,1 ==> ",_qua:SetIdentity())
	--10.Inverse
	Debug.Log("Inverse:	0,-0.7071068,0,0.7071068 ==> ",_quaClone:Inverse())
	--11.ToAngleAxis
	Debug.Log("ToAngleAxis:	0,0,0,1 ==> ",_quaClone:ToAngleAxis())
	--12.ToEulerAngles
	Debug.Log("ToEulerAngles:	90 ==> ",_quaClone:ToEulerAngles())
	--13.Forward
	Debug.Log("Forward:	0,0,0,1 ==> ",Quaternion.identity:Forward())
	--14. *
	Debug.Log("* ==> ",Quaternion(0,0.3826835,0,0.9238795)*Vector3.up);
	--15. ==
	Debug.Log("== ==> ",Quaternion.identity == Quaternion(0,0,0,1))
	--16. Dot
	Debug.Log("Dot ==> ",Utils.Dot(Quaternion.identity,Quaternion(1,1,1,1)))
	--17
	--[1,0,0]
	Debug.Log(Quaternion(0,0.7071068,0,0.7071068)*Vector3(0,0,1))
	--90,[0.92387953251129,0.92387953251129,0.92387953251129]
	Debug.Log(Quaternion(0.5,0.5,0.5,0.5):ToAngleAxis())
	--[1,0,0]
	Debug.Log("[1,0,0]",Utils.AngleAxis(Quaternion(0.5,0.5,0.5,0.5):ToAngleAxis())*Vector3(0,0,1))
	--[]
	Debug.Log("FromToRotation ",Quaternion:GetFromToRotation(Vector3.up, Vector3.forward))
	--120.00000762939    (0.6, 0.6, 0.6): -86245104
	--Debug.Log(Quaternion(0.5,0.5,0.5,0.5):ToAngleAxis());
	Debug.Log("Lerp ",Utils.Lerp(Quaternion(-0.5,-0.5,-0.5,-0.5), Quaternion.identity, 0.5))
	local _CSQ = CS.UnityEngine.Quaternion.Lerp(CS.UnityEngine.Quaternion(-0.5,-0.5,-0.5,-0.5),CS.UnityEngine.Quaternion.identity,0.5)
	Debug.Log("CSLerp ",_CSQ.x,_CSQ.y,_CSQ.z,_CSQ.w)

	Debug.Log("Lerp2 ",Utils.Lerp(Quaternion(0.5,0.5,0.5,0.5), Quaternion.identity, 0.5))
	local _CSQ = CS.UnityEngine.Quaternion.Lerp(CS.UnityEngine.Quaternion(0.5,0.5,0.5,0.5),CS.UnityEngine.Quaternion.identity,0.5)
	Debug.Log("CSLerp2 ",_CSQ.x,_CSQ.y,_CSQ.z,_CSQ.w)

	Debug.Log("RotateTowards ",Utils.RotateTowards(Vector3(0,1,0), Vector3(0,0,1), 0.1, 1))

	Debug.Log("RotateTowards ",Utils.RotateTowards(Quaternion.identity, Quaternion(0.5,0.5,0.5,0.5),1))
	-- Utils.SmoothDamp(current, target, currentVelocity, smoothTime)
	Debug.Log("Slerp ",Utils.Slerp(Vector3.up, Vector3.forward, 0.1));
	Debug.Log("Slerp ",Utils.Slerp(Vector3.up, Vector3.forward, 1));
	Debug.Log("Slerp ",Utils.Slerp(Quaternion.identity, Quaternion(0,0.7071068,0,0.7071068), 0.1));
	Debug.Log("Slerp ",Utils.Slerp(Quaternion.identity, Quaternion(0,0.7071068,0,0.7071068), 1));

	Debug.Log("Angle ",Utils.Angle(Quaternion.identity, Quaternion(0,0.7071068,0,0.7071068)))

	Debug.Log("SmoothDamp ",Utils.SmoothDamp(Vector3.up, Vector3.forward, Vector3(0,0,1), 1))
end

function M.Test27()
	local str = nil;
	collectgarbage("collect")
	collectgarbage("stop")
	local _c1 = collectgarbage("count")*1024;
	str = "11111111111111111111"
	collectgarbage("collect")
	Debug.Log(collectgarbage("count")*1024-_c1);
	collectgarbage("restart")
end

function M.Test26()
	local StringDefinesXXX,StringDefinesXXX2,StringDefinesXXX3 = nil,nil,nil
	Utils.RemoveRequiredByName("Config.Data.StringDefinesXXX")
	collectgarbage("collect")
	collectgarbage("stop")
	local _c1 = collectgarbage("count")*1024;
	StringDefinesXXX,StringDefinesXXX2,StringDefinesXXX3 = require("Config.Data.StringDefinesXXX")
	collectgarbage("collect")
	Debug.Log(collectgarbage("count")*1024-_c1);
	collectgarbage("restart")
end

--内存分配
function M.Test25()
	collectgarbage("collect")
	Debug.Log("lua总内存消耗："..collectgarbage("count"));

	DataConfig.MemoryRecordList:Sort(function(a,b) return a.count > b.count end);
	local _allCount = 0;
	for i,v in ipairs(DataConfig.MemoryRecordList) do
		print("=======[DataConfig.MemoryRecordList]=======",i,v.name,v.count .. " KB")
		_allCount = _allCount + v.count;
	end

	Debug.Log("配置总内存：".. _allCount..",其他内存："..(collectgarbage("count")-_allCount));
end


local Vector3 = require("Common.CustomLib.Utility.Vector3")

function M.Test24()
	--1.新建Vector3
	Debug.Log("[11,22,33] ==> ",Vector3(11,22,33));
	Debug.Log("[0,1,0] ==> ",Vector3.up);
	--2.设值
	local _v = Vector3(11,22,33);
	_v:Set(111,222,333);
	Debug.Log("[111,222,333] ==> ",_v);
	Debug.Log("111, 222, 333==> ",_v:Get());
	--3.Clone
	local _vClone = _v:Clone();
	Debug.Log("[111,222,333] ==> ",_vClone);
	Debug.Log("值的比较：true ==> ",_vClone == _v);
	--4.GetNormalize
	local _v2One = Vector3.one
	Debug.Log("[1,1,1] ",_v2One);
	Debug.Log("[0.57735026918963,0.57735026918963,0.57735026918963] ==> ",_v2One:GetNormalize());
	--5.Normalize
	_v2One:Normalize();
	Debug.Log("[0.57735026918963,0.57735026918963,0.57735026918963] ==> ",_v2One);
	--6.Dot
	Debug.Log("1 ==> ",Utils.Dot(Vector3.up,Vector3.one));
	--7.Angle
	Debug.Log("90 ==> ",Utils.Angle(Vector3.up,Vector3.left));
	--8.Distance
	Debug.Log("1.414 ==> ",Utils.Distance(Vector3.one,Vector3.zero));
	--9.Magnitude
	Debug.Log("1.414 ==> ",Vector3.one:Magnitude());
	--10. +
	Debug.Log("[12,24,36] ==> ",Vector3(1,2,3)+Vector3(11,22,33));
	--11. -
	Debug.Log("[5,14,23] ==> ",Vector3(10,20,30)-Vector3(5,6,7));
	--12. *
	Debug.Log("[20,40,60] ==> ",Vector3(10,20,30)*2);
	--13. /
	Debug.Log("[-10,-20,-30] ==> ",-Vector3(10,20,30));
	--14. ==
	Debug.Log("true ==> ",Vector3.zero == Vector3(0.000001,0,0))
	--15.Cross
	Debug.Log("Cross 0,0,0 ==> ",Utils.Cross(Vector3(1,2,3), Vector3(10,20,30)))
	--16.Lerp
	Debug.Log("Lerp 1,2,3 ==> ",Utils.Lerp(Vector3(0,0,0), Vector3(10,20,30), 0.1))
	--17.MoveTowards
	Debug.Log("MoveTowards  [0.057735026918963,0.057735026918963,0.057735026918963] ==> ",Utils.MoveTowards(Vector3(0,0,0), Vector3(10,10,10), 0.1))
	Debug.Log("MoveTowards  [0.057735026918963,0.057735026918963,0.057735026918963] ==> ",Utils.MoveTowards(Vector3(0,0,0), Vector3(10,10,10), 0.2))
	Debug.Log("MoveTowards  [0.057735026918963,0.057735026918963,0.057735026918963] ==> ",Utils.MoveTowards(Vector3(0,0,0), Vector3(10,10,10), 1))
	Debug.Log("MoveTowards  [0.057735026918963,0.057735026918963,0.057735026918963] ==> ",Utils.MoveTowards(Vector3(0,0,0), Vector3(10,0,0), 10))
	--18.Project
	Debug.Log("Project 0,0,0.1 ==> ",Utils.Project(Vector3(0.1,0.1,0.1), Vector3(0,0,1)))
	--19.ProjectOnPlane
	Debug.Log("ProjectOnPlane 1,1,0 ==> ",Utils.ProjectOnPlane(Vector3(1,1,1), Vector3(0,0,1)))
	--20.Reflect
	Debug.Log("Reflect 1,-1,1 ==> ",Utils.Reflect(Vector3(1,1,1), Vector3(0,1,0)))
	--21.AngleAroundAxis
	Debug.Log("AngleAroundAxis 180 ==> ",Utils.AngleAroundAxis (Vector3(1,0,0), Vector3(-1,0,0), Vector3(0,1,0)))
	--22.ClampMagnitude
	Debug.Log("ClampMagnitude 0.5,0,0 ==> ",Utils.ClampMagnitude(Vector3(1,0,0) ,0.5))
end

local Vector2 = require("Common.CustomLib.Utility.Vector2")

function M.Test23()
	--1.新建Vector2
	Debug.Log("[11,22] ==> ",Vector2(11,22));
	Debug.Log("[0,1] ==> ",Vector2.up);
	--2.设值
	local _v = Vector2(11,22);
	_v:Set(111,222);
	Debug.Log("[111,222] ==> ",_v);
	Debug.Log("111, 222 ==> ",_v:Get());
	--Clone
	local _vClone = _v:Clone();
	Debug.Log("[111,222] ==> ",_vClone);
	Debug.Log("值的比较：true ==> ",_vClone == _v);
	--GetNormalize
	local _v2One = Vector2.one
	Debug.Log("[1,1] ",_v2One);
	Debug.Log("[0.707107,0.707107] ==> ",_v2One:GetNormalize());
	--Normalize
	_v2One:Normalize();
	Debug.Log("[0.7,0.7] ==> ",_v2One);
	--Dot
	Debug.Log("1 ==> ",Utils.Dot(Vector2.up,Vector2.one));
	--Angle
	Debug.Log("90 ==> ",Utils.Angle(Vector2.up,Vector2.left));
	--Distance
	Debug.Log("1.414 ==> ",Utils.Distance(Vector2.one,Vector2.zero));
	--Magnitude
	Debug.Log("1.414 ==> ",Vector2.one:Magnitude());
	-- +
	Debug.Log("[12,24] ==> ",Vector2(1,2)+Vector2(11,22));
	-- -
	Debug.Log("[5,14] ==> ",Vector2(10,20)-Vector2(5,6));
	-- *
	Debug.Log("[20,40] ==> ",Vector2(10,20)*2);
	-- /
	Debug.Log("[-10,-20] ==> ",-Vector2(10,20));
	-- ==
	Debug.Log("true ==> ",Vector2.zero == Vector2(0.000001,0))
end

function M.Test22()
	local _v = Vector2:New(1, 2)
	for k,v in pairs(_v) do
		print(k,v)
	end
end

function M.Test21()
	local _t =List:New({{x=1},{x=3},{x=2}})

	_t:Sort( function(a,b)
		return a.x < b.x
	end)

	for k,v in pairs(_t) do
		print(k,v.x)
	end
end

function M.Test20()
	Debug.Log(Vector2.__index)

	local _t1 = Vector2(1,2)
	local _t2 = Vector2(11,22)

	Debug.Log(_t1.Set)
	Debug.Log(_t2.Set)

	Debug.Log(_t1.one)
	Debug.Log(_t2.one)

	Debug.Log(Vector2:New(88, 99))
	local _n = Vector2:New(88, 99)
	_n:Set(11,22)
	Debug.Log(_n)
	Debug.Log(Vector2:New(88, 99):Get())
	local _v = Vector2:New(88, 99)
	local _v2 = _v
	local _clone = _v:Clone();
	local _clone2 = _clone
	_clone:Set(10,20)
	Debug.Log(_v,_clone,_v2,_clone2)

	Debug.Log(Vector2.one:SetNormalize())

	Debug.Log(Vector2.up:Angle(Vector2.right))
	Debug.Log(Vector2.up:Angle(Vector2.down))

	Debug.Log(Vector2.up == Vector2(0,1))
	Debug.Log(Vector2.right/0.5)
	Debug.Log(Vector2.zero+Vector2.one)
	Debug.Log(-Vector2.one)

	Debug.Log(Vector2.up:Distance(Vector2.one))
	Debug.Log(Vector2.one:Normalize())
	Debug.Log(Vector2.one:SqrMagnitude())
	Debug.Log(Vector2.one:Magnitude())
end

function M.Test19()
	local x =1
	local y = 2
	local _t = {x,y}

	for k,v in pairs(_t) do
		print(k,v)
	end
end

function M.Test18()
	Debug.Log(math.Round(4.51)) --大约 5
	Debug.Log(math.Sign(-20)) -- -1
	Debug.Log(math.Clamp(20, 0, 15)) --15
	Debug.Log(math.Lerp(0, 10, 0.1)) --1.0
	Debug.Log(math.LerpUnclamped(0, 10, 1.1)) --11.0
	Debug.Log(math.Repeat(370, 360)) --10
	Debug.Log(math.LerpAngle(0, 90, 1)) --90
	Debug.Log(math.LerpAngle(0, 90, 1.1)) --90
	Debug.Log(math.MoveTowards(0, 1, 0.1)) --0.1
	Debug.Log(math.MoveTowards(0, 1, -0.1)) -- -0.1
	Debug.Log(math.DeltaAngle(30, 370)) -- -20
	Debug.Log(math.MoveTowardsAngle(1, 180, 5)) --6 ??
	Debug.Log(math.MoveTowardsAngle(170, 180, 20)) --190 ??
	Debug.Log(1.0 == 10.0/10.0)
	Debug.Log(math.Approximately(1.0, 10.0/10.0))
	Debug.Log(math.InverseLerp(0, 1, 0.1)) --0.1
	Debug.Log(math.InverseLerp(0, 1, 0.9)) --0.9
	Debug.Log(math.PingPong(0, 360)) --0
	Debug.Log(math.PingPong(370, 360)) --350
	Debug.Log(math.Random(0, 1)) --0.17306
	Debug.Log(math.IsNan(1/0)) --false
	Debug.Log(math.Gamma(6, 2, 6)) --6
	Debug.Log(math.HorizontalAngle({x = 1,y = 0,z = 1})) --45.0
	Debug.Log("======================")
	local current, currentVelocity = math.SmoothDamp(0,100,4,1,10)
	Debug.Log(current, currentVelocity)
	for i=1,100 do
		current, currentVelocity = math.SmoothDamp(current,100,currentVelocity,1,5)
		Debug.Log(current, currentVelocity)
	end
	Debug.Log("======================")
	Debug.Log(math.SmoothDampAngle(0, 360, 10, 1, 5, 0.1))

	Debug.Log(math.SmoothStep(0, 10, 0)) --0
	Debug.Log(math.SmoothStep(0, 10, 0.1)) --0.28
	Debug.Log(math.SmoothStep(0, 10, 0.2)) --1.04
	Debug.Log(math.SmoothStep(0, 10, 0.3)) --2.16
	Debug.Log(math.SmoothStep(0, 10, 0.4)) --3.52
	Debug.Log(math.SmoothStep(0, 10, 0.5)) --0.5
	Debug.Log(math.SmoothStep(0, 10, 0.6)) --6.48
	Debug.Log(math.SmoothStep(0, 10, 0.7)) --7.84
	Debug.Log(math.SmoothStep(0, 10, 0.8)) --8.96
	Debug.Log(math.SmoothStep(0, 10, 0.9)) --9.72
	Debug.Log(math.SmoothStep(0, 10, 1)) --1
end

function M.Test17()
	Debug.Log(math.maxinteger) -- 最大值 9223372036854775807
	Debug.Log(math.mininteger) -- 最小值 -9223372036854775808
	Debug.Log(math.huge) -- 无穷大	inf
	Debug.Log(math.tointeger(10.0)) -- 转数值
	Debug.Log( math.pi) --	圆周率	math.pi	3.1415926535898
	Debug.Log(math.abs(-2012))	--取绝对值	math.abs(-2012)	2012
	Debug.Log( math.ceil(9.1))	--向上取整	math.ceil(9.1)	10
	Debug.Log( math.floor(9.9))	--向下取整	math.floor(9.9)	9
	Debug.Log( math.max(2,4,6,8))	--取参数最大值	math.max(2,4,6,8)	8
	Debug.Log( math.min(2,4,6,8))	--取参数最小值	math.min(2,4,6,8)	2
	Debug.Log( math.sqrt(65536))	--开平方	math.sqrt(65536)	256
	Debug.Log(math.modf(20.12))	--取整数和小数部分	math.modf(20.12)	20   0.12
	Debug.Log( math.randomseed(os.time()))	--设随机数种子	math.randomseed(os.time())
	Debug.Log( math.random(5,90))	--取随机数	math.random(5,90)	5~90
	Debug.Log( math.rad(180))	--角度转弧度	math.rad(180)	3.1415926535898
	Debug.Log(math.deg(math.pi))	--弧度转角度	math.deg(math.pi)	180
	Debug.Log( math.exp(4))	--e的x次方	math.exp(4)	54.598150033144
	Debug.Log(math.log(54.598150033144)	)--计算x的自然对数	math.log(54.598150033144)	4
	Debug.Log(math.sin(math.rad(30))	)--正弦	math.sin(math.rad(30))	0.5
	Debug.Log(math.cos(math.rad(60))	)--余弦	math.cos(math.rad(60))	0.5
	Debug.Log( math.tan(math.rad(45))	)--正切	math.tan(math.rad(45))	1
	Debug.Log( math.deg(math.asin(0.5))	)--反正弦	math.deg(math.asin(0.5))	30
	Debug.Log( math.deg(math.acos(0.5))	)--反余弦	math.deg(math.acos(0.5))	60
	Debug.Log( math.deg(math.atan(1))	)--反正切	math.deg(math.atan(1))	45
	Debug.Log( math.type(1.0) )--获取类型是integer还是float
	Debug.Log( math.fmod(65535,2) )--取模 math.fmod(65535,2)	1
end

function M.Test16()
	local t = {a=1;b=2}
	Debug.LogError(100//9)
	Debug.LogError(string.format("%d",10))
end

function M.Test15()
	local _t1 = List.New()
	_t1:Add("a")
	_t1:Add("b")

	for i,v in ipairs(_t1) do
		print("Add a、b =========== >> ",i,v)
	end

	_t1:Remove("a")

	for i,v in ipairs(_t1) do
		print("Remove a =========== >> ",i,v)
	end

	_t1:Add("c")
	_t1:RemoveAt(1)

	for i,v in ipairs(_t1) do
		print("RemoveAt 1 =========== >> ",i,v)
	end

	_t1:Add("e")
	_t1:Add("d")

	_t1:Sort()

	for i,v in ipairs(_t1) do
		print("Sort c、e、d、 =========== >> ",i,v)
	end

	_t1:AddRange({"f","g"})
	for i,v in ipairs(_t1) do
		print("AddRange c、e、d、f、g =========== >> ",i,v)
	end
	print("Contains a,v =========== >> ",_t1:Contains("c"),_t1:Contains("v"))

	_t1:Clear()
	for i,v in ipairs(_t1) do
		print("Clear ",i,v)
	end
end


function M.Test14()
	local metatable = {__newindex = function(t,k,v) print(t,k,v) end}
	metatable.__index = metatable
	local mytable = {}
	setmetatable(mytable,metatable)
	mytable.a = nil
end

function M.Test13()
	collectgarbage("collect")
	collectgarbage("stop")
	

	local cnt1 = collectgarbage("count")*1024
	local _parent = {}
	local cnt2 = collectgarbage("count")*1024

	local _t = {}
	local cnt3 = collectgarbage("count")*1024

	setmetatable(_t,_parent)
	local cnt4 = collectgarbage("count")*1024

	local _t2 = {}
	local cnt5 = collectgarbage("count")*1024

	setmetatable(_t2,_parent)
	local cnt6 = collectgarbage("count")*1024

	local _t3 = {}
	local cnt7 = collectgarbage("count")*1024

	setmetatable(_t3,_parent)
	local cnt8 = collectgarbage("count")*1024

	print("_parent = {} ",cnt2-cnt1)
	print("_t  = {} ",cnt3-cnt2)
	print("setmetatable(_t,_parent)",cnt4-cnt3)
	print("_t2  = {} ",cnt5-cnt4)
	print("setmetatable(_t2,_parent)",cnt6-cnt5)

	print("_t3  = {} ",cnt7-cnt6)
	print("setmetatable(_t3,_parent)",cnt8-cnt7)
end


function M.Test12()
	local _parent = {v2 = 200, func2 = function(self) print(self.a,"_parent func2()")  end}
	_parent.__index = _parent
	_parent.__newindex = function(t,k,v)
		if t[k] then
			if rawget(t,k) then
				rawset(t,k,v);
			else
				_parent[k] = v;
			end
		else
			rawset(t,k,v);
		end
  	end

	local _t = {v3 = 300,fun3 = function(self) print(self.a,"_parent func3()")  end}
	-- _t.__index = _t
	setmetatable(_t,_parent)

	local clone = Utils.DeepCopy(_t)
	local clone2 = Utils.DeepCopy(_t)

	-- local clone = setmetatable({},_t)
	-- local clone2 = setmetatable({},_t)
	for k,v in pairs(clone2) do
		print("++++++++++1	",k,v)
	end
	clone2.v2 = 2000
	clone2.v3 = 3000

	for k,v in pairs(clone2) do
		print("++++++++++2	",k,v)
	end

	for k,v in pairs(clone) do
		print(k,v)
	end

	print(clone.v2)
	print(clone.v3)

	print(clone2.v2)
	print(clone2.v3)

end

function M.Test11()
	local _t = {a = 100}
	local _x = { func1 = function(self) print(self.a,"x func1()") end }
	local _y = { func2 = function(self) print(self.a,"y func2()") end }
	Utils.Super(_t,{_x,_y})

	_t:func1()
	_t:func2()
end

function M.Test10()
	print(UIUtils.CSFormat("1{0}3{2}5{1}",2,6,4))
end

function M.Test9()
	print(100/10)

	print(100)

	print(100.0)

	print(_ENV)

	print(1~3)
	local a = 1

	::A::
	if a <5 then
		a = a + 1
		print(a)
		goto A
	end

end

function M.Test8()
	local t = {}
	for i=1,1000000 do
		t[i] = true
	end
	local index = 1
	local _time1 = os.clock()
	for i=1,#t do
		index = index + 1
	end
	print("For do:",os.clock()-_time1)

	_time1 = os.clock()
	for i,v in ipairs(t) do
		index = index + 1
	end
	print("For ipairs:",os.clock()-_time1)
end


function M.Test7()
	-- Debug.LogError(UIUtils.CSFormat("1{0}3{2}5{1}", "2", "6", "4"))
	Debug.LogTable(Utils.SplitStr("1,	2; 3", '\t;'))
end


local T1 = {
	x1 = 1,
	y1 = 11,
}
T1.__index = T1

function T1:New()
	return Utils.DeepCopy(self)
end
function T1:GetX()
	return self.x1
end

function T1:GetY()
	return self.y1
end

local T2 = {
	x2 = 2,
	y2 = 12,
}
T2.__index = T2

function T2:New()
	local _t = Utils.DeepCopy(self)
	setmetatable(_t,{__index = T1:New()})
	return _t
end
function T2:GetX()
	return self.x2
end

function T2:GetY()
	return self.y2
end

function M.Test6()

	local _ta = T2:New()
	local _tb = T2:New()

	local x1 = _ta.x1
	local x2 = _ta.x2
	local y1 = _ta.y1
	local y2 = _ta.y2

	local x11 = _ta:GetX()
	local x21 = _tb:GetX()

end

function M.Test5()
	GameCenter.MainFunctionSystem:DoFunctionCallBack(2266000)
	-- GameCenter.Network.Send("MSG_Welfare.ReqReceiveUniversalReward",{})
end

function M.Test4()
	local t1 = require("Test/Test")
	t1.a = 99
	
	local t2 = require("Test.Test")
	Debug.Log("===========================>> t2.a = ", t2.a)
	
end

function M.Test3()
	local _dic = Dictionary.New({x = 99})
	_dic:Add("a", 1)
	_dic:Add("b", 2)
	_dic:Add("f", 5)
	_dic:Add("g", 6)
	Debug.LogTable(_dic)
	Debug.Log(_dic:ContainsKey("a"), _dic:ContainsKey("b"), _dic:ContainsKey("c"))
	Debug.Log(_dic:ContainsValue(1), _dic:ContainsValue(2), _dic:ContainsValue(3))
	Debug.Log("count = ", _dic:Count())
	Debug.Log("==============Remove('a')=====================")
	_dic:Remove("a")
	Debug.LogTable(_dic)
	
	Debug.Log("==============pairs=====================")
	for k, v in pairs(_dic) do
		print(k, v)
	end
	Debug.Log("==============AddRange=====================")
	_dic:AddRange({b = 97, h = 20, i = 21})
	Debug.LogTable(_dic)
	
	Debug.LogTable(_dic:GetKeys())
	_dic:Clear()
	Debug.LogTable(_dic)
	
end

function M.Test2()
	local mt1 = {a = 1}
	local mt2 = {a = 2}
	mt1.__index = mt1
	mt2.__index = mt2
	local t1 = {}
	local t2 = {}
	
	setmetatable(t1, mt1)
	setmetatable(t1, mt2)
	
	Debug.Log(t1.a)
	
	
	local _testList = List.New({1, 3, 5})
	Debug.LogTable(_testList)
	_testList:AddRange({2, 4, 6})
	Debug.LogTable(_testList)
end

function M.Test1()
	Debug.Log("==================================================")
	local _testList = List.New()
	
	_testList:Add(1)
	_testList:Add(3)
	_testList:Add(5)
	_testList:Add(2)
	_testList:Add(4)
	
	Debug.Log("count = ", _testList:Count())
	Debug.Log("Contains(1) = ", _testList:Contains(1), "Contains(6) = ", _testList:Contains(6))
	
	Debug.Log("IndexOf(5) :", _testList:IndexOf(5), "IndexOf(6) :", _testList:IndexOf(6))
	_testList:Add(2)
	
	Debug.Log("LastIndexOf(2) :", _testList:LastIndexOf(2), "LastIndexOf(6) :", _testList:LastIndexOf(6))
	Debug.Log("==============Insert(10,2)=====================")
	_testList:Insert(10, 2)
	Debug.LogTable(_testList)
	Debug.Log("==============Remove(2)=====================")
	_testList:Remove(2)
	Debug.LogTable(_testList)
	
	Debug.Log("==============RemoveAt(1)=====================")
	_testList:Remove(1)
	Debug.LogTable(_testList)
	Debug.Log("==============Sort=====================")
	_testList:Sort()
	Debug.LogTable(_testList)
	
	Debug.Log("==============Find=====================")
	local tar = _testList:Find(function(item)
		return item == 3
	end)
	Debug.Log("Find :", tar)
	Debug.Log("==============Clear=====================")
	_testList:Clear()
	Debug.LogTable(_testList)
end
return M 