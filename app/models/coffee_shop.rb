class CoffeeShop < ApplicationRecord
    validates :name, presence: true
    validates :x, presence: true
    validates :y, presence: true

    validates :x, uniqueness: { scope: :y }
end
