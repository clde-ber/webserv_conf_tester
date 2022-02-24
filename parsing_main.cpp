#include "parsing_conf.hpp"

int main(int ac, char **av)
{
    if (ac != 2){
        std::cout << "ERROR, conf file missing" << std::endl;
    }
    return start_conf(av[1]);
}