# frozen_string_literal: true

module RubyLexer
  class Position
    attr_reader :line, :colum

    def initialize(line, colum)
      @line = line
      @colum = colum
    end
  end
end
