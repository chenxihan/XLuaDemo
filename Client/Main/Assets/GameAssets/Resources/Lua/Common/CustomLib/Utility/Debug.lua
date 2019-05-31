------------------------------------------------
-- 作者：xihan
-- 日期：2019-04-08
-- 文件：Debug.lua
-- 模块：Debug
-- 描述：lua端对UnityEnging.Debug的封装
------------------------------------------------
-- 获取到unity的Debug类
local CSDebug = CS.UnityEngine.Debug

local Debug = {
    -- 调试器是否已启用日志记录(只针对Lua端)
    IsLogging = true
}

-- Log a message to the Unity Console.
function Debug.Log(...)
    if not Debug.IsLogging then return end

    local _count = select('#', ...)
    if _count == 0 then
        CSDebug.Log(debug.traceback("==========[未传参数！]=========="))
        return
    end
    local _str = nil
    local _argument = {...}
    for i = 1, _count do
        _str = _str and string.format("%s    %s", _str, _argument[i]) or
                   tostring(_argument[i])
    end
    _str = string.format("<color=#FFABFF>%s</color>", _str)
    CSDebug.Log(debug.traceback(_str))
end

-- A variant of Debug.Log that logs an assertion message to the console.
function Debug.LogError(...)
    if not Debug.IsLogging then return end

    local _count = select('#', ...)
    if _count == 0 then
        CSDebug.LogError(
            debug.traceback("==========[未传参数！]=========="))
        return
    end
    local _str = nil
    local _argument = {...}
    for i = 1, _count do
        _str = _str and string.format("%s    %s", _str, _argument[i]) or
                   tostring(_argument[i])
    end
    _str = string.format("<color=#FFABFF>%s</color>", _str)
    CSDebug.LogError(debug.traceback(_str))
end

function Debug.LogTableWhite(tb, title, notSort)
    Debug.LogTable(tb, title, notSort, "FFFFFF")
end

function Debug.LogTableRed(tb, title, notSort)
    Debug.LogTable(tb, title, notSort, "FF0000")
end

function Debug.LogTableGreen(tb, title, notSort)
    Debug.LogTable(tb, title, notSort, "00FF00")
end

function Debug.LogTableYellow(tb, title, notSort)
    Debug.LogTable(tb, title, notSort, "FFFF00")
end

-- 打印表结构(tb:table, title:Console面板显示的第一行信息，notSort：keys排序，rgb:Console面板显示的颜色)
function Debug.LogTable(tb, title, notSort, rgb)
    if not Debug.IsLogging then return end
    local _format = string.format
    rgb = rgb or "FFABFF"
    local fmtColor = "<color=#" .. rgb .. ">%s</color>"
    local strConcat = ""

    if not tb or type(tb) ~= "table" then
        strConcat =
            _format(fmtColor, tostring(tb) .. " " .. os.date("%H:%M:%S"))
        Debug.Log(strConcat)
        return
    end

    local _insert = table.insert
    local _tostring = tostring

    local tabNum = 0
    local function stab(numTab) return string.rep("    ", numTab) end
    local str = {}

    local function _printTable(t)
        _insert(str, "{")
        tabNum = tabNum + 1

        local keys = {}
        for k, _ in pairs(t) do _insert(keys, k) end

        if not notSort then table.sort(keys) end

        local _v, _kk, _vv, _ktp, _vtp
        for _, k in pairs(keys) do
            _v = t[k]
            _ktp = type(k)
            if _ktp == "string" then
                _kk = "['" .. k .. "']"
            else
                _kk = "[" .. _tostring(k) .. "]"
            end

            _vtp = type(_v)

            if _vtp == "table" then
                _insert(str, _format("\n%s%s = ", stab(tabNum), _kk))
                _printTable(_v)
            else
                if _vtp == "string" then
                    _vv = _format("\"%s\"", _v)
                elseif _vtp == "number" or _vtp == "boolean" then
                    _vv = _tostring(_v)
                else
                    _vv = "['" .. _vtp .. "']"
                end

                if _ktp == "string" then
                    _insert(str,
                            _format("\n%s%-10s = %s,", stab(tabNum), _kk,
                                    string.gsub(_vv, "%%", "?")))
                else
                    _insert(str,
                            _format("\n%s%-4s = %s,", stab(tabNum), _kk,
                                    string.gsub(_vv, "%%", "?")))
                end
            end
        end
        tabNum = tabNum - 1

        if tabNum == 0 then
            _insert(str, "}")
        else
            _insert(str, "},")
        end
    end

    local titleInfo = title or "table"
    _insert(str, _format(fmtColor,
                         "=========" .. titleInfo .. "----------[" ..
                             os.date("%H:%M:%S") .. "]\n"))
    _printTable(tb)
    _insert(str, _format("\n=========== [%s]----------\n", titleInfo))

    strConcat = table.concat(str, "")
    CSDebug.Log(debug.traceback(strConcat));
end

return Debug
