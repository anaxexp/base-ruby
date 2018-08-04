#!/bin/bash

set -e

cp Dockerfile-alpine.template tmp

# Change basic image.
sed -i '/FROM alpine/i\ARG BASE_IMAGE_TAG\n' tmp
sed -i 's/FROM alpine.*/FROM anaxexp\/alpine:${BASE_IMAGE_TAG}/' tmp

mv tmp Dockerfile-alpine.anaxexp.template
cp update.sh tmp

sed -i 's/Dockerfile-${template}.template/Dockerfile-${template}.anaxexp.template/' tmp
sed -i 's/\/Dockerfile"/\/Dockerfile.anaxexp"/' tmp
# Only alpine 3.7
sed -i 's/alpine{3.6,3.7}/alpine3.7/' tmp
sed -i '/jessie,stretch/d' tmp
# Change .travis.yml modifications.
sed -i -E 's/^(echo "\$travis.*)/#\1/' tmp
# Update travis.yml
sed -i '/$fullVersion;/a\    sed -i -E "s/(RUBY${version//.})=.*/\\1=$fullVersion/" .travis.yml' tmp
# Update README.
sed -i '/$fullVersion;/a\\n    sed -i -E "s/\\`${version}\.[0-9]+\\`/\\`$fullVersion\\`/" README.md' tmp

mv tmp update.anaxexp.sh

./update.anaxexp.sh

rm Dockerfile-alpine.anaxexp.template
rm update.anaxexp.sh