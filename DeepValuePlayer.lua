require "nn"

local DPlayer, VBPlayer = torch.class ("DeepValuePlayer", "ValueBasedPlayer")

function DPlayer:__init (decay, learnRate , size, ...)
    VBPlayer.__init(self,...)
    self.decay=decay
    self.learnRate=learnRate
    self.net = nn.Sequential ()
    self.net:add (nn.Linear (2*math.pow (size,3),size))
            :add (nn.Tanh())
            :add (nn.Linear (size ,1))
    self.err = 0
end

function DPlayer:value (field, action)
    local netInput = torch.Tensor(
        torch.cat {field, action}:storage()
    )
    local result = self.net:forward (netInput) [1]
    return result
end


function DPlayer:learn (reward ,state, action)
    local oponentsState = (state + action) * -1
    local oponentsAction = self:chooseBestAction (oponentsState)

    local myNextAction=nil
    local myNextState =nil
    if (oponentsAction) then
        local myNextState = (oponentsState + oponentsAction) * -1
        local myNextAction= self:chooseBestAction (myNextState)
    end
    
    local rateCurAction = self:value(state, action)
    local rateNextAction = myNextAction and self:value (myNextState, myNextAction) or 0

    self.err = self.err + math.pow (rateCurAction - reward + self.decay * rateNextAction,2)
    self.countLearnSteps = (self.countLearnSteps or 0 ) +1
    local grad = rateCurAction - reward - self.decay * rateNextAction

    -- train Net:
    local netInput = torch.Tensor(
        torch.cat {state, action}:storage()
    )
    self.net:zeroGradParameters ()
    self.net:forward(netInput)
    local gradIn = self.net:backward (netInput, torch.Tensor {grad})
    self.net:updateParameters (self.learnRate)
    return self.err, gradIn
end
