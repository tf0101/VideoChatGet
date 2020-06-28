
def datatime_apitimeconvert(time)
    #datatime型→time型→iso8601型
    time=DateTime.parse(time).to_time.utc.iso8601
    return time
end