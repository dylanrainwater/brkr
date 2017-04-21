class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50}
  # Regex matches valid emails:
  # (any word, +, -, or .)@(at least a letter, -, #, or .).(at least a letter)
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
end
