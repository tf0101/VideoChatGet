require 'requests/request'
require 'progressbars/progressbar'


"""
Openrec_analyze

・Explanation
get chat data from openrec

・use
obj=Openrec_analyze.new(url)
obj.chat_scrape

・instance variable
video_id（String）:video identifier
videoinfo（Hash）:Video information
videoinfo_request_status(Integer):Videoinformation request statuscode

・method
private method:
videoid_get!(url)
chat_nextpage_get(time_key)

public method:
chat_scrape()
chatinfo_request_status()

・test
Check if the request statuscode is 200

videoinfo_request_status==200
chatinfo_request_status==200

"""

class Openrec_analyze
    attr_reader :video_id, :videoinfo, :videoinfo_request_status
    def initialize(url)

        @VIDEOINFO_REQEST_URL="https://public.openrec.tv/external/api/v5/movies/"
        @CHAT_REQEST_PARAMETER1="/chats?from_created_at="
        @CHAT_REQEST_PARAMETER2="&is_including_system_message=false"
        @CHAT_STARTTIME_KEY="started_at"
        @CHAT_ENDTIME_KEY="ended_at"
        @CHAT_NEXTTIME_KEY="posted_at"

        @video_url=url
        @video_id=videoid_get!(@video_url)
        @videoinfo,@videoinfo_request_status=request(@VIDEOINFO_REQEST_URL+@video_id)
        @chatlog_filepath="./"+@video_id+".txt"
    
    end


    def videoid_get!(url)
        videoid=url.split("/")[4].split("&")[0]
        return videoid
    end


    """
        チャットの続きページを取得するには、現在取得しているチャットログの最新チャットの時間情報が必要、時間情報はチャットログではdatetime形式だがリクエストurlではiso8601形式が必要なので変換が必要
        ログから得たstring型のチャット時間をdatatime型→time型→iso8601(string型)に変換
    """
    def chat_nextpage_get(time_key)
        #datatime型→time型→iso8601型
        time_key=DateTime.parse(time_key).to_time.utc.iso8601
        chat_request_url=@VIDEOINFO_REQEST_URL+@video_id+@CHAT_REQEST_PARAMETER1+time_key+@CHAT_REQEST_PARAMETER2

        return chat_request_url
    end


    def chat_scrape(log_path=@chatlog_filepath)

        start_time=@videoinfo[@CHAT_STARTTIME_KEY]
        end_time=@videoinfo[@CHAT_ENDTIME_KEY]
        next_url=chat_nextpage_get(start_time)
        chat_body,chat_status=request(next_url)
        file=File.open(log_path,"w")
        chat_list=[]
        next_time=""
        head=0
        
        while !(chat_body[head..-1].empty?) do

            chat_body[head..-1].each do |chat|
                chat_list.push chat
                next_time=chat[@CHAT_NEXTTIME_KEY]
                chat=chat.to_s
                file.puts chat
            end
            
            head=1
            next_url=chat_nextpage_get(next_time)
            chat_body,chat_status=request(next_url)
            progressbar(next_time,end_time)
        end

        file.close
        puts "Scraping finished!! last chat time is #{next_time} , chat log is (#{log_path}) "
        return chat_list
    end


    def chatinfo_request
        start_time=@videoinfo[@CHAT_STARTTIME_KEY]
        next_url=chat_nextpage_get(start_time)
        chat_body,chat_status=request(next_url)
        return chat_body,chat_status
    end

    public :chat_scrape, :chatinfo_request
    private :videoid_get!, :chat_nextpage_get

end


#obj=Openrec_analyze.new(ARGV[0])
#list=obj.chat_scrape
#puts list[0]
#puts list[0].class
#puts list.size()

