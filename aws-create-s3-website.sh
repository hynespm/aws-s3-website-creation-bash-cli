#!/bin/bash
# Description : Bash script to create two s3 buckets for static website hosting
# Arguments : Website name & Region
# Author : Patrick Hynes
# Date : 21.01.17

WEBSITE_NAME=$1
REGION=$2
PROFILE=$3

# Create the two bucket names
PROD_WEBSITE_NAME=$WEBSITE_NAME"-prod"
STAG_WEBSITE_NAME=$WEBSITE_NAME"-dev"

echo "Creating S3 Buckets for Website Hosting ...."
echo "S3 Bucket Name: " $WEBSITE_NAME

echo "Creating staging website...."
aws s3 mb s3://$STAG_WEBSITE_NAME --region $REGION --profile $PROFILE
aws s3 website s3://$STAG_WEBSITE_NAME/ --index-document index.html --error-document error.html --profile $PROFILE
echo "Staging created..."

echo "Creating production website...."
aws s3 mb s3://$PROD_WEBSITE_NAME --region $REGION --profile $PROFILE
aws s3 website s3://$PROD_WEBSITE_NAME/ --index-document index.html --error-document index.html --profile $PROFILE

echo "Production created..."
aws s3api put-bucket-policy --bucket $STAG_WEBSITE_NAME --policy file://policy-file/stag-policy.json --profile $PROFILE
aws s3api put-bucket-policy --bucket $PROD_WEBSITE_NAME --policy file://policy-file/prod-policy.json --profile $PROFILE
echo "Policies applied..."