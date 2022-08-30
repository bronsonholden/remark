class BlogController < ApplicationController
  layout "blog"

  def index
    @articles = Article.published.order(created_at: :desc)
    render :index, locals: { search_enabled: false }
  end

  def show
    @article = Article.published.find_by(slug: params.require(:slug))
    if @article.present?
      render :show, locals: { search_enabled: false }
    else
      flash[:error] = "No article found"
      redirect_to blog_path
    end
  end
end
