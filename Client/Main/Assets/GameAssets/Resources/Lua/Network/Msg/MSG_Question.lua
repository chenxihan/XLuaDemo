local MSG_Question = {}
local Network = GameCenter.Network

function MSG_Question.RegisterMsg()
    Network.CreatRespond("MSG_Question.ResSystemQuestionResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResPlayerSendQuestionResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResPlayerAnswerResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResPlayerQuestions",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResAllPlayerAnswer",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResExceptionalAllPlayer",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResPlayerQuestionCount",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResSendQuestions",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResAnswerList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResOverQuestions",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Question.ResAnswerPoints",function (msg)
        --TODO
    end)

end
return MSG_Question

