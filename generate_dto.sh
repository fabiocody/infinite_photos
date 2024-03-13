#!/bin/sh

set -e

flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib/ test/ --line-length 120
