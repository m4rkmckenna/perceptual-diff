#!/usr/bin/env bash

IMAGE_FORAMT="png"
HIGHLIGHT_COLOUR="red"

while [[ $# -gt 1 ]]; do
 	case $1 in
 		-f|--format)
 			IMAGE_FORAMT="$2"
 			shift
 		;;
 		*)
 		;;
 	esac
 	shift
done

function run(){
	rm -rf /result/*
	echo "results:" > /result/results.yaml
	find /base -type f -name "*.${IMAGE_FORAMT}" | while read BASE_IMAGE_PATH; do
		IMAGE_RELATIVE_PATH="${BASE_IMAGE_PATH#"/base/"}"
		COMPARE_IMAGE_PATH="/compare/${IMAGE_RELATIVE_PATH}"
		RESULT_IMAGE_PATH="/result/${IMAGE_RELATIVE_PATH}"

		if [ -f /compare/${IMAGE_RELATIVE_PATH} ]; then
			mkdir -p $(dirname ${RESULT_IMAGE_PATH})
			compare -metric 'RMSE' -highlight-color ${HIGHLIGHT_COLOUR} \
				${BASE_IMAGE_PATH} ${COMPARE_IMAGE_PATH} ${RESULT_IMAGE_PATH} >${RESULT_IMAGE_PATH}_.txt 2>&1

			RMS=$(cat ${RESULT_IMAGE_PATH}_.txt | awk -F'[)(]' '{print $2}')
			PASS=$(awk "BEGIN { pass=${RMS}==0; print pass }")
			if [ ${PASS} == "1" ]; then
				rm -f ${RESULT_IMAGE_PATH} ${RESULT_IMAGE_PATH}_.txt
				writeResult ${IMAGE_RELATIVE_PATH} true
				echo "${IMAGE_RELATIVE_PATH} :: PASS"
			else
				writeResult ${IMAGE_RELATIVE_PATH} false
				convert -delay 50 ${BASE_IMAGE_PATH} ${RESULT_IMAGE_PATH} -loop 0 ${RESULT_IMAGE_PATH}_.gif
				echo "${IMAGE_RELATIVE_PATH} :: FAIL"
			fi
		fi
	done
}

function writeResult(){
	echo "  - image: ${1}" >> /result/results.yaml
	echo "    pass: ${2}" >> /result/results.yaml
}

run