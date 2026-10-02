# frozen_string_literal: true

module RubyLexer
  module TokenType
    INTEGER = :integer
    FLOAT = :float
    STRING = :string

    ID = :id
    INSTANCE_VAR = :instance_var      # @name
    CLASS_VAR    = :class_var         # @@name
    GLOBAL_VAR   = :global_var        # $name

    PLUS = :plus
    MINUS = :minus
    MULTIPLY = :multiply
    DIVIDE = :divide
    DOT = :dot

    LPAR = :lpar
    RPAR = :rpar
    LBRACE = :lbrace
    RBRACE = :rbrace
    COMMA = :comma
    COLON = :colon
    # DOUBLE_COLON = :double_colon

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

    TK_AND = :tk_and
    TK_OR = :tk_or
    TK_NOT = :tk_not
    TK_BIT_AND = :tk_bit_and
    TK_BI_TOR = :tk_bit_or

    EOF = :eof
    COMMENT = :comment

    NIL = :nil
    TRUE = :true
    FALSE = :false
    IF = :if
    UNLESS = :unless
    THEN = :then
    ELSE = :else
    ELSIF = :elsif
    WHILE = :while
    UNTIL = :until
  end
end
