class ChangeUserAgentToText < ActiveRecord::Migration[7.2]
  def change
    change_column :casino_ticket_granting_tickets, :user_agent, :text
  end
end
