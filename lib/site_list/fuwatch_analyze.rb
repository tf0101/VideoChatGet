require 'requests/request'
require 'progressbars/progressbar'


"""
"""

class Fuwatch_analyze
    attr_reader :video_id, :videoinfo, :videoandchat_info_request_status
    def initialize(url)
        @VIDEOINFO_REQEST_URL="https://api.whowatch.tv/lives/"

        @video_url=url
        @video_id=videoid_get!(@video_url)
        @videoinfo,@chat_body,@videoandchat_info_request_status=videoinfo_get!(@VIDEOINFO_REQEST_URL+@video_id)
        @chatlog_filepath="./"+@video_id+".txt"

    end


    def videoid_get!(url)
        videoid=url.split("/")[4]
        return videoid
    end


    def videoinfo_get!(url)
        body,status=request(url)
        chat_body=body.delete("comments")
        return body,chat_body,status
    end


    def chat_scrape(log_path=@chatlog_filepath)
        
        comment_count=@videoinfo["live"]["comment_count"]
        file=File.open(log_path,"w")
        chat_list=[]
        count=0

        @chat_body[0..-1].each do |chat|
            chat_list.push chat
            chat=chat.to_s
            file.puts chat
            count+=1
            progressbar(count,comment_count)
        end
        
        file.close
        puts "Scraping finished!! comment_count is #{count} , chat log is (#{log_path}) "
        return chat_list

     end

    public :chat_scrape
    private :videoid_get!, :videoinfo_get!

end

#obj=Fuwatch_analyze.new(ARGV[0])
#list=obj.chat_scrape
#puts list[0]
#puts list[0].class
#puts list.size()
