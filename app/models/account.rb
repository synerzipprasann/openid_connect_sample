class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :phone_number, :dob, :verified
  has_one :facebook, class_name: 'Connect::Facebook'
  has_one :google,   class_name: 'Connect::Google'
  has_one :fake,     class_name: 'Connect::Fake'
  has_many :clients
  has_many :access_tokens
  has_many :authorizations
  has_many :id_tokens
  has_many :pairwise_pseudonymous_identifiers

  before_validation :setup, on: :create

  validates :identifier, presence: true, uniqueness: true

  def to_response_object(access_token)
    userinfo = (google || facebook || fake).userinfo
    unless access_token.accessible?(Scope::PROFILE)
      userinfo.all_attributes.each do |attribute|
        userinfo.send("#{attribute}=", nil) unless access_token.accessible?(attribute)
      end
    end
    userinfo.email        = nil unless access_token.accessible?(Scope::EMAIL)   || access_token.accessible?(:email)
    userinfo.address      = nil unless access_token.accessible?(Scope::ADDRESS) || access_token.accessible?(:address)
    userinfo.phone_number = nil unless access_token.accessible?(Scope::PHONE)   || access_token.accessible?(:phone)
    userinfo.subject = if access_token.client.ppid?
      ppid_for(access_token.client.sector_identifier).identifier
    else
      identifier
    end
    userinfo
  end

  def ppid_for(sector_identifier)
    self.pairwise_pseudonymous_identifiers.find_or_create_by_sector_identifier! sector_identifier
  end

  private

  def setup
    self.identifier = SecureRandom.hex(8)
  end
end