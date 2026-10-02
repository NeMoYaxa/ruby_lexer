# frozen_string_literal: true

module RubyLexer
  class Position
    attr_reader :line, :column

    def initialize(line, column)
      @line = line
      @column = column
    end
  end
end
