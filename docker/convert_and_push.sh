#!/bin/bash

# Exit if any command returns a non-zero status
set -e

validate_variables() {
  for var in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY S3_PATH; do
    if [ -z "${!var}" ]; then
      echo "Error: $var is not set."
      exit 1
    fi
  done
}

validate_variables

if [ -z "$1" ]; then
  echo "Error: Version argument is missing."
  exit 1
fi

echo "Validation successful. Continuing with the execution."

echo "Converting test_report.xml to HTML..."
python -m junit2htmlreport test_report.xml test_report.html

new_filename=$(date +"%Y-%m-%d_%H-%M-%S")
echo "Renaming test_report.html to $new_filename.html..."
mv test_report.html $new_filename.html

version=$1

echo "Copying $new_filename.html to S3 bucket (s3://empatica-test-reports-data/$S3_PATH/$version/)..."
aws s3 cp $new_filename.html "s3://empatica-test-reports-data/$S3_PATH/$version/"
rm $new_filename.html

echo "Done."
