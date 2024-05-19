import json
import streamlit as st
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.sequence import pad_sequences
import pickle

# Load the model, tokenizer, and label encoder
model = load_model('chatbot_model.h5')

with open('tokenizer.pickle', 'rb') as handle:
    tokenizer = pickle.load(handle)

with open('label_encoder.pickle', 'rb') as handle:
    label_encoder = pickle.load(handle)

# Function to predict intents based on user input
def predict_intent(user_input):
    user_input_seq = tokenizer.texts_to_sequences([user_input])
    user_input_pad = pad_sequences(user_input_seq, maxlen=model.input_shape[1], padding='post')
    prediction = model.predict(user_input_pad)
    intent = label_encoder.inverse_transform([np.argmax(prediction)])
    return intent[0]

# Function to generate responses based on predicted intents
def generate_response(intent):
    with open('therapy_data.json', 'r') as f:
        data = json.load(f)
    responses = [i['responses'] for i in data['intents'] if i['tag'] == intent]
    response = np.random.choice(responses[0])
    return response

# Streamlit UI
st.title("AI Therapy Chatbot")

user_input = st.text_input("You:", "")

if user_input:
    intent = predict_intent(user_input)
    response = generate_response(intent)
    st.write(f"Chatbot: {response}")
