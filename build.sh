#!/bin/bash

# Specify UID & GID
UID=${UID:-$(id -u)}
GID=${GID:-$(id -g)}

# Build Docker Image
docker build --build-arg USER=$USER --build-arg UID=$UID --build-arg GID=$GID -t ${USER}_label-studio .