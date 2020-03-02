class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    message = child(message)
    message.deliver
    message.destroy
  end

  private

  # Shit style, can parent get a children directly?
  def child(message)
    message.type.constantize.find(message.id)
  end
end
