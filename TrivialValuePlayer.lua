local TValuePlayer, VBPlayer = torch.class ("TrivialValuePlayer", "ValueBasedPlayer")

function TValuePlayer:value (field, action)
    return self:judgeState (field + action)
end

function TValuePlayer:judgeState (field)
    value = 0
    for d = 1, field:dim() do
        local sum = field:sum(d)
        value = value +(sum:pow(3)):sum() --
    end
    return value
end
