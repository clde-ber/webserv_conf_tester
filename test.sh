#!bin/sh
rm computer.log
rm program.log
rm diff.txt

cd ../../../etc/nginx/; sudo mv nginx.conf nginx_old_conf; sudo -n touch nginx.conf;
cd; cd conf_tester/;

n=1;

while [ $n -le 71 ]
do
    cd ../../../etc/nginx/; sudo -n rm nginx_old; sudo -n mv nginx.conf nginx_old; cd; cd conf_tester/; sudo -n cp nginx$n.conf ../../../etc/nginx/nginx.conf;

    echo -n "test $n : " >> diff.txt;
    sudo -n service nginx restart;
    echo -n "computer $? | " >> diff.txt;
    sleep 2;
    echo "************************************************** test $n **************************************************" >> computer.log
    systemctl status nginx >> computer.log;
    cd; cd conf_tester/;
    echo "************************************************** test $n **************************************************" >> program.log
    clang++ -Wall -Wextra -Werror -g3 -fsanitize=address parsing_main.cpp parsing_conf.cpp && ./a.out nginx$n.conf >> program.log;
    echo "program $?" >> diff.txt;
    sleep 2
    n=$(( n+1 ))	 # increments $n
done