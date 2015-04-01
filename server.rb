require 'socket'

server = TCPServer.new('localhost', 5678)

# infinite loop to process one incoming connection at a time

loop do
  # wait for client to connect, then reurn a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects.
  socket = server.accept

  # read the first line of request (Request Line)
  request = socket.gets

  # Log request to console for debugging
  STDERR.puts request

  response = "Welcome to jetWhidbey World.\n"

  # Include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that  HTTP is whitespacce sensitive
  # and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the respnse body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body, which is just "Welcome to jetWhidbey World.\n" 
  socket.print response
end
