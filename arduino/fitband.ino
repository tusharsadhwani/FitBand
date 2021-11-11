#define USE_ARDUINO_INTERRUPTS true
#include <PulseSensorPlayground.h>
#include <SoftwareSerial.h>

int pulseInput = A0;
PulseSensorPlayground pulseSensor;
int Threshold = 440;

int rx = A2;
int tx = A3;
SoftwareSerial MyBlue(rx, tx);

void debugBluetooth() {
  int flag;
  if (MyBlue.available()) {
    flag = MyBlue.read();
  }
  MyBlue.write(flag);
  char text[64];
  sprintf(text, "Flag: %d\n", flag);
  Serial.print(text);
  if (flag > 0)
  {
    digitalWrite(13, HIGH);
    Serial.println("LED On");
  }
  else
  {
    digitalWrite(13, LOW);
    Serial.println("LED Off");
  }
}

int pedometerInput = A1;
int startup = 0;
long long hundredSum = 0;
int averageHeight = 0;

int steps = 0;
bool takingStep = false;

int tenCounter = 0;

void setup()
{
  Serial.begin(9600);
  MyBlue.begin(38400);
  pinMode(2, INPUT);
  pinMode(3, OUTPUT);
  pinMode(13, OUTPUT);

  pulseSensor.analogInput(pulseInput);
  //  pulseSensor.blinkOnPulse(13);
  pulseSensor.setThreshold(Threshold);

  if (pulseSensor.begin()) {
    MyBlue.println("Pulse Sensor started!");
  }
}
void loop()
{
  if (startup >= 0 && startup < 100) {
    hundredSum += analogRead(pedometerInput);
    averageHeight = hundredSum / 100;
    startup++;
  } else {
    //    char buf[64];
    //    sprintf(buf, "Average height: %d", averageHeight);
    //    Serial.println(buf);

    int height = analogRead(pedometerInput);
    int actualHeight = averageHeight - height;

    if (!takingStep && actualHeight > 20) {
      takingStep = true;
    } else if (takingStep && actualHeight < -20) {
      steps++;
      takingStep = false;
    }
    //  debugBluetooth();
    int pulseValue = analogRead(pulseInput);
    Serial.println(pulseValue);
    char stepper[64];
    sprintf(stepper, "pedometer %d", actualHeight);
    Serial.println(stepper);


    int myBPM = pulseSensor.getBeatsPerMinute();
    if (tenCounter == 0) {
      char buf[64];
      sprintf(buf, "%d,%d,%d\n", 37, steps, myBPM / 3);
      MyBlue.print(buf);
    }
    tenCounter++;
    tenCounter %= 10;
  }
  delay(10);
}
