# 需要全量备份的表
full_tables=(
	#t1
)
# 只需要备份近期数据的表
where_tables=(
    #'table field'
)
# 源数据库配置
src_h=*
src_p=*
src_db=*
src_u=*
src_pwd=*

# 新数据库配置
des_h=*
des_p=*
des_db=*
des_u=*
des_pwd=*
# 最早时间
date=2020-07-08

clean() {
    echo 'rm outdated files in ./sql'
    mkdir -p sql
    rm sql/*.sql || true
}

dump_full() {
    # 全量备份
    for table in ${full_tables[@]}; do
        echo "dumping full $table..."
        MYSQL_PWD=$src_pwd mysqldump --insert-ignore --set-gtid-purged=OFF --port=$src_p --host=$src_h --user=$src_u $src_db $table > sql/$table.sql
    done
}

dump_where() {
    # 根据日期进行部分备份
    n_tables=${#where_tables[*]}
    for ((i=0;i<$n_tables;i++)); do
        table_and_column=(${where_tables[$i]})
        table=${table_and_column[0]}
        column=${table_and_column[1]}
        echo "dumping $table filter by $column>$date.."
        MYSQL_PWD=$src_pwd mysqldump --insert-ignore --single-transaction --set-gtid-purged=OFF --port=$src_p --host=$src_h --user=$src_u --where="id>(SELECT id FROM $table WHERE $column>'$date' LIMIT 1)" $src_db $table > sql/$table.sql
    done
}

dump() {
    dump_full
    dump_where
}

restore() {
    # 在新数据库中执行备份的 sql
    for i in sql/*.sql; do
        echo "restoring $i..."
        MYSQL_PWD=$des_pwd mysql --port=$des_p --host=$des_h --user=$des_u sentiment < $i
    done
}

clean
dump
restore
