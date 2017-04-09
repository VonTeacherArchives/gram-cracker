class Like < ApplicationRecord
  belongs_to :gram
  belongs_to :user
  validates :user_id, uniqueness: { scope: :gram_id }
end
