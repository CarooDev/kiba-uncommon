module Kiba
  module Zuora
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
