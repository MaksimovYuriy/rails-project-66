class Repository < ApplicationRecord
    belongs_to :user

    extend Enumerize

    enumerize :language, in: %i[Ruby] 
end
