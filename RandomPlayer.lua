local RPlayer , Player = torch.class ("RandomPlayer", "Player")

function Game:doMove (game)
    local size = math.floor (math.rand()* math.pow (game.size,3))
    local action = nil
    repeat
        local pos = math.floor (math.rand()* size)
        action = torch.zeros (size)
        action [pos] = 1 -- one hot
        action = action:view (game.size, game.size, game.size)
    until
    game:doAction (action)
end
