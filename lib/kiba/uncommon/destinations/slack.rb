module Kiba
  module Uncommon
    module Destinations
    end
  end
end


# Very basic Slack destination
class Kiba::Uncommon::Destinations::Slack
  attr_reader :notifier


  def initialize(slack_notifier)
    @notifier = slack_notifier
  end


  def write(row)
    unless @headers_written
      @headers_written = true
      notifier.ping "`#{row.keys.join(',')}`"
    end
    
    notifier.ping row.values.join(',')
  end


  def close
    # Nothing to do
  end
end
