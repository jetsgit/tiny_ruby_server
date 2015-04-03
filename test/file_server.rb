require 'pry'
require 'tiny_ruby_server'

server = TCPServer.new('localhost', 5678)
  loop do
    socket = server.accept
    request_line = socket.gets
    STDERR.puts request_line

    if request_line
      path = TinyRubyServer.requested_file(request_line)

      path = File.join(path, 'index.html') if File.directory?(path)

      # Make sure file exists and is not a directory
      # before attempting to open it
      if File.exist?(path) && !File.directory?(path)
        File.open(path, "rb") do |file|
          socket.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: #{TinyRubyServer.content_type(file)}\r\n" +
                   "Content-Length: #{file.size}\r\n" +
                   "Connection: close\r\n"

          socket.print "\r\n"

          # Write the contents of the file to the socket
          IO.copy_stream(file, socket)
        end

      else
        msg = "File not found\n"

        # respond with a 404 error code to indicate the file does not exist
        socket.print "HTTP/1.1 404 Not Found\r\n" +
                     "Content-Type: text/plain\r\n" +
                     "Content-Length: #{msg.size}\r\n" +
                     "Connection: close\r\n"

        socket.print "\r\n"
        socket.print msg
      end
      
      socket.close
    end
end

