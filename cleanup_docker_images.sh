#!/bin/bash
touch container_images.txt
docker_images=$(docker images -q)
all_containers=$(docker ps -aq --format "{{.Names}}")
for image in $all_containers;
do
docker inspect --format '{{.Image}}' $image |cut -d":" -f2 |cut -c 1-12 >>container_images.txt;
done

for image in $docker_images; do
  grep $image container_images.txt
  if [[ $? -ne 0 ]]; then
    #echo "image to remove $image"
     docker rmi $image
  fi
done
rm  container_images.txt
