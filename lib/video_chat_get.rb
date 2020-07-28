require 'video_chat_get/version'
Dir[File.expand_path('../site_list',__FILE__)<<'/*.rb'].each do |file| require file end

   """
    ・argument
    @@OPENREC_IDENTFIER:
    @@MILDOM_IDENTFIER:
    @@WHOWATCH_IDENTFIER:
    @@YOUTUBELIVE_IDENTFIER:
    @@TWITCASTING_IDENTFIER:

　　 ・method
    url_route():
    """

module VideoChatGet

  @@OPENREC_IDENTFIER="https://www.openrec.tv/live/"
  @@MILDOM_IDENTFIER="https://www.mildom.com/playback/"
  @@WHOWATCH_IDENTFIER="https://whowatch.tv/archives/"
  @@YOUTUBELIVE_IDENTFIER="https://www.youtube.com/watch?"
  @@TWITCASTING_IDENTFIER="https://twitcasting.tv/"

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
    elsif url.include?(@@WHOWATCH_IDENTFIER) then
        puts "identifier:whowatch videourl:#{url}"
        obj=Whowatch_analyze.new(url)
        obj.chat_scrape
    elsif url.include?(@@YOUTUBELIVE_IDENTFIER) then
        puts "identifier:youtube videourl:#{url}"
        obj=Youtubelive_analyze.new(url)
        obj.chat_scrape
    elsif url.include?(@@TWITCASTING_IDENTFIER) then
        puts "identifier:twitcasting videourl:#{url}"
        obj=Twitcasting_analyze.new(url)
        obj.chat_scrape
    else
        puts "urlerr"
    end

    "end"
  end

end
