from flask import Flask, render_template_string, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
    return render_template_string(open('index.html', encoding='utf-8').read())

@app.route('/api/hello')
def api_hello():
    return jsonify({'message': 'Hello from GKE by Wuoc'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
