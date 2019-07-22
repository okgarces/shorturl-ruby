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
    redirect_to @url ? @url.original : urls_url
  end

  def create
    original_url = params[:url]
    @new_url = Url.new(count: 0, original: original_url)

    message = @new_url.generated? ? "Url generated:  " + @new_url.get_full_short_url(urls_url) : "Error generating URL"
    begin
      render action: "create", message: message
    rescue
      render json: {message: message}
    end
  end
end
