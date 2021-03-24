from flask import Flask, request
import sys
sys.path.insert(1, './service')
from preprocessing import *
from sentimentService import *
import numpy as np

app = Flask(__name__)

class_dict = {0:'amecro', 1:'brdowl', 2:'grhowl', 3:'moudov', 4:'semplo'}

@app.route('/hello')
def hello():
    return 'Hello there!'


@app.route('/predict', methods = ['POST'])
def model_predict():
    print('='*80)
    print(request.form)
    print('='*80)
    uploaded_file = request.files['audioFile']
    if uploaded_file.filename != '':
        fp = 'saved_files/' + uploaded_file.filename
        uploaded_file.save(fp)
        features = run_preprocessing(fp)
        model = SentimentService.get_model()
        res = (model.predict(features) > 0.5).astype("int32").tolist()[0]
        key = res.index(max(res))
        print(res)
        print(key)
        code = class_dict[key]
        return code
    return 'Something went wrong'
