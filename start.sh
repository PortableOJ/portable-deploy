echo "正在更新启动脚本(master)"

sudo git pull origin master

echo "正在为需要使用的脚本赋予权限"

sudo chmod +x ./wait-for

echo "正在关闭之前的 Judge 服务"

sudo docker rm -f portable-oj_judge_1

echo "正在更新所需要的镜像文件"

sudo docker pull 998244353/portable-judge
sudo docker-compose pull

echo "正在启动 server 和 web 服务"
sudo docker-compose up -d

echo "等待服务就绪"

# 由于启动需要一定时间，所以这段时间内对镜像进行清理
echo "开始清理过期镜像"

sudo docker image ls | grep portable | grep none | awk '{print $3}' | xargs sudo docker rmi

./wait-for localhost:8080 -- echo "服务已经就绪"

code=`curl localhost:8080/api/judge/initCode`

read -n1 -p "是否需要在本地启动 judge [y/n]?" answer
echo ""
case $answer in
Y | y)
    echo "正在准备启动 judge";;
N | n)
    echo "完成！"
    exit 0;;
*)
    echo "错误的答复"
    exit 0;;
esac

url=`ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:" | sed -n '1p'`

wd=`pwd`

sudo docker run -itd --name portable-deploy_judge_1 -e home=/portable_data -e serverUrl=${url} -e heartbeatTime=5 -e serverCode=${code} -v ${wd}/data:/portable_data --log-opt max-size=10m --log-opt max-file=5 998244353/portable-judge

echo "启动完成"
