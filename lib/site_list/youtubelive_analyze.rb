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
        @video_id=videoid_get(@video_url)
        @videoinfo_body,@videoinfo_request_status=videoinfo_get(@video_url)
        @videoinfo=videoinfo_extraction()
        @chatlog_filepath="./"+@video_id+".txt"
    end
    

    def videoid_get(url=@video_url)
        videoid=url.split("=")[1].split("&")[0]
        return videoid
    end


    def videoinfo_get(url=@video_url)
        
        opt={}
        videoinfo_body=""

        videoinfo_respons,videoinfo_status=request_html_parse(url,opt)
        videoinfo_body=htmlpage_script_parse(videoinfo_respons,method(:videoinfo_script_cleanup))
        return videoinfo_body,videoinfo_status
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
        script_body=""
        script_body=script_date.split("=",2)[1].split("\n",2)[0].strip.chomp(";")
        return script_body
    end


    def chatinfo_script_cleanup(script_date)
        script_body=""
        script_body=script_date.split("=",2)[1].chomp("</script>").strip.chomp(";")
        return script_body
    end


    def htmlpage_script_parse(respons,callback)
        script_body=""
        respons.search('script').each do |script|
            script=script.to_s
            if script.include?("window[\"ytInitialData\"]") then
                script_body=callback.call(script)
                script_body=JSON.parse(script_body)
            end
        end
        return script_body
    end


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)

        chat_body={}
        chat_list=[]
        chat_count=0
        opt={'User-Agent' => @USER_AGENT}
        continue_parameter=@videoinfo_body["contents"]["twoColumnWatchNextResults"]["conversationBar"]["liveChatRenderer"]["continuations"][0]["reloadContinuationData"]["continuation"]
        next_url=@CHAT_REQUEST_URL+continue_parameter

        while true do
            begin
                chat_respons,chat_status=request_html_parse(next_url,opt)
                chat_body=htmlpage_script_parse(chat_respons,method(:chatinfo_script_cleanup))
                continue_parameter = chat_body["continuationContents"]["liveChatContinuation"]["continuations"][0]["liveChatReplayContinuationData"]["continuation"]
                next_url=@CHAT_REQUEST_URL+continue_parameter

                chat_body["continuationContents"]["liveChatContinuation"]["actions"][1..-1].each do |chat|
                    chat_count+=1
                    chat_list.push chat
                end

                progressbar(chat_count,"chat_count_inf")

            rescue
                break
            end

        end

        file_write(chat_list,log_flag,log_path)
        return chat_list
    end


    public :chat_scrape
    private :videoid_get, :videoinfo_get, :videoinfo_extraction, :htmlpage_script_parse, :videoinfo_script_cleanup, :chatinfo_script_cleanup

end