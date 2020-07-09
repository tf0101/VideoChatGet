require 'video_chat_get/version'
require 'site_list/video_analyze'
require 'site_list/openrec_analyze'
require 'site_list/mildom_analyze'
require 'site_list/fuwatch_analyze'

   """
    ・argument
    @@OPENREC_IDENTFIER:
    @@MILDOM_IDENTFIER:

　　 ・method
    url_route():
    """

module VideoChatGet

  @@OPENREC_IDENTFIER="https://www.openrec.tv/live/"
  @@MILDOM_IDENTFIER="https://www.mildom.com/playback/"
  @@FUWATCH_IDENTFIER="https://whowatch.tv/archives/"

  def self.test
    "hello"
  end

  def self.url_route(url)
    if url.include?(@@OPENREC_IDENTFIER) then
        puts "identifier:openrec videourl:#{url}"
        obj=Openrec_analyze.new(url)
        obj.chat_scrape
    elsif url.include?(@@MILDOM_IDENTFIER) then
        puts "identifier:mildom videourl:#{url}"
        obj=Mildom_analyze.new(url)
        obj.chat_scrape
    elsif url.include?(@@FUWATCH_IDENTFIER) then
        puts "identifier:fuwatch videourl:#{url}"
        obj=Fuwatch_analyze.new(url)
        obj.chat_scrape
    else
        puts "urlerr"
    end

  end

end

print(VideoChatGet.url_route(ARGV[0]))
