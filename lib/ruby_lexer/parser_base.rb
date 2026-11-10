# frozen_string_literal: true

module RubyLexer
  class ParserBase
    attr_reader :lexer, :current_token

    def initialize(lexer)
      @lexer = lexer
      @current_token = @lexer.next_token
    end

    def next_token
      token = @current_token
      @current_token = @lexer.next_token
      token
    end

    def peek_token
      @current_token
    end

    def at?(*token_types)
      token_types.include?(current_token.type)
    end

    def match?(*types)
      return false unless at?(*types)

      next_token
      true
    end

    def require_token(*types)
      return next_token if at?(*types)

      expected_error(*types)
    end

    def check(*types)
      return true if at?(*types)

      expected_error(*types)
    end

    def at_end?
      at?(TokenType::EOF)
    end

    def expected_error(*types)
      expected = types.join(" или ")
      actual = current_token.type

      raise BaseError::ParseError.new(
        "#{expected} ожидалось, но #{actual} найдено",
        current_token.position
      )
    end
  end
end
