# frozen_string_literal: true

module RubyLexer
  class Lexer < LexerBase
    KEYWORDS = {
      "nil" => TokenType::NIL,
      "true" => TokenType::TRUE,
      "false" => TokenType::FALSE,
      "if" => TokenType::IF,
      "unless" => TokenType::UNLESS,
      "else" => TokenType::ELSE,
      "elsif" => TokenType::ELSIF,
      "while" => TokenType::WHILE,
      "until" => TokenType::UNTIL,
      "then" => TokenType::THEN,
      "do" => TokenType::DO,
      "repeat" => TokenType::REPEAT
    }.freeze

    def next_token
      skip_whitespace

      position = current_position
      return Token.new(TokenType::EOF, position, "EOF") if at_end?

      char = peek_char
      if digit?(char)
        scan_number(position)
      elsif alpha?(char)
        scan_identifier(position)
      elsif char == '"'
        scan_string(position)
      else
        scan_symbol(position)
      end
    end

    private

    def scan_identifier(start_position)
      identifier = read_identifier
      token_type = KEYWORDS[identifier] || TokenType::ID
      Token.new(token_type, start_position, identifier)
    end

    def scan_string(start_position)
      start_with_quotes = read_string('"')
      start_value = start_with_quotes[1...-1]
      Token.new(TokenType::STRING, start_position, start_value)
    end

    def scan_number(start_position)
      number_string = read_number

      if number_string.include?(".")
        Token.new(TokenType::FLOAT, start_position, number_string.to_f)
      else
        Token.new(TokenType::INTEGER, start_position, number_string.to_i)
      end
    end

    def scan_variable(start_position)
      start_position # доделать
    end

    def scan_symbol(start_position) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      start_token
      char = next_char

      case char
      when ","
        Token.new(TokenType::COMMA, start_position, ",")
      when ";"
        Token.new(TokenType::SEMICOLON, start_position, ";")
      when ":"
        Token.new(TokenType::COLON, start_position, ":")
      when "("
        Token.new(TokenType::LPAR, start_position, "(")
      when ")"
        Token.new(TokenType::RPAR, start_position, ")")
      when "{"
        Token.new(TokenType::LBRACE, start_position, "{")
      when "}"
        Token.new(TokenType::RBRACE, start_position, "}")
      when "."
        Token.new(TokenType::DOT, start_position, ".")
      when "+"
        Token.new(match?("=") ? TokenType::ASSIGN_PLUS : TokenType::PLUS, start_position, token_text)
      when "-"
        Token.new(match?("=") ? TokenType::ASSIGN_MINUS : TokenType::MINUS, start_position, token_text)
      when "*"
        Token.new(match?("=") ? TokenType::ASSIGN_MULT : TokenType::MULTIPLY, start_position, token_text)
      when "/"
        Token.new(match?("=") ? TokenType::ASSIGN_DIV : TokenType::DIVIDE, start_position, token_text)
      when "!"
        Token.new(match?("=") ? TokenType::NOT_EQUAL : TokenType::TK_NOT, start_position, token_text)
      when "="
        Token.new(match?("=") ? TokenType::EQUAL : TokenType::ASSIGN, start_position, token_text)
      when ">"
        Token.new(match?("=") ? TokenType::GREATER_EQUAL : TokenType::GREATER, start_position, token_text)
      when "<"
        Token.new(match?("=") ? TokenType::LESS_EQUAL : TokenType::LESS, start_position, token_text)
      when "&"
        raise BaseError::LexerError.new("Ожидался второй символ '&'", start_position) unless match?("&")

        Token.new(TokenType::TK_AND, start_position, "&&")
      when "|"
        raise BaseError::LexerError.new("Ожидался второй символ '|'", start_position) unless match?("|")

        Token.new(TokenType::TK_OR, start_position, "||")
      when "#"
        next_char while peek_char != "\n" && !at_end?
        next_token
        # when "@"
        # if match?("@")
        #  Token.new(TokenType::CLASS_VAR, start_position, )
        # end
      else
        raise BaseError::LexerError.new("Неизвестный символ #{char}", start_position)
      end
    end
  end
end
