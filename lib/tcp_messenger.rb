require 'socket'
require 'io/wait'
require 'quack_concurrency'

require 'tcp_messenger/closed_error'
require 'tcp_messenger/connection_error'
require 'tcp_messenger/messenger'
require 'tcp_messenger/server'

module TCPMessenger

  def self.connect(duck_types: {}, host: , max_message_length: Float::INFINITY, port: )
    tcp_socket_class = duck_types[:tcp_socket] || TCPSocket
    socket = tcp_socket_class.new(host, port)
    Messenger.new(socket, duck_types: duck_types, max_message_length: max_message_length)
  end
  
  def self.listen(duck_types: {}, max_message_length: Float::INFINITY, port: )
    tcp_server_class = duck_types[:tcp_server] || TCPServer
    Server.new(tcp_server_class.new(port), duck_types: duck_types, max_message_length: max_message_length)
  end
  
  def self.accept(duck_types: {}, max_message_length: Float::INFINITY, port: )
    tcp_server_class = duck_types[:tcp_server] || TCPServer
    server = Server.new(tcp_server_class.new(port), duck_types: duck_types, max_message_length: max_message_length)
    socket = server.accept
    server.close
    socket
  end
  
end
