class String

  def secure_eql?(s)
    return false if blank? || s.blank? || bytesize != b.bytesize
    l = unpack "C#{bytesize}"
    res = 0
    s.each_byte {|byte| res |= byte ^ l.shift }
    res.zero?
  end

end
