#!/bin/bash

# Ex: split_tensiometer_device_sensor_values.sh 62c7c657127dbd00011540a6
# this script splits a tensiometer device backup file into several files

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Need the device id"
    echo "e.g. split_tensiometer_device_sensor_values.sh 62c7c657127dbd00011540a6"
    exit
fi

# SENSORS="temperatureSensor_0 temperatureSensor_1 temperatureSensor_5 analogInput_6"
SENSORS="temperatureSensor_0 temperatureSensor_1 temperatureSensor_2 temperatureSensor_3 temperatureSensor_5 analogInput_6"


for k in $SENSORS
do
	if [ -f "$1.tensiometer.${k}.data.json" ]; then
		echo "--> Split sensor's values from device $1 sensor $k"
		split $1.tensiometer.${k}.data.json -a 3 -d $1.tensiometer.${k}.data_split_

		SPLIT_FILES=`ls $1.tensiometer.${k}.data_split*`
		NFILE=`ls -l $1.tensiometer.${k}.data_split* | wc -l`

		if [ $NFILE -gt 1 ];
		then
			echo "]" >> $1.tensiometer.${k}.data_split_000
		fi
		mv $1.tensiometer.${k}.data_split_000 $1.tensiometer.${k}.data_split_000.json

		for (( i = 1; i < $NFILE; i++ ))
		do
			sn=$(printf "%03d" $i)
			echo "processing split file $sn"
			sed -i '1s/^./[/' $1.tensiometer.${k}.data_split_${sn}
			if [ $i -lt $(( $NFILE-1 )) ];
				then
					echo "]" >> $1.tensiometer.${k}.data_split_${sn}
				fi	
			mv $1.tensiometer.${k}.data_split_${sn} $1.tensiometer.${k}.data_split_${sn}.json
		done
	else
  	echo "no $1.tensiometer.${k}.data.json"
	fi		
done	

echo "Done"