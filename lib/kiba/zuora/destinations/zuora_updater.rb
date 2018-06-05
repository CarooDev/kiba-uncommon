module Kiba
  module Zuora
    module Destinations
    end
  end
end


class Kiba::Zuora::Destinations::ZuoraUpdater
  attr_reader :zuora_client
  attr_reader :type

  def initialize(zuora_client, type)
    @zuora_client = zuora_client
    @type = type
  end

  def write(row)
    zuora_client.call! :update, :type => type, :objects => [row]
  end

  def close
  end
end
