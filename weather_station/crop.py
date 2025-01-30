import tkinter as tk
from tkinter import messagebox
from tkinter import ttk
import serial
import time
import threading
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Connect to Arduino
SERIAL_PORT = "COM4"  # Change this to your Arduino's serial port
BAUD_RATE = 115200

try:
    arduino = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    time.sleep(2)  # Allow Arduino to reset
except Exception as e:
    print(f"Error connecting to Arduino: {e}")
    arduino = None

# Initialize data storage
data = []  # Store sensor data
labels = []  # Store safety labels (0 = Danger, 1 = Safe)

# Machine learning model
clf = RandomForestClassifier()

# Function to read data from Arduino
def read_arduino_data():
    if arduino:
        try:
            line = arduino.readline().decode("utf-8").strip()
            if line:
                temp, humidity, rain = map(float, line.split(","))
                return temp, humidity, rain
        except Exception as e:
            print(f"Error reading from Arduino: {e}")
    return None, None, None

# Background thread to collect data from Arduino
def collect_arduino_data():
    global clf

    while True:
        temp, humidity, rain = read_arduino_data()
        if temp is not None:
            # Automatically label the data based on simple thresholds
            # (This is just a placeholder logic. Replace with real criteria.)
            label = 1 if temp < 35 and humidity > 40 and rain < 70 else 0
            data.append([temp, humidity, rain])
            labels.append(label)
            print(f"Data added: Temp={temp}, Humidity={humidity}, Rain={rain}, Label={label}")

            # Retrain the model on the updated dataset
            if len(data) >= 10:  # Ensure sufficient data before training
                X = np.array(data)
                y = np.array(labels)

                # Split the data for training and evaluation
                X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

                clf.fit(X_train, y_train)
                y_pred = clf.predict(X_test)
                accuracy = accuracy_score(y_test, y_pred)
                print(f"Model updated! Accuracy: {accuracy * 100:.2f}%")
        time.sleep(1)

# Predict crop safety
def predict_safety():
    if len(data) < 10:
        messagebox.showerror("Error", "Not enough data to make predictions. Please wait for more samples.")
        return

    temp, humidity, rain = read_arduino_data()
    if temp is None:
        messagebox.showerror("Error", "Failed to read data from Arduino.")
        return

    result = clf.predict([[temp, humidity, rain]])[0]
    status = "Safe" if result == 1 else "Danger"
    result_label.config(text=f"Prediction: {status}\nTemp: {temp}°C, Humidity: {humidity}%, Rain: {rain}%")

# GUI setup
root = tk.Tk()
root.title("Crop Safety Predictor")
root.geometry("500x400")

# Prediction
predict_button = ttk.Button(root, text="Predict Safety", command=predict_safety)
predict_button.pack(pady=10)

result_label = ttk.Label(root, text="Prediction: N/A", font=("Helvetica", 14))
result_label.pack(pady=20)

# Start data collection in the background
thread = threading.Thread(target=collect_arduino_data, daemon=True)
thread.start()

# Run GUI
root.mainloop()

# Close Arduino connection on exit
if arduino:
    arduino.close()
