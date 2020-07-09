
def file_write(data_list,log_flag,log_path)

    if log_flag==true then
        File.open(log_path,"w") do |file|
            data_list.each do |chat|
                file.puts chat
            end
        end
        puts "Scraping finished!! , log_flag true , chat log path is (#{log_path}) "
    else
        puts "Scraping finished!! , log_flag false , chat log path is (no_path) "
    end

end