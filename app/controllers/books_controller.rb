class BooksController < ApplicationController
  

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @book_comment = BookComment.new
    @book_detail = Book.find(params[:id])

    # 閲覧数をインクリメントする処理
    if current_user && !ViewCount.exists?(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book: @book_detail)
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day

    # いいねが多い順にBookレコードを取得
    @books = Book.includes(:favorites)
                 .sort_by { |book| -book.favorites.where(created_at: from...to).count }

    @book = Book.new
  end

  def create
  @book = Book.new(book_params)
  @book.user_id = current_user.id

  if @book.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book)
  else
    @books = Book.all
    render :index
  end
end

  def edit
    @book = Book.find(params[:id])
    if current_user != @book.user
      redirect_to books_path, alert: "You are not authorized to edit this user."
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "You have deleted book successfully."
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
