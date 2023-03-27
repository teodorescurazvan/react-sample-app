# pull a node base image (alpine 13.12.0)
FROM node:19.8.1-alpine3.17

# set workdir
WORKDIR ../react-sample-app

# add '/react-sample-app/node_modules/.bin' to $PATH
ENV PATH ../react-sample-app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# add react-sample-app
COPY . ./

# start app
CMD ["npm", "start"]