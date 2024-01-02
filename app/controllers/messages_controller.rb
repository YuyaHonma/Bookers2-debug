class MessagesController < ApplicationController
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.new(message_params)
      @message.user = current_user
      if @message.save
        redirect_to room_path(@message.room), notice: 'メッセージを送信しました。'
      else
        flash[:alert] = 'メッセージの送信に失敗しました。'
        render :validate
      end
    else
      flash[:alert] = 'メッセージの送信に失敗しました。'
      render :validate
    end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :content)
  end
end
