echo "正在更新启动脚本(master)"

sudo git pull origin master

echo "正在启动"

sudo chmod +x ./start-server

./start-server
