//April 23 Full Receive Data and Send data to app


#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include "printf.h"

#define CE_PIN   A0
#define CSN_PIN  A1

const byte thisSlaveAddress[5] = {'R','x','A','A','A'};

RF24 radio(CE_PIN, CSN_PIN);

/*********************************************************************
  Bluefruit LE Connect Plotter 
  for Feather Bluefruit -> Bluefruit LE Connect app
  
  outputs dummy values for demo use with BLuefruit LE Connect app
  change SEND_SECOND_PLOT define to 1 to output second plot using sine wave table

  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!
  
  MIT license, check LICENSE for more information
  All text above, and the splash screen below must be included in
  any redistribution
*********************************************************************/

#include <Arduino.h>
#include <SPI.h>
#if not defined (_VARIANT_ARDUINO_DUE_X_) && not defined (_VARIANT_ARDUINO_ZERO_)
#include <SoftwareSerial.h>
#endif

#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"
#include "BluefruitConfig.h"
#define FACTORYRESET_ENABLE         1
#define MINIMUM_FIRMWARE_VERSION    "0.6.6"
#define MODE_LED_BEHAVIOUR          "MODE"
#define SEND_SECOND_PLOT            0



Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);



// A small helper
void error(const __FlashStringHelper*err) {
  Serial.println(err);
  while (1);
}





//===========

void setup() {


    
    Serial.begin(9600);
    while(!Serial){}

    //-----Radio setup--------
    printf_begin();
    radio.begin();
    radio.setDataRate( RF24_250KBPS );
    radio.openReadingPipe(1, thisSlaveAddress);
    radio.setChannel(120);
    radio.startListening();
    radio.printDetails();
    //--------------------------






  /* Initialise the module */
  Serial.print(F("Initialising the Bluefruit LE module: "));

  if ( !ble.begin(VERBOSE_MODE) )
  {
    error(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
  }
  Serial.println( F("OK!") );

  if ( FACTORYRESET_ENABLE )
  {
    /* Perform a factory reset to make sure everything is in a known state */
    Serial.println(F("Performing a factory reset: "));
    if ( ! ble.factoryReset() ) {
      error(F("Couldn't factory reset"));
    }
  }

  /* Disable command echo from Bluefruit */
  ble.echo(false);

  Serial.println("Requesting Bluefruit info:");
  /* Print Bluefruit information */
  ble.info();

  Serial.println(F("Please use Adafruit Bluefruit LE app to connect in UART mode"));
  Serial.println(F("Then Enter characters to send to Bluefruit"));
  Serial.println();

  ble.verbose(false);  // debug info is a little annoying after this point!

  /* Wait for connection */
  while (! ble.isConnected()) {
    delay(500);
  }

  Serial.println(F("******************************"));

  // LED Activity command is only supported from 0.6.6
  if ( ble.isVersionAtLeast(MINIMUM_FIRMWARE_VERSION) )
  {
    // Change Mode LED Activity
    Serial.println(F("Change LED activity to " MODE_LED_BEHAVIOUR));
    ble.sendCommandCheckOK("AT+HWModeLED=" MODE_LED_BEHAVIOUR);
  }

  // Set module to DATA mode
  Serial.println( F("Switching to DATA mode!") );
  ble.setMode(BLUEFRUIT_MODE_DATA);

  Serial.println(F("******************************"));
}


    


//==============END SETUP===================

//Global array variable to recieve data from radio
int vitals[3];
int previousVitals[3] = {80, 75, 90};


//these three arrays populate in a FIFO order so that the average
//of all 5 numbers is taken every loop iteration. 
int TempArray[5] = {80};
int HRArray[5] =  {75};
int OxArray[5] = {90};

//index where the current vital needs to be updated in the arrays listed above. 
int indexCountVitalRead = 0;


String compute_vitals_string(int averageTemp, int averageHR, int averageOx) {
    String myString;
    myString = ('T' + String(averageTemp) + 'H' + String(averageHR) + 'S' + String(averageOx)); 
    return myString;
  }


//this function replaces the number at the current index with the new vital.
void addVitalsToArrays(int temp, int HR, int Ox) {
    TempArray[indexCountVitalRead] = temp;
    HRArray[indexCountVitalRead] = HR;
    OxArray[indexCountVitalRead] = Ox;
    return;
  }


int CalculateAverage(int arrayToAverage[]) {
    int sum = 0;
    for (int i = 0; i < 5; i++) { 
      sum += arrayToAverage[i]; 
      }
    return (sum / 5);

    }



int fixVital(int vitalToFix, int vitalCase) {
  if (vitalToFix <= 0){
    return previousVitals[vitalCase];
    }
  return vitalToFix;
  }
  


void loop() {

    if(radio.available()){
      
      radio.read(&vitals, sizeof(vitals));

      //distribute the vitals to their corresponding arrays for average calculation.
      //make an index count so we know which spot in the vitals arrays to add the new
      //value. this gets incremented every radio read. For all vitals, if the value is
      //zero or negative, the previous value added becomes the new value. 

      //fix the vital pertaining to the vital case that is temp, HR, or Ox. 
      int fixedTemp = fixVital(vitals[0], 0);
      int fixedHR = fixVital(vitals[1], 1);
      int fixedOx = fixVital(vitals[2], 2);

      
      //add new values
      addVitalsToArrays(fixedTemp, fixedHR, fixedOx);

      //take the averages of the three updated arrays.
      int averageOfFiveTemp = CalculateAverage(TempArray);
      int averageOfFiveHR = CalculateAverage(HRArray);
      int averageOfFiveOx = CalculateAverage(OxArray);



      String output_string = compute_vitals_string(averageOfFiveTemp, averageOfFiveHR, averageOfFiveOx);

      Serial.println("Temperature Array = ");
      for (int i = 0; i<5; i++) Serial.println(TempArray[i]);
      Serial.println();
      Serial.println("HR Array = ");
      for (int i = 0; i<5; i++) Serial.println(HRArray[i]);
      Serial.println();
      Serial.println("SPO2 Array = ");
      for (int i = 0; i<5; i++) Serial.println(OxArray[i]);
      Serial.println();

      Serial.print("String to send = ");
      Serial.println(output_string);
      ble.println(output_string);

      //finally, update the previous values. 
      previousVitals[0] = fixedTemp;
      previousVitals[1] = fixedHR;
      previousVitals[2] = fixedOx;

      
      //increment indexCount;
      indexCountVitalRead++;
      //loop it. if over 5, reset to 0. 
      if(indexCountVitalRead > 4) indexCountVitalRead = 0;

    }
}

//=============
