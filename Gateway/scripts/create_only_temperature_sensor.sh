#!/bin/bash

# Ex: create_only_temperature_sensor.sh 1
# this script creates a temperature sensor attached to a given device
# the temperature sensor is always temperatureSensor_5

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Need the device name index"
    echo "e.g. create_only_temperature_sensor.sh 1"
    exit
fi

echo "--> Get token"
TOK=`curl -X POST "http://localhost/auth/token" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"loragateway\"}" | tr -d '\"'`

DATE=`date +"%Y-%m-%dT%H:%M:%S.%3NZ"`

echo "--> date is $DATE" 
echo "--> Use device ${1}62286d72f06c4c0001eba943"
echo "--> Create temperature sensor"
curl -X POST "http://localhost/devices/${1}62286d72f06c4c0001eba943/sensors" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{\"id\":\"temperatureSensor_5\",\"kind\":\"\",\"meta\":{\"createdBy\":\"wazigate-lora\",\"kind\":\"degree Celsius\",\"model\":\"DS18B20\",\"type\":\"temperature\",\"value_index\":0},\"name\":\"Soil Temperature Sensor\",\"quantity\":\"\",\"time\":\"2022-04-06T14:39:45.205Z\",\"unit\":\"\",\"value\":24}"
echo "		with soil temperature displaying degree Celsius"
echo "		and initialized with 24 value"

