#!/bin/bash

URL=”http://127.0.0.1/”
curlit()
{
curl –connect-timeout 15 –max-time 20 –head –silent “$URL” | grep ’200′
# 上面的15是连接超时时间，若访问localhost的HTTP服务超过15s仍然没有正确响应200头代码，则判断为无法访问。
}
doit()
{
if ! curlit; then
# 如果localhost的apache服务没有正常返回200头，即出现异常。执行下述命令：
sleep 20
top -n 1 -b >> /var/log/apachemonitor.log
# 上面将top命令内容写入日至文件备查
/usr/bin/killall -9 apache2 && /usr/bin/killall -9 php5-cgi && /usr/bin/killall -9 httpd && /usr/bin/killall -9 http && /usr/bin/killall -9 apache && /usr/bin/killall -9 php-cgi > /dev/null
# 兼容起见，杀死了各种apache的进程。可以根据自己apache服务的特点修改
sleep 2
/etc/init.d/apache2 start > /dev/null
/etc/init.d/httpd start > /dev/null
# 兼容起见，执行了两种apache重启命令，可根据需要自己修改。
echo $(date) “Apache Restart” >> /var/log/apachemonitor.log
# 写入日志
sleep 30
# 重启完成后等待三十秒，然后再次尝试一次
if ! curlit; then
# 如果仍然无法访问，则：
echo $(date) “Failed! Now Reboot Computer!” >> /var/log/apachemonitor.log
# 写入apache依然重启失效的日志
reboot
# 重启机器呗。实际上重启整个服务器是一种非常不得已的做法。本人并不建议。大家根据需要自己修改，比如短信、邮件报警什么的。
fi
sleep 180
fi
}
sleep 300
# 运行脚本后5分钟后才开始正式工作（防止重启服务器后由于apache还没开始启动造成误判）
while true; do
# 主循环体
doit > /dev/null
sleep 10
done
