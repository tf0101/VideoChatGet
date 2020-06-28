RSpec.describe Fuwatch_analyze do
    before do
        @video_url = "https://whowatch.tv/archives/16121094"
        @video_obj = Fuwatch_analyze.new(@video_url)
    end
    describe 'reqest_status_check' do
        it 'videoandchat_info_request_status==200' do
            expect(@video_obj.videoandchat_info_request_status).to eq 200
        end
    end
end