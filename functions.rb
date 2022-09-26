FNS = {
  # Nullary
  'P' => ->{ gets&.chomp }, # or gets(chomp: true) for boring folk
  'R' => ->{ rand(0..0xFFFFFFFF) },
  # Unary
  'Q' => ->{ exit(_1.to_i) },
  'B' => ->{ _1 },
  'C' => ->{ _1.call },
  'O' => ->{ print(_1.to_s.then{ |s| s[-1] == "\\" ? s[0...-1] : s+$/ }) },
  'D' => ->{ print(_1.inspect) },
  'L' => ->{ _1.to_a.size },
  '!' => ->{ !_1.truthy? },
  '~' => ->{ -_1.to_i },
  'A' => ->{ _1.is_a?(Integer) ? _1.chr : _1.ord },
  ',' => ->{ [_1] },
  '[' => ->{ _1[0] },
  ']' => ->{ _1[1..] },
  # Binary
  '+' => ->{ _1 + _2 },
  '-' => ->{ _1 - _2 },
  '*' => ->{ _1 * _2 },
  '/' => ->{ _1 / _2 },
  '%' => ->{ _1 % _2 },
  '^' => ->{ _1 ** _2 },
  '<' => ->{ _1 < _2 },
  '>' => ->{ _1 > _2 },
  '?' => ->{ _1 == _2 },
  '&' => ->{ (v = _1.call.truthy?) && _2.call || v },
  '|' => ->{ (v = _1.call.truthy?) && v || _2.call },
  ';' => ->{ _2 },
  '=' => ->{ _2.call.tap(&_1.method(:call=)) },
  'W' => ->{ _2.call while _1.truthy?; nil },
  # Ternary
  'I' => ->{ (_1.truthy? ? _2 : _3).call },
  'G' => ->{ _1[_2.to_i, _3.to_i] },
  # Quaternary
  'S' => ->{ _1.set(_2.to_i, _3.to_i, _4) }
}
