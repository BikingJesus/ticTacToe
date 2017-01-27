local VBPlayer, Player = torch.class ("ValueBasedPlayer", "Player")

function VBPlayer:doMove (game, id)
    local state = game.field * id
    return self:chooseBestAction(state)
end

function VBPlayer:chooseBestAction (state)
    local moves  = {}
    for pos = 1, math.pow (game.size,3) do
        local action = torch.zeros (math.pow (game.size, 3))
        action [pos] = 1
        action = action:view (game.size,game.size, game.size)
        if game:isAllowed (action) then
           table.insert (moves, {a = action, v = self:value (state,action)})
        end
    end
    local function comp (a,b) 
        return a.v > b.v
    end
    table.sort (moves,comp)
    return moves[1].a
end

function VBPlayer:value (state, action)
    error "abstract function should be overriden"
end
