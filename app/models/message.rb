class Message < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :to_account_name, presence: true
  validates :message, presence: true, length:{maximum: 200}
end
