# frozen_string_literal: true

module RubyLexer
  class Node
    attr_reader :position

    def initialize(position = nil)
      @position = position
    end

    def accept(visitor)
      visitor.public_send("visit_#{self.class.name.split("::").last.gsub(/([a-z])([A-Z])/, '\\1_\\2').downcase}", self)
    end
  end

  class ExprNode < Node; end
  class StatementNode < Node; end

  class StatementListNode < StatementNode
    attr_reader :statements

    def initialize(statements = [], position = nil)
      super(position)
      @statements = statements
    end

    def add(statement)
      @statements << statement
      self
    end
  end

  class ExprListNode < Node
    attr_reader :expressions

    def initialize(expressions = [], position = nil)
      super(position)
      @expressions = expressions
    end

    def add(expression)
      @expressions << expression
      self
    end
  end

  class IntNode < ExprNode
    attr_reader :value

    def initialize(value, position = nil)
      super(position)
      @value = value
    end
  end

  class DoubleNode < ExprNode
    attr_reader :value

    def initialize(value, position = nil)
      super(position)
      @value = value
    end
  end

  class StringNode < ExprNode
    attr_reader :value

    def initialize(value, position = nil)
      super(position)
      @value = value
    end
  end

  class BooleanNode < ExprNode
    attr_reader :value

    def initialize(value, position = nil)
      super(position)
      @value = value
    end
  end

  class NilNode < ExprNode; end

  class IdNode < ExprNode
    attr_reader :name

    def initialize(name, position = nil)
      super(position)
      @name = name
    end
  end

  class BinOpNode < ExprNode
    attr_reader :left, :right, :operator

    def initialize(left, right, operator, position = nil)
      super(position)
      @left = left
      @right = right
      @operator = operator
    end
  end

  class AssignNode < StatementNode
    attr_reader :ident, :expression, :operator

    def initialize(ident, expression, position = nil, operator: "=")
      super(position)
      @ident = ident
      @expression = expression
      @operator = operator
    end
  end

  class IfNode < StatementNode
    attr_reader :condition, :then_statement, :else_statement

    def initialize(condition, then_statement, else_statement = nil, position = nil)
      super(position)
      @condition = condition
      @then_statement = then_statement
      @else_statement = else_statement
    end
  end

  class WhileNode < StatementNode
    attr_reader :condition, :statement

    def initialize(condition, statement, position = nil)
      super(position)
      @condition = condition
      @statement = statement
    end
  end

  class RepeatNode < StatementNode
    attr_reader :statement, :condition

    def initialize(statement, condition, position = nil)
      super(position)
      @statement = statement
      @condition = condition
    end
  end

  class ProcCallNode < StatementNode
    attr_reader :name, :parameters

    def initialize(name, parameters, position = nil)
      super(position)
      @name = name
      @parameters = parameters
    end
  end

  class FuncCallNode < ExprNode
    attr_reader :name, :parameters

    def initialize(name, parameters, position = nil)
      super(position)
      @name = name
      @parameters = parameters
    end
  end
end
