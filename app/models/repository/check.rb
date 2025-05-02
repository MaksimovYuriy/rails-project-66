# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  belongs_to :repository

  include AASM

  aasm column: 'state' do
    state :created, initial: true
    state :cloning, :running, :successful, :failed

    event :to_clone do
      transitions from: :created, to: :cloning
    end

    event :run do
      transitions from: :cloning, to: :running
    end

    event :success do
      transitions from: :running, to: :successful
    end

    event :fail do
      transitions from: %i[created cloning running], to: :failed
    end
  end
end
