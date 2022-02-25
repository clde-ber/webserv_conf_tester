#!bin/sh
rm computer.log
rm program.log
rm diff.txt
rm output.txt

cd ../../../etc/nginx/; sudo mv nginx.conf nginx_old_conf; sudo -n touch nginx.conf;
cd; cd web_tester/;

n=1;
p=0;
c=0;

while [ $n -le 71 ]
do
    cd ../../../etc/nginx/; sudo -n rm nginx_old; sudo -n mv nginx.conf nginx_old; cd; cd web_tester/; sudo -n cp nginx$n.conf ../../../etc/nginx/nginx.conf;

    echo -n "test $n : " >> output.txt;
    sudo -n service nginx restart;
    c=$?;
    echo -n "computer $c | " >> output.txt;
    sleep 2;
    echo "************************************************** test $n **************************************************" >> computer.log;
    systemctl status nginx >> computer.log;
    cd; cd web_tester/;
    echo "************************************************** test $n **************************************************" >> program.log;
    clang++ -Wall -Wextra -Werror -g3 -fsanitize=address parsing_main.cpp parsing_conf.cpp && ./a.out nginx$n.conf >> program.log;
    p=$?;
    echo "program $p" >> output.txt;
    sleep 2;
    if [ $c -ne $p ]
    then
        echo "test $n : c $c | p $p" >> diff.txt;
    fi
    n=$(( n+1 ));	 # increments $n
done