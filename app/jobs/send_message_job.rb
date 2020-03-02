class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    child(message).deliver
  end

  private

  # Shit style, can parent get a children directly?
  def child(message)
    message.type.constantize.find(message.id)
  end
end
