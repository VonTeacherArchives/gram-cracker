class Comment < ApplicationRecord
  validates :message, presence: true, length: { in: 10..140}
  belongs_to :gram
  belongs_to :user
end
