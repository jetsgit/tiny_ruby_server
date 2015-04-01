require 'socket'
require 'uri'
require 'pry'

# File will be served from below directory
WEB_ROOT = './public'

# Map extensions to their content type
CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt' => 'text/plain', 
  'png' => 'image/png',
  'jpg' => 'image/jpeg',
  'gif' => 'image/gif'
}

# Treat as binary data if content type can not be found
DEFAULT_CONTENT_TYPE = 'application/octet-stream'

# Helper function to parse extension of requested file,
# then looks up its content type:

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

# Helper function to parse the Request-Line and
# generate a pathe to a file on the server.

# The below is lifted from Rack::File
# The reason for this is that it is extremely easy to introduce a 
# security vulnerablility where any file in file system can be accessed.
# In fact, the below was added in 2013 specifically to deal with such a 
# security vulnerablility

def requested_file(request_line)
  request_uri  = request_line.split(" ")[1]
  path         = URI.unescape(URI(request_uri).path)

  clean = []

  # Split the path into components
  parts = path.split("/")

  parts.each do |part|
    # skip any empty or current directory (".") path components
    next if part.empty? || part == '.'
    # If the path component goes up one directory level (".."),
    # remove the last clean component.
    # Otherwise, add the component to the Array of clean components
    part == '..' ? clean.pop : clean << part
  end
  # return the web root joined to the clean path
  path = File.join(WEB_ROOT, *clean)
  
end

 
server = TCPServer.new('localhost', 5678)

loop do
  socket = server.accept
  request_line = socket.gets
  STDERR.puts request_line

  if request_line
    path = requested_file(request_line)

    path = File.join(path, 'index.html') if File.directory?(path)

    # Make sure file exists and is not a directory
    # before attempting to open it
    if File.exist?(path) && !File.directory?(path)
      File.open(path, "rb") do |file|
        socket.print "HTTP/1.1 200 OK\r\n" +
                 "Content-Type: #{content_type(file)}\r\n" +
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
