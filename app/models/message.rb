class Message < ApplicationRecord
  after_create :send_message

  def data=(value)
    super(value.to_json)
  end

  private

  def send_message
    SendMessageJob.perform_now(self)
  end
end
