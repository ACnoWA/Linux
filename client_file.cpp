/*************************************************************************
> File Name: client.cpp
> Author: Liyi
> Mail: 294225027@qq.com
> Created Time: 2018年09月23日 星期日 16时22分59秒
************************************************************************/
#include <arpa/inet.h>
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>		
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/file.h>
#include <signal.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
#include <stdarg.h>

#include <stdio.h>
#include<iostream>
using namespace std;
#define MAX_SIZE 1024


int main(int argc, char *argv[]){
    int sock_client;
    char buffer[MAX_SIZE];
    struct sockaddr_in dest_addr;
    int port = atoi(argv[2]);
    char *host = argv[1];
    if ((sock_client = socket(AF_INET, SOCK_STREAM, 0)) < 0){
        perror("Socket");
        return -1;
    }
    //AF_INET表示IPV_4协议族	
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(port);
    dest_addr.sin_addr.s_addr = inet_addr(host);
    if (connect(sock_client, (struct sockaddr *)&dest_addr, sizeof(dest_addr)) < 0){
        perror("Connect");
        return -1;
    }
    FILE *stream;
    if ((stream = fopen("client.cpp","r")) == NULL) {
        perror("file open failed!");
        return -1;
    }

    while(!feof(stream)) {
        fread(buffer, sizeof(char), MAX_SIZE - 1, stream);
        printf("strlen = %d\n",strlen(buffer));
        buffer[strlen(buffer)+1] = '\0';
        send(sock_client, buffer, strlen(buffer), 0);
        memset(buffer, 0, sizeof(buffer));
    }

    fclose(stream);
    close(sock_client);

    return 0;
}
