#!/bin/bash

# Ex: split_capacitive_device_sensor_values.sh 62c7c657127dbd00011540a6
# this script splits a capacitive device backup file into several files

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Need the device id"
    echo "e.g. split_capacitive_device_sensor_values.sh 62c7c657127dbd00011540a6"
    exit
fi

SENSORS="temperatureSensor_0 temperatureSensor_5 analogInput_6"

for k in $SENSORS
do
	if [ -f "$1.capacitive.${k}.data.json" ]; then
		echo "--> Split sensor's values from device $1 sensor $k"
		split $1.capacitive.${k}.data.json -a 1 -d $1.capacitive.${k}.data_split_

		SPLIT_FILES=`ls $1.capacitive.${k}.data_split*`
		NFILE=`ls -l $1.capacitive.${k}.data_split* | wc -l`

		if [ $NFILE -gt 1 ];
		then
			echo "]" >> $1.capacitive.${k}.data_split_0
		fi
		mv $1.capacitive.${k}.data_split_0 $1.capacitive.${k}.data_split_0.json

		for (( i = 1; i < $NFILE; i++ ))
		do
			sed -i '1s/^./[/' $1.capacitive.${k}.data_split_${i}
			if [ $i -lt $(( $NFILE-1 )) ];
				then
					echo "]" >> $1.capacitive.${k}.data_split_${i}
				fi	
			mv $1.capacitive.${k}.data_split_${i} $1.capacitive.${k}.data_split_${i}.json
		done
	else
  	echo "no $1.capacitive.${k}.data.json"
	fi		
done	

echo "Done"