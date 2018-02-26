module TCPMessenger
  class Server
  
    def initialize(tcp_server, duck_types: , max_message_length: )
      @tcp_server = tcp_server
      @duck_types = duck_types
      @max_message_length = max_message_length
      @close_mutex = QuackConcurrency::ReentrantMutex.new(duck_types: duck_types)
      @accept_mutex = Mutex.new
      @closed = false
    end
    
    def accept
      @accept_mutex.synchronize do
        raise ClosedError if closed?
        begin
          socket = @tcp_server.accept
        rescue
          @close_mutex.synchronize do
            raise ClosedError if closed?
            close
            raise ConnectionError
          end
        end
        return Messenger.new(socket, duck_types: @duck_types, max_message_length: @max_message_length)
      end
    end
    
    def close
      @close_mutex.synchronize do
        raise ClosedError if closed?
        begin
          @tcp_server.close
        rescue
          raise ConnectionError
        ensure
          @closed = true
        end
      end
      nil
    end
    
    def closed?
      @closed
    end
    
  end
end
