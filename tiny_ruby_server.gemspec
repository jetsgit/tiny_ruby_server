# coding: utf-8

lib = File.expand_path(File.join(*%w[.. lib]), File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/tiny_ruby_server/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                = 'tiny_ruby_server'
  gem.version             = TinyRubyServer::VERSION
  gem.date                = '2015-04-02'
  gem.summary             = "Tiny Ruby Server"
  gem.description         = "A tiny, secure Ruby file server"
  gem.authors             = ["Jerry Thompson"]
  gem.email               = 'jerrold.r.thompson@gmail.com'
  gem.homepage            = 'https://github.com/jetsgit/tiny_ruby_server'
  gem.files               = `git ls-files`.split($/)
  gem.require_paths       = ["lib"]
end
