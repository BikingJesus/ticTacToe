Game = torch.class ("TicTacToe")

function Game:__init(size, player1, player2)
    self.player={}
    self.player[1]  = player1
    self.player[-1] = player2
    self.field = torch.zeros (size, size, size)
    self.size = size
    self.currentPlayer = 1
end

function Game:getWinner ()
    local d1 =    self.field:sum(1):max()
    local d2 =    self.field:sum(2):max()
    local d3 =    self.field:sum(3):max()
    print (d1,d2,d3)
    local staight = math.max (d1,d2,d3)
    if staight == self.size then
        return true
    end

    return false
end

function Game:run ()
    local won = false
    while (not won) do
        local player = self.player [currentPlayer]
        print "Choose Move"
        local action player:doMove (self)
        print "Move chosen. Thx."
        won = self:doAction (action)
    end
end

function Game:doAction (action)
    local won = false
    if self:isAllowed(action) then
        action = action * currentPlayer
        self.field = self.field + action
        self.currentPlayer = self.currentPlayer * -1
        local won = self.getWinner ()
        print (string.format(
        "Action done. You %d won.",
        won and "have" or "have not yet"))
        print (self.field)
    else
        print "Action not possible."
    end
    return won
end

function Game:isAllowed (action)
    -- action one hot 3D-Matrix determening the position.
    local t0 = os.clock()
    local check = self.field * action
    return check:max () == check:min () and check:min () == 0
end
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
