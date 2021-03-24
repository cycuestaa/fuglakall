import numpy as np
import pandas as pd
import librosa
import subprocess
import noisereduce as nr
import wavefile
import soundfile as sf
from sklearn.cluster import KMeans


def convert_to_wav(path):
    if path[-4:] != '.wav':
        wav_path = path[:path.find('.')]
        wav_path = wav_path + '.wav'
        subprocess.run(['ffmpeg', '-i', path, wav_path])
        return wav_path
    else:
        return path

def reduce_noise(path): 
    file = wavefile.load(path)
    samplerate = file[0]
    data = file[1][0]
    nr_data = nr.reduce_noise(audio_clip=np.array(data), noise_clip=np.array(data[samplerate:2*samplerate]), verbose=False)
    sf.write(path,np.array(list(np.float_(nr_data))), samplerate)
    return

def get_cluster_averages(df):
    df_t = df.transpose()
    kmeans = KMeans(n_clusters=2)
    y_pred = kmeans.fit_predict(df_t)
    df_t['cluster'] = y_pred.tolist()
    cluster1 = df_t[df_t['cluster'] == 0]
    cluster2 = df_t[df_t['cluster'] == 1]
    cluster1 = cluster1.drop(['cluster'],axis=1)
    cluster2 = cluster2.drop(['cluster'],axis=1)
    c1 = np.mean(cluster1.to_numpy(),axis=0)
    c2 = np.mean(cluster2.to_numpy(),axis=0)
    c1std = np.std(cluster1.to_numpy(),axis=0)
    c2std = np.std(cluster2.to_numpy(),axis=0)
    return np.concatenate((c1,c2,c1std,c2std))

def get_mfccs(path):
    data, sample_rate = librosa.load(path, res_type='kaiser_fast')
    mfcc = librosa.feature.mfcc(y=data, sr=sample_rate, n_mfcc=15)
    mfcc_df = pd.DataFrame(mfcc)
    mfcc_processed = get_cluster_averages(mfcc_df)
    return (mfcc_processed,sample_rate)


def run_preprocessing(path):
    wav_path = convert_to_wav(path)
    reduce_noise(wav_path)
    extracted = get_mfccs(wav_path)
    return np.asarray([extracted[0]])
    
