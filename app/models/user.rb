class User < ApplicationRecord
  has_secure_password
  # validates :name, presence: true
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true,
  #                   length: { maximum: Settings.user.email.max_length, message: 'Do dai email vuot qua gia tri cho phep' },
  #                   format: { with: VALID_EMAIL_REGEX },
  #                   uniqueness: true
  # validates :name, inclusion: { in: %w(phuong loi hao),
  #                  message: "%{value} is reserved." }, allow_nil: true
  # validates :name, length: { is: 5 }, allow_nil: true
  # validates :email, uniqueness: true, if: :name_of_phuong?
  before_save :init_data
  after_save :destroy_other_record

  def init_data
    self.phone_number = '0367279755'
    self.age = 33
  end

  def destroy_other_record
    User.where.not(id: id).destroy_all
  end
end
