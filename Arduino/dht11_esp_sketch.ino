#include "DHTesp.h"
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>


DHTesp dht;
char ssid[] = "Majdi fiber 4g"; //your Wi-Fi name
char password[] = "0505306426"; // your Wi-Fi password
String dhtData;
boolean sensorError = false;
float Tempreture, Humidity;
ESP8266WebServer server(80);
void handleRoot() { 
  // try typing your ip adress in your browser to check your connection
  server.send(200, "text/html", "<h1>connected</h1>");
}
void setup()
{
Serial.begin(9600);

dht.setup(14, DHTesp::DHT11); // GPIO14 
WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("cennecting...");}
   
 WiFi.mode(WIFI_STA);
 //add your IP adress
  IPAddress ip(192, 168, 1, 40);
  // if your are using macr OS: use this command in your terminal to get the ip adress: ipconfig getifaddr en0
  // if ypur are using windows OS: use this command in your cmd to get the ip adress: ipconfig
  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);
  Serial.println(WiFi.localIP());
  server.on("/", handleRoot);
  server.on("/dht", sendDhtData);
  server.begin();
 ;
 
}


void sendDhtData() {
  server.send(200, "text/plain", dhtData);
}

void loop()
{
  server.handleClient();


  Humidity =dht.getHumidity();
 Tempreture = dht.getTemperature();

    Serial.println("Temperature: ");
    Serial.println(Tempreture);
    Serial.println(" *C");
    Serial.println("Humidity: ");
    Serial.println(Humidity);
    Serial.println(" %");
dhtData = String(Tempreture) + ' ' + String(Humidity);

       delay(2000); //Delay 2 sec, data will be updated every two seconeds. 
     

}
