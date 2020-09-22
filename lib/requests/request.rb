require 'httpclient'
require 'json'
require 'nokogiri'
require 'open-uri'


def request_json_parse(url)

    client=HTTPClient.new()
    response=client.get(url)

    if response.status==200
        return JSON.parse(response.body),response.status
    end

    return {},response.status
 end


 def request_html_parse(url,opt)

    charset=nil
    status=[]
    response=URI.open(url,opt) do |f|
        charset=f.charset
        status=f.status
        f.read
    end

    response_body=Nokogiri::HTML.parse(response,nil,charset)
    return response_body,status
 end
 