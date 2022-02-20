class IdeasController < ApplicationController
  before_action :set_idea, only: %i[ show edit update destroy ]

  # GET /ideas or /ideas.json
  def index
    # @ideas = Idea.all
    @idea = Idea.new
    @q = Idea.ransack(params[:q])
    @ideas = @q.result(distinct: true).order("created_at DESC")
    @ideas = @ideas.filter_by_student_id(params[:student_id]) if params[:student_id].present?
    @ideas = @ideas.filter_by_realm(params[:realm_id]) if params[:realm_id].present?
    @realms = Realm.all

   #  @filterrific = initialize_filterrific(
   #   Idea,
   #   params[:filterrific]
   # ) or return
   # @ideas = @filterrific.find.page(params[:page])
  end

  # GET /ideas/1 or /ideas/1.json
  def show
    # @comment = Comment.new
    @ratings_data = @idea.ratings.collect{ |r| [r.impact, r.viability] }
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas or /ideas.json
  def create
    @idea = Idea.new(idea_params)

    respond_to do |format|
      if @idea.save
        format.html { redirect_to ideas_url, notice: "Idea was successfully created! Now do another!" }
        format.json { render :show, status: :created, location: @idea }
      else
        # format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1 or /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to idea_url(@idea), notice: "Idea was successfully updated." }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1 or /ideas/1.json
  def destroy
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to ideas_url, notice: "Idea was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea
      @idea = Idea.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def idea_params
      params.require(:idea).permit(:title, :content, :student_id, realm_ids:[], comment_ids:[], rating_ids:[])
    end
end
