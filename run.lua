require "game"
require "gnuplot"
require "Player"
require "RandomPlayer"
require "ValueBasedPlayer"
require "TrivialValuePlayer"
require "DeepValuePlayer"

igor = RandomPlayer ("Igor")
hans = RandomPlayer ("Vladimir")
hans = TrivialValuePlayer ("Hans")
kurt = TrivialValuePlayer ("Kurt")
size = 3
learnRate = 0.00005
decay = 0.9
deepBoth = DeepValuePlayer (decay,learnRate , size, "Bothson")
deepIgor = DeepValuePlayer (decay,learnRate , size, "Igorson")
deepHans = DeepValuePlayer (decay,learnRate , size, "Hansson")

igor.students = {deepBoth, deepIgor}
hans.students = {deepBoth, deepHans}

function train (iter, player1, player2)
    results = {}
    results[player1] = 0
    results[player2] = 0
    results[0]= 0
    local errsB = {}
    local errsH = {}
    local errsI = {}
    for j = 1 , iter do
        for i = 1, 20 do
            game = TicTacToe (size,player1,player2)
            local winner = game:run() or 0
            print ("Winner",winner)
            results[winner] = results[winner]+1
        end
        errsB[j] = (deepBoth.err /deepBoth.countLearnSteps)
        errsI[j] = (deepIgor.err /deepIgor.countLearnSteps)
        errsH[j] = (deepHans.err /deepHans.countLearnSteps)
        deepBoth.err = 0
        deepHans.err = 0
        deepIgor.err = 0
        deepBoth.countLearnSteps = 0
        deepHans.countLearnSteps = 0
        deepIgor.countLearnSteps = 0
        gnuplot.plot (
            {"bothson",torch.Tensor(errsB)},
            {"hansson",torch.Tensor(errsH)},
            {"igorson",torch.Tensor(errsI)}
        )
    end
    print (results)
    print ("bothon",errsB)
    print ("igorson",errsI)
    print ("hanson",errsH)

    print ("training Finished")
end
train (100, igor, hans)
--
--result = {}
--for i = 1, 20 do
--    game = TicTacToe (size,deepHans ,deepHans)
--    local winner = game:run() or 0
--    print ("Winner",winner)
--    results[winner] = results[winner]+1
--end
--print (results)
--result = {}
--for i = 1, 20 do
--    game = TicTacToe (size,deepIgor ,deepBoth)
--    local winner = game:run() or 0
--    print ("Winner",winner)
--    results[winner] = results[winner]+1
--end
--print (results)
--result = {}
