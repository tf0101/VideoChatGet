RSpec.describe Youtubelive_analyze do

    before(:all) do
        @video_url = "https://www.youtube.com/watch?v=QepaEuJ9pvE"
        @video_obj = Youtubelive_analyze.new(@video_url)
        @chat_log_path="./spec/testdata_log/"+@video_obj.video_id+".txt"
    end

    describe 'videoinfo check' do

        before(:all) do
            @videoinfo=@video_obj.videoinfo
            @videoinfo_request_status=@video_obj.videoinfo_request_status
        end

        describe '@videoinfo_request_status' do
            context 'videoinfo_request_status is existence' do

                it 'return Array ["200","OK"]' do
                    expect(@videoinfo_request_status[0]).to eq "200"
                end
            end
        end

        describe '@videoinfo' do
            context 'videoinfo is existence' do

                it 'return hash videoinfo' do
                    expect(!(@videoinfo.empty?)).to eq true
                end

                context 'ch_name is existence' do
                    it 'return string ch_name' do
                        expect(!(@videoinfo["ch"].empty?)).to eq true
                    end
                end

                context 'ch_id is existence' do
                     it 'return string ch_id' do
                         expect(!(@videoinfo["chid"].empty?)).to eq true
                     end
                end

                context 'title is existence' do
                    it 'return string title' do
                        expect(!(@videoinfo["title"].empty?)).to eq true
                    end
                end
                
                context 'starttime is existence' do
                    it 'return string starttime' do
                        expect(!(@videoinfo["starttime"].empty?)).to eq true
                    end
                end

                context 'videocount is existence' do
                    it 'return string videocount' do
                        expect(!(@videoinfo["videocount"].empty?)).to eq true
                    end
                end

                context 'good is existence' do
                    it 'return string good' do
                        expect(!(@videoinfo["good"].empty?)).to eq true
                    end
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