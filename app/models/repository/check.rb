class Repository::Check < ApplicationRecord
  belongs_to :repository

  include AASM

  aasm column: 'state' do

    state :in_process, initial: true
    state :completed

    event :complete do
      transitions from: :in_process, to: :completed
    end

  end

end
