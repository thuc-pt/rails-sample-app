class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.size.content}
  mount_uploader :picture, PictureUploader

  default_scope ->{order created_at: :desc}
  scope :select_posts, (lambda do |id|
    where "user_id in (?) or user_id = #{id}",
      Relationship.by_followed(id).pluck(:followed_id)
  end)
  delegate :name, to: :user
end
