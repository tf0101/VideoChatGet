RSpec.describe Mildom_analyze do

    before(:all) do
        @video_url = "https://www.mildom.com/playback/10558567?v_id=10558567-1593954251"
        @video_obj = Mildom_analyze.new(@video_url)
        @chat_log_path="./spec/testdata_log/"+@video_obj.video_id+".txt"
    end
    
    describe 'videoinfo check' do
        describe '@videoinfo' do
            context 'videoinfo existence' do
                it 'return hash videoinfo' do
                    expect(!(@video_obj.videoinfo.empty?)).to eq true
                end
             end

             context 'videoid existence' do
                it 'return string videoid' do
                    expect(@video_obj.videoinfo["body"]["playback"]["v_id"].nil?).to eq false
                end
             end

        end
        
        describe '@videoinfo_request_status' do
            context 'videoinfo_request_status is existence' do
                it 'return Integer 200' do
                    expect(@video_obj.videoinfo_request_status).to eq 200
                end
            end
        end
    end

    describe 'chat check' do
        describe '#chat_scrape(chat_write_path)' do
            context 'chat_list is existence' do

                before do
                    @chat_list=@video_obj.chat_scrape(true,@chat_log_path)
                 end

                it 'return Array chat_list' do 
                    expect(!(@chat_list.empty?)).to eq true
                end
            end
        end
    end

end