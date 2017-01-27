local TValuePlayer, VBPlayer = torch.class ("TrivialValuePlayer", "ValueBasedPlayer")

function TValuePlayer:value (game, action)
    return self:judgeState (game.field + action)
end

function TValuePlayer:judgeState (field)
    value = 0
    for d = 1, field:dim() do
        local sum = field:sum(d)
        value = value + sum:cmul(sum) --square
    end
    return value
end
