require 'site_list/video_analyze'
require 'requests/request'

class Twitcasting_analyze<Video_analyze

    attr_reader :video_id, :videoinfo, :videoinfo_request_status

    def initialize(url)

        @video_url=url
        @video_id=videoid_get(@video_url)
        @videoinfo,@videoinfo_request_status=videoinfo_get(@video_url)
    
    end

    def videoid_get(url=@video_url)
        videoid=url.split("/")[5].split("&")[0]
        return videoid
    end

    def videoinfo_get(url=@video_url)

        opt={}
        videoinfo={}
        videoinfo_body,status=request_html_parse(url,opt)
        
        videoinfo["user_name"]=videoinfo_body.at_css(".tw-user-nav-name").text.gsub(" ","")
        videoinfo["video_title"]=videoinfo_body.at_css("#movie_title_content").text

        videoinfo_polymer=videoinfo_body.css(".tw-player-meta__status").css(".tw-player-meta__status_item")
        videoinfo_polymer.each do |fact|
            fact=fact.text
            fact=fact.gsub(/ {2,}|\n/, "")
            fact=fact.split(":",2)
            videoinfo[fact[0]]=fact[1]
        end
        
        return videoinfo,status
    end


end