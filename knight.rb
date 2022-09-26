require_relative 'types.rb'

# only -e sort of works
if __FILE__ == $0
  case $*.first
  when '-e'
    $*.last.dup.parse!.call
  when '-f'
    File.read($*.last)
  else
    abort "usage: knight.rb (-e 'source code' | -f filename)"
  end if $*.size == 2
end
