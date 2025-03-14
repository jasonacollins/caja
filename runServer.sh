set -x
docker stop ${SERVER_CONTAINER} || true
docker rm ${SERVER_CONTAINER} || true
docker run -d -it --platform=linux/arm64 --name ${SERVER_CONTAINER} -p 5001:5000 ${SERVER_IMAGE}
docker exec -it ${SERVER_CONTAINER} rm -rf /app
docker exec -it ${SERVER_CONTAINER} mkdir /app
docker cp ./. ${SERVER_CONTAINER}:/app
docker exec -it --env FLASK_ENV=${FLASK_ENV} --env SERVER=$SERVER --env DATABASE=$DATABASE --env USER=$USER --env PASSWORD=$PASSWORD ${SERVER_CONTAINER} bash -c "cd /app && python3 backend/app.py"