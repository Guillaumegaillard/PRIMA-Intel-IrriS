#!/bin/bash

# this script adds a watermark sensor as secondary device, i.e. SOIL-AREA-2 and devAddr=26011DBB

echo "--> Get token"
TOK=`curl -X POST "http://localhost/auth/token" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"loragateway\"}" | tr -d '\"'`

echo "--> Adding an additional device to the existing device 62286d72f06c4c0001eba943"
echo "--> Create device 622a0c50f8f06600016be8fd"
curl -X POST "http://localhost/devices" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"actuators\":[],\"id\":\"622a0c50f8f06600016be8fd\",\"name\":\"SOIL-AREA-2\",\"sensors\":[{\"id\":\"temperatureSensor_0\",\"kind\":\"\",\"meta\":{\"createdBy\":\"wazigate-lora\",\"kind\":\"centibars from WM200\",\"model\":\"WM200\",\"type\":\"tensiometer\",\"sensor_dry_max\":120,\"sensor_wet_max\":0,\"sensor_n_interval\":6,\"value_index\":0},\"name\":\"Soil Humidity Sensor\",\"quantity\":\"\",\"time\":\"2022-04-06T14:39:45.205Z\",\"unit\":\"\",\"value\":10},{\"id\":\"temperatureSensor_1\",\"kind\":\"\",\"meta\":{\"createdBy\":\"wazigate-lora\",\"kind\":\"Scaled value from WM200 real=x10\",\"model\":\"WM200\",\"type\":\"tensiometer\",\"sensor_dry_max\":8000,\"sensor_wet_max\":0,\"sensor_n_interval\":6,\"value_index\":0},\"name\":\"Soil Humidity Sensor\",\"quantity\":\"\",\"time\":\"2022-04-06T14:39:45.205Z\",\"unit\":\"\",\"value\":550}]}"
echo "		name: SOIL-AREA-2"
echo "		with Soil Humidity Sensor displaying centibars from WM200"
echo "		and initialized with 10 value"

echo "--> Make it LoRaWAN"
echo "		device id: 26011DBB"
curl -X POST "http://localhost/devices/622a0c50f8f06600016be8fd/meta" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d  "{\"codec\":\"application/x-xlpp\",\"lorawan\":{\"appSKey\":\"23158D3BBC31E6AF670D195B5AED5525\",\"devAddr\":\"26011DBB\",\"devEUI\":\"AA555A0026011DBB\",\"nwkSEncKey\":\"23158D3BBC31E6AF670D195B5AED5525\",\"profile\":\"WaziDev\"}}"

echo "--> Add value 0"
curl -X POST "http://localhost/devices/622a0c50f8f06600016be8fd/sensors/temperatureSensor_0/value" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"value\":0}"

echo "--> Add value 0"
curl -X POST "http://localhost/devices/622a0c50f8f06600016be8fd/sensors/temperatureSensor_1/value" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"value\":0}"

#we adopt the following rule: 0:very dry; 1:dry; 2:dry-wet 3-wet-dry; 4-wet; 5-very wet
echo "--> Change humidity index to max value - 5:very wet"
curl -X POST "http://localhost/devices/622a0c50f8f06600016be8fd/sensors/temperatureSensor_0/meta" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"value_index\":5}"

curl -X POST "http://localhost/devices/622a0c50f8f06600016be8fd/sensors/temperatureSensor_1/meta" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"value_index\":5}"