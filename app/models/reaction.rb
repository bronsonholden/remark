class Reaction < ApplicationRecord
  validates :kind, uniqueness: {scope: [:remark_id, :user_id]}

  belongs_to :remark
  belongs_to :user

  enum kind: {
    like: 0,
    dislike: 1
  }
end
