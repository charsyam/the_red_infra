# the_red_infra
the red infra

# setup

if amazon linux or redhat 
```
	sudo yum install gcc zlib-devel bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl openssl-devel libffi-devel -y
```

if ubuntu 20.04
```
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
```

```
	git clone git@github.com:charsyam/the_red_infra
	./install_pyenv.sh
	source ~/.bashrc
	./install_python.sh
    install_ansible_password.sh    
	install_terraform.sh	
```

build aws 
```
    cd terraform/ec2/ap-northeast-2
    terraform init
    terraform plan -out "output"
    terraform apply "output"
```

apply ansible: geoip
```
    ansible-playbook -i aws the_red_1_base.yml
    ansible-playbook -i aws the_red_2_geoip.yml
    ansible-playbook -i aws the_red_2_lb.yml
```

apply ansible: monitor(prometheus + grafana)
```
    ansible-playbook -i aws the_red_1_base.yml
    ansible-playbook -i aws the_red_2_monitor.yml
```

apply ansible: ngrinder
```
    ansible-playbook -i aws the_red_1_jvm.yml
    ansible-playbook -i aws the_red_2_ngrinder.yml
```
