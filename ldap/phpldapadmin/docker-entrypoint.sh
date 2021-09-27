#!/bin/sh

# nginx php7 起動
start() {
  php7 
  nginx
}

start

wait
