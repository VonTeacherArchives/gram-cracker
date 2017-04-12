class Gram < ApplicationRecord
  validates :caption, presence: true, length: { in: 6..200 }
  validates :picture, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  mount_uploader :picture, PictureUploader

  def as_json( options={} )
    super(options).merge(:likes => self.likes.count)
  end
end
