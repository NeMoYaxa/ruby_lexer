# frozen_string_literal: true

module RubyLexer
  class BaseError < StandardError
    attr_reader :position

    def initialize(message, position)
      super(message)
      @position = position
    end

    class LexerError < BaseError
    end

    class ParseError < BaseError
    end

    class SemanticError < BaseError
    end

    class OutputError < BaseError
    end
  end
end
