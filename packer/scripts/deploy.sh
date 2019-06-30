#!/bin/bash

#Clone the repo and install the dependencies
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

#Starting the server
puma -d

