class Author < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :users, through: :microposts
end
