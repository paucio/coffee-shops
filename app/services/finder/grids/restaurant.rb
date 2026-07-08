# frozen_string_literal: true

module Finder
	module Grids
		class Restaurant < Base
			def self.redis_key(x, y)
				"restaurant_grid:x:#{x}:y:#{y}"
			end
		end
	end
end
