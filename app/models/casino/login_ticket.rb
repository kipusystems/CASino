class Casino::LoginTicket < ActiveRecord::Base
  include Casino::ModelConcern::Ticket
  include Casino::ModelConcern::ConsumableTicket

  self.ticket_prefix = 'LT'.freeze

  def self.cleanup
    where('created_at < ?', Casino.config.login_ticket[:lifetime].seconds.ago).delete_all
  end

  def expired?
    (Time.now - (self.created_at || Time.now)) > Casino.config.login_ticket[:lifetime].seconds
  end
end
