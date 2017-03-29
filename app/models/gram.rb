class Gram < ApplicationRecord
  validates :caption, presence: true, length: { in: 6..200 }
end
