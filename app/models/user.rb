class User < ApplicationRecord
  has_many :todos, foreign_key: :created_by, dependent: :destroy

  validates_presence_of :name, :email, :password_digest
end
