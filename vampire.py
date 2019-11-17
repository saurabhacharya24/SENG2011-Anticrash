from flask import Flask, render_template, request, redirect, url_for
from bloodbank_class import *
from make_requests import Make_requests

app = Flask(__name__)

@app.route("/", methods=['GET'])
def home():
    return render_template("homepage.html")

@app.route("/donor")
def donor():
    return render_template("donor.html")


@app.route("/medfacility",methods=['GET', 'POST'])
def medfacility():
    if request.method == 'POST':        
        print(request.form)
        bank = Blood_bank()
        if request.form['request_type'] == 'Emergency':
            emergency= True
        else:
            emergency= False
        mf_id = str(request.form['facility_id'])
        blood_req = Make_requests( medical_facility_id=mf_id,amount=request.form['facility_id'],blood_type=request.form['facility_id'],emergency=emergency,bloodbank_class=bank)
        blood_req.decrease_inventory()
        print("check sql db now")
        return redirect(url_for('home'))
    return render_template("med_facility.html")

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
