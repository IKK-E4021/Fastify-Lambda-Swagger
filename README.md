# Fastify-Lambda-Swagger

Fastifyで「LambdaでAPIサーバーを作りたい」と「Open API (Swagger) でAPI仕様書を作成したい！」を共存させるためのサンプルコード

## コンテナ上のLocalStackでLambdaを呼び出す

rootディレクトリで

1. `npm run zip` でLambda関数のfunction.zipを作成します。

2. `docker-compose up -d` でLocalStack上にfunction.zipを格納します。

3. `docker exec -it fastify-lambda-localstack /bin/bash` でLocalStackのコンテナの中に入ります。

4. `./setup.sh`を実行し、以下を行います。
    1.  Lambda関数のデプロイ
    2. API GateWay のリソースの作成
    3. 1と2の連携
    4. API Gatewayの呼び出しに必要な`REST_API_ID`を取得

5. 4で取得した`REST_API_ID`を使って、コンテナ内でAPI Gateway経由でLambda関数を呼び出せるようになります。

例
```
curl -X GET http://localhost:4566/restapis/{{$REST_API_ID}}/test-stage/_user_request_/api/users

curl -X POST -H "Content-Type: application/json" -d '{"name" : "Ken", "age" : 27 }' http://localhost:4566/restapis/{{$REST_API_ID}}/test-stage/_user_request_/api/users
```

## Open API (Swagger) を確認する

1. `npm run start`

2. http://localhost:3000/documentation/static/index.html (or http://0.0.0.0:3000/documentation/static/index.html#/ ) にアクセス

http://0.0.0.0:3000/documentation/json で取得できるjsonを活用すればアプリケーションを起動することなく表示もできそう