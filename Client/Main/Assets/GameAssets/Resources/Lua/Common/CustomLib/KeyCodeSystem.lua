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

function M.Update(deltaTime)
	if GetKeyDown(KeyCode.Y) then
		M.KeyCodeY()
		-- M.Test()
	elseif GetKeyDown(KeyCode.F) then
		M.KeyCodeF();
	elseif GetKeyDown(KeyCode.G) then
		M.KeyCodeG();
	elseif GetKeyDown(KeyCode.H) then
		M.KeyCodeH();
	end
end

function M.KeyCodeY()
	--打开jjc
	-- GameCenter.ArenaShouXiSystem:ReqOpenJJC()
	-- --更换对手
	-- GameCenter.ArenaShouXiSystem:ReqChangeTarget()
	-- --挑战
	-- GameCenter.ArenaShouXiSystem:ReqChallenge(15098)
	-- --领奖
	-- GameCenter.ArenaShouXiSystem:ReqGetAward()
	-- --添加挑战次数
	-- GameCenter.ArenaShouXiSystem:ReqAddChance()
	-- --获取昨天排名
	-- GameCenter.ArenaShouXiSystem:ReqGetYesterdayRank()
	-- --获取战报
	-- GameCenter.ArenaShouXiSystem:ReqGetReport()
	-- --退出jjc
	GameCenter.ArenaShouXiSystem:ReqJJCexit()


end

function M.KeyCodeF()
	local _t = {a=1;b=2,c=3}

	Debug.LogTable(_t)

	Debug.Log(#"")
	Debug.Log(#"a")
	Debug.Log(string.len("9"))
end

function M.KeyCodeG()
	-- GameCenter.Network.DoResTest("MSG_Achievement.ResUpdateAchivement",{infos = {{id = 1000, pro = 90, state = 1}}})

	-- GameCenter.Network.DoResTest("MSG_Achievement.ResAchievementInfo",{hasGetIds = {3000,3001},canGetIds={6014,5000},infos = {{id = 1000, pro = 90, state = 0},{id = 1001, pro = 10, state = 0}}});

	-- GameCenter.Network.DoResTest("MSG_Achievement.ResGetAchievement",{id=1000});


	-- GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(800)
end

function M.KeyCodeH()
	
end

function M.Test()
	local _dic = Dictionary:New({a=1});
	_dic.a = nil;

	Debug.Log(_dic:Count())
end

function M.Test9()
	Debug.Log(Time.SplitTime(10))
	Debug.Log(Time.SplitTime(3600))
	-- Debug.Log(Utils.GetHMS(3600))
	-- Debug.Log(string.sub ("abcd", 2,2));
	Debug.Log(UIUtils.CSFormat("{0:D2}:{1:D2}:{2:D2}",9,2,1));

	Debug.Log(11.1//1)

	Debug.Log(7>>2)
end

function M.Test8()
	local _t = {a =1,b =2,d = 4,c=3};
	local _k = {"a","b","d","c"}
	local func1,func2,func3,func4 = function() end,function() end,function() end,function() end;
	local _k2 = {func1,func2,func4,func3}

	local _tb1,_tb2,_tb3,_tb4 = {},{},{},{};
	local _k3 = {_tb1,_tb2,_tb3,_tb4}

	-- table.sort(_k3)
	-- for i,v in ipairs(_k3) do
	-- 	print(i,v)
	-- end

	-- local _tx = {[100]=1,[200]=2,[150]=3,[50]=4}
	local _tx = {a=1,c=2,b=3,d=4}
	-- table.remove(_tx,"a") --Error

	local _dic = Dictionary:New(_tx)
	_dic:Foreach(function(k,v) Debug.Log("===",k,v) end)
	_dic:ForeachReverse(function(k,v) Debug.Log(k,v) end)

	_dic:ForeachReverseCanBreak(function(k,v) Debug.Log(k,v);if v == 2 then return "break" end; end)
end

function M.Test7()
	local _t = {x = 1};
	local _t2 = _t;
	_t2 = {x = 2};

	Debug.Log(_t2==_t);

	local function A(tb)
		tb = {x = 3};
		tb.y = 6
	end
	A(_t);
	Debug.LogTable(_t);

	Debug.LogTable(table.insert({},1)); -- nil
end
function M.Test6()
	local _x = 1;
	local function A(layer)
		if layer > 3 then
			return;
		end
		Debug.Log(_x);
		_x = _x + 1
		A(layer+1)
	end
	A(1)
end

function M.Test5()
	local _t = {2,4,3,6,8,7}
	table.sort(_t)

	for i,v in ipairs(_t) do
		print(i,v)
	end
	print(string.find( "ssssss","s"))
end

function M.Test4()
	Debug.Log(6708335100)
	Debug.Log("=============[KeyCode.Y]=================")
	local _dic = Dictionary:New({x = 99})
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

function M.Test3()
	Debug.Log("=============[KeyCode.F]=================")
	local _t = Dictionary:New()
	_t:Add(0,3)
	_t:Add(1,2)
	_t[2] = 9
	_t[3] = 9
	Debug.Log(_t:Count())

	local _t2 = Dictionary:New(_t)
	_t2:Add(8,9)
	_t2[11]= 9
	Debug.Log(_t2:Count())
end

function M.Test2()
	Debug.Log("=============[KeyCode.G]=================")
	collectgarbage("collect")
end

function M.Test1()
	Debug.Log("=============[KeyCode.H]=================")
	local _dic = Dictionary:New({a = {v = 3},b = {v = 2},c = {v = 1},d = {v = 100}})
	_dic:Sort(function(a, b)
		return a.v > b.v
	end)
	Debug.LogTable(_dic:GetKeys())
end

return M