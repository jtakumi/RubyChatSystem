#!/usr/bin/env ruby
require "socket"
include Socket::Constants
INADDR_ANY=0x00000000
if ARGV.size == 0
   puts "usage: ./chat.rb <port> ::server
         ./chat.rb <port> <server-ip> ::client"
   exit
elsif ARGV.size == 1
   S = 1 # server-flag
   host = INADDR_ANY
else
   S = 0 # client
   host = ARGV[1]
end
port = ARGV[0].to_i
bufsize = 1024
sock = Socket.open(PF_INET, SOCK_STREAM, IPPROTO_TCP)
addr = Socket.pack_sockaddr_in(port, host)
sock.setsockopt(Socket::SOL_SOCKET,
                Socket::SO_REUSEADDR, true)
if S == 1 
    puts "*** server ***"
       sock.bind(addr)
       sock.listen(5)
    end
    if S == 0 
    puts "*** client ***"
       sock.connect(addr)
       c_sock = sock 
    end
    loop{
       if S == 1 
    c_sock, c_addr = sock.accept
          prt, adr = Socket.unpack_sockaddr_in(c_addr)
          printf "connect from %s:%d\n",adr,prt
          buff = c_sock.recv(bufsize,0) 
    printf "recv: %s\n",buff
       end
       loop{ 
    print "in> "
          mesg = STDIN.gets.chomp
          c_sock.send(mesg, 0) 
    c_sock.flush
          printf "sent: %s\n",mesg
          break if mesg =~ /^quit/
          buff = c_sock.recv(bufsize, 0) 
    printf "recv: %s\n",buff
          break if buff =~ /^quit/
       }
       c_sock.close unless sock.closed?
       puts "close connection"
       break if S == 0 
    }