echo Removing all containers...
containers=$(docker ps -aq)
if [ -z "$containers" ]; then
  echo No containers to remove.
else
  docker rm -f $(docker ps -aq) # remove all containers
  echo Removed all containers.
fi

echo Removing all images...
images=$(docker images -q)
if [ -z "$images" ]; then
  echo No images to remove.
else
  docker rmi -f $(docker images -q) # remove all images
  echo Removed all images.
fi
docker volume ls -q | xargs docker volume rm # delete all volumes
docker network prune -f # prune networks
