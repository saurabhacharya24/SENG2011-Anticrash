from flask import Flask, render_template, request, redirect, url_for
from bloodbank_class import *

app = Flask(__name__)

@app.route("/", methods=['GET'])
def home():
    return render_template("homepage.html")

@app.route("/donor")
def donor():
    return render_template("donor.html")

@app.route("/admin")
def admin():
    bank = Blood_bank()
    blood_amounts = bank.get_all_blood_amounts()
    threshold = {}
    
    for btype in blood_amounts.keys():
        threshold[btype] = bank.get_threshold_level(btype)

    return render_template("admin.html", amounts=blood_amounts, threshold=threshold)

if __name__ == "__main__":
    app.run(debug=True)
