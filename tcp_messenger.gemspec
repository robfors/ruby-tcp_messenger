Gem::Specification.new do |s|
  s.name        = 'tcp_messenger'
  s.version     = '0.0.0'
  s.date        = '2018-02-25'
  s.summary     = "Send messages over TCP connection."
  s.description = "Simple library to open/accept TCP connections and send/receive messages of strings over the connection."
  s.authors     = ["Rob Fors"]
  s.email       = 'mail@robfors.com'  
  s.files       = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.homepage    = 'https://github.com/robfors/ruby-tcp_messenger'
  s.license     = 'MIT'
  s.add_runtime_dependency 'quack_concurrency', '=0.0.1'
end
