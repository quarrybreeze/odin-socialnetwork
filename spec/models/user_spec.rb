require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let(:user) { User.new(email: 'test@example.com', password: 'password123') }

    it "requires an email" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a unique email (case insensitive)" do
      User.create!(email: 'TEST@example.com', password: 'password123')
      user.email = 'test@example.com'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "requires a password" do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "requires password to meet minimum length" do
      user.password = 'short'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is #{Devise.password_length.min} characters)")
    end
  end

  describe "associations" do
    let(:user) { User.create(email: 'test@example.com', password: 'password123') }

    describe "#authored_posts" do
      it "can have many posts" do
        post1 = Post.create(body: 'Post 1', author: user)
        post2 = Post.create(body: 'Post 2', author: user)
        expect(user.authored_posts).to match_array([ post1, post2 ])
      end
    end

    describe "#likes" do
      it "can have many likes" do
        post = Post.create(body: 'Test post', author: user)
        post2 = Post.create(body: 'Test post', author: user)
        like1 = Like.create(liker: user, post: post)
        like2 = Like.create(liker: user, post: post2)
        expect(user.likes).to match_array([ like1, like2 ])
      end

      it "destroys associated likes when user is destroyed" do
        post = Post.create(body: 'Test post', author: user)
        like = Like.create(liker: user, post: post)
        expect { user.destroy }.to change { Like.count }.by(-1)
      end
    end

    describe "follower relationships" do
      let(:follower) { User.create(email: 'follower@example.com', password: 'password123') }

      it "can be followed by many users" do
        follow = Follow.create(follower: follower, followed_user: user)
        expect(user.followers).to include(follower)
      end

      it "destroys associated follows when user is destroyed" do
        Follow.create(follower: follower, followed_user: user)
        expect { user.destroy }.to change { Follow.count }.by(-1)
      end
    end

    describe "following relationships" do
      let(:followed_user) { User.create(email: 'followed@example.com', password: 'password123') }

      it "can follow many users" do
        follow = Follow.create(follower: user, followed_user: followed_user)
        expect(user.following).to include(followed_user)
      end

      it "destroys associated follows when user is destroyed" do
        Follow.create(follower: user, followed_user: followed_user)
        expect { user.destroy }.to change { Follow.count }.by(-1)
      end
    end
  end

  describe "Devise modules" do
    it "includes database_authenticatable module" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "includes registerable module" do
      expect(User.devise_modules).to include(:registerable)
    end

    it "includes recoverable module" do
      expect(User.devise_modules).to include(:recoverable)
    end

    it "includes rememberable module" do
      expect(User.devise_modules).to include(:rememberable)
    end

    it "includes validatable module" do
      expect(User.devise_modules).to include(:validatable)
    end

    it "includes omniauthable module" do
      expect(User.devise_modules).to include(:omniauthable)
    end
  end

  describe "callbacks" do
    let(:user) { User.new(email: 'test@example.com', password: 'password123') }

    it "sends welcome email after create" do
      allow(user).to receive(:send_welcome_email)
      user.save!
      expect(user).to have_received(:send_welcome_email)
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '12345',
        info: {
          email: 'test@example.com',
          name: 'Test User',
          image: 'http://example.com/avatar.jpg'
        }
      )
    end

    context "when user doesn't exist" do
      it "creates a new user" do
        expect {
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)
      end

      it "sets user attributes from auth hash" do
        user = User.from_omniauth(auth)
        expect(user.provider).to eq('github')
        expect(user.uid).to eq('12345')
        expect(user.email).to eq('test@example.com')
        expect(user.display_name).to eq('Test User')
        expect(user.picture_url).to eq('http://example.com/avatar.jpg')
      end

      it "generates a password for the user" do
        user = User.from_omniauth(auth)
        expect(user.password).to be_present
      end
    end

    context "when user already exists" do
      before do
        User.create!(
          provider: 'github',
          uid: '12345',
          email: 'existing@example.com',
          password: 'password'
        )
      end

      it "doesn't create a new user" do
        expect {
          User.from_omniauth(auth)
        }.not_to change(User, :count)
      end

      it "returns the existing user" do
        user = User.from_omniauth(auth)
        expect(user.email).to eq('existing@example.com')
      end
    end
  end

  describe ".new_with_session" do
    let(:params) { {} }
    let(:session) do
      {
        "devise.github_data" => {
          "extra" => {
            "raw_info" => {
              "email" => "github@example.com"
            }
          }
        }
      }
    end

    it "sets email from session data when email is blank" do
      user = User.new_with_session(params, session)
      expect(user.email).to eq("github@example.com")
    end

    it "doesn't override email when already present in params" do
      user = User.new_with_session({ email: "param@example.com" }, session)
      expect(user.email).to eq("param@example.com")
    end
  end

  describe "#send_welcome_email" do
    let(:user) { User.create(email: 'test@example.com', password: 'password123') }

    it "sends welcome email" do
      expect(UserMailer).to receive(:welcome_email).with(user).and_call_original
      user.send(:send_welcome_email)
    end
  end
end
