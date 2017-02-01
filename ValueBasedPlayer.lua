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
    local acc = 0
    local acumumlatedValues = {}
    for pos = 1, math.pow (game.size,3) do
        --allowed?
        if (flatState[pos] == 0) then
            local action = torch.zeros (math.pow (game.size, 3))
            action [pos] = 1
            action = action:view (game.size,game.size, game.size)
	    local val = self:value (state, action)
           table.insert (moves, {a = action, v = cal})
            acc = acc + math.exp (val)
            table.insert (acumumlatedValues, acc)
        end
    end

    local rand = math.random ()*acc

    local i = 1
    while (acumumlatedValues[i]<=rand) do
        i = i+1
    end
    return moves[i].a
end

function VBPlayer:value (state, action)
    error "abstract function should be overriden"
end
