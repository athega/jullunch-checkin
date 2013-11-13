class HttpClient
  #UPLOAD_URL = "http://192.168.1.5:8080"
  UPLOAD_URL = "http://10.0.0.144:8080"
  BASE_URL = "http://10.0.0.144:3000"
  #BASE_URL = "http://192.168.1.18:3000"
  #BASE_URL = "http://192.168.1.5:3000"
  def get_companies(&block)
    url = "#{BASE_URL}/companies.json"
    BW::HTTP.get(url) do |response|
      if response.ok?
        begin
          result = BW::JSON.parse(response.body.to_str)
          block.call(
            result.map do |company_name, guests|
              guests = guests.map {|guest| Guest.new(guest) }
              company = Company.new(company_name, guests)
            end
          )
        rescue BW::JSON::ParserError
          PM.logger.error "Unable to parse JSON"
        end
      end
    end
  end

  def check_in(guest, &block)
    url = "#{BASE_URL}/check-in/guests/#{guest.token}"
    BW::HTTP.put(url) do |response|
      block.call(response)
    end
  end

  def upload_image(image, orientation, features)
    data = UIImagePNGRepresentation(image)
    NSLog("data #{data.length}")
    client = AFMotion::Client.build(UPLOAD_URL) do
      header "Accept", "application/json"
    end
    client.multipart_post("images/new", orientation: orientation, rotate: true, features: features) do |result, form_data|
      if form_data
        form_data.appendPartWithFileData(data, name: "uploaded", fileName: "image.jpg", mimeType: "image/jpeg")
      elsif result.success?
        NSLog "Yes"
        NSLog "#{result.inspect}"
      else
        NSLog "#{result.inspect}"
        NSLog "Noooo"
      end
    end
  end

end
