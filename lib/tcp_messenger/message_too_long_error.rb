module TCPMessenger
  class MessageTooLongError < StandardError
  
    def initialize(message = "Message too long.")
      super
    end
    
  end
end
