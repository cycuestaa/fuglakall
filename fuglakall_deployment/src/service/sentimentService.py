import tensorflow as tf

class SentimentService(object):
    model = None

    @classmethod
    def load_deep_model(self, model):
        loaded_model = tf.keras.models.load_model("/home/macgroup/fuglakall_deployment/src/saved_models/" + model + ".h5")
        return loaded_model

    @classmethod
    def get_model(self):
        if self.model is None:
            self.model = self.load_deep_model('fuglakall')
        return self.model
