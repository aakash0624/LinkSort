class UrlsController < ApplicationController
  before_action :authentication
  before_action :search_url, only: [:show]

  #without 'net/http' => uninitialized constant Net::HTTP
  require 'net/http'

  #skip the authenticity token.
  skip_before_action :verify_authenticity_token

  #display all the data in the database.
  def index
    # searchUrl is used to search the url in the database.
    if params[:s].present?
      @searchUrl = Url.where("name LIKE ?", "%" + params[:s] + "%")
      if @searchUrl.present?
        render json: @searchUrl, status: :ok
      else
        render json: {message: "No record found"}
      end
    else
      urls = Url.paginate(page: params[:page], per_page: 3)
      render json: urls, status: :ok
    end
  end

  def create
    #create a new record in the database.
    @url = Url.new(set_url_params)

    # generate random string and number and assign it to slug column in the database table.
    @url.slug = SecureRandom.hex(2)

    #this will trime only the https:// and www. from the url.
    # @url.website_name = URI.parse(@url.name).host

    #with the help of gsub method we can remove .com from the url.
    @url.website_name = URI.parse(@url.name).host.gsub(/(http:\/\/|https:\/\/|www\.|\.com)/, "")

    # binding.irb

    # urlCheck = URI.parse(@url.name)
    # req = Net::HTTP.new(urlCheck.host, urlCheck.port)
    # req.use_ssl = true
    # path = urlCheck.path if urlCheck.path.present?
    # res = req.request_head(path || '/')

    #if res.code == "200"
      if @url.save!
        render json: @url, status: :created
      #end
      else
      render json: { message: "the request URLs #{@url.name} was not found on this server" },
      status: :unprocessable_entity
      end
  end

  #display the details of the url in the show page.
  def show
      render json: @url,
      status: :ok
  end

  #top_url method is used to display the top 3 count urls in the database.
  def top_urls
    top_url = Url.order("count DESC").limit(3)
    render json: top_url, status: :ok
  end

  def top_level_domain
    #count all top level domains in the database.
    urlArr = []
    urls = Url.all.pluck(:name)
    urls.each do |actualUrl|
      uri = URI(actualUrl)
      uri = uri.host
      urlArr << uri.split(".")[1]
    end
    top_level_domain =  Hash[urlArr.uniq.map {|value| [value, urlArr.count(value)]}]
    render json: top_level_domain, status: :ok
  end

  # used to prevent the mass assignment vulnerability.
  private
  def set_url_params
    params.require(:url).permit(:name)
  end

  def search_url
    #Url.find_by use for find the id of the url and display it in the show
    @url = Url.find_by(id: params[:id])
    if @url.blank?
      render json: "ID not Present!"
    end
  end

end
