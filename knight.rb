require_relative 'types.rb'
require_relative 'functions.rb'

case $*.first
when '-e'
  $*.last
when '-f'
  File.read($*.last)
else
  abort 'usage: knight.rb (-e 'source code' | -f filename)'
end if $*.size == 2
