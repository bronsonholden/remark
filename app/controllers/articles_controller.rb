class ArticlesController < ApplicationController
  before_action :require_admin
  before_action :set_article, only: %i[show edit update destroy]
  before_action :set_articles, only: :index

  def new
    @article = Article.new(author: current_user)
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash.discard
      redirect_to article_path(@article)
    else
      flash[:error] = @article.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    render :show, layout: "blog"
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash.discard
      redirect_to article_path(@article)
    else
      flash[:error] = @article.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
  end

  def index
  end

  private

  def article_params
    params.require(:article).permit(:title, :source, :status, :author_id, :slug)
  end

  def set_article
    @article = Article.find_by!(slug: params.require(:id))
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = e.message
    redirect_to articles_path
  end

  def set_articles
    @articles = Article.all
  end
end
