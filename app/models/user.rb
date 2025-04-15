class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[github]

  after_create :send_welcome_email

  has_many :authored_posts, class_name: "Post", foreign_key: "author_id"
  has_many :likes, dependent: :destroy

  has_many :followed_by, foreign_key: :followed_user_id, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :followed_by, source: :follower

  has_many :following_user, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
  has_many :following, through: :following_user, source: :followed_user

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.display_name = auth.info.name   # assuming the user model has a name
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
