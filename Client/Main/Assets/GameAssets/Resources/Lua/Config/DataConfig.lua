------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： DataConfig.lua
--模块： DataConfig
--描述： 数据加载处理
------------------------------------------------
--//模块定义
local rawset = rawset
local rawget = rawget
local DataConfig = {
	MemoryRecordDic = Dictionary:New(),
	MemoryRecordList = List:New()
}
local ConfigNames = nil

local MetaTable = {}
setmetatable(DataConfig, MetaTable)

MetaTable.__index = function(mytable, name)
	return DataConfig.Load(name)
end

--数据加载
function DataConfig.Load(name)
	if not rawget(DataConfig,name) then
		collectgarbage("collect")
		collectgarbage("stop")
		local _startcount = collectgarbage("count")
		rawset(DataConfig,name,require(string.format("Config.Data.%s", name)))
		collectgarbage("collect")
		local _addCount = collectgarbage("count") - _startcount
		collectgarbage("restart")
		DataConfig.MemoryRecordDic:Add(name,_addCount)
		DataConfig.MemoryRecordList:Add({name = name,count = _addCount})
	end
	return DataConfig[name]
end

--卸载数据
function DataConfig.UnLoad(name)
	if DataConfig[name] then
		Utils.RemoveRequiredByName(string.format("Config.Data.%s", name))
		DataConfig[name] = nil
	end
end

--获取所有配置表名称
function DataConfig.GetConfigNames()
	if not ConfigNames then
		ConfigNames = require("Config.Data.ConfigNames")
	end
	return ConfigNames
end

--加载所有配置数据
function DataConfig.LoadAll()
	local _names = DataConfig.GetConfigNames()
	for i = 1, #_names do
		DataConfig.Load(_names[i])
	end
end

--卸载所有配置数据
function DataConfig.UnLoadAll()
	local _names = DataConfig.GetConfigNames()
	for i = 1, #_names do
		DataConfig.UnLoad(_names[i])
	end
end

return DataConfig
