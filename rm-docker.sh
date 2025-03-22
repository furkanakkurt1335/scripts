echo "Removing all containers..."
containers=$(docker ps -aq)
if [ -z "$containers" ]; then
  echo "No containers to remove."
else
  docker rm -f $containers  # remove all containers
  echo "Removed all containers."
fi

echo "Removing all images..."
images=$(docker images -q)
if [ -z "$images" ]; then
  echo "No images to remove."
else
  docker rmi -f $images  # remove all images
  echo "Removed all images."
fi

echo "Removing all volumes..."
docker volume ls -q | xargs -r docker volume rm  # delete all volumes

echo "Pruning networks..."
docker network prune -f  # prune unused networks
