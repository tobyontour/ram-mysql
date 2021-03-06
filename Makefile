RAMDISK_LOCATION=/mnt/ramdisk
RAMDISK_SIZE=512M
FDISK_LINE="tmpfs       ${RAMDISK_LOCATION} tmpfs   nodev,nosuid,noexec,nodiratime,size=${RAMDISK_SIZE}   0 0"

build: ${RAMDISK_LOCATION}
	docker build -t mysqlram .

start:
	#docker run --name ram-mysql -e MYSQL_ROOT_PASSWORD=root -p 3307:3306 -d mysqlram -v /mnt/ramdisk:/var/lib/mysql
	docker run --name ram-mysql -e MYSQL_ROOT_PASSWORD=root -p 3307:3306 -d mysqlram 

stop:
	docker stop ram-mysql
	sudo rm -rf /mnt/ramdisk/*
	docker rm ram-mysql

connect:
	mysql -u root -p --port=3307 --protocol=TCP

ssh:
	docker exec -i -t ram-mysql bash

${RAMDISK_LOCATION}:
	@grep "${RAMDISK_LOCATION}" /etc/fstab || (echo "Add this line to /etc/fstab and `sudo mkdir ${RAMDISK_LOCATION}` and `sudo chmod a+rwx ${RAMDISK_LOCATION}`" && echo ${FDISK_LINE} && false)
	sudo mount ${RAMDISK_LOCATION}

clean:
	sudo rm -rf /mnt/ramdisk/*
	docker rm ram-mysql || true
	docker rmi -f mysqlram || true
