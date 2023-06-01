# grab the image from docker hub
FROM mileschou/lapis:alpine

# RUN luarocks install underscore.lua --from=http://marcusirven.s3.amazonaws.com/rocks/

# make a project folder
RUN mkdir /code
WORKDIR /code
# copy the source files
COPY . .
