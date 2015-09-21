class String
  def remove_non_ascii(replacement = '')
    self.gsub!(/[\u0080-\u00ff]/, replacement)
  end
end