#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#ifndef STASSID
#define STASSID "guest-TheCircle"
#define STAPSK  "Guest@811"
#endif
#include <WiFiClient.h>
#include <ThingSpeak.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
const char* ssid     = STASSID;
const char* password = STAPSK;
# define sensorPin A0
# define buzzer D0
# define red_led D3
# define green_led D2

ESP8266WiFiMulti WiFiMulti;

 
WiFiClient client;
 
unsigned long myChannelNumber = 906882;
 
const char * myWriteAPIKey = "77826LOSB65OVA4K";
void setup()
 
{

Serial.begin(9600);
 
// Connect to WiFi network
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(ssid, password);
   while (WiFiMulti.run() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  delay(500);
  ThingSpeak.begin(client);
  pinMode(sensorPin,INPUT);
  pinMode(buzzer,OUTPUT);
  pinMode(green_led,OUTPUT);
  pinMode(red_led,OUTPUT);
}
 
 
 
void loop()
 
{
  int data = analogRead(sensorPin);
  Serial.println(data);

ThingSpeak.writeField(myChannelNumber, 1,data, myWriteAPIKey); //Update in ThingSpeak
if (data<890)
{
  digitalWrite(red_led,HIGH);
  digitalWrite(green_led,LOW);
  Serial.println("Bad Posture!!");
  digitalWrite(buzzer,HIGH);
}
else if((data>900)&&(data<=1024))
{
  digitalWrite(red_led,LOW);
  digitalWrite(green_led,HIGH);
  digitalWrite(buzzer,LOW);
  Serial.println("Normal Posture");
}
delay(50);
}
