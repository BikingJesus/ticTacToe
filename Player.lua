local Player = torch.class ("Player")

function Player:__init (name)
    self.name = name
    self.students = {}
end

function Player:teach(reward)
--    print (string.format("I, %s, try to teach. Reward: %d", self, reward))
    assert (reward)
    assert (self.students)
    if self.lastState and self.lastAction then 
        for _, student in ipairs (self.students) do
            student:learn (reward, self.lastState, self.lastAction)
        end
    else
        print (string.format("I, %s, cannot teach since I have not yet done anyhing.", self))
    end
end


function Player:__tostring__ ()
    return self.name
end

function Player:doMove (game)
    error "The abstract Method has to be overridden."
end
