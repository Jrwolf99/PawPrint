
//This is the dog's Arduino Nano code with the
//Thermisters and HR/POX sensor integrated.



#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include <Wire.h>
#include <SoftwareSerial.h>
#include "MAX30100_PulseOximeter.h"

#include <avr/wdt.h>

// the value of the 'other' resistor
#define SERIESRESISTOR_1 9800          // calculated room temp resistance
#define SERIESRESISTOR_2 9800
 
// What pin to connect the sensor to
#define THERMISTORPIN_1 A0
#define THERMISTORPIN_2 A1 
 
#define REPORTING_PERIOD_MS     1000
#define CE_PIN   9
#define CSN_PIN  10


//temp stuff from: https://www.circuitbasics.com/arduino-thermistor-temperature-sensor-tutorial/
//used for the thermistor calculations
#define c1 1.009249522e-03
#define c2 2.378405444e-04
#define c3 2.019202697e-07


//declare the board.
PulseOximeter pox;

uint32_t tsLastReport = 0;



const byte slaveAddress[5] = {'R','x','A','A','A'};


RF24 radio(CE_PIN, CSN_PIN); // Create a Radio

char dataToSend[10] = "Message 0";
char txNum = '0';


unsigned long currentMillis;
unsigned long prevMillis;
unsigned long txIntervalMillis = 1000; 




void onBeatDetected()
{
   // Serial.println("Beat!");
}




void watchdogSetup(void){
  wdt_enable(WDTO_2S);
  Serial.println("Watchdog Timer has completed setup");
}



void setup() {
    Serial.begin(9600);
    radio.begin();
    radio.setDataRate( RF24_250KBPS );
    radio.setRetries(0,15); // delay, count
    radio.openWritingPipe(slaveAddress);
    radio.setPALevel(RF24_PA_MIN);
    radio.setChannel(120);
    watchdogSetup();
    wdt_reset();
    Serial.println("***Board was reset***");

    
    // Initialize the PulseOximeter instance
    if (!pox.begin()) {
        Serial.println("FAILED");
        for(;;);
    } else {
        Serial.println("SUCCESS");
    }
    // Infared LED Current Value
     pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);

    // Register a callback for the beat detection
    pox.setOnBeatDetectedCallback(onBeatDetected);
 
}







  int a = 0;
  static float HeartRate;
  static int SpO2;



float GetTemperatureValue(int adc) {
  //the imported number is the 5V version of n/1023.
  //convert the adc number to 3.3V version of n/1023.
  adc = adc*(5/3.3); 
  //if the adc value if over 1023, we just make it the max. 
  if (adc > 1023) adc = 1023;

 // R2 is the resistance of the thermistor. this is calculated from
 //this formula that was derived from a voltage divider. 
 //SERIESRESISTOR_1 and _2 are the same. there are two of them, but they are equal.
    float R2 = (SERIESRESISTOR_1*(float)adc) / (1023.0 - (float)adc);
  float logR2 = log(R2);
  //resistance to temperature.
  float T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
  float Tc = T - 273.15;
  float Tf = (Tc * 9.0)/ 5.0 + 32.0; 
  
  return Tf;



  }

  
void loop() {

//POX CODE--------------------------------------------------
  //pox.update();
  // Safety reset of the WDT
  wdt_reset();
  



    pox.update();

    currentMillis = millis();
    // Currently polling every 1000 ms
    if (currentMillis - prevMillis >= txIntervalMillis) {
      
        // Make sure to call update as fast as possible
        wdt_reset();

        pox.update();
        //Serial.print("Heart rate:");
        HeartRate = pox.getHeartRate();
        int HRSend = HeartRate;
     //   Serial.println(HRSend); 

        wdt_reset();
        SpO2 = pox.getSpO2();
        int SpO2Send = SpO2;
  //      Serial.print("SpO2: ");
      //  Serial.println(SpO2Send); 
  
      ////Thermister Code -------------------------------
        int reading_1 = analogRead(THERMISTORPIN_1);
        float temp_1 = GetTemperatureValue(reading_1);
        
        int reading_2 = analogRead(THERMISTORPIN_2);
        float temp_2 = GetTemperatureValue(reading_2);

      //  Serial.println(reading_1);
//        float temp_1 = 10;
//        float temp_2 = 10;
        float temp_avg = (temp_1 + temp_2) / 2;
      ////-----------------------------------------------

        int TempSend  = temp_avg;
   //     Serial.print("Temp: ");
   //     Serial.println(TempSend);
        wdt_reset();
        
        wdt_reset();
        prevMillis = millis();
   //     Serial.println("");

        int vitals[3] = {TempSend, HRSend, SpO2Send};

       for (int i = 0; i <3; i++)
        Serial.println(vitals[i]);
        
        radio.write(&vitals, sizeof(vitals));

    }


}
