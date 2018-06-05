class RegexMatcher
  attr_reader :field
  attr_reader :regex


  def initialize(field, regex)
    @field = field
    @regex = regex
  end


  def process(row)
    (regex =~ row.fetch(field)) ? row : nil
  end
end
