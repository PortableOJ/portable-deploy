echo "正在更新所需要的镜像文件"

sudo docker pull 998244353/portable-server
sudo docker pull 998244353/portable-judge
sudo docker pull 998244353/portable-web

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

sudo docker run -itd --name portable_judge -e home="/root/portable" -e serverUrl="localhost" -e log="/root/portable/judge.log" -e heartbeatTime=5 -e serverCode=$code -v ./data:/root 998244353/portable-judge

echo "启动完成"
