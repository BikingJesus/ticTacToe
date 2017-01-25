Game = torch.class ("TicTacToe")

function Game:__init(size)

    self.field = torch.zeros (size, size, size)
    self.size = size
    self.currentPlayer = 1
end

function Game:getWinner ()
    local staight = torch.max {
        self.filed:sum(1):max(),
        self.filed:sum(2):max(),
        self.filed:sum(3):max()
    }
    if staight == self.size then
        return 1
    end
    staight = torch.min {
        self.filed:sum(1):min(),
        self.filed:sum(2):min(),
        self.filed:sum(3):min()
    }
    if staight == self.size then
        return 1
    end
end

function Game:action (x,y,z)
    if (self.field (x,y,z) == 0) then
        self.field[x][y][z] = self.currentPlayer
        self.currentPlayer = self.currentPlayer * -1
    end
end
