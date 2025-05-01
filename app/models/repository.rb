# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks, dependent: :destroy

  extend Enumerize

  enumerize :language, in: %i[Ruby]
end
