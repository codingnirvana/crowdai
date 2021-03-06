class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized


  def index
    @query = Article.ransack(params[:q])
    @articles = policy_scope(@query.result)
    authorize @articles
  end


  def show
    @article.record_page_view
    @comments = @article.comments
    load_gon
  end


  def new
    @article = Article.new
    authorize @article
  end


  def edit
    load_gon
  end


  def create
    if current_participant
      @article = current_participant.articles.new(article_params)
      authorize @article
    else
      raise Pundit::NotAuthorizedError
    end

    if @article.save
      @article.article_sections.create!(section: 'Introduction', icon: 'home', seq: 1)
      redirect_to @article
    else
      render :new
    end
  end


  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end


  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully deleted.'
  end

  def articles_filter
    Article::CATEGORIES.sort.map {|k,v| [v,k]}
  end


  private
    def set_article
      @article = Article.friendly.find(params[:id])
      authorize @article
    end


    def article_params
      params.require(:article).permit(:article, :user_id, :published, :category, :summary, :participant_id,
                    article_sections_attributes: [:id, :article_id, :seq, :icon, :section, :description_markdown ],
                    image_attributes: [:id, :image, :_destroy ])
    end
end
