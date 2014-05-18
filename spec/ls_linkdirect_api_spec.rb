require 'spec_helper'

describe LsLinkdirectAPI do
  context "errors" do

    it "raise connection error if times out" do
      expect{ LsLinkdirectAPI.api_timeout = "" }.to raise_error(LsLinkdirectAPI::ArgumentError,"Timeout must be a Fixnum; got String instead")
    end

    it "raise connection error if times out" do
      expect{ LsLinkdirectAPI.api_timeout = 0 }.to raise_error(LsLinkdirectAPI::ArgumentError,"Timeout must be > 0; got 0 instead")
    end

    
    it "raises authenication if token not present" do
      textlinks = LsLinkdirectAPI::TextLinks.new
      expect{ textlinks.get({})}.to raise_error(LsLinkdirectAPI::AuthenticationError)
    end

    it "raises authenication if token has spaces" do
      LsLinkdirectAPI.token = 'afajfdafd dfjaskdfk'
      textlinks = LsLinkdirectAPI::TextLinks.new
      expect{ textlinks.get({})}.to raise_error(LsLinkdirectAPI::AuthenticationError)
    end

    it "raises ArgumentError if params is not a hash" do
      LsLinkdirectAPI.token = 'afajfdafddfjaskdfk'
      textlinks = LsLinkdirectAPI::TextLinks.new
      expect{ textlinks.get('text')}.to raise_error(LsLinkdirectAPI::ArgumentError)
    end

    it "base_path for TextLinks is getTextLinks" do
      textlinks = LsLinkdirectAPI::TextLinks.new
      expect(textlinks.base_path).to eq("/getTextLinks/")
    end

    it "raises Not Implemented Error if APIResource is accessed" do
      textlinks = LsLinkdirectAPI::APIResource.new
      expect{ textlinks.base_path }.to raise_error(LsLinkdirectAPI::NotImplementedError)
    end

    it "raises ArgumentError on wrong date format" do
      LsLinkdirectAPI.token = 'afajfdafddfjaskdfk'
      textlinks = LsLinkdirectAPI::TextLinks.new
      params = { endDate: 'dec 10'}
      expect{ textlinks.get(params)}.to raise_error(LsLinkdirectAPI::ArgumentError)
    end
  end

  context "response code is not 200, 201, 204" do
    it "raise Invalid Request Error if response is 400" do
      LsLinkdirectAPI.token = '400'
      xml_response = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <ns1:XMLFault xmlns:ns1="http://cxf.apache.org/bindings/xformat"><ns1:faultstring xmlns:ns1="http://cxf.apache.org/bindings/xformat">Invalid URL/Verb combination. Verb: GET Path: /etTextLinks/06a400a42d5ee2822cc4342b7cedf714bffa542768b1c06d571c0ebe8aa85203/38605/-1//05162014/-1/1</ns1:faultstring></ns1:XMLFault>
      XML
      stub_request(
        :get,
        "http://lld2.linksynergy.com/services/restLinks/getTextLinks/400/-1/-1//05162014/-1/1"
        ).
        to_return(
          status: 400,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
      textlinks = LsLinkdirectAPI::TextLinks.new
      params = { endDate: '05162014'}
      expect { textlinks.get(params) }.to raise_error(LsLinkdirectAPI::InvalidRequestError)
    end
  end
  context "response code is 200 TextLinks" do
    before do
      LsLinkdirectAPI.token = '200'
      xml_response = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <ns1:getTextLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200321300</ns1:categoryID><ns1:categoryName>Toys</ns1:categoryName><ns1:linkID>3997</ns1:linkID><ns1:linkName>5/15-5/18 10% off Outdoor Toys. Promo Code OUTDOOR10</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.3997&amp;type=3</ns1:clickURL><ns1:endDate>May 19, 2014</ns1:endDate><ns1:landURL>www.kohls.com/catalog.jsp?N=3000060558</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.3997&amp;type=3</ns1:showURL><ns1:startDate>May 15, 2014</ns1:startDate><ns1:textDisplay>Extra 10% off Outdoor Toys. Promo Code OUTDOOR10</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>0</ns1:categoryID><ns1:categoryName>Default</ns1:categoryName><ns1:linkID>3986</ns1:linkID><ns1:linkName>Free Shipping $50+ with Code FREE50MAY</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.3986&amp;type=3</ns1:clickURL><ns1:endDate>May 19, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.3986&amp;type=3</ns1:showURL><ns1:startDate>May 16, 2014</ns1:startDate><ns1:textDisplay>Free Shipping $50+ with Code FREE50MAY. Valid 5/16-5/18.</ns1:textDisplay></ns1:return></ns1:getTextLinksResponse>
      XML
      stub_request(
        :get,
        "http://lld2.linksynergy.com/services/restLinks/getTextLinks/200/-1/-1//05162014/-1/1"
      ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
    end

    let(:textlinks) { LsLinkdirectAPI::TextLinks.new }
    let(:params) { { endDate: '05162014'} }
    let(:response) { textlinks.get(params) }

    it "first record linkid is 3997" do
      expect(response.data.first.linkID).to eq("3997")
    end

    it "last record linkid is 3986" do
      expect(response.data.last.linkID).to eq("3986")
    end
  end

  context "response code is 200 BannerLinks" do
    before do
      LsLinkdirectAPI.token = '200'
      xml_response = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <ns1:getBannerLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>0</ns1:categoryID><ns1:categoryName>Default</ns1:categoryName><ns1:linkID>3</ns1:linkID><ns1:linkName>Candie's</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.3&amp;type=4</ns1:clickURL><ns1:endDate>Dec 31, 2019</ns1:endDate><ns1:height>31</ns1:height><ns1:iconURL>http://merchant.linksynergy.com/fs/banners/38605/38605_3.jpg</ns1:iconURL><ns1:imgURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.3&amp;type=4</ns1:imgURL><ns1:landURL>http://www.kohls.com/catalog/juniors-candie-s-clothing.jsp?CN=4294719935+4294875004+4294719810</ns1:landURL><ns1:serverType>4</ns1:serverType><ns1:size>7</ns1:size><ns1:startDate>Jul 18, 2013</ns1:startDate><ns1:width>88</ns1:width></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>0</ns1:categoryID><ns1:categoryName>Default</ns1:categoryName><ns1:linkID>4</ns1:linkID><ns1:linkName>Candie's</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4&amp;type=4</ns1:clickURL><ns1:endDate>Dec 31, 2019</ns1:endDate><ns1:height>90</ns1:height><ns1:iconURL>http://merchant.linksynergy.com/fs/banners/38605/38605_4.jpg</ns1:iconURL><ns1:imgURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4&amp;type=4</ns1:imgURL><ns1:landURL>http://www.kohls.com/catalog/juniors-candie-s-clothing.jsp?CN=4294719935+4294875004+4294719810</ns1:landURL><ns1:serverType>4</ns1:serverType><ns1:size>5</ns1:size><ns1:startDate>Jul 18, 2013</ns1:startDate><ns1:width>120</ns1:width></ns1:return></ns1:getBannerLinksResponse>
      XML
      stub_request(
        :get,
        "http://lld2.linksynergy.com/services/restLinks/getBannerLinks/200/-1/-1//05162014/-1/-1/1"
      ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
    end

    let(:bannerlinks) { LsLinkdirectAPI::BannerLinks.new }
    let(:params) { { endDate: '05162014'} }
    let(:response) { bannerlinks.get(params) }

    it "first record linkid is 3" do
      expect(response.data.first.linkID).to eq("3")
    end

    it "last record linkid is 4" do
      expect(response.data.last.linkID).to eq("4")
    end
  end

  context "response code is 200 DRMLinks" do
    before do
      LsLinkdirectAPI.token = '200'
      xml_response = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <ns1:getDRMLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>78</ns1:categoryID><ns1:categoryName>Dynamic Media - Banners</ns1:categoryName><ns1:linkID>6885</ns1:linkID><ns1:linkName>Banner 300x250</ns1:linkName><ns1:mid>14028</ns1:mid><ns1:nid>1</ns1:nid><ns1:code>&lt;script src='http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=299527.6885&amp;catid=78&amp;gridnum=13&amp;type=14'>&lt;/script>&lt;noscript>&lt;a href='http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=299527&amp;type=4&amp;subid='>&lt;img src='http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=299527&amp;subid=&amp;type=4&amp;gridnum=13'>&lt;/a>&lt;/noscript></ns1:code><ns1:endDate>Oct 13, 2017</ns1:endDate><ns1:height>250</ns1:height><ns1:serverType>4</ns1:serverType><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=299527.6885&amp;catid=78&amp;gridnum=13&amp;type=14</ns1:showURL><ns1:size>13</ns1:size><ns1:startDate>Oct 13, 2011</ns1:startDate><ns1:width>300</ns1:width></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>78</ns1:categoryID><ns1:categoryName>Dynamic Media - Banners</ns1:categoryName><ns1:linkID>4027</ns1:linkID><ns1:linkName>Banner 120x240</ns1:linkName><ns1:mid>14028</ns1:mid><ns1:nid>1</ns1:nid><ns1:code>&lt;script src='http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=299527.4027&amp;catid=78&amp;gridnum=8&amp;type=14'>&lt;/script>&lt;noscript>&lt;a href='http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=299527&amp;type=4&amp;subid='>&lt;img src='http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=299527&amp;subid=&amp;type=4&amp;gridnum=8'>&lt;/a>&lt;/noscript></ns1:code><ns1:endDate>Feb 28, 2017</ns1:endDate><ns1:height>240</ns1:height><ns1:serverType>4</ns1:serverType><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=299527.4027&amp;catid=78&amp;gridnum=8&amp;type=14</ns1:showURL><ns1:size>8</ns1:size><ns1:startDate>Feb 27, 2007</ns1:startDate><ns1:width>120</ns1:width></ns1:return></ns1:getDRMLinksResponse>
      XML
      stub_request(
        :get,
        "http://lld2.linksynergy.com/services/restLinks/getDRMLinks/200/-1/-1//05162014/-1/1"
      ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
    end

    let(:drmlinks) { LsLinkdirectAPI::DRMLinks.new }
    let(:params) { { endDate: '05162014'} }
    let(:response) { drmlinks.get(params) }

    it "first record linkid is 6885" do
      expect(response.data.first.linkID).to eq("6885")
    end

    it "last record linkid is 4027" do
      expect(response.data.last.linkID).to eq("4027")
    end
  end
end