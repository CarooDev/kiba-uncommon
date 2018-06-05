require 'zuora'
require 'hashie/logger'


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

    Hashie.logger = Logger.new(nil)
  end


  def each
    results = query

    loop do
      results.records.each do |result|
        yield result
      end

      break if results['done'] == 'true'
      results = query(results['query_locator'])
    end
  end


  def query(query_locator=nil)
    unless query_locator
      response = zuora_client.call! :query, zoql_query
      result = response.to_h['envelope']['body']['query_response']['result']
    else
      response = zuora_client.call! :query_more, query_locator
      result = response.to_h['envelope']['body']['query_more_response']['result']
    end

    # Remove XML fields
    result.records.each do |record|
      record.delete(:ns2)
      record.delete(:type)
      record.delete(:xsi)
    end

    result
  end
end
