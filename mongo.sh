src_h=*
src_p=*
src_u=*
src_pwd=*

des_h=*
des_p=*
des_u=*
des_pwd=*

collections=(
	#c1
)

clean() {
    echo "rm outdated mongodb bson..."
    mkdir -p mongobk
    rm -rf mongobk/* || true
}

dump() {
    for c in ${collections[@]}; do
        mongodump --host $src_h --port $src_p -u$src_u -p$src_pwd --authenticationDatabase admin --db=$c --out ./mongobk/$c 
    done
}

restore() {
    for c in ${collections[@]}; do
        mongorestore --host $des_h --port $des_p -u$des_u -p$des_pwd --authenticationDatabase admin ./mongobk/$c 
    done
}

clean
dump
restore
