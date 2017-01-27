local Player = torch.class ("Player")

function Player:__init (name)
    self.name = name
end

function Player:__tostring__ ()
    return self.name
end

function Player:doMove (game)
    error "The abstract Method has to be overridden."
end
