local VBPlayer, Player = torch.class ("ValueBasedPlayer", "Player")

function VBPlayer:doMove (game)
    local moves = {}
    for pos = 1, math.pow (game.size,3) do
        local action = torch.zeros (math.pow (game.size, 3))
        action [pos] = 1
        action = action:view (game.size,game.size, game.size)
        if game:isAllowed (action) then 
            moves [action] = self:value (game,action)
        end
    end
end

function VBPlayer:value (game, action)
    error "abstract function should be overriden"
end
