#!/bin/sh

cp package.json package-lock.json ./dist

cd dist

npm ci --omit=dev

rm -rf package.json package-lock.json
