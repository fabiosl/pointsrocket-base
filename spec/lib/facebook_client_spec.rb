require 'rails_helper'

RSpec.describe FacebookClient do

  describe "post on timeline" do
    let(:access_token) {
      "EAACEdEose0cBAI14xjh37DGmmi8ShIUfP1Pl21VH6Udy5nEFHUbnEZC4N3ZBIXGPzDiewghtZB4hZBs48s77ZALddrvPutncuSvTh8B9TDbwimjcu3VWkAX7kWIDobAuiLL3AYIWSBy1OnWEkkhjNyxqrUw2cGdtWbUjtMvIHeQZDZD"
    }

    subject { described_class.new(access_token).post_timeline(options) }

    let(:options) {
      {
        message: "Testando a publicação"
      }
    }

    it "posts on timeline" do
      VCR.use_cassette 'facebook_client/post_on_timeline' do
        subject
      end
    end

    context "without message" do
      let(:options) {
        {
          message: ""
        }
      }

      it "raises FacebookClient::FacebookError" do
        VCR.use_cassette 'facebook_client/fail_post_on_timeline' do
          expect {
            subject
          }.to raise_error(FacebookClient::FacebookError)
        end
      end
    end

    context "with link" do
      let(:options) {
        {
          message: "Teste com link",
          link: "http://pointsrocket.com",
          picture: "http://www.dicasuteisbrasil.com.br/wp-content/uploads/2015/01/Desenhos_de_carro_para_colorir_2.gif",
          name: "name of link",
          caption: "caption of link",
          description: "description of link"
        }
      }

      it "create post successfully" do
        VCR.use_cassette 'facebook_client/post_on_timeline_with_link_options' do
          subject
        end
      end
    end

    context "with link (2)" do
      let(:options) {
        {
          message: "Teste com link (2)",
          link: "http://pointsrocket.com",
          picture: "http://www.dicasuteisbrasil.com.br/wp-content/uploads/2015/01/Desenhos_de_carro_para_colorir_2.gif",
          caption: "caption of link",
        }
      }

      it "create post successfully" do
        VCR.use_cassette 'facebook_client/post_on_timeline_with_link_options_2' do
          subject
        end
      end
    end

    context "with link (3)" do
      let(:options) {
        {
          message: "Teste com link (3)",
          link: "http://pointsrocket.com",
          picture: "http://www.dicasuteisbrasil.com.br/wp-content/uploads/2015/01/Desenhos_de_carro_para_colorir_2.gif",
        }
      }

      it "create post successfully" do
        VCR.use_cassette 'facebook_client/post_on_timeline_with_link_options_3' do
          subject
        end
      end
    end
  end

end
