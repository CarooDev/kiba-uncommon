module Kiba
  module Zuora
    module Transforms
    end
  end
end


class Kiba::Zuora::Transforms::RegexMatcher
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
