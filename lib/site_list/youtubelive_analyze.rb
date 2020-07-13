require 'site_list/video_analyze'
require 'requests/request'
require 'progressbars/progressbar'
require 'file_operats/file_operat_chatdata'
require 'json'
require 'nokogiri'


class Youtubelive_analyze<Video_analyze

    attr_reader :video_id, :videoinfo, :videoinfo_request_status

    def initialize(url)
        @CHAT_REQUEST_URL="https://www.youtube.com/live_chat_replay?continuation="
        @USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'

        @video_url=url
        @video_id=videoid_get!(@video_url)
        @videoinfo_polymer,@videoinfo_request_status=videoinfo_get(@video_url)
        @videoinfo=videoinfo_extraction()
        @chatlog_filepath="./"+@video_id+".txt"
    end
    

    def videoid_get!(url=@video_url)
        videoid=url.split("=")[1].split("&")[0]
        return videoid
    end


    def videoinfo_get(url=@video_url)
        
        opt={}
        next_url_polymer=""
        next_url=""

        videoinfo_respons,videoinfo_status=request_html_parse(url,opt)
        videoinfo_respons.search('script').each do |script|
            script=script.to_s
            if script.include?("window[\"ytInitialData\"]") then
                next_url_polymer=script.split("=",2)[1].split("\n",2)[0]
                next_url_polymer=next_url_polymer.strip.chomp(";")
                next_url_polymer=JSON.parse(next_url_polymer)
            end
        end
        
        return next_url_polymer,videoinfo_status
    end
    


    def videoinfo_extraction()
        videoinfo={}
        common_hash=@videoinfo_polymer["contents"]["twoColumnWatchNextResults"]["results"]["results"]["contents"]

        videoinfo["ch"]=common_hash[1]["videoSecondaryInfoRenderer"]["owner"]["videoOwnerRenderer"]["title"]["runs"][0]["text"]
        videoinfo["title"]=common_hash[0]["videoPrimaryInfoRenderer"]["title"]["runs"][0]["text"]
        videoinfo["starttime"]=common_hash[0]["videoPrimaryInfoRenderer"]["dateText"]["simpleText"]
        videoinfo["videocount"]=common_hash[0]["videoPrimaryInfoRenderer"]["viewCount"]["videoViewCountRenderer"]["viewCount"]["simpleText"]
        videoinfo["good"]=common_hash[0]["videoPrimaryInfoRenderer"]["videoActions"]["menuRenderer"]["topLevelButtons"][0]["toggleButtonRenderer"]["defaultText"]["simpleText"]
        videoinfo["bad"]=common_hash[0]["videoPrimaryInfoRenderer"]["videoActions"]["menuRenderer"]["topLevelButtons"][1]["toggleButtonRenderer"]["defaultText"]["simpleText"]
        
        return videoinfo
    end


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)
    
    chat_body={}
    chat_list=[]
    chat_count=0
    opt={'User-Agent' => @USER_AGENT}
    next_url=@videoinfo_polymer["contents"]["twoColumnWatchNextResults"]["conversationBar"]["liveChatRenderer"]["continuations"][0]["reloadContinuationData"]["continuation"]
    next_url=@CHAT_REQUEST_URL+next_url

    while true do

        begin
            chat_respons,chat_status=request_html_parse(next_url,opt)

            chat_respons.search('script').each do |script|
                script=script.to_s

                if script.include?("window[\"ytInitialData\"]") then
                    chat_body=script.split("=",2)[1].chomp("</script>").strip.chomp(";")
                    chat_body=JSON.parse(chat_body)
                    continue_url = chat_body["continuationContents"]["liveChatContinuation"]["continuations"][0]["liveChatReplayContinuationData"]["continuation"]
                    next_url=@CHAT_REQUEST_URL+continue_url

                    chat_body["continuationContents"]["liveChatContinuation"]["actions"][1..-1].each do |chat|
                        chat_count+=1
                        chat_list.push chat
                        end
                    progressbar(chat_count,"chat_count_inf")
                end
            end
        rescue
            break
        end
    end

    file_write(chat_list,log_flag,log_path)
    return chat_list
    end


    public :chat_scrape
    private :videoid_get!, :videoinfo_get, :videoinfo_extraction

end