require 'open-uri'

class TitleCrawlerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = URI.parse(args[0])
      open(url) do |f|
        page  = Nokogiri::HTML(f)
        title = page.css("title").text
        title =
            if title
              title
            else
             begin
               page.css("h1")[0].text
             rescue
               nil
             end
            end
            title ? title : page.css("h1")[0].text

          url_to_modify = Url.find_by_original(args[0])
          url_to_modify.title = title
          url_to_modify.save
    end
  end
end
