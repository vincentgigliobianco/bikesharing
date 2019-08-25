def RMSE(pred,y):
    resultat = np.sqrt(np.mean((pred - y.values)**2, axis=0))
    return resultat