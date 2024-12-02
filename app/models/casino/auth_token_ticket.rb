class Casino::AuthTokenTicket < ActiveRecord::Base
  include Casino::ModelConcern::Ticket
  include Casino::ModelConcern::ConsumableTicket

  self.ticket_prefix = 'ATT'.freeze

  def self.cleanup
    where('created_at < ?', Casino.config.auth_token_ticket[:lifetime].seconds.ago).delete_all
  end

  def expired?
    (Time.now - (self.created_at || Time.now)) > Casino.config.auth_token_ticket[:lifetime].seconds
  end

end
