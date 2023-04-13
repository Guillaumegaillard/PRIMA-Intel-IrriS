#!/bin/bash


if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    exit
else
    echo "--> Get token"
    TOK=`curl -X POST "http://localhost/auth/token" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"loragateway\"}" | tr -d '\"'`
    
    if [ $1 == 'devices' ]
    then
        curl -X GET "http://wazigate.local:5000/devices" -H  "accept: application/json" > iiwa_devices.json
    elif [ $1 == 'add' ]
    then
        curl -X POST "http://wazigate.local:5000/devices/$2" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "{
          \"device_id\":\"$2\",\"device_name\":\"$3\",\"sensors_structure\":\"$4\"}" | tr -d '\"'

        if [ $4 == '1_watermark' ] || [ $4 == '2_watermark' ]
        then
            curl -X POST "http://wazigate.local:5000/devices/$2/sensors/$5" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "
            {
                \"sensor_type\": \"tensiometer_cbar\", 
                \"sensor_age\": \"0\", 
                \"sensor_max_value\": \"124\", 
                \"sensor_min_value\": \"0\", 
                \"soil_type\": \"silty\", 
                \"soil_irrigation_type\": \"undefined\", 
                \"soil_salinity\": \"undefined\", 
                \"soil_bulk_density\": \"undefined\",
                \"soil_field_capacity\":\"undefined\", 
                \"soil_temperature_value\": \"undefined\", 
                \"soil_temperature_device_id\": \"$2\", 
                \"soil_temperature_sensor_id\": \"temperatureSensor_5\", 
                \"plant_category\":\"undefined\",
                \"plant_type\":\"undefined\",
                \"plant_variety\":\"undefined\",
                \"plant_planting_date\": \"undefined\", 
                \"weather_region\": \"semi-arid\", 
                \"weather_weekly_evaporation\":\"undefined\",
                \"weather_weekly_pluviometry\":\"undefined\"
            }
            " | tr -d '\"'
        else
            curl -X POST "http://wazigate.local:5000/devices/$2/sensors/$5" -H "accept: application/json" -H "Authorization: Bearer $TOK" -H  "Content-Type: application/json" -d "
            {
                \"sensor_type\": \"capacitive\", 
                \"sensor_age\": \"0\", 
                \"sensor_max_value\": \"800\", 
                \"sensor_min_value\": \"0\", 
                \"soil_type\": \"silty\", 
                \"soil_irrigation_type\": \"undefined\", 
                \"soil_salinity\": \"undefined\", 
                \"soil_bulk_density\": \"undefined\",
                \"soil_field_capacity\":\"undefined\", 
                \"soil_temperature_value\": \"undefined\", 
                \"soil_temperature_device_id\": \"undefined\", 
                \"soil_temperature_sensor_id\": \"undefined\", 
                \"plant_category\":\"undefined\",
                \"plant_type\":\"undefined\",
                \"plant_variety\":\"undefined\",
                \"plant_planting_date\": \"undefined\", 
                \"weather_region\": \"semi-arid\", 
                \"weather_weekly_evaporation\":\"undefined\",
                \"weather_weekly_pluviometry\":\"undefined\"
            }
            " | tr -d '\"'            
        fi
    elif [ $1 == 'delete' ]
    then
        curl -X DELETE "http://wazigate.local:5000/devices/$2" -H  "accept: application/json"
    elif [ $1 == 'data' ]
    then
        curl -X GET "http://wazigate.local:5000/devices/data" -H  "accept: application/json" > iiwa_data.json
    elif [ $1 == 'configs' ]
    then
        curl -X GET "http://wazigate.local:5000/sensors_configurations" -H  "accept: application/json" > iiwa_sensors_configurations.json
    fi
fi

