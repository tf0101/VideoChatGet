require 'site_list/video_analyze'
require 'requests/request'
require 'progressbars/progressbar'
require 'file_operats/file_operat_chatdata'



"""
"""

class Whowatch_analyze<Video_analyze

    attr_reader :video_id, :videoinfo, :chat_body, :videoandchat_info_request_status

    def initialize(url)
        @VIDEOINFO_REQEST_URL="https://api.whowatch.tv/lives/"
        
        @video_url=url
        @video_id=videoid_get(@video_url)
        @videoinfo,@chat_body,@videoandchat_info_request_status=videoinfo_get(@VIDEOINFO_REQEST_URL+@video_id)
        @chatlog_filepath="./"+@video_id+".txt"

    end


    def videoid_get(url=@video_url)
        videoid=url.split("/")[4]
        return videoid
    end


    def videoinfo_get(url)
        body,status=request_json_parse(url)
        chat_body=body.delete("comments")
        return body,chat_body,status
    end


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)
        
        comment_count=@videoinfo["live"]["comment_count"]
        chat_list=[]
        count=0
        
        @chat_body[0..-1].each do |chat|
            chat_list.push chat
            count+=1
            progressbar(count,comment_count)
        end
        
        file_write(chat_list,log_flag,log_path)
        return chat_list
     end

    public :chat_scrape
    private :videoid_get, :videoinfo_get

end