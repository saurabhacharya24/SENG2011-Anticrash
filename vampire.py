from flask import Flask, render_template, request, redirect, url_for


app = Flask(__name__)

@app.route("/", methods=['GET'])
def home():
    return render_template("homepage.html")

@app.route("/donor")
def donor():
    return render_template("donor.html")

if __name__ == "__main__":
    app.run(debug=True)
