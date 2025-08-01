import chess
import chess.engine

engine = chess.engine.SimpleEngine.popen_uci("/Users/frankammeter/stockfish/stockfish-macos-x86-64-bmi2")

board = chess.Board()
result = engine.play(board, chess.engine.Limit(time=0.1))
print("Empfohlener Zug:", result.move)

engine.quit()

