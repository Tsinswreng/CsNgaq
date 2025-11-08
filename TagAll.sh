#!/usr/bin/env bash
set -e
Tag=$1
[[ -z $Tag ]] && { echo "用法: $0 <tag>"; exit 1; }



sh ./TagLibs.sh $Tag
sh ./TagEtPushRepo.sh  Ngaq.Core  $Tag
sh ./TagEtPushRepo.sh  Ngaq.Local  $Tag
sh ./TagEtPushRepo.sh  Ngaq.Frontend  $Tag
sh ./TagEtPushRepo.sh  Ngaq.Server  $Tag
sh ./TagEtPushRepo.sh  Ngaq.Test  $Tag



# 主项目打 tag
git tag -a "$Tag" -m "$Tag"
#git push origin "$Tag"
