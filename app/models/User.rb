class User < ActiveRecord::Base
    has_secure_password
    has_many :entries

    validates_uniqueness_of :username
    validates_uniqueness_of :email
    validates :username, :email, presence: true
end