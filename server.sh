#!/bin/bash

mix_env='dev'
port=4000
case $# in
  0)
    ;;
  1)
    mix_env=$0
    ;;
  2)
    mix_env=$0
    port=$1
    ;;
  *)
    echo '参数个数不正确'
    ;;
esac

MIX_ENV=$mix_env PORT=$port elixir --detached -S mix do compile, phoenix.server
