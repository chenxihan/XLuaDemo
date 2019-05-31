local Network = {}

local pb = require("pb")
local CSNetworker = CS.Funcell.Plugins.Common.Networker

--存储所有的服务器响应事件【key:消息id(enum)，value:事件】一个消息只能创建一个响应事件
local msgMap = {}
--根据枚举存储所有类型
local cmdMap = {}
--根据类型存储所有枚举
local msgIDMap = {}
--是否是重新注册消息
local isReRegisterMsg = false
--创建服务器消息响应事件
function Network.CreatRespond(cmd, callback)
	if not cmd or not callback then
		Debug.LogError(string.format("注册消息错误 cmd = %s,callback = %s", cmd, callback))
		return
	end
	local _msgid = pb.enum(string.format("%s.MsgID", cmd), "eMsgID")

    if not _msgid then
		Debug.LogError(string.format("消息不存在，请手动删除 %s", cmd))
		return
    end

	if msgMap[_msgid] and not isReRegisterMsg then
		Debug.LogError(string.format("消息重复注册 cmd = %s", cmd))
		return
	end

	msgMap[_msgid] = callback
	cmdMap[_msgid] = cmd
	msgIDMap[cmd] = _msgid
end

--发送消息【编码-->序列化-->发送】
function Network.Send(cmd, msg)
	msg = msg or {}
	if not cmd then
		Debug.LogError(string.format("注册消息错误 cmd = %s", cmd))
		return
	end

	if not msgIDMap[cmd] then
		msgIDMap[cmd] = pb.enum(string.format("%s.MsgID", cmd), "eMsgID")
		if not msgIDMap[cmd] then
			Debug.LogError(string.format("消息不存在: %s",cmd))
			return
		end
	end

	local _code = pb.encode(cmd, msg)
	Debug.LogTable(msg, string.format("[Network.Send]  cmd:%s", cmd))
	CSNetworker.Instance:Send(_code, msgIDMap[cmd])
end

--处理服务器发来的消息
function Network.DoResMessage(msgid, bytes)
	local _cmd = cmdMap[msgid]
	if not _cmd then
		Debug.LogError(string.format("msgid = %s 消息未注册", msgid))
		return
	end
	local _msg = pb.decode(_cmd, bytes)
	-- Debug.LogTable(_msg, string.format(">>收到消息<< CMD:[ %s ] msgid:[ %s ]",_cmd, msgid))
	--存一个MsgID
	_msg.MsgID = msgid
	msgMap[msgid](_msg)
	-- local _ok, _err = xpcall(function() msgMap[cmd](_msg) end, debug.traceback)
	-- if not _ok then
	-- 	Debug.Log(_err)
	-- end
end

--本地模拟服务器
function Network.DoResTest(cmd, table)
	local msgid = msgIDMap[cmd]
	if not msgid then
		Debug.LogError(string.format("msgid = %s 消息未注册", msgid))
		return
	end
	table.MsgID = msgid
	msgMap[msgid](table)
end

--获取所有Lua端的消息ID
function Network.GetResLuaMsgIDs()
	local resMsgCMDs = require("Network.ResMsgCMD")
	local resMsgIDs = {}
	for i=1, #resMsgCMDs do
		-- Debug.Log("走Lua的协议：",i,resMsgCMDs[i],msgIDMap[resMsgCMDs[i]])
		table.insert(resMsgIDs, msgIDMap[resMsgCMDs[i]])
	end
	return resMsgIDs
end

function Network.ReRegisterMsg(name)
	local _path = string.format("Network.Msg.%s", name)
	Utils.RemoveRequiredByName(_path)
	local _msgSystem = require(_path)
	if _msgSystem then
		isReRegisterMsg = true
		_msgSystem.RegisterMsg()
		isReRegisterMsg = false
	end
end

--注册所有消息
function Network.RegisterAllMsg()
	local _msgNames = require("Network.Msg.MsgNames")
	for i=1, #_msgNames do
		-- Debug.Log("============>>> ", i, _msgNames[i])
		local _msgSystem = require(string.format("Network/Msg/%s", _msgNames[i]))
		if _msgSystem then
			_msgSystem.RegisterMsg()
		end
	end
end

--初始化
function Network.Init()
	--加载所有协议文件
	local protoPaths = CSNetworker.GetAllProtoPath()
	for i=0, protoPaths.Length-1 do
		local _path = protoPaths[i]
		if not string.find(_path, ".meta") then
			local _isok = pb.loadfile(_path)
			-- Debug.Log(_isok, _path)
		end
	end

	Network.RegisterAllMsg()
	-- Debug.LogError(pb.enum("MSG_Friend.ReqGetRelationList.MsgID", 116201))
	-- Debug.LogError(pb.type(116201))
end

function Network.GetMsgID(cmd)
	return pb.enum(string.format("%s.MsgID", cmd), "eMsgID")
end

return Network