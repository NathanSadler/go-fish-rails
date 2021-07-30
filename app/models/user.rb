class User < ApplicationRecord
  has_many :game_users
  has_many :games, through: :game_users
  before_save {self.email = email.downcase}

  
  validates(:name, {presence: true, length: {maximum:50}})

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, {presence: true, length: {maximum:255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}})

  has_secure_password
  validates(:password, {presence: true, length: {minimum: 6}})

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def tie_count
    won_gameusers = GameUser.where(user_id: id, is_game_winner: true)

    # Get gameusers where the user did not win
    other_winner_gameusers = GameUser.where.not(user_id: id).where(is_game_winner: true)

    # Get gamesusers from won_gameusers where the ID of the won_gameuser is in other_winner_gameusers
    tied_games = won_gameusers.select {|gameuser| other_winner_gameusers.map(&:game_id).include?(gameuser.game_id)}
    tied_games.length
  end

  def loss_count
    GameUser.where(user_id: id, is_game_winner: false).count
  end

  def win_count
    GameUser.where(user_id: id, is_game_winner: true).count - tie_count
  end
end
