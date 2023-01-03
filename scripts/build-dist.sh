#!/bin/bash
echo "$PYTHON_BIN"

set -x
$PYTHON_BIN setup.py sdist bdist_wheel

set +x
