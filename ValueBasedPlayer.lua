local VBPlayer, Player = torch.class ("ValueBasedPlayer", "Player")

function VBPlayer:doMove (game, id)
    self.lastState = game.field * id
    self.lastAction =  self:chooseBestAction(self.lastState)
    return self.lastAction
end

function VBPlayer:chooseBestAction (state)
    local flatState = torch.Tensor (state:storage())
    if (state:pow(2):sum() == flatState:size(1)) then
        -- no position available.
        return nil
    end
    local moves  = {}
    for pos = 1, math.pow (game.size,3) do
        --allowed?
        if (flatState[pos] == 0) then
            local action = torch.zeros (math.pow (game.size, 3))
            action [pos] = 1
            action = action:view (game.size,game.size, game.size)
           table.insert (moves, {a = action, v = self:value (state,action)})
        end
    end
    local function comp (a,b) 
        return a.v > b.v
    end
    table.sort (moves,comp)
    assert (#moves > 0, (string.format ("no move possible%s",state)))
    return moves[1].a
end

function VBPlayer:value (state, action)
    error "abstract function should be overriden"
end
