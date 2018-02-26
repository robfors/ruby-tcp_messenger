module TCPMessenger
  class Messenger
  
    def initialize(socket, duck_types: , max_message_length: )
      @socket = socket
      @max_message_length = max_message_length
      @close_mutex = QuackConcurrency::ReentrantMutex.new(duck_types: duck_types)
      @send_mutex = Mutex.new
      @receive_mutex = Mutex.new
      @closed = false
    end
    
    def close
      @close_mutex.synchronize do
        raise ClosedError if closed?
        begin
          @socket.close
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
    
    def send(message)
      @send_mutex.synchronize do
        raise ClosedError if closed?
        raise "'message' must be a string." unless message.respond_to?(:to_s)
        message = message.to_s
        encoded_message = message.gsub("\n", '\n')
        raise MessageTooLong if encoded_message.length > @max_message_length
        begin
          @socket.puts(encoded_message)
        rescue
          @close_mutex.synchronize do
            raise ClosedError if closed?
            close
            raise ConnectionError
          end
        end
      end
      nil
    end
    
    def receive
      @receive_mutex.synchronize do
        encoded_message = ''
        loop do
          char = receive_byte
          break if char == "\n"
          binding.pry if char == nil
          encoded_message << char
          if encoded_message.length > @max_message_length
            @close_mutex.synchronize { close unless closed? }
            loop do
              char = receive_byte
              break if char == "\n"
            end
            raise MessageTooLong
          end
        end
        message = encoded_message.gsub('\n', "\n")
        return message
      end
    end
    
    private
    
    def receive_byte
      begin
        char = @socket.getc
        raise if char == nil
      rescue
        @close_mutex.synchronize do
          raise ClosedError if closed?
          close
          raise ConnectionError
        end
      end
      char
    end
    
  end
end
