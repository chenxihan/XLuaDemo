------------------------------------------------
--作者： gzg
--日期： 2019-05-15
--文件： FeedBackSystem.lua
--模块： FeedBackSystem
--描述： 玩家反馈系统
------------------------------------------------
local FeedBackInfo = require("Logic.FeedBack.FeedBackInfo");
local FeedBackSystem ={
    FeedbackList = List:New(),
};

--==公共方法==--
function FeedBackSystem:Initialize()

end

function FeedBackSystem:UnInitialize()

end

--转换List
function FeedBackSystem:ConvertList(msgList)    
    local _result = List:New();    
    for i = 0, msgList.Count do
        --转换数据
        _result.Add(FeedBackInfo:New(msgList[i].Sender,msgList[i].Type,msgList[i].SendTime,msgList[i].Contend));
    end
    return _result;
end

--通过类型获取反馈的信息列表
function FeedBackSystem:GetFeedBackByType(type)
    local _result = List:New();
    local _time = List:New();
    local dataList = self.FeedbackList;
    for i = 1, #dataList do
        --把不和条件的过滤过去
        if type ~= 0 and type ~= dataList[i].Type then
            break;
        end
        _result.Add(dataList[i]);
        
        --处理日期提示
        local _curDay = dataList[i].SendTime - math.mod(dataList[i].SendTime,(60*60*24));
        local _find = false;
        for j = 1 , #_time do
            if _time[j] == _curDay then
                _find = true;
                break;
            end
        end
        if not _find then
            local _tmp = FeedBackInfo:New(0,type,_curDay,Time.StampToDateTime(_curDay));
            _result.Add(_tmp);
            _time.Add(_tmp);
        end
    end      
    _time = nil;
    --根据时间升序排列
    _result:Sort(function(a,b) return a.SendTime < b.SendTime end );
    return _result;
end

--==处理网络消息==--

--接受反馈信息列表
function FeedBackSystem:ResFeedBackList(msg)
    self.FeedBackSystem:Clear();    
    GameCenter.PushFixEvent(LogicLuaEventDefine.EID_FEEDBACK_LIST_CHANGED);
end

--提交反馈给服务器
function FeedBackSystem:PostFeedBack(content)

end

return FeedBackSystem;
