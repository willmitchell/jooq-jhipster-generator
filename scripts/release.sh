#!/bin/bash -x

echo "yes I should get the gpg-agent working to avoid this, but..."
echo "Prepare to type your key 4 times"

mvn clean deploy -P deploy
