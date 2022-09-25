# frozen_string_literal: true

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

class NilClass
  def truthy? = false
  def inspect = 'null'
  freeze
end

class String
  alias to_a chars
  alias old_to_i to_i
  def to_i    = self.sub(/d/i, '@').old_to_i
  def truthy? = !empty?
  prepend Module.new {
    def +(rhs)  = super(rhs.to_s)
    def *(rhs)  = super(rhs.to_i)
    def <(rhs)  = super(rhs.to_i)
    def >(rhs)  = super(rhs.to_i)
    def ==(rhs) = rhs.is_a?(String) && super(rhs.to_i)
  }
  def set(b, l, s)
    ns = dup
    ns[b, l] = s.to_s
    ns
  end
  freeze
end

class Array
  alias to_i size
  def truthy? = !empty?
  def to_s    = self.join $/
  def *(rhs)
    r = []
    rhs.to_i.times{ r += self }
    r
  end
  def **(rhs) = join rhs.to_s
  prepend Module.new {
    def +(rhs)  = super(rhs.to_a)
    def <(rhs)  = super(rhs.to_i)
    def >(rhs)  = super(rhs.to_i)
    def ==(rhs) = rhs.is_a?(Array) && super(rhs.to_i)
  }
  def set(b, l, a)
    na = dup
    na[b, l] = a.to_a
    na
  end
  freeze
end

class Integer
  def to_a    = positive? ? digits.reverse : abs.digits.reverse.map(&:-@)
  def truthy? = self != 0
  prepend Module.new{
    def +(rhs)  = super(rhs.to_i)
    def -(rhs)  = super(rhs.to_i)
    def *(rhs)  = super(rhs.to_i)
    def /(rhs)  = super(rhs.to_i)
    def %(rhs)  = super(rhs.to_i)
    def **(rhs) = super(rhs.to_i).to_i
    def <(rhs)  = super(rhs.to_i)
    def >(rhs)  = super(rhs.to_i)
    def ==(rhs) = rhs.is_a?(Integer) && super(rhs.to_i)
  }
  freeze
end

class Identifier

end
