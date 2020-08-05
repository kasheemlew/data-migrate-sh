.PHONY: help
mongo:
	@mongodump --version >/dev/null
	sudo bash mongo.sh
redis:
	@redis-cli --version >/dev/null
	sudo bash redis.sh
mysql:
	@mysqldump --version >/dev/null
	@mysql --version >/dev/null
	sudo bash mysql.sh
help:
	@echo '$ make [mongo|redis|mysql]'
