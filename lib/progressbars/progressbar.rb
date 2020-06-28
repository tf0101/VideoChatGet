
def progressbar(point_key,end_key)
    print "scraping_progress... #{point_key} / #{end_key}\r"
    sleep 0.001
    STDOUT.flush
end