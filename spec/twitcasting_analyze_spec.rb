RSpec.describe Twitcasting_analyze do

    before(:all) do
        @video_url = "https://twitcasting.tv/unkochan1234567/movie/582479572"
        @video_obj = Twitcasting_analyze.new(@video_url)
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

                context 'user_name is existence' do
                    it 'return string user_name' do
                        expect(!(@videoinfo["user_name"].empty?)).to eq true
                    end
                end

                context 'video_title is existence' do
                    it 'return string video_title' do
                        expect(!(@videoinfo["video_title"].empty?)).to eq true
                    end
                end
                
                context 'video_time_range is existence' do
                    it 'return string video_time_range' do
                        expect(!(@videoinfo["video_time"].empty?)).to eq true
                    end
                end

                context 'videocount is existence' do
                    it 'return string videocount' do
                        expect(!(@videoinfo["Total"].empty?)).to eq true
                    end
                end

                context 'video_start_time is existence' do
                    it 'return string video_start_time' do
                        expect(!(@videoinfo["video_start_time"].empty?)).to eq true
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