require "game"
require "Player"
require "RandomPlayer"
require "ValueBasedPlayer"
require "TrivialValuePlayer"
require "DeepValuePlayer"

player1 = RandomPlayer ("Igor")
--player2 = RandomPlayer ("Vladimir")
--player2 = TrivialValuePlayer ("Hans")
--player1 = TrivialValuePlayer ("Kurt")
player2 = DeepValuePlayer ( 0.9,0.001 ,3, "Jordan")


results = {}
results[player1] = 0
results[player2] = 0
results[0]= 0
for i = 1, 100 do
    game = TicTacToe (3,player1,player2)
    local winner = game:run() or 0
    print ("Winner",winner)
    results[winner] = results[winner]+1
end
print (results)
