# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  session_token   :string
#
class User < ApplicationRecord
  attr_reader :password

  validates :session_token, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: { message: ' can\'t be blank' }
  # check the length of the password that is not hashed
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  # Association Between User and Cat
  has_many :cats,
           class_name: 'Cat',
           foreign_key: :user_id,
           primary_key: :id,
           dependent: :destroy
  # wen the user input a password directly runs to this password function to make it even more secure
  def password=(password)
    @password = password # set an instance method for storing the password and not persisted in the db
    self.password_digest = BCrypt::Password.create(password)
  end

  # check if the password is the password who is in the DB level
  def is_password!(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  # generate a session token every time we called this function
  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  # reset the session token every time we called this function
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    save!
    session_token
  end

  # find the user by credentials
  def self.find_by_credentials!(email, password)
    user = User.find_by(email: email) # find the user
    return nil if user.nil? # return nil if the user is not found

    user.is_password!(password) ? user : nil
  end

  def self.is_email_valid?(email)
    unless User.find_by(:email => email).nil?
      email
    end
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
