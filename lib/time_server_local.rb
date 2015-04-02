require 'socket'

port = (ARGV[0] || 5678).to_i
server = TCPServer.new('localhost', port)

loop do
  while (session = server.accept)
    puts "Request: #{session.gets}"
    session.print "HTTP/1.1 200/OK\r\nContent-type: text/html\r\n\r\n"
    session.print "<html><body><h1>#{Time.now}</h1></body></html>\r\n"
    session.close
  end
end

