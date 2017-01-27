require "game"
require "Player"
require "RandomPlayer"
require "ValueBasedPlayer"

player1 = RandomPlayer ("Igor")
player2 = ValueBasedPlayer ("Hans")


results = {}
results[player1] = 0
results[player2] = 0
results[0]= 0
for i = 1, 100 do
    game = TicTacToe (7,player1,player2)
    local winner = game:run() or 0
    print ("Winner",winner)
    results[winner] = results[winner]+1
end
print (results)
