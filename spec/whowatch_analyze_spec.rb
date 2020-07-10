RSpec.describe Whowatch_analyze do

    before(:all) do
        @video_url = "https://whowatch.tv/archives/12373483"
        @video_obj = Whowatch_analyze.new(@video_url)
        @chat_log_path="./spec/testdata_log/"+@video_obj.video_id+".txt"
    end

    describe 'video&chat info check' do
        describe '@videoinfo' do
            context 'videoinfo is existence ' do
                it 'return Hash videoinfo' do
                    expect(!(@video_obj.videoinfo.empty?)).to eq true
                end
             end
        end

        describe '@chat_body' do
            context 'chat_body is existence' do
                it 'return Hash chat_body' do
                    expect(!(@video_obj.chat_body.empty?)).to eq true
                end
             end
        end
        
        describe '@videoandchat_info_request_status' do
            context 'videoandchat_info_request_status is existence' do
                it 'return Integer 200' do
                    expect(@video_obj.videoandchat_info_request_status).to eq 200
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