Game = torch.class ("TicTacToe")

function Game:__init(size, player1, player2)
    self.player={}
    self.player[1]  = player1
    self.player[-1] = player2
    assert (self.player[1])
    assert (self.player[-1])
    self.field = torch.zeros (size, size, size)
    self.size = size
    self.currentPlayer = 1
    self.count = 0
end

function Game:getWinner ()
    local field = self.field * self.currentPlayer
    local d1 =    field:sum(1):max()
    local d2 =    field:sum(2):max()
    local d3 =    field:sum(3):max()
    --print (d1,d2,d3)
    local staight = math.max (d1,d2,d3)
    if staight == self.size then
        return self.currentPlayer
    end

    return nil
end

function Game:run ()
    local won = false
    while (not won) do
        local movesLeft = math.pow(self.size,3) - self.count
        if (movesLeft  > 0) then 
            local player = self.player [self.currentPlayer]
            assert (player)
            print (string.format ("%s, Choose Move... %d moves possible", 
                player,
                movesLeft)
            )
            local action =  player:doMove (self)
            assert (action, string.format("No action given by player %s", player))
            print (string.format("Move chosen. Thx %s.",player))
            won = self:doAction (action)
--            print (self.field)
    --        local t0 = os.clock()
    --        while (os.clock() - t0 < .01) do end
           else
               won = 0
               print "No more move possible. -- Drawn."
           end

    end
    print "game is over"
    return self.player[won]
end

function Game:doAction (action)
    assert (action, "action mandatory.")
    local won = false
    if self:isAllowed(action) then
        --palyer -1 -> one-cold instead of one-hot.
        action = action * self.currentPlayer
        local sumOld = self.field:sum()
        self.field = self.field + action
        assert (self.field:sum() - sumOld == self.currentPlayer)
        won = self:getWinner ()
        self.currentPlayer = self.currentPlayer * -1
        self.count = self.count + 1
        print (string.format(
        "Action done. You %s won.",
        won and "have" or "have not yet"))
    else
        print "Action not possible."
    end
    return won
end

function Game:isAllowed (action)
    -- action one hot 3D-Matrix determening the position.
    assert (action, "action mandatory.")
    local check = self.field:clone():cmul (action)
    local max = check:max ()
    local min = check:min ()
    print ("sould be 0: ",max, min)
    --print (check)
    --print (self.field)
    --print (self.action)
    return min == max and max == 0
end

--function Game:getPossibleMoves ()
--    
--end

function Game:plot ()
    require "gnuplot"
    local player = {}
    player[1] = {
        x= torch.Tensor (self.size*self.size*self.size):fill(-1),
        y= torch.Tensor (self.size*self.size*self.size):fill(-1),
        z= torch.Tensor (self.size*self.size*self.size):fill(-1)
    }
    player[0] = {   
        x= torch.Tensor (self.size*self.size*self.size):fill(-1),
        y= torch.Tensor (self.size*self.size*self.size):fill(-1),
        z= torch.Tensor (self.size*self.size*self.size):fill(-1)
    }             
    player[-1] = { 
        x= torch.Tensor (self.size*self.size*self.size):fill(-1),
        y= torch.Tensor (self.size*self.size*self.size):fill(-1),
        z= torch.Tensor (self.size*self.size*self.size):fill(-1)
    }
    local size = self.size
    local count = {}
    count [-1] = 1
    count [ 0] = 1
    count [ 1] = 1
    for x = 1, size do
        for y = 1, size do
            for z = 1, size do
                local content = self.field[x][y][z]
                --     if content ~= 0 then
                player[content].x[count[content]] = x
                player[content].y[count[content]] = y
                player[content].z[count[content]] = z
                count[content] = count[content] + 1
                --    end
            end
        end
    end

    local e, p1, p2
    if count[ 0]>1 then e ={
        "Empty",   player[ 0].x:narrow(1,1,count[ 0]-1),
        player[ 0].y:narrow(1,1,count[ 0]-1),
        player[ 0].z:narrow(1,1,count[ 0]-1)}
    end
    if count[ 1]>1 then p1 ={
        "Player1", player[ 1].x:narrow(1,1,count[ 1]-1),
        player[ 1].y:narrow(1,1,count[ 1]-1),
        player[ 1].z:narrow(1,1,count[ 1]-1)}
    end
    if count[-1]>1 then p2 ={
        "Player2", player[-1].x:narrow(1,1,count[-1]-1),
        player[-1].y:narrow(1,1,count[-1]-1),
        player[-1].z:narrow(1,1,count[-1]-1)}
    end
    gnuplot.scatter3(e,p1,p2)
end
