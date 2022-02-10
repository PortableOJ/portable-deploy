echo "正在更新所需要的镜像文件"

sudo docker pull 998244353/portable-judge
sudo docker-compose pull

echo "正在启动 server 和 web 服务"
sudo docker-compose up -d
read -n1 -p "是否需要在本地启动 judge [y/n]?" answer
case $answer in
Y | y)
    echo "\n正在准备启动 judge";;
N | n)
    echo "\n完成！"
    exit 0;;
*)
    echo "\n错误的答复"
    exit 0;;
esac

read -p "请输入 server 提供的服务器密钥：" code

url=`ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:" | sed -n '1p'`
wd=`pwd`

sudo docker run -itd --name portable-deploy_judge_1 -e home=/portable -e serverUrl=${url} -e heartbeatTime=5 -e serverCode=${code} -v ${wd}/data:/portable --log-opt max-size=10m --log-opt max-file=5 998244353/portable-judge

echo "启动完成"
