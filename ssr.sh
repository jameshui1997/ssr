#卸载已安装的Docker相关组件
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

#添加Docker的官方GPG密钥
apt-get update
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

#将存储库添加到apt源
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update

#安装Docker相关组件
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 拉取Docker镜像同时运行ssr
docker run hello-world
docker run -d --name=ssr --network=host --restart=always jameshui/ssr:1 tail -f /dev/null
docker exec -it ssr /bin/bash -c "echo 10 | ./root/ssr.sh"

#防火墙打开10250端口
ufw allow 10250
ufw reload
ufw status
