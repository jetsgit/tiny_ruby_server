### Demo of Simple Ruby Web Werver to View Files 

#### Usage:

* Run with ruby, `ruby ./test/file_server.rb`
* Navigate to a file, e.g.  http://5678:SeaSerpent.jpg

#### Features

* Will only serve files in `public` directory
* Incorporates security features implemented in `Rack::File` to ensure only authorized files are accessed.
* Uses `IO.copy_stream(file, socket)`
* Will continue to serve files until killed.
