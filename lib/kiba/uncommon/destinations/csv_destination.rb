require 'csv'
module Kiba
  module Uncommon
    module Destinations
      class CsvDestination
        attr_reader :output_file

        def initialize(output_file)
          @output_file = output_file
          @csv = CSV.open(output_file, 'w')
        end

        def write(row)
          unless @headers_written
            @headers_written = true
            @csv << row.keys
          end
          @csv << row.values
        end

        def close
          @csv.close
        end
      end
    end
  end
end
