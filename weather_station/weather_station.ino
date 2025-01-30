#include <Arduino.h>
#include <U8g2lib.h>
#include <Wire.h>
#include <DHT.h>

U8G2_SSD1306_128X64_NONAME_1_HW_I2C u8g2(U8G2_R0);

#define DHTPIN 2     // DHT11 data pin
#define DHTTYPE DHT11

#define TRIGGER_PIN 3  // Sonar trigger pin
#define ECHO_PIN 4     // Sonar echo pin

DHT dht(DHTPIN, DHTTYPE);

float temperature = 0.0;  // in Celsius
float humidity = 0.0;     // in percentage
float rainIntensity = 0.0;  // 0 to 100%

unsigned long lastDHTReadTime = 0;
const unsigned long DHT_READ_INTERVAL = 1000;  // Read DHT every 2 seconds

int animationFrame = 0;
long baselineDistance = 0;  // Baseline distance to ground/collection surface
const int RAIN_SAMPLES = 5;
long rainSamples[RAIN_SAMPLES];
int currentSample = 0;

void setup(void) {
  Serial.begin(115200);
  u8g2.begin();
  u8g2.setContrast(255);
  dht.begin();
  
  pinMode(TRIGGER_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  
  // Calibrate baseline distance
  baselineDistance = getAverageDistance(10);
  for (int i = 0; i < RAIN_SAMPLES; i++) {
    rainSamples[i] = baselineDistance;
  }
}

long measureDistance() {
  digitalWrite(TRIGGER_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER_PIN, LOW);
  
  long duration = pulseIn(ECHO_PIN, HIGH);
  return duration * 0.034 / 2;  // Convert to distance in cm
}

long getAverageDistance(int samples) {
  long sum = 0;
  for (int i = 0; i < samples; i++) {
    sum += measureDistance();
    delay(10);
  }
  return sum / samples;
}

void updateRainIntensity() {
  long currentDistance = getAverageDistance(3);
  rainSamples[currentSample] = currentDistance;
  currentSample = (currentSample + 1) % RAIN_SAMPLES;
  
  long averageDistance = 0;
  for (int i = 0; i < RAIN_SAMPLES; i++) {
    averageDistance += rainSamples[i];
  }
  averageDistance /= RAIN_SAMPLES;
  
  long waterLevel = baselineDistance - averageDistance;
  
  if (waterLevel > 0) {
    // Assume max detectable water level is 5cm
    rainIntensity = constrain(map(waterLevel, 0, 5, 0, 100), 0, 100);
  } else {
    rainIntensity = 0;
  }
}

void drawBorder() {
  u8g2.drawFrame(0, 0, 128, 64);
}

void drawWeatherInfo() {
  u8g2.setFont(u8g2_font_profont12_tr);
  
  // Draw title
  u8g2.drawStr(4, 12, "Weather Station");
  
  // Draw temperature
  u8g2.drawStr(4, 28, "Temp:");
  u8g2.setCursor(40, 28);
  u8g2.print(temperature, 1);
  u8g2.drawStr(70, 28, "C");
  
  // Draw humidity
  u8g2.drawStr(4, 44, "Humidity:");
  u8g2.setCursor(60, 44);
  u8g2.print(humidity, 1);
  u8g2.drawStr(90, 44, "%");

  // Draw rain intensity
  u8g2.drawStr(4, 60, "Rain:");
  u8g2.setCursor(40, 60);
  u8g2.print(rainIntensity, 1);
  u8g2.drawStr(70, 60, "%");

  // Draw animation
  for (int i = 0; i < animationFrame; i++) {
    u8g2.drawStr(110 + i * 6, 60, ".");
  }
}

void loop(void) {
  unsigned long currentMillis = millis();

  // Read temperature and humidity from DHT11 every 2 seconds
  if (currentMillis - lastDHTReadTime >= DHT_READ_INTERVAL) {
    float newTemp = dht.readTemperature();
    float newHumidity = dht.readHumidity();
    
    if (!isnan(newTemp) && !isnan(newHumidity)) {
      temperature = newTemp;
      humidity = newHumidity;
    }
    lastDHTReadTime = currentMillis;
  }

  // Update rain intensity
  updateRainIntensity();

  u8g2.firstPage();
  do {
    drawBorder();
    drawWeatherInfo();
  } while (u8g2.nextPage());

  animationFrame = (animationFrame + 1) % 3;

  // Print debug information to Serial Monitor
Serial.print(temperature);
Serial.print(",");
Serial.print(humidity);
Serial.print(",");
Serial.println(rainIntensity);


  delay(100);  // Small delay for stability
}

