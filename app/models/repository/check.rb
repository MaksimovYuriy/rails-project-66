class Repository::Check < ApplicationRecord
  belongs_to :repository

  include AASM

  aasm column: 'state' do

    state :created, initial: true
    state :cloning, :running, :completed, :failed

    event :to_clone do
      transitions from: :created, to: :cloning
    end

    event :run do
      transitions from: :cloning, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed
    end

    event :fail do
      transitions from: [:created, :cloning, :running], to: :failed
    end

  end

end
