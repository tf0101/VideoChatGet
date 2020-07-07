RSpec.describe Youtubelive_analyze do

    before(:all) do
        @video_url = "https://www.youtube.com/watch?v=QepaEuJ9pvE"
        @video_obj = Youtubelive_analyze.new(@video_url)
    end

    describe 'chat check' do
        describe '#chat_url_get_js_extraction(video_url)' do
            context 'chat_url is existence' do

                before(:all) do
                    @chat_url,@status=@video_obj.chat_url_get_js_extraction
                end

                it 'return Array ["200","OK"]' do
                    expect(@status[0]).to eq "200"
                end

                it 'return string chat_url' do
                    expect(!(@chat_url.empty?)).to eq true
                end
            end
        end

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