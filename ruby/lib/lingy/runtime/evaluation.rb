# frozen_string_literal: true

require_relative '../reader'

module Lingy
  module Runtime
    module Evaluation
      def read_string(string)
        array = []
        Reader.new(string).tap do |r|
          until r.eof?
            form = r.next!
            next if form == r

            array << form
          end
        end
        array
      end
    end
  end
end
