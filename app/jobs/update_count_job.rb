class UpdateCountJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # This can be improved
    # I can create a new model as a log to create each time someone access to an URL
    # Then this task can update or create the report
    url_to_modify = Url.find_by_original(args[0])

    if url_to_modify
      url_to_modify.count += 1
      url_to_modify.save
    end

  end
end
