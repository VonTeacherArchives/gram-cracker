class Gram < ApplicationRecord
  validates :caption, presence: true, length: { in: 6..200 }
  belongs_to :user
  mount_uploader :picture, PictureUploader
end
