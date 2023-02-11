FROM node:14.21.1-alpine

WORKDIR ${DOCKER_PATH}

RUN apk update && apk upgrade
RUN apk add git
RUN apk add curl

COPY ./package*.json ${DOCKER_PATH}/

RUN npm install && npm cache clean --force

ENV PATH ./node_modules/.bin/:$PATH

COPY . .

EXPOSE ${PORT_APP}

CMD [ "node", ${INDEX_PATH} ]
