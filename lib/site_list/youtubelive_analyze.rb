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
        @video_id=videoid_get()
        @videoinfo_body,@videoinfo_request_status=videoinfo_get()
        @videoinfo=videoinfo_extraction()
        @chatlog_filepath="./"+@video_id+".txt"
    end
    

    def videoid_get()
        return @video_url.split("=")[1].split("&")[0]
    end


    def videoinfo_get()

        videoinfo_respons,videoinfo_status=request_html_parse(@video_url,{})

        videoinfo_respons.search('script').each do |script|

            if script.to_s.include?("window[\"ytInitialData\"]") then
                return htmlpage_script_parse(script,method(:videoinfo_script_cleanup)),videoinfo_status
            end

            if script.to_s.include?("var ytInitialData =") then
                return htmlpage_script_parse(script,method(:videoinfo_script_cleanup_p2)),videoinfo_status
            end

        end

        return ""
    end


    def videoinfo_extraction()

        videoinfo={}
        common_hash=@videoinfo_body["contents"]["twoColumnWatchNextResults"]["results"]["results"]["contents"]

        videoinfo["ch"]=common_hash[1]["videoSecondaryInfoRenderer"]["owner"]["videoOwnerRenderer"]["title"]["runs"][0]["text"]
        videoinfo["title"]=common_hash[0]["videoPrimaryInfoRenderer"]["title"]["runs"][0]["text"]
        videoinfo["starttime"]=common_hash[0]["videoPrimaryInfoRenderer"]["dateText"]["simpleText"]
        videoinfo["videocount"]=common_hash[0]["videoPrimaryInfoRenderer"]["viewCount"]["videoViewCountRenderer"]["viewCount"]["simpleText"]
        videoinfo["good"]=common_hash[0]["videoPrimaryInfoRenderer"]["videoActions"]["menuRenderer"]["topLevelButtons"][0]["toggleButtonRenderer"]["defaultText"]["simpleText"]
        videoinfo["bad"]=common_hash[0]["videoPrimaryInfoRenderer"]["videoActions"]["menuRenderer"]["topLevelButtons"][1]["toggleButtonRenderer"]["defaultText"]["simpleText"]
        return videoinfo
    end
    

    def videoinfo_script_cleanup(script_date)
        return script_date.split("=",2)[1].split("\n",2)[0].strip.chomp(";")
    end


    def videoinfo_script_cleanup_p2(script_date)
        return script_date.split("var ytInitialData =",2)[1].split(";if (window.ytcsi)",2)[0].strip.chomp(";</script>").strip
    end


    def chatinfo_script_cleanup(script_date)
        return script_date.split("=",2)[1].strip.chomp(";</script>").strip
    end


    def htmlpage_script_parse(respons,callback)
        script_body=callback.call(respons.to_s)
        return JSON.parse(script_body)
    end


    def chat_body_get(next_url, opt={'User-Agent' => @USER_AGENT})

        chat_respons,chat_status=request_html_parse(next_url,opt)

        chat_respons.search('script').each do |script|

            if script.to_s.include?("window[\"ytInitialData\"]") then
                return htmlpage_script_parse(script,method(:chatinfo_script_cleanup))
            end

        end

        return ""
    end
    


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)

        chat_list=[]
        chat_count=0
        next_url=@CHAT_REQUEST_URL + @videoinfo_body["contents"]["twoColumnWatchNextResults"]["conversationBar"]["liveChatRenderer"]["continuations"][0]["reloadContinuationData"]["continuation"]

        while true do
            begin
                chat_body=chat_body_get(next_url)
                chat_body["continuationContents"]["liveChatContinuation"]["actions"][1..-1].each do |chat|
                    chat_count+=1
                    chat_list.push chat
                end
                progressbar(chat_count,"chat_count_inf")

                next_url=@CHAT_REQUEST_URL + chat_body["continuationContents"]["liveChatContinuation"]["continuations"][0]["liveChatReplayContinuationData"]["continuation"]
                sleep(1)

            rescue
                break
            end

        end

        file_write(chat_list,log_flag,log_path)
        return chat_list
    end


    public :chat_scrape
    private :videoid_get, :videoinfo_get, :videoinfo_extraction, :htmlpage_script_parse, :videoinfo_script_cleanup, :chatinfo_script_cleanup, :chat_body_get, :videoinfo_script_cleanup_p2

end