#!bin/sh
rm computer.log
rm program.log
rm details.txt

n=60;

while [ $n -le 71 ]
do
    cd ../../../etc/nginx; sudo rm nginx_old; sudo mv nginx.conf nginx_old; cd; cd conf_tester/; sudo -n cp nginx$n.conf ../../../etc/nginx/nginx.conf;

    echo -n "test $n : " >> computer.log;
    sudo -n service nginx restart;
    echo "error $?" >> computer.log;
    sleep 2;
    echo "************************************************** test $n **************************************************" >> details.txt
    systemctl status nginx >> details.txt;
    cd; cd conf_tester/;
    echo -n "test $n : " >> program.log;
    clang++ -Wall -Wextra -Werror -g3 -fsanitize=address parsing_main.cpp parsing_conf.cpp && ./a.out nginx$n.conf;
    echo "error $?" >> program.log;
    sleep 2
    n=$(( n+1 ))	 # increments $n
done