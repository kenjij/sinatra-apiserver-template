# apiserver

```markdown
[![Gem Version](https://badge.fury.io/rb/apiserver.svg)](http://badge.fury.io/rb/apiserver) [![Code Climate](https://codeclimate.com/github/kenjij/apiserver/badges/gpa.svg)](https://codeclimate.com/github/kenjij/apiserver) [![security](https://hakiri.io/github/kenjij/apiserver/master.svg)](https://hakiri.io/github/kenjij/apiserver/master)
```

A Ruby server for providing API service.

## Requirements

- [Ruby](https://www.ruby-lang.org/) 2.1 <=
- [Kajiki](https://kenjij.github.io/kajiki/) 1.1 <=
- [Sinatra](http://www.sinatrarb.com) 1.4 <=

## Getting Started

### Install

```
$ gem install apiserver
```

### Configure

Create a configuration file following the example below.

```ruby
# Configure application logging
APIServer.logger = Logger.new(STDOUT)
APIServer.logger.level = Logger::DEBUG

APIServer::Config.setup do |c|
  # User custom data
  c.user = {my_data1: 'Something', my_data2: 'Somethingelse'}
  # Optional: if any number of strings are set, it will require a matching "?auth=" parameter in the incoming request
  c.auth_tokens = [
    'someSTRING1234',
    'OTHERstring987'
  ]
  # HTTP server (Sinatra) settings
  c.dump_errors = true
  c.logging = true
end
```

### Use

To see help:

```
$ apiserver -h
Usage: apiserver [options] {start|stop}
  -c, --config=<s>     Load config from file
  -d, --daemonize      Run in the background
  -l, --log=<s>        Log output to file
  -P, --pid=<s>        Store PID to file
  -p, --port=<i>       Use port (default: 4567)
```

The minimum to start a server:

```
$ apiserver -c config.rb start
```
