# shell-script

[docker-push](docker-push.sh)

修改脚本里的 site、repo 和 images 变量对应自己的 registry
然后执行

```
./docker-push -e test                                                 // 输出命令但不执行（检查是否错误）
./docker-push -u <自己的registry登陆名> -p <registry登陆密码> -e prod   // 执行
```

## 现成的 dotnet core 镜像

| 地址                                       | tag                  |
| :----------------------------------------- | :------------------- |
| ccr.ccs.tencentyun.com/dotnetimages/sdk    | 3.1, 3.1.102, latest |
| ccr.ccs.tencentyun.com/dotnetimages/aspnet | 3.1, 3.1.2, latest   |
