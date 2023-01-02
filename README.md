# the_red_infra
the red infra

# 흔히 하는 질문
* EC2 VPC Not Found 에러가 발생합니다.
  * 다음과 같은 경우에 발생합니다.
    * VPC가 기본적으로 AWS에서 생성하는 VPC가 아니라 임의로 생성한 경우
    * 이때는 VPC id 를 명시적으로 입력해주면 동작합니다.  
    * 주석 "#"으로 처리된 부분으로 변경해보시길 바랍니다.

# Q/A
* Issue 에 질문을 생성해주세요.

# setup

* 기본적인 테스트는 ubuntu 20.04 에서 진행되었습니다.(18.04 도 동작합니다.)
* apt 를 제대로 사용하기 위해서 apt update 를 진행합니다.

```
sudo apt update
```

* python 설치에 필요한 패키지를 설치합니다. 버전에 따라 아래 두 가지 중 선택해주세요. 
* ubuntu 20.04 (18.04) 

```
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
```

* ubuntu 22.04

```
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl
```

* the_red_infra를 git clone 받고 ./install_pyenv.sh를 실행합니다. bash를 쓰시면 source ~/.bashrc, zsh를 쓰시면 source ~/.zshrc

```
	git clone https://github.com/charsyam/the_red_infra
	./install_pyenv.sh
	source ~/.bashrc
	./install_python.sh
    install_ansible_password.sh    
	install_terraform.sh	
```

* terraform 실행
```
    cd terraform/ec2/ap-northeast-2
    terraform init
    terraform plan -out "output"
    terraform apply "output"
```

* 다음은 ansible 의 실행 방법입니다. 작성전에 aws/hosts 파일에 대상 호스트 설정이 되어 있어야 합니다.

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

# Ansile Reference
* Ansibel 기초 자료는 다음을 참고하세요.
 * [https://docs.google.com/presentation/d/1I40dnYLKSM3MqlI54iWHH-CegdQWSmgDl_8m8iQFi9Q/edit?usp=sharing]
