-include .env

all    :; dapp build
clean  :; dapp clean
test   :; dapp test

deploy :; @./scripts/deploy.sh
