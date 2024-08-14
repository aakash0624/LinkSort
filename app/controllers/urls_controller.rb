class UrlsController < ApplicationController
  before_action :authentication
  before_action :search_url, only: [:show]
  before_action :set_url, only: [:show, :update, :destroy]

  #without 'net/http' => uninitialized constant Net::HTTP
  require 'net/http'

  skip_before_action :verify_authenticity_token

  def index
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
    @url = Url.new(set_url_params)

    @url.slug = SecureRandom.hex(2)

    #with the help of gsub method we can remove .com from the url.
    @url.website_name = URI.parse(@url.name).host.gsub(/(http:\/\/|https:\/\/|www\.|\.com)/, "")

      if @url.save!
        render json: @url, status: :created
      #end
      else
      render json: { message: "the request URLs #{@url.name} was not found on this server" },
      status: :unprocessable_entity
      end
  end

  def show
      render json: @url,
      status: :ok
  end

  def destroy
    if @url
      @url.destroy
      render json: { message: 'URL successfully deleted' }
    else
      render json: { error: 'URL not found' }, status: :not_found
    end
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
    params.require(:urls).permit(:name)
  end

  def search_url
    #Url.find_by use for find the id of the url and display it in the show
    @url = Url.find_by(id: params[:id])
    if @url.blank?
      render json: "ID not Present!"
    end
  end

  def set_url
    @url = Url.find_by(id: params[:id])
  end

end
