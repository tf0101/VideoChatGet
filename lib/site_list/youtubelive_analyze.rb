require 'requests/request'
require 'progressbars/progressbar'
require 'json'
require 'nokogiri'


class Youtubelive_analyze
    attr_reader :video_id
    def initialize(url)
        @CHAT_REQUEST_URL="https://www.youtube.com/live_chat_replay?continuation="
        @USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'

        @video_url=url
        @video_id=videoid_get!(@video_url)
        @chatlog_filepath="./"+@video_id+".txt"
    end
    
    def videoid_get!(url)
        videoid=url.split("=")[1].split("&")[0]
        return videoid
    end

    
    def videoinfo_get()
    end


    def chat_url_get(url=@video_url)

        next_url=""
        body_status=""
        iframe_count=0
        opt={}

        while next_url.empty?
            sleep(1)
            iframe_count+=1
            first_respons, body_status=request_html_parse(url,opt)
            first_respons.search('iframe').each do |info|
                if info["src"].include?("live_chat_replay") then
                    next_url=info["src"]
                end
            end
            progressbar(iframe_count,"iframe_count_inf")
        end

        puts "iframe search finished!! iframe acquisition count  #{iframe_count} "
        return next_url,body_status

    end
    


    def chat_scrape(log_path=@chatlog_filepath)
    
    chat_body={}
    chat_list=[]
    chat_count=0
    opt={'User-Agent' => @USER_AGENT}


    next_url,chat_url_status=chat_url_get(@video_url)

    File.open(log_path,"w") do |file|
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
                            file.puts chat
                        end
                        progressbar(chat_count,"chat_count_inf")
                    end
                end
            rescue
                break
            end
        end
    end

    puts "Scraping finished!! chat count is #{chat_count} , chat log is (#{log_path}) "
    return chat_list
    end

    public :chat_scrape, :chat_url_get
    private :videoid_get!, :videoinfo_get

end

#obj=Youtubelive_analyze.new(ARGV[0])
#obj.chat_scrape
#obj.videoinfo_get