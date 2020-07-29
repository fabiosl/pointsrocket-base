module Api
  class EsController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def get_publications_count
      page_id_providers_data = params["data"].select { |d|
        ["facebook", "youtube"].include? d['provider'] }
      author_id_providers_data = params["data"].select { |d|
        ["instagram"].include? d['provider'] }

      to_return = []
      if page_id_providers_data.any?
        to_return += get_data(page_id_providers_data, "page_id")
      end
      if author_id_providers_data.any?
        to_return += get_data(author_id_providers_data, "author.id")
      end

      render json: to_return.to_json
    end

    def get_data providers_data, key
      body = {
        "query" => {
          "bool" => {
            "should" => providers_data.map { |d|
              {
                "bool" => {
                  "must" => [
                    {
                      "term" => {
                        "social_network" => d["provider"]
                      }
                    }, {
                      "term" => {
                        key => d["id"]
                      }
                    }
                  ]
                }
              }
            }
          }

        },
        "size" => 0,
        "aggs" => {
          "social_network" => {
            "terms" => {
              "field" => "social_network"
            },
            "aggs" => {
              key => {
                "terms" => {
                  "field" => key
                }
              }
            }
          }
        }
      }

      ap "calling es with body"
      print body.to_json + "\n\n"

      response = HTTParty.post(
        "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}/post/_search",
        {
          headers: {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
          },
          body: body.to_json
        }
      )

      print response.body + "\n\n"

      to_return = providers_data.map do |d|

        provider_bucket = response.parsed_response["aggregations"]["social_network"]["buckets"].select do |s_bucket|
          s_bucket["key"] == d['provider']
        end.first

        if provider_bucket
          key_bucket = provider_bucket[key]["buckets"].select do |p_bucket|
            p_bucket["key"] == d['id']
          end.first

          if key_bucket
            d.merge!(count: key_bucket["doc_count"])
          else
            d.merge!(count: 0)
          end
        else
          d.merge!(count: 0)
        end

        d
      end

      to_return
    end

  end
end
