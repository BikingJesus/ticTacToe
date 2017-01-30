local RPlayer , Player = torch.class ("RandomPlayer", "Player")

math.randomseed(os.time())

function RPlayer:doMove (game)
    self.lastState = game.field * game.currentPlayer
    local size = math.pow (game.size,3)
    local action = nil
    repeat
        local pos = math.floor (math.random()* size)+1
        action = torch.zeros (size)
        action [pos] = 1 -- one hot
        action = action:view (game.size, game.size, game.size)
--        print (string.format(
--            "  %s: 'I will randomly try %d, might be allowed :)'."
--            ,self.name,
--            pos)
--        )
    until game:isAllowed (action)
    self.lastAction = action
    return action
end
