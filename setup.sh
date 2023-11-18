#!/bin/sh

apt-get update

apt-get install -y jq

## Lambda デプロイ

echo '============== lambda create-function =============='
awslocal lambda create-function \
  --function-name apigw-lambda-sample \
  --runtime nodejs18.x \
  --handler function/src/lambda.apiHandler \
  --memory-size 128 \
  --zip-file fileb://function.zip \
  --role arn:aws:iam::111111111111:role/apigw

## API Gateway リソース作成

echo '============== apigateway create-rest-api =============='
output=$(awslocal apigateway create-rest-api \
    --name 'ApiGateway-Lambda')

echo $output

REST_API_ID=$(echo $output | jq -r '.id')

echo '============== REST_API_ID =============='
echo $REST_API_ID

echo '============== apigateway get-resources =============='
output=$(awslocal apigateway get-resources \
    --rest-api-id $REST_API_ID)

echo $output

PARENT_ID_ROOT=$(echo $output | jq -r '.items[0].id')

echo '============== PARENT_ID_ROOT =============='
echo $PARENT_ID_ROOT

echo '============== apigateway create-resource api =============='
output=$(awslocal apigateway create-resource \
  --rest-api-id $REST_API_ID \
  --parent-id $PARENT_ID_ROOT \
  --path-part "api")

echo $output

PARENT_ID_API=$(echo $output | jq -r '.id')

echo '============== PARENT_ID_API =============='
echo $PARENT_ID_API

echo '============== apigateway create-resource users =============='
output=$(awslocal apigateway create-resource \
  --rest-api-id $REST_API_ID \
  --parent-id $PARENT_ID_API \
  --path-part "users")

echo $output

RESOURCE_ID_API_USERS=$(echo $output | jq -r '.id')

echo '============== RESOURCE_ID_API_USERS =============='
echo $RESOURCE_ID_API_USERS

# API Gateway GET : /api/users

echo '============== apigateway put-method =============='
awslocal apigateway put-method \
  --rest-api-id $REST_API_ID \
  --resource-id $RESOURCE_ID_API_USERS \
  --http-method GET \
  --request-parameters "method.request.path.somethingId=true" \
  --authorization-type "NONE"

echo '============== apigateway put-integration =============='
awslocal apigateway put-integration \
  --rest-api-id $REST_API_ID \
  --resource-id $RESOURCE_ID_API_USERS \
  --http-method GET \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:apigw-lambda-sample/invocations \
  --passthrough-behavior WHEN_NO_MATCH

# API Gateway POST : /api/users

echo '============== apigateway put-method =============='
awslocal apigateway put-method \
  --rest-api-id $REST_API_ID \
  --resource-id $RESOURCE_ID_API_USERS \
  --http-method POST \
  --request-parameters "method.request.path.somethingId=true" \
  --authorization-type "NONE"

echo '============== apigateway put-integration =============='
awslocal apigateway put-integration \
  --rest-api-id $REST_API_ID \
  --resource-id $RESOURCE_ID_API_USERS \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:apigw-lambda-sample/invocations \
  --passthrough-behavior WHEN_NO_MATCH

# API Gateway Deploy

echo '============== apigateway create-deployment =============='
awslocal apigateway create-deployment \
  --rest-api-id $REST_API_ID \
  --stage-name test-stage

echo "REST_API_ID : $REST_API_ID"
