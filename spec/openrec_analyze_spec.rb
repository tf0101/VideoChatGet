RSpec.describe Openrec_analyze do
    before do
        @video_url = "https://www.openrec.tv/live/mlrlm9dxnzg"
        @video_obj = Openrec_analyze.new(@video_url)
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
  