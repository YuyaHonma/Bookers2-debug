# app/models/book.rb

class Book < ApplicationRecord
  belongs_to :user, optional: true
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  has_many :read_counts, dependent: :destroy
  has_many :view_counts, dependent: :destroy  # 追加する行

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
