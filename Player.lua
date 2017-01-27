local Player = torch.class ("Player")

function Player:__init ()
end

function doMove (game)
    error "The abstract Method has to be overridden."
end
