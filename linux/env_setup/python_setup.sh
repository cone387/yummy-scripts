#!/bin/bash

# stop at when any error
set -e

echo "|------------------------------------Python Setup Shell------------------------------------------|"


INSTALL_PATH="/usr/local/python37"
PYTHON_VERSION='3.7.9'

### !!! 注意 shell中声明变量不能有空格！！！！！

# 不能写在函数里面，函数里会导致getopts获取到得参数不一样
while getopts v:p: opt
  do
    case $opt in
      v)
        PYTHON_VERSION=$OPTARG ;;
      p)
        INSTALL_PATH=$OPTARG ;;
      ?)
        echo "unknown params"
        exit 1;;
    esac
  done


PYTHON_BIN="python${PYTHON_VERSION%.*}"
PIP_BIN="pip${PYTHON_VERSION%.*}"


echo -e "\033[31m |------------------------------INSTALL_PATH: $INSTALL_PATH------------------------------| \033[0m"
echo -e  "\033[31m |------------------------------PYTHON_VERSION: $PYTHON_VERSION---------------------------| \033[0m"
echo -e "\033[31m |------------------------------PYTHON_BIN: $PYTHON_BIN-----------------------------------| \033[0m"
echo -e "\033[31m |------------------------------PIP_BIN: $PIP_BIN-----------------------------------------| \033[0m"


function install_python() {
  if [ "$($PYTHON_BIN -V 2>&1)" = "Python $PYTHON_VERSION" ];then
    echo "python$PYTHON_VERSION already exists"
  else
    echo "python$PYTHON_VERSION does't exists, start install python$PYTHON_VERSION"
    cd /tmp/
    wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
    tar -xvf Python-3.7.9.tar.xz

    echo "create dir: $INSTALL_PATH"
    mkdir -p $INSTALL_PATH

    cd Python-$PYTHON_VERSION

    # 不然或缺少_ctype
    sudo apt-get update
    sudo apt-get -y upgrade --fix-missing
    sudo apt-get install libffi-dev

    sudo ./configure prefix=$INSTALL_PATH

    sudo make && make install

    sudo sudo rm -f /usr/bin/$PYTHON_BIN
    rm -f /usr/bin/$PIP_BIN

    sudo ln -s $INSTALL_PATH/bin/$PYTHON_BIN /usr/bin/$PYTHON_BIN
    sudo ln -s $INSTALL_PATH/bin/$PIP_BIN /usr/bin/$PIP_BIN

    echo "python$PYTHON_VERSION to $INSTALL_PATH install success"

  fi

}

# 设置pip源
function set_pip_index_url() {
  index_url=$1;
  if [ ! $index_url ];then
    index_url="https://pypi.tuna.tsinghua.edu.cn/simple";
  fi
  echo "set pip index url to $index_url"
  sudo $PIP_BIN config set global.index-url $index_url
}

install_python