class String  
  REPLACEMENTS = {
    'ä' => 'ae', 'ö' => 'oe', 'ü' => 'ue',
    'á' => 'a', 'ã' => 'a', 'é' => 'e', 'í' => 'i', 'í' =>'i', 'ó' => 'o', 'ú' => 'u',
    'å' => 'a', 'à' => 'a', 'è' => 'e', 'ì' => 'i', 'ò' => 'o', 'ù' => 'u',
    'â' => 'a', 'ê' => 'e', 'î' => 'i', 'ô' => 'o', 'û' => 'u',
    'ß' => 'ss',
    'ñ' => 'n',
    'č' => 'c', 'ç' => 'c',
    'Ä' => 'Ae', 'Ö' => 'Oe', 'Ü' => 'Ue',
    'Á' => 'A', 'É' => 'E', 'Í' => 'I', 'ø'  => 'o', 'Ø' => 'O', 'Ó' => 'O', 'Ú' => 'U',
    'À' => 'A', 'È' => 'E', 'Ì' => 'I', 'Ò' => 'O', 'Ù' => 'U',
    'Â' => 'A', 'Å' => 'A', 'Ê' => 'E', 'Î' => 'I', 'Ô' => 'O', 'Û' => 'U',
  }
  
  def convert_characters
    result = dup
    for character, conversion in REPLACEMENTS
      result.gsub! character, conversion
    end  
    result
  end  
  
  def substitute_non_alphanum_with_hyphen
    gsub(/[-_,.;: \/\\]/, '_').gsub(/[^_a-z0-9]/i, '').gsub(/_{2,}/, '_').gsub(/^_/,'')
  end
  
  def convert_umlauts
    downcase.gsub(/[äÄ]/, 'ae').gsub(/[öÖ]/, 'oe').gsub(/[üÜ]/, 'ue').gsub(/ß/, 'ss')
  end
  
  def to_url
    downcase.convert_characters.substitute_non_alphanum_with_hyphen
  end
  
  def to_mobile
    unless blank? || self =~ /^\+[0-9]+$/
      gsub(/^\+/, '00').        # replace + country prefix by 00 country prefix
      gsub(/[^0-9]+/, '').      # strip all non numeric characters
      gsub(/^0{2,}/, '+').      # replace 00 country prefix by + country prefix
      gsub(/^0/, '+49').        # add default + country prefix to numbers without country prefix
      gsub(/^([^\+])/, '+\1') # add + for country prefix to numbers without it (assuming they just forgot to add the leading + to their country prefix)
    end || self
  end
end
