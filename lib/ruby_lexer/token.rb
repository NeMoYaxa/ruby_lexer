# frozen_string_literal: true

module RubyLexer
  class Token
    attr_reader :type, :position, :value

    def initialize(type, position, value)
      @type = type
      @position = position
      @value = value
    end
  end
end
