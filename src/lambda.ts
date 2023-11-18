import { APIGatewayEvent, APIGatewayProxyResult, Context } from "aws-lambda";
import awsLambdaFastify = require('@fastify/aws-lambda');

const app = require("./app");

const proxy = awsLambdaFastify(app, {
    binaryMimeTypes: ["application/octet-stream"],
    decorateRequest: false
})

const apiHandler = async (event: APIGatewayEvent, context: Context): Promise<APIGatewayProxyResult> =>{
    console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    console.log(event);
    console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    console.log(context);
    console.log("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return proxy(event, context);
}

module.exports = {
    apiHandler
}
