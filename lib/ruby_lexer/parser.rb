# frozen_string_literal: true

module RubyLexer
  class Parser < ParserBase
    COMPARISON_OPERATORS = [
      TokenType::EQUAL, TokenType::NOT_EQUAL,
      TokenType::LESS, TokenType::LESS_EQUAL,
      TokenType::GREATER, TokenType::GREATER_EQUAL
    ].freeze

    ADDITIVE_OPERATORS = [
      TokenType::PLUS, TokenType::MINUS, TokenType::TK_OR
    ].freeze

    MULTIPLICATIVE_OPERATORS = [
      TokenType::MULTIPLY, TokenType::DIVIDE, TokenType::TK_AND
    ].freeze

    ASSIGNMENT_OPERATORS = {
      TokenType::ASSIGN => "=",
      TokenType::ASSIGN_PLUS => "+=",
      TokenType::ASSIGN_MINUS => "-=",
      TokenType::ASSIGN_MULT => "*=",
      TokenType::ASSIGN_DIV => "/="
    }.freeze

    def parse
      main_program
    end

    def main_program
      program = statement_list
      require_token(TokenType::EOF)
      program
    end

    # StatementList := [Statement (';' Statement)* [';']]
    # Допускает пустые блоки и завершающую точку с запятой.
    def statement_list
      position = @current_token.position
      statements = []

      until at?(TokenType::EOF, TokenType::RBRACE, TokenType::UNTIL)
        statements << statement
        break unless match?(TokenType::SEMICOLON)

        # Несколько ';' подряд и ';' перед закрывающим токеном допустимы.
        next while match?(TokenType::SEMICOLON)
      end

      StatementListNode.new(statements, position)
    end

    def statement
      position = current_token.position

      if match?(TokenType::IF)
        condition = expression
        require_token(TokenType::THEN)
        then_statement = statement
        else_statement = match?(TokenType::ELSE) ? statement : nil
        return IfNode.new(condition, then_statement, else_statement, position)
      end

      if match?(TokenType::WHILE)
        condition = expression
        require_token(TokenType::DO)
        return WhileNode.new(condition, statement, position)
      end

      if match?(TokenType::REPEAT)
        body = statement_list
        require_token(TokenType::UNTIL)
        return RepeatNode.new(body, expression, position)
      end

      if match?(TokenType::LBRACE)
        body = statement_list
        require_token(TokenType::RBRACE)
        return body
      end

      identifier = ident
      if at?(*ASSIGNMENT_OPERATORS.keys)
        operator = ASSIGNMENT_OPERATORS.fetch(next_token.type)
        return AssignNode.new(identifier, expression, position, operator: operator)
      end

      if match?(TokenType::LPAR)
        arguments = expression_list
        require_token(TokenType::RPAR)
        return ProcCallNode.new(identifier, arguments, position)
      end

      expected_error(TokenType::ASSIGN, TokenType::ASSIGN_PLUS,
                     TokenType::ASSIGN_MINUS, TokenType::ASSIGN_MULT,
                     TokenType::ASSIGN_DIV, TokenType::LPAR)
    end

    def expression_list
      expressions = []
      return ExprListNode.new(expressions, current_token.position) if at?(TokenType::RPAR)

      expressions << expression
      expressions << expression while match?(TokenType::COMMA)
      ExprListNode.new(expressions)
    end

    def ident
      token = require_token(TokenType::ID)
      IdNode.new(token.value, token.position)
    end

    # Expr := Comp (CompOp Comp)*
    def expression
      node = comp
      while at?(*COMPARISON_OPERATORS)
        operator = next_token
        node = BinOpNode.new(node, comp, operator.value, node.position)
      end
      node
    end

    # Comp := Term (('+' | '-' | '||') Term)*
    def comp
      node = term
      while at?(*ADDITIVE_OPERATORS)
        operator = next_token
        node = BinOpNode.new(node, term, operator.value, node.position)
      end
      node
    end

    # Term := Factor (('*' | '/' | '&&') Factor)*
    def term
      node = factor
      while at?(*MULTIPLICATIVE_OPERATORS)
        operator = next_token
        node = BinOpNode.new(node, factor, operator.value, node.position)
      end
      node
    end

    # Factor := number | string | boolean | nil | '(' Expr ')' | Id | FuncCall
    def factor
      token = current_token

      case token.type
      when TokenType::INTEGER
        next_token
        IntNode.new(token.value, token.position)
      when TokenType::FLOAT
        next_token
        DoubleNode.new(token.value, token.position)
      when TokenType::STRING
        next_token
        StringNode.new(token.value, token.position)
      when TokenType::TRUE, TokenType::FALSE
        next_token
        BooleanNode.new(token.type == TokenType::TRUE, token.position)
      when TokenType::NIL
        next_token
        NilNode.new(token.position)
      when TokenType::LPAR
        next_token
        node = expression
        require_token(TokenType::RPAR)
        node
      when TokenType::ID
        identifier = ident
        return identifier unless match?(TokenType::LPAR)

        arguments = expression_list
        require_token(TokenType::RPAR)
        FuncCallNode.new(identifier, arguments, identifier.position)
      else
        raise BaseError::ParseError.new(
          "Ожидалось выражение, но #{token.type} найдено",
          token.position
        )
      end
    end
  end
end
