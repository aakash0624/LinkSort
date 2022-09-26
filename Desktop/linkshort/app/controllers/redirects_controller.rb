class RedirectsController < ApplicationController


  #find the slug of the url and display it in the show page.
  def redirect
    @url = Url.find_by(slug: params[:url_id])

    #count the number of times the url is clicked.
    if @url.present?
      # @url.count += 1
      # @url.save!
      puts "------------------------"
      puts request.env['HTTP_USER_AGENT']
      ClickCountWorker.perform_async(@url.id)
      redirect_to @url.name, allow_other_host: true

    else
      render json: "Url not found"
    end
  end

end
