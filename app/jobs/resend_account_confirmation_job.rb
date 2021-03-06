class ResendAccountConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    participant = Participant.find(participant_id)
    participant.send_confirmation_instructions
  end
end
