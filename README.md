# VideoChatGet

This is a ruby ​​package that gets a list of chats from the broadcasts of video distribution sites.

## Support sites
|site_name |status |
|:---|:---:|
|mildom |◯ |
|niconico | |
|openrec |◯ |
|twitcasting |◯ |
|twitch | |
|whowatch |◯ |
|youtubelive |◯ |


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'video_chat_get'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install video_chat_get

## Usage
### CLI
use CLI:

    $ videochatget videourl

### In code
```ruby
require 'video_chat_get'

#mildom
obj=Mildom_analyze.new(url)
video_info=obj.videoinfo
chat_list=obj.chat_scrape()

#openrec
obj=Openrec_analyze.new(url)
video_info=obj.videoinfo
chat_list=obj.chat_scrape()

#twitcasting
obj=Twitcasting_analyze.new(url)
video_info=obj.videoinfo
chat_list=obj.chat_scrape()

#whowatch
obj=Whowatch_analyze.new(url)
video_info=obj.videoinfo
chat_list=obj.chat_scrape()

#youtubelive
obj=Youtubelive_analyze.new(url)
video_info=obj.videoinfo
chat_list=obj.chat_scrape()

```

## Document
Basically use instance method

↓　Example of use
```ruby
obj=Youtubelive_analyze.new(url)
video_info=obj.videoinfo
chat_list=obj.chat_scrape()
```

### instance variable
@videoinfo

・Returns: hash  
&emsp;&emsp;&emsp;We can acquire broadcast frame information.  

### instance method  
#chat_scrape(log_flag=true,log_path="./videoid.txt")  
  
Parameters:  
&emsp;&emsp;&emsp;・log_flag:boolean (default=true)  
&emsp;&emsp;&emsp;　Whether to write chat list to file, write when true.  

&emsp;&emsp;&emsp;・log_path:string (default="./videoid.txt")  
&emsp;&emsp;&emsp;　File path to write chat list.  

Returns:  
&emsp;&emsp;&emsp;・chat_list:array  
&emsp;&emsp;&emsp;　Chat data list. Chat information is stored as dictionary data,  
&emsp;&emsp;&emsp;　and this dictionary data exists for the number of chats.  

&emsp;&emsp;&emsp; chat_list=[hash,hash,...]

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tf0101/VideoChatGet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VideoChatGet project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/video_chat_get/blob/master/CODE_OF_CONDUCT.md).
