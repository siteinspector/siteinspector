curl https://raw.githubusercontent.com/siteinspector/siteinspector/master/docker-compose.yml  | sed "s/SECRET_KEY_BASE:/SECRET_KEY_BASE: `openssl rand -hex 64`/" > docker-compose.yml

if ! [ -x "$(command -v docker-compose)" ]; then
  echo
  echo "Install docker with docker-compose in order to run the app:"
  echo "https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=94798094"
  echo
  exit
fi

if [[ `uname` == 'Linux' ]]; then
  sudo docker-compose up
else
  docker-compose up
fi
