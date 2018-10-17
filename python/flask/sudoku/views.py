from flask import jsonify, render_template, request

from sudoku import app
import sudoku.sudoku_solver

@app.route('/', defaults={'js': 'plain'})
@app.route('/<any(plain, jquery, fetch):js>')
def index(js):
    return render_template('{0}.html'.format(js), js=js)


@app.route('/add', methods=['POST'])
def add():
    a = request.form.get('a', 0, type=float)
    b = request.form.get('b', 0, type=float)
    board = sudoku.sudoku_solver.solve_next()
    sudoku.sudoku_solver.printBoard(board)
    json_dict = board_to_dict(board)
    json_dict['result'] = a + b

    print(json_dict)
    return jsonify(json_dict)

def board_to_dict(b):
    d = {}
    for lineno in range(len(b)):
        line = b[lineno]
        for colno in range(len(line)):
            cellid = 'cell_' + str(lineno*9+colno)
            d[cellid] = b[lineno][colno]
    return d
