class Array
  def window_around_index(index, size)
    left = ((index - size) < 0) ? 0 : (index - size)
    right = ((index + size) > self.size) ? (self.size - 1) : (index + size)
    self[left..right]
  end
  def window_around_element(element, size)
    if index = self.index(element)
      window_around_index(index, size)
    else
      []
    end
  end
end