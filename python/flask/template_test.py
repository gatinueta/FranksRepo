from flask import Flask, render_template
app = Flask(__name__)

@app.route('/template_test')
def hello_world():
    return render_template('template.html', my_string="Wheeeee!", my_list=[0,1,2,3,4,5])

@app.route('/template_attr')
def render_attr():
	l = [ { 'n': i, 'sq': i*i, 'inv': 1.0/i } for i in range(1, 15) ]
	return render_template('attr_template.html', my_list=l)

if __name__ == '__main__':
    app.run(debug=True, port=5001)

# http://localhost:5001/template_attr

