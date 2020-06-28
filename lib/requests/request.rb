require 'httpclient'
require 'json'


def request(url)
    body_dic={}

    client=HTTPClient.new()
    response=client.get(url)

    if response.status==200
     body_dic=JSON.parse(response.body)
    end

    return body_dic,response.status
 end
 