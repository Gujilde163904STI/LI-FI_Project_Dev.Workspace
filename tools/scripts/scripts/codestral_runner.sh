#!/bin/bash
# codestral_runner.sh: Offload /// CODESRAL: blocks to Codestral-22B via LM Studio API

API_URL="http://192.168.2.1:1234/v1"

find . \( -name '*.py' -o -name '*.js' \) | while read -r file; do
  awk '/^\/\/\/ CODESRAL:/{flag=1; block=""; next} /^\/\//{if(flag){block=block $0 "\n"} else {next}} /^[^\/]/ {if(flag){flag=0; if(block!=""){ \
    echo "[CODESRAL] File: $file"; \
    echo -e "$block" | curl -s -X POST "$API_URL" -H 'Content-Type: application/json' -d @-; \
    echo; \
  } block=""}} END{if(flag && block!=""){ \
    echo "[CODESRAL] File: $file (EOF)"; \
    echo -e "$block" | curl -s -X POST "$API_URL" -H 'Content-Type: application/json' -d @-; \
    echo; \
  }}' "$file"
done 