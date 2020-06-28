RSpec.describe Mildom_analyze do
    before do
        @video_url = "https://www.mildom.com/playback/10558567?v_id=10558567-1592927023107-1935"
        @video_obj = Mildom_analyze.new(@video_url)
        @chatinfo_body,@chatinfo_status=@video_obj.chatinfo_request()
    end
    describe 'reqest_status_check' do
        it 'videoinfo_request_status==200' do
            expect(@video_obj.videoinfo_request_status).to eq 200
        end
        it 'chatinfo_request_status==200' do
            expect(@chatinfo_status).to eq 200
        end
    end
end