#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 获取传入参数
username=""
password=""
env=""
show_usage="args: [-u , -p, -e prod] [--username=, --password=, --env=prod]"
getopt_args=`getopt -o u:p:e: -al username:,password:,env: -- "$@"`
eval set -- "$getopt_args"
while [ -n "$1" ]
do
    case "$1" in
        -u|--username) username=$2; shift 2;;
        -p|--password) password=$2; shift 2;;
        -e|--env) env=$2; shift 2;;
        --) break ;;
        *) echo $1,$2,$3,$show_usage; break ;;
    esac
done
if [[ -z $username || -z $password ]]; then
        echo $show_usage
        echo "username: $username password: $password env: $env"
        exit 0
fi
if [[ -z $env ]]; then
    env="test"
fi
# -e prod 执行命令
exec_command(){
    if [ $env == "prod" ]; then
        eval $1
    else
        echo $1
    fi
}
site=ccr.ccs.tencentyun.com
repo=dotnetimages
declare -A images
images=(
[mcr.microsoft.com/dotnet/core/sdk]="sdk|3.1.102|3.1|latest"
[mcr.microsoft.com/dotnet/core/aspnet]="aspnet|3.1.2|3.1|latest"
)
exec_command "docker login -n=$username -p=$password $site"
for key in $(echo ${!images[*]})
do
    array=(`echo ${images[$key]} | tr '|' ' '` )
    arg_count=${#array[@]}
    if [ $arg_count -lt 2 ]; then
        exec_command "args must be more than 1.(now $arg_count)"
        exec_command "${images[$key]}"
        exit 0
    fi
    image=${array[0]}
    ver=${array[1]}
    exec_command "docker pull $key:$ver"
    exec_command "docker tag $key:$ver $site/$repo/$image:$ver"
    exec_command "docker push $site/$repo/$image:$ver"
    if [ $arg_count -gt 2 ]; then
        for((i=2;i<=$arg_count-1;i++));
        do
            exec_command "docker tag $site/$repo/$image:$ver $site/$repo/$image:${array[$i]}"
            exec_command "docker push $site/$repo/$image:${array[$i]}"
        done
    fi
done