class PrototypesController < ApplicationController
  before_action :set_prototype , only: [:destroy, :update]
  before_action :authenticate_user! , only: [:new, :edit, :destroy]
  before_action :move_to_index ,only: :edit

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      @prototype = Prototype.new(prototype_params)
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit

    @prototype = Prototype.find(params[:id])
  end

  def update
    if prototype.update(prototype_params)
      redirect_to  prototype_path(params[:id])
    else
      @prototype = Prototype.find(params[:id])
      render :edit
    end
  end

  def destroy
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def set_prototype
    prototype = Prototype.find(params[:id])
  end
end
