# frozen_string_literal: true

require_relative 'functions.rb'

class Object
  alias call itself
  def to_i        = call.to_i
  def to_s        = call.to_s
  def to_a        = call.to_a
  def coerce(rhs) = [rhs, to_i]
end

class NilClass
  def truthy? = false
  def inspect = 'null'
  freeze
end

class TrueClass
  alias truthy? itself
  def to_i    = 1
  def to_a    = [true]
  def <(rhs)  = false
  def >(rhs)  = !rhs.truthy?
  freeze
end

class FalseClass
  alias truthy? itself
  def to_i    = 0
  def to_a    = []
  def <(rhs)  = rhs.truthy?
  def >(rhs)  = false
  freeze
end

class Integer
  def to_a    = positive? ? digits.reverse : abs.digits.reverse.map(&:-@)
  def truthy? = self != 0
  freeze
end

class String
  alias to_a chars
  alias old_to_i to_i
  def to_i    = sub(/d/i, '@').old_to_i
  def truthy? = !empty?
  prepend Module.new {
    def +(rhs)  = super(rhs.to_s)
    def *(rhs)  = super(rhs.to_i)
    def <(rhs)  = super(rhs.to_s)
    def >(rhs)  = super(rhs.to_s)
    def ==(rhs) = rhs.is_a?(String) && super(rhs)
  }
  def set(b, l, s)
    ns = dup
    ns[b, l] = s.to_s
    ns
  end

  def parse!
    case
    when slice!(/\A([():\s]+|#.*\n)/) then return replace($').parse!
    when slice!(/\A\d+/) then $&.to_i
    when slice!(/\A[a-z_][a-z_\d]*/) then Identifier.new($&)
    when slice!(/\A(?:'([^']*?)'|"([^"]*?)")/) then $+
    when slice!(/\A([TF])[A-Z_]*/) then $1 == 'T'
    when slice!(/\AN[A-Z_]*/) then nil
    when slice!(/\A@/) then []
    when slice!(/\A([A-Z][A-Z_]*|.)/) then return FNS.fetch($&[0]).create{ parse! }
    end.tap{ replace $' }
  end
  freeze
end

class Array
  include Comparable
  alias to_i size
  def truthy? = !empty?
  def to_s    = join $/
  def *(rhs)
    r = []
    rhs.to_i.times{ r += self }
    r
  end
  def **(rhs) = join rhs.to_s
  prepend Module.new {
    def +(rhs)  = super(rhs.to_a)
    def <(rhs)  = super(rhs.to_a)
    def >(rhs)  = super(rhs.to_a)
    def ==(rhs) = rhs.is_a?(Array) && super(rhs)
  }
  def set(b, l, a)
    na = dup
    na[b, l] = a.to_a
    na
  end
  freeze
end

class Identifier
  @vs = {}
  def self.new(name) = @vs[name] ||= super()
  attr_accessor :call
  def truthy? = call.truthy?
end

class Proc
  def create(&b) = arity.times.map(&b).then { |x| proc { call(x) } }
  def truthy? = !call
end 
