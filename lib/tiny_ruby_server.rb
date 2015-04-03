require 'socket'
require 'uri'
require 'tiny_ruby_server/version'

module TinyRubyServer

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

  def self.content_type(path)
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

  def self.requested_file(request_line)
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
end

