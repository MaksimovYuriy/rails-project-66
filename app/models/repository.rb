class Repository < ApplicationRecord
    extend Enumerize

    enumerize :language, in: %i[Ruby] 
end
