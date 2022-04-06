---
title: MySQL_基础 (83)
date: 2021-11-11
tags: MySQL
toc: true
---

### 更好的理解MySQL
    Mysql备份

<!-- more -->

#### 数据库备份
> 另一种迁移shell
- code
    ```bash
        #!/bin/bash
        MYSQLDUMP=/usr/local/mysql/bin/mysqldump
        MYSQLPATH=/usr/local/mysql/bin/mysql

        TDAY=`date  +%Y%m%d`
        data_dir=/home/work
        backup_file_name=${data_dir}/${ONLINE_MYSQL_DB}_${TDAY}
        echo "begin to dump data from online", `date`
        ${MYSQLDUMP} -h${ONLINE_MYSQL_HOST} -P${ONLINE_MYSQL_PORT} -u${ONLINE_MYSQL_USER} -p${ONLINE_MYSQL_PASSWD} --flush-logs --delete-master-logs ${ONLINE_MYSQL_DB} > ${backup_file_name}
        echo "dump data ending", `date`

        echo "begin to load data for backup", `date`
        ${MYSQLPATH} -h${BACKUP_MYSQL_HOST} -P${BACKUP_MYSQL_PORT} -u${BACKUP_MYSQL_USER} -p${BACKUP_MYSQL_PASSWD}  ${BACKUP_MYSQL_DB} < ${backup_file_name}
        #mysql -h${BACKUP_MYSQL_HOST} -P${BACKUP_MYSQL_PORT} -u${BACKUP_MYSQL_USER} -p${BACKUP_MYSQL_PASSWD}  ${BACKUP_MYSQL_DB} < ${data_dir}/AIEP_20181017
        echo "load data ending", `date`

        echo "begin to delete data before 30d"
        echo "delete files:". `find ${data_dir} -mtime +30 -type f`
        find ${data_dir} -mtime +30 -type f | xargs rm -f
        echo "delete data ending", `date`
        echo "#########################################"
    ```



