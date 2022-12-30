#!/bin/bash

# Set the current date and time
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# Set the name of the database to be backed up
DATABASE_NAME=my_database

# Set the path to the MySQL dump utility
MYSQLDUMP_PATH="/usr/bin/mysqldump"



# Set the name of the S3 bucket and the path to the backup file
S3_BUCKET=my-s3-bucket
S3_PATH=mysql-backups/$TIMESTAMP-$DATABASE_NAME.sql

# Run the MySQL dump command
$MYSQLDUMP_PATH -u root -p $DATABASE_NAME > $DATABASE_NAME.sql

# Install the AWS CLI if it is not already installed
if ! [ -x "$(command -v aws)" ]; then
  sudo apt-get update
  sudo apt-get install -y python3-pip
  pip3 install awscli --upgrade
fi

# Sync the MySQL dump file to the S3 bucket
aws s3 cp $DATABASE_NAME.sql s3://$S3_BUCKET/$S3_PATH --acl public-read --sse AES256 --region us-east-1

# Remove the MySQL dump file from the local machine
rm $DATABASE_NAME.sql
