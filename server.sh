source $envFile

case $1 in
Y | y)
    echo "Started a Server with a Judge."
    sudo docker pull 998244353/portable-judge
    sudo docker rm -f portable-deploy_judge_1
    ;;
N | n | *)
    echo "Started a Server without a Judge."
    ;;
esac

sudo docker-compose down
sudo docker-compose up -d

sudo docker image ls | grep portable | grep none | awk '{print $3}' | xargs sudo docker rmi

for i in {1..10}
do
    sleep 6
    curl localhost:8080 &> /dev/null
    if [ $? == 0 ]
    then
        # 先获取一次 serverCode，使得服务器的 serverCode 被提前获取，用来关闭此 API
        code=`curl localhost:8080/api/judge/initCode`
        break
    else
        if [ ${i} == 10 ]
        then
            echo "please check the server!!!"
            exit 1
        fi
    fi
done

echo "serverCode: $code"

url=`ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:" | sed -n '1p'`

wd=`pwd`

case $1 in
Y | y)
    echo "Started a Server, now start a Judge."
    ;;
N | n | *)
    echo "Started a Server without Judge."
    exit 0
    ;;
esac

sudo docker run -itd --name portable-deploy_judge_1 -e home=/portable_data -e serverUrl=${url} -e heartbeatTime=${HEART_BEAT_TIME} -e serverCode=$code -v ${wd}/data:/portable_data --log-opt max-size=10m --log-opt max-file=5 998244353/portable-judge

sudo docker image ls | grep portable | grep none | awk '{print $3}' | xargs sudo docker rmi
