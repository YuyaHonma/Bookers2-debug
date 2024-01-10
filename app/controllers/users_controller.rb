class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

 def show
  @user = User.find(params[:id])
  @books = @user.books
  @book = Book.new
  @currentUserEntry = Entry.where(user_id: current_user.id)
  @userEntry = Entry.where(user_id: @user.id)
  @isRoom = false
  @roomId = nil

  unless @user.id == current_user.id
    @currentUserEntry.each do |cu|
      @userEntry.each do |u|
        if cu.room_id == u.room_id
          @isRoom = true
          @roomId = cu.room_id
          @room = Room.find_by(id: @roomId)
          @entry = Entry.new(room: @room, user: current_user) if @room.present?
        end
      end
    end
  end

  if @isRoom
  else
    @room = Room.new
    @entry = Entry.new(room: @room, user: current_user)
  end
end



  def index
    @users = User.all
    @book = Book.new
  end
  def edit
    @user = User.find(params[:id])
    
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end
  
    def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
