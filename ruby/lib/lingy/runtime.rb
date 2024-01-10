# frozen_string_literal: true

module Lingy
  module Runtime
    include Evaluation
  end

  RT = Object.new.extend(Runtime)
end
