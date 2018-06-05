require 'zuora'


module Kiba
  module Zuora
    module Sources
    end
  end
end


class Kiba::Zuora::Sources::ZOQLSource
  attr_reader :zuora_client
  attr_reader :zoql_query

  
  def initialize(zuora_client, zoql_query)
    @zuora_client = zuora_client
    @zoql_query = zoql_query
  end


  def each
    results = query
    results.each do |result|
      yield result
    end
  end


  def query
    response = zuora_client.call! :query, zoql_query
    records = response.to_h['envelope']['body']['query_response']['result']['records']

    records.map do |record|
      record.delete(:ns2)
      record.delete(:type)
      record.delete(:xsi)
      record
    end
  end
end
