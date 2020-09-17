require 'site_list/video_analyze'
require 'requests/request'
require 'progressbars/progressbar'
require 'file_operats/file_operat_chatdata'

"""
"""

class Openrec_analyze<Video_analyze

    attr_reader :video_id, :videoinfo, :videoinfo_request_status

    def initialize(url)

        @VIDEOINFO_REQEST_URL="https://public.openrec.tv/external/api/v5/movies/"
        @CHAT_REQEST_PARAMETER1="/chats?from_created_at="
        @CHAT_REQEST_PARAMETER2="&is_including_system_message=false"

        @video_url=url
        @video_id=videoid_get()
        @videoinfo,@videoinfo_request_status=request_json_parse(@VIDEOINFO_REQEST_URL+@video_id)
        @chatlog_filepath="./"+@video_id+".txt"
    
    end


    def videoid_get()
        return @video_url.split("/")[4].split("&")[0]
    end


    """
        チャットの続きページを取得するには、現在取得しているチャットログの最新チャットの時間情報が必要、時間情報はチャットログではdatetime形式だがリクエストurlではiso8601形式が必要なので変換が必要
        ログから得たstring型のチャット時間をdatatime型→time型→iso8601(string型)に変換
    """
    def chat_nextpage_get(time_key)
        #datatime型→time型→iso8601型
        time_key=DateTime.parse(time_key).to_time.utc.iso8601
        return @VIDEOINFO_REQEST_URL+@video_id+@CHAT_REQEST_PARAMETER1+time_key+@CHAT_REQEST_PARAMETER2
    end


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)

        start_time=@videoinfo["started_at"]
        end_time=@videoinfo["ended_at"]
        next_url=chat_nextpage_get(start_time)
        chat_body,chat_status=request_json_parse(next_url)

        chat_list=[]
        next_time=""
        head=0
        
        while !(chat_body[head..-1].empty?) do
            chat_body[head..-1].each do |chat|
                chat_list.push chat
                next_time=chat["posted_at"]
            end
            
            head=1
            next_url=chat_nextpage_get(next_time)
            chat_body,chat_status=request_json_parse(next_url)
            progressbar(next_time,end_time)
            sleep(1)
        end

        file_write(chat_list,log_flag,log_path)
        return chat_list
    end

    public :chat_scrape
    private :videoid_get, :chat_nextpage_get

end