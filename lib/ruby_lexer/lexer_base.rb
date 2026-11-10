# frozen_string_literal: true

module RubyLexer
  class LexerBase
    attr_reader :code

    def initialize(code)
      @code = code # код программы
      @line = 1 # текущая строка
      @column = 1 # текущий столбец
      @current = 0 # текущая позиция
      @token_start = 0 # начальная позиция токена
      @at_eoln = false # сервисное поле для метода next_char
    end

    protected

    def current_position
      Position.new(@line, @column)
    end

    def at_end?
      @current >= @code.length
    end

    def token_text
      @code[@token_start...@current]
    end

    def start_token
      @token_start = @current
    end

    # Вернуть текущий символ
    def peek_char
      return "\0" if at_end?

      @code[@current]
    end

    # Вернуть следующий символ
    def peek_next_char
      @current + 1 >= @code.length ? "\0" : @code[@current + 1]
    end

    # Возвращает текущий символ и переходит в следующему
    def next_char
      char = peek_char

      return if char == "\0"

      if char == "\n"
        @line += 1
        @column = 1
        @at_eoln = true
      else
        @column += 1
        @at_eoln = false
      end

      @current += 1
      char
    end

    # Вернуть ожидаемый символ
    def match?(expected)
      return false if peek_char != expected

      next_char
      true
    end

    # Пропустить все пробельные символы
    def skip_whitespace
      next_char while whitespace?(peek_char) && !at_end?
    end

    # Является ли символ пробельным
    def whitespace?(char)
      [" ", "\t", "\n", "\r"].include?(char)
    end

    # Является ли символ буквой
    def alpha?(char)
      char.match?(/\A(?:\p{L}|_)\z/)
    end

    # Является ли символ числом
    def digit?(char)
      char.match?(/\A\d\z/)
    end

    # Является ли символ буквой или цифрой
    def alpha_numeric?(char)
      alpha?(char) || digit?(char)
    end

    # Прочитать число (целое или вещественное)
    def read_number
      start_token

      next_char while digit?(peek_char)

      if peek_char == "." && digit?(peek_next_char)
        next_char
        next_char while digit?(peek_char)
      end

      token_text
    end

    # Прочитать индентификатор
    def read_identifier
      start_token

      if alpha?(peek_char)
        next_char
        next_char while alpha_numeric?(peek_char)
      end

      token_text
    end

    # Прочитать строку
    def read_string(quote_char = '"')
      start_token

      if match?(quote_char)
        next_char while (peek_char != quote_char) && !at_end?

        raise BaseError::LexerError.new("Незавершенная строковая константа", current_position) unless match?(quote_char)
      end

      token_text
    end

    # Прочитать переменную
    # def read_variable
    # start_token
    # end
  end
end
