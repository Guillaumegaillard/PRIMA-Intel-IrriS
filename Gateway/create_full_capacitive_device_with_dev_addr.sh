#!/bin/bash

# Ex: create_full_capacitive_device_with_dev_addr.sh 1 AA
# this script creates a capacitive sensor with SOIL-AREA-x and dev addr 26011Dyy
# for capacitive, it is recommended to use AA, AB, AC,... for yy
# the device id will be x62286d72f06c4c0001eba943: i.e. 162286d72f06c4c0001eba943

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Need the device id where the sensor will be added"
    exit
fi

echo "--> Get token"
TOK=`curl -X POST "http://localhost/auth/token" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"loragateway\"}" | tr -d '\"'`

DATE=`date +"%Y-%m-%dT%H:%M:%S.%3NZ"`

echo "--> date is $DATE" 
echo "--> Create device ${1}62286d72f06c4c0001eba943"
curl -X POST "http://localhost/devices" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"actuators\":[],\"id\":\"${1}62286d72f06c4c0001eba943\",\"name\":\"SOIL-AREA-${1}\",\"sensors\":[{\"id\":\"temperatureSensor_0\",\"kind\":\"\",\"meta\":{\"createdBy\":\"wazigate-lora\",\"kind\":\"Raw value from SEN0308\",\"model\":\"SEN0308\",\"type\":\"capacitive\",\"sensor_dry_max\":800,\"sensor_wet_max\":0,\"sensor_n_interval\":6,\"value_index\":0},\"name\":\"Soil Humidity Sensor\",\"quantity\":\"\",\"time\":\"2022-04-06T14:39:45.205Z\",\"unit\":\"\",\"value\":800}]}"
echo "		name: SOIL-AREA-${1}"
echo "		with Soil Humidity Sensor displaying Raw value from SEN0308"
echo "		and initialized with 800 value"

echo "--> Make it LoRaWAN"
echo "		device id: 26011D${2}"
curl -X POST "http://localhost/devices/${1}62286d72f06c4c0001eba943/meta" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d  "{\"codec\":\"application/x-xlpp\",\"lorawan\":{\"appSKey\":\"23158D3BBC31E6AF670D195B5AED5525\",\"devAddr\":\"26011D${2}\",\"devEUI\":\"AA555A0026011D${2}\",\"nwkSEncKey\":\"23158D3BBC31E6AF670D195B5AED5525\",\"profile\":\"WaziDev\"}}"

echo "--> Add value 0"
curl -X POST "http://localhost/devices/${1}62286d72f06c4c0001eba943/sensors/temperatureSensor_0/value" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"value\":0}"

#we adopt the following rule: 0:very dry; 1:dry; 2:dry-wet 3-wet-dry; 4-wet; 5-very wet
echo "--> Change humidity index to max value - 5:very wet"
curl -X POST "http://localhost/devices/${1}62286d72f06c4c0001eba943/sensors/temperatureSensor_0/meta" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"value_index\":5}"