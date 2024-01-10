class TagsearchesController < ApplicationController
  def search
    @model = Book
    @word = params[:content]
    @books = Book.where("category LIKE ?", "%#{@word}%")
    puts "Word: #{@word}" # デバッグ用ログ
    puts "Books: #{@books.inspect}" # デバッグ用ログ
    render "tagsearches/tagsearch"
  end
end