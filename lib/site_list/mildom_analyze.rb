require 'site_list/video_analyze'
require 'requests/request'
require 'progressbars/progressbar'
require 'file_operats/file_operat_chatdata'


"""
"""

class Mildom_analyze<Video_analyze

    attr_reader :video_id, :videoinfo, :videoinfo_request_status

    def initialize(url)
        @VIDEOINFO_REQEST_URL="https://cloudac.mildom.com/nonolive/videocontent/playback/getPlaybackDetail?v_id="
        @CHAT_REQEST_URL="https://cloudac.mildom.com/nonolive/videocontent/chat/replay?video_id="
        @CHAT_REQEST_PARAMETER="&time_offset_ms="
        @CHAT_STARTTIME="0"

        @video_url=url
        @video_id=videoid_get(@video_url)
        @videoinfo,@videoinfo_request_status=request_json_parse(@VIDEOINFO_REQEST_URL+@video_id)
        @chatlog_filepath="./"+@video_id+".txt"
    end


    def videoid_get(url=@video_url)
        videoid=url.split("=")[1].split("&")[0]
        return videoid
    end


    def chat_nextpage_get(time_key)
        time_key=time_key.to_s
        chat_request_url=@CHAT_REQEST_URL+@video_id+@CHAT_REQEST_PARAMETER+time_key
        return chat_request_url
    end


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)

        next_url=chat_nextpage_get(@CHAT_STARTTIME)
        chat_body,chat_status=request_json_parse(next_url)
        
        time_length=@videoinfo["body"]["playback"]["video_length"]
        next_time=0
        chat_list=[]
        

        while next_time<=time_length do
                
            chat_body["body"]["models"][0]["detail"][0..-1].each do |chat|
                chat_list.push chat
            end

            next_time=chat_body["body"]["models"][0]["summary"]["end_offset_ms"]
            next_url=chat_nextpage_get(next_time)
            chat_body,chat_status=request_json_parse(next_url)
            progressbar(next_time,time_length)
        end

        file_write(chat_list,log_flag,log_path)
        return chat_list
    end

    public :chat_scrape
    private :videoid_get, :chat_nextpage_get

end