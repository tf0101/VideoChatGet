RSpec.describe Openrec_analyze do
    
    before(:all) do
        @video_url = "https://www.openrec.tv/live/mlrlm9dxnzg"
        @video_obj = Openrec_analyze.new(@video_url)
    end

    describe 'videoinfo check' do
        describe '@videoinfo' do
            context 'videoinfo existence == chat page first key is existence' do
                it 'return string chatpage_firstkey' do
                    expect(!(@video_obj.videoinfo["started_at"].empty?)).to eq true
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
                    @chat_list=@video_obj.chat_scrape
                 end

                it 'return Array chat_list' do 
                    expect(!(@chat_list.empty?)).to eq true
                end
            end
        end

    end


end
  