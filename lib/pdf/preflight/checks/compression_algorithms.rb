# coding: utf-8

module PDF
  module Preflight
    module Checks

      # check a file only uses permitted compression algorithms
      #
      class CompressionAlgorithms

        def initialize(*algorithms)
          @algorithms = algorithms.flatten 
        end

        def message(ohash)
          algorithms = banned_algorithms(ohash)

          if algorithms.size > 0
            "File uses excluded compression algorithm (#{algorithms.join(", ")})"
          else
            nil
          end
        end

        private

        def banned_algorithms(ohash)
          array = []
          ohash.each do |key, obj|
            if obj.is_a?(PDF::Reader::Stream)
              filters = [obj.hash[:Filter]].flatten.compact
              array += (filters - @algorithms)
            end
          end
          array
        end
      end
    end
  end
end