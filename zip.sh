#!/bin/bash

cd ../sans-resizer
zip -r -X ../sans-terraform/sans-resizer.zip * %1>/dev/null %2>/dev/null
echo "{}"