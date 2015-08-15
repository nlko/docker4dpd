#!/bin/bash 


usage()
{
cat << EOF
usage: $0 [options] app_name

This script starts the ukaribu servers

OPTIONS:
   -h      Show this message
   -m      Start mongo db server
   -d      Start dpd server
   -s      Stop all servers
   -i      Interactive mode
EOF
}

ALL=1
MONGO=0
DPD=0
INTERACTIVE=0

stop()
{
	docker stop $1 2> /dev/null
	docker rm $1 2> /dev/null
}

stop_all()
{
	stop generic_dpd
	stop generic_mongo	
}


while getopts “hmdsi” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         m)
             ALL=0
             MONGO=1
             ;;
         d)
             ALL=0
             DPD=1
             ;;
	 s)
             stop_all
	     exit
	     ;;
         i)
             INTERACTIVE=1
             ;;
         ?)
             usage
             exit 1
             ;;
     esac
#    shift
done

shift $((OPTIND-1))
if [ $# -lt 1 ]; then
if [ $INTERACTIVE -eq 0 ] && { [ $MONGO -eq 0 ]; } then
echo Missing appname or interactive mode
usage
exit 1
fi
fi

PROJECT=$1

if [ $ALL -eq 1 ]
then
	echo Starting all servers
	MONGO=1
	DPD=1
fi


docker build -t generic_mongo docker4mongo&
docker build -t generic_node docker4node
docker build -t generic_dpd docker4dpd
wait

ROOT=$PWD

MONGO_DATA=$ROOT/mongo_data
DPD_DATA=$ROOT/dpd_data

mkdir -p $MONGO_DATA $DPD_DATA

if [ $MONGO -eq 1 ]; then
	stop generic_mongo &>/dev/null
	echo Starting mongo instance
	docker run       --name="generic_mongo" -p 27017:27017  -v $MONGO_DATA:/data/db      -d generic_mongo         mongod --smallfiles
fi

if [ $DPD -eq 1 ]; then
	stop generic_dpd &>/dev/null
        if [ $INTERACTIVE -eq 1 ]; then
            docker run -i -t --name="generic_dpd" -p 3000:3000 -v $DPD_DATA:/usr/src/app --link generic_mongo:generic_mongo -w /usr/src/app generic_dpd bash 
        else
            docker run -d --name="generic_dpd" -p 3000:3000 -v $DPD_DATA:/usr/src/app --link generic_mongo:generic_mongo -w /usr/src/app generic_dpd start_dpd.sh $PROJECT generic_mongo 27017 3000 
            if [ $? -eq 0 ]; then
                echo Deployd started. Application should be up and running on localhost:3000
            fi
        fi
fi

