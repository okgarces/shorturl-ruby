class UrlController < ApplicationController
  skip_before_action :verify_authenticity_token


  def to_json(url)
    Hash(title: url.title, short_url: url.short, original_url: url.original, count: url.count)
  end

  def list
    urls = Url.all
    if request.headers["Accept"]  == 'application/json'
      h = urls.collect { |v| [ to_json(v) ] }.flatten
      render json: {list_urls: h}
    end
    @urls = urls
  end

  def find_by_short
    @url = Url.find_by_short(params[:id])

    if @url
      UpdateCountJob.perform_later(@url.original) # Create a job and do not block the user and scale through a queue
      redirect_to @url.original
    else
      redirect_to urls_url
    end

  end

  def create
    original_url = params[:url]
    @new_url = Url.new(count: 0, original: original_url)

    if @new_url.generated?
      message = "Url generated:  " + @new_url.get_full_short_url(urls_url)
      TitleCrawlerJob.perform_later(@new_url.original)
    else
      message = "Error generating URL"
    end

    begin
      render action: "create", message: message
    rescue
      render json: {message: message}
    end
  end
end
