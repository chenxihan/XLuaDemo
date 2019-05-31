--==============================--
--作者： gzg
--日期： 2019-05-13
--文件： FeedBackInfo.lua
--模块： FeedBackInfo
--描述： 反馈信息数据
--==============================--

local FeedBackInfo = 
{
    --发送者 0:表示事件,1:表示GM,2:表示我的信息
    Sender = 0,
    --当前消息的类型,1:玩家bug,2.游戏建议,3.问题咨询,4.其他 
    Type = 0,
    --发送时间,这里用于排序,秒
    SendTime = nil,
    --内容
    Content = nil,
}

function FeedBackInfo:New(s,t,st,c)
    local _m = Utils.DeepCopy(self);
    _m.Sender = s;
    _m.Type = t;
    _m.SendTime = st;
    _m.Content = c;
    return _m;
end

--过滤
function FeedBackInfo:Filter(dataList,type)
    local _result = List:New();
    local _time = List:New();
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

return FeedBackInfo;