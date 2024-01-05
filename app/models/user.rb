class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :view_counts, dependent: :destroy
  
  has_many :follower_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :followed_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :following, through: :followed_relationships, source: :followed
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_one_attached :profile_image
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  def get_profile_image
    profile_image.attached? ? profile_image : 'no_image.jpg'
  end
  
  # ユーザーをフォローする
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  
  # フォローを外すとき
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしているか確認するとき
  def following?(user)
    following.include?(user)
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
  
end
