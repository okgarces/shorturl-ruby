require 'digest'
require 'cgi'

class Url < ApplicationRecord

  default_scope {order(count: :desc)}
  attribute :count

  def generated?
    if Url.exists?(original: self.original)
      false
    else
      generate_short
      true
    end
  end

  def generate_short
    initial=0
    end_url = 8
    digest = CGI::escape(Digest::MD5.base64digest(self.original))
    possible_short = ""

    for i in 0..digest.size-end_url do
      possible_short = String(digest[initial, end_url + i])

      # break if not short exists
      break unless short_url_exists?(possible_short)
    end
    self.short = String(possible_short)
    self.save!
  end

  def short_url_exists?(short_url)
    Url.exists?(short: short_url)
  end

  def get_full_short_url(base_url)
      base_url + "/"+ self.short
  end

end
