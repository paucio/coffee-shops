

module Finder
  module Grids
    class Bar < Base
      def self.redis_key(x, y)
        "bar_grid:x:#{x}:y:#{y}"
      end
    end
  end
end