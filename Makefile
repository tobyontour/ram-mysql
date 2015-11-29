start:
	docker run --name ram-mysql -e MYSQL_ROOT_PASSWORD=root -p 3307:3306 -d mysqlram -v /mnt/ramdisk:/var/lib/mysql

stop:
	docker stop ram-mysql
	sudo rm -rf /mnt/ramdisk/*
	docker rm ram-mysql

build:
	docker build -t mysqlram .

connect:
	mysql -u root -p --port=3307 --protocol=TCP

ssh:
	docker exec -i -t ram-mysql bash
