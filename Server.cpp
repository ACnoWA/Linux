/*************************************************************************
> File Name: Server.cpp
> Author: Liyi
> Mail: 294225027@qq.com
> Created Time: 2018年09月25日 星期二 18时59分03秒
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


int main(int argc, char *argv[]){
    int sockfd, pid;
    int bindres;
    int listeners, port = atoi(argv[1]);
    int a = 0;
    if (argc != 2) {
        printf("Usage: ./tcp_server port\n");
        exit(0);
    }

    if (( sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
        perror("Socket");
        return -1;
    }
    struct sockaddr_in server;    
    memset( &server, 0, sizeof( struct sockaddr_in ) );
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    //INADDR_ANY转换过来就是0.0.0.0，泛指本机的意思，也就是表示本机的所有IP，因为有些机子不止一块网卡，多网卡的情况下，这个就表示所有网卡ip地址的意思。 比如一台电脑有3块网卡，分别连接三个网络，那么这台电脑就有3个ip地址了，如果某个应用程序需要监听某个端口，那他要监听哪个网卡地址的端口呢？ 如果绑定某个具体的ip地址，你只能监听你所设置的ip地址所在的网卡的端口，其它两块网卡无法监听端口，如果我需要三个网卡都监听，那就需要绑定3个ip，也就等于需要管理3个套接字进行数据交换，这样岂不是很繁琐？ 所以出现INADDR_ANY，你只需绑定INADDR_ANY，管理一个套接字就行，不管数据是从哪个网卡过来的，只要是绑定的端口号过来的数据，都可以接收到
    server.sin_addr.s_addr = htonl( INADDR_ANY );

    bindres = bind( sockfd, (struct sockaddr*)&server, sizeof( server ) );
    if( -1 == bindres ) {
        close(sockfd);
        perror( "sock bind" );
        exit( -1 );
    }

    listeners = listen( sockfd, 20 );
    if(-1 == listeners){
        close(sockfd);
        perror("sock listen");
        exit( -1 );
    }


    char recvBuf[1024];    
    while( 1 ) {
        struct sockaddr_in peerServer;
        int acceptfd = -1;
        socklen_t len = sizeof( peerServer );
        //当accept成功时，peerServer将被对端的ip地址填充
        acceptfd = accept( sockfd, (struct sockaddr*)&peerServer, &len );
        if ( -1 == acceptfd ) {
            break;
        }
        //创建一个子进程，由子进程来处理这个连接
        if ((pid = fork()) < 0)
            printf("Error forking child process");
        //通过判段pid是否为0来判断是子进程还是父进程，fork之后父进程的pid是子进程的pid，子进程的pid为0
        if (pid == 0) {
            char buffer[1024];
            while ((a = recv(acceptfd, buffer, 1024, 0)) > 0 ) {
                printf("%s:%d:recv %d 字节　%s\n",inet_ntoa(peerServer.sin_addr),ntohs(peerServer.sin_port),a,buffer);
                fflush(stdout);
                memset(buffer, 0, sizeof(buffer));
            }
            close(sockfd);
            exit(0);
        }
        close(sockfd);
    }

  return 0;
}
