from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello, World! 🚀"

if __name__ == '__main__':
    # Run the app on port 5000, accessible from any host
    app.run(host='0.0.0.0', port=5000)
