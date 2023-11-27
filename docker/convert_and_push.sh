#!/bin/bash

set -e

validate_variables() {
  required_vars=("AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY")

  for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
      echo "Error: $var is not set."
      exit 1
    fi
  done

  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Error: Some arguments are missing. (s3_bucket_base_path, s3_path, version, test_report_filename)"
    exit 1
  fi
}

convert_xml_to_html() {
  echo "Converting $test_report_filename.xml to HTML..."
  python -m junit2htmlreport "$test_report_filename.xml" "$test_report_filename.html"
}

rename_html_file() {
  new_filename=$(date +"%Y-%m-%d_%H-%M-%S")
  echo "Renaming $test_report_filename.html to $new_filename.html..."
  mv "$test_report_filename.html" "$new_filename.html"
}

copy_to_s3() {
  s3_bucket_base_path="$1"
  s3_path="$2"
  version="$3"
  s3_full_path="$s3_bucket_base_path/$s3_path/$version/"
  echo "Copying $new_filename.html to S3 bucket ($s3_full_path)..."
  aws s3 cp "$new_filename.html" "$s3_full_path"
}

validate_variables "$@"
echo "Variable validation successful. Continuing with the execution."

test_report_filename="$4"

convert_xml_to_html
rename_html_file
copy_to_s3

rm "$new_filename.html"
echo "Done."
