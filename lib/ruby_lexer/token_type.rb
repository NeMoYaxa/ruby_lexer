# frozen_string_literal: true

module RubyLexer
  module TokenType
    INT = :int
    DOUBLE_LITERAL = :double_literal
    STRING_LITERAL = :string_literal

    ID = :id

    PLUS = :plus
    MINUS = :minus
    MULTIPLY = :multiply
    DIVIDE = :divide
    DOT = :dot

    SEMICOLON = :semicolon
    LPAR = :lpar
    RPAR = :rpar
    LBRACE = :lbrace
    RBRACE = :rbrace
    COMMA = :comma
    COLON = :colon

    ASSIGN = :assign
    ASSIGN_PLUS = :assign_plus
    ASSIGN_MINUS = :assign_minus
    ASSIGN_MULT = :assign_mult
    ASSIGN_DIV = :assign_div

    EQUAL = :equal
    LESS = :less
    LESS_EQUAL = :less_equal
    GREATER = :greater
    GREATER_EQUAL = :greater_equal
    NOT_EQUAL = :not_equal

    AND = :and
    OR = :or
    NOT = :not

    EOF = :eof

    TRUE = :true
    FALSE = :false
    IF = :if
    THEN = :then
    ELSE = :else
    WHILE = :while
    DO = :do
  end
end
