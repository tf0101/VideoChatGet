require 'site_list/video_analyze'
require 'requests/request'
require 'progressbars/progressbar'
require 'file_operats/file_operat_chatdata'

class Twitcasting_analyze<Video_analyze

    attr_reader :video_id, :user_id, :videoinfo, :videoinfo_request_status

    def initialize(url)

        @video_url=url
        @video_id=videoid_get()
        @user_id=userid_get()

        @videoinfo_request_body,@videoinfo_request_status=request_html_parse(@video_url,{})
        @videoinfo=videoinfo_get()

        @chat_request_url="https://twitcasting.tv/"+@user_id+"/moviecomment/"+@video_id
        @chat_request_body,@chat_request_status=request_html_parse(@chat_request_url,{})

        @chatlog_filepath="./"+@video_id+".txt"
    end


    def videoid_get()
        videoid=@video_url.split("/")[5].split("&")[0]
        return videoid
    end


    def userid_get()
        userid=@video_url.split("/")[3]
        return userid
    end


    def videoinfo_get()

        videoinfo={}
        videoinfo["user_name"]=@videoinfo_request_body.at_css(".tw-user-nav-name").text.gsub(" ","")
        videoinfo["video_title"]=@videoinfo_request_body.at_css("#movie_title_content").text
        videoinfo["video_time"]=@videoinfo_request_body.at_css(".tw-player-duration-time").text.strip
        videoinfo["video_start_time"]=@videoinfo_request_body.at_css(".tw-player-duration-time > time")[:datetime]

        videoinfo_polymer=@videoinfo_request_body.css(".tw-player-meta__status").css(".tw-player-meta__status_item")
        i=0
        videoinfo_polymer.each do |fact|
            if i==1 then
                fact=fact.text.gsub(/ {2,}|\n/, "").split(":",2)
                videoinfo["Total"]=fact[1]
            end
            i+=1
        end
        
        return videoinfo
    end


    def chat_page_range()
        
        size=@chat_request_body.css(".paging").css("a").size()
        range=@chat_request_body.css(".paging").css("a")[size-1].text
        range=range.to_i
        
        return range
    end


    def chat_scrape(log_flag=true,log_path=@chatlog_filepath)

        chat_fact_dic={}
        chat_list=[]
        next_url=""
        chatinfo_body=@chat_request_body
        page_count=0
        page_range=chat_page_range()

        while page_count<=page_range do
            begin
                chatinfo_body.css(".tw-comment-history-item").each do |chat|
                    chat_fact_dic["comment"]=chat.at_css(".tw-comment-history-item__content__text").text.strip
                    chat_fact_dic["user_name"]=chat.at_css(".tw-comment-history-item__details__user-link").text.strip
                    chat_fact_dic["time"]=chat.at_css(".tw-comment-history-item__info__date")[:datetime]
                    chat_list.push(chat_fact_dic)
                    chat_fact_dic={}
                end
                page_count+=1
                next_url=@chat_request_url+"-"+"#{page_count}"
                chatinfo_body,status=request_html_parse(next_url,{})
                progressbar(page_count,page_range)
                sleep(1)

            rescue
                break
            end

        end

        chat_list.reverse!
        file_write(chat_list,log_flag,log_path)
        return chat_list
    end

    public :chat_scrape
    private :videoid_get, :userid_get, :videoinfo_get, :chat_page_range

end