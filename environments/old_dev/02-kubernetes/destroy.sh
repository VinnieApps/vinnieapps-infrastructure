#!/bin/bash

set -e

kubectl delete --ignore-not-found -f 001-contour.yml
