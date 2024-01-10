class GroupsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_correct_user, only: [:edit, :update]
  
    def index
      @book = Book.new
      @groups = Group.all
      @user = User.find(current_user.id)
    end
  
   def show
  @group = Group.find(params[:id])
  @user = @group.owner
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
        end
      end
    end
  end

  if @isRoom
    @room = Room.find(@roomId) # 既存のRoomを取得
  else
    @room = Room.new # 新しいRoomを作成
    @entry = Entry.new
  end
end


  
    def new
      @group = Group.new
    end
  
    def create
      @group = Group.new(group_params)
      @group.owner_id = current_user.id
      if @group.save
        redirect_to groups_path, method: :post
      else
        render 'new'
      end
    end
  
    def edit
    end
  
    def update
      if @group.update(group_params)
        redirect_to groups_path
      else
        render "edit"
      end
    end
    
    def destroy
    @group = Group.find(params[:id])

    # Leave ボタンがクリックされた場合の処理
    if @group.includes_user?(current_user)
      @group.group_users.find_by(user_id: current_user.id).destroy
      flash[:notice] = "You have left the group successfully."

      # グループ一覧画面にリダイレクト
      redirect_to groups_url
      return
    end

    # それ以外の場合は通常の destroy アクション
    @group.destroy
    flash[:notice] = "Group was successfully destroyed."

    # 通常のグループ詳細画面にリダイレクト
    redirect_to group_url(@group)
  end

  
    private
  
    def group_params
      params.require(:group).permit(:name, :introduction, :group_image)
    end
  
    def ensure_correct_user
      @group = Group.find(params[:id])
      unless @group.owner_id == current_user.id
        redirect_to groups_path
      end
    end
  end