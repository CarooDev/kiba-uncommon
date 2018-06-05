module Kiba
  module Uncommon
    module Transforms
      class IdentityTransform
        def initialize
        end

        def process(row)
          row
        end
      end
    end
  end
end
