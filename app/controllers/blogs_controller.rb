class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @photos = []
    unless @blog = Blog.find_by(id: params[:id])
      @blog = { url: params[:id] }
    end
    posts = HTTParty.post("https://api.tumblr.com/v2/blog/#{@blog.url}/posts?api_key=z3lrerYuy075yp74piNFYOInINGoxNk1jTMWd8YlrJTUxqNfB7").parsed_response['response']['posts']
    posts.each do |post|
      begin
        post['photos'].each do |photo|
          @photos << photo['alt_sizes'][0]['url']
        end
      rescue
        puts "PHOTO ERROR"
      end
    end
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def quick_create
    render 'quick.html'
  end

  def quick_post
    redirect_to blogs
  end

  def quick_show
    @photos = []
    @blog = Blog.new(title: "QUICK BLOG", url: params[:url])
    posts = HTTParty.post("https://api.tumblr.com/v2/blog/#{@blog.url}/posts?api_key=z3lrerYuy075yp74piNFYOInINGoxNk1jTMWd8YlrJTUxqNfB7").parsed_response['response']['posts']
    posts.each do |post|
      post['photos'].each do |photo|
        @photos << photo['alt_sizes'][0]['url']
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :url)
    end
end
