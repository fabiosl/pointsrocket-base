require 'rails_helper'

RSpec.describe UrlInfoCrawler do
  let(:url) {}
  let(:info_object) {
    obj = described_class.new(url)
    obj.fetch
    obj
  }

  context "when url is globo" do
    let(:url) { "http://globo.com" }

    describe "title" do
      subject { info_object.title }

      it 'returns globo.com - Absolutamente tudo sobre notícias, esportes e entretenimento' do
        VCR.use_cassette 'url_info_crawler/globo.com' do
          expect(subject).to eql("globo.com - Absolutamente tudo sobre notícias, esportes e entretenimento")
        end
      end
    end

    describe "description" do
      subject { info_object.description }

      it 'returns globo.com description' do
        VCR.use_cassette 'url_info_crawler/globo.com' do
          expect(subject).to eql("Só na globo.com você encontra tudo sobre o conteúdo e marcas do Grupo Globo. O melhor acervo de vídeos online sobre entretenimento, esportes e jornalismo do Brasil.")
        end
      end
    end

    describe "image" do
      subject { info_object.image }

      it 'returns globo.com image' do
        VCR.use_cassette 'url_info_crawler/globo.com' do
          expect(subject).to eql("http://s.glbimg.com/en/ho/static/globocom2012/img/fb_marca.png")
        end
      end
    end
  end

  context "when url is points rocket" do
    let(:url) { "http://pointsrocket.com" }

    describe "title" do
      subject { info_object.title }

      it 'returns Points Rocket | Engajamento Corporativo' do
        VCR.use_cassette 'url_info_crawler/pointsrocket.com' do
          expect(subject).to eql("Points Rocket | Engajamento Corporativo")
        end
      end
    end

    describe "description" do
      subject { info_object.description }

      it 'returns pointsrocket.com description' do
        VCR.use_cassette 'url_info_crawler/pointsrocket.com' do
          expect(subject).to eql(nil)
        end
      end
    end

    describe "image" do
      subject { info_object.image }

      it 'returns pointsrocket.com image' do
        VCR.use_cassette 'url_info_crawler/pointsrocket.com' do
          expect(subject).to eql(nil)
        end
      end
    end
  end

  context "when url is facebook (with redirection)" do
    let(:url) { "http://facebook.com" }

    describe "title" do
      subject { info_object.title }

      it 'returns Facebook – entre ou cadastre-se' do
        VCR.use_cassette 'url_info_crawler/facebook.com' do
          expect(subject).to eql("Facebook – entre ou cadastre-se")
        end
      end
    end

    describe "description" do
      subject { info_object.description }

      it 'returns facebook.com description' do
        VCR.use_cassette 'url_info_crawler/facebook.com' do
          expect(subject).to eql("Crie uma conta ou entre no Facebook. Conecte-se com amigos, familiares e outras pessoas que você conheça. Compartilhe fotos e vídeos, envie mensagens e...")
        end
      end
    end

    describe "image" do
      subject { info_object.image }

      it 'returns facebook.com image' do
        VCR.use_cassette 'url_info_crawler/facebook.com' do
          expect(subject).to eql("https://www.facebook.com/images/fb_icon_325x325.png")
        end
      end
    end
  end

end
