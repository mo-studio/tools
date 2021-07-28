#!/bin/bash

docker build -t amp .
docker run -it -v /Users/$USER/.aws:/root/.aws -v /Users/$USER/Desktop/tools:/amp/ amp