------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： AppConfig.lua
--模块： AppConfig
--描述： 应用配置定义
------------------------------------------------
--//模块定义
local AppConfig =
{
	--窗体关闭时,是否删除ui预制件
	IsDestroyPrefabOnClose = false,
	--是否加载Lua配置
	IsLoadLuaConfig = true,
	--是否走lua逻辑
	IsLoadLuaLogic = true,
	--是否运行分析工具
	IsRuntimeProfiler = false,
	--是否记录的耗时写文件
	IsRecordWriteFile = false,
	--是否收集消耗时间
	IsCollectRecord = false,
	--c#获取lua配置后，是否释放lua配置的内存
	IsFreeLuaCfg = false,
}

return AppConfig