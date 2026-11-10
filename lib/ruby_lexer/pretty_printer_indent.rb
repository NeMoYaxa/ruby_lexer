# frozen_string_literal: true

module RubyLexer
  class PrettyPrinterIndent
    def initialize(indent_size: 2)
      @indent_size = indent_size
      @level = 0
    end

    def print(node)
      node.accept(self)
    end

    def visit_statement_list_node(node)
      return "{}" if node.statements.empty?

      opening = "{"
      @level += 1
      body = node.statements.map { |statement| line(statement) }.join("\n")
      @level -= 1
      "#{opening}\n#{body}\n#{indent}}"
    end

    def visit_expr_list_node(node)
      node.expressions.map { |expression| expression.accept(self) }.join(", ")
    end

    def visit_int_node(node) = node.value.to_s
    def visit_double_node(node) = node.value.to_s
    def visit_string_node(node) = node.value.inspect
    def visit_boolean_node(node) = node.value.to_s
    def visit_nil_node(_node) = "nil"
    def visit_id_node(node) = node.name

    def visit_bin_op_node(node)
      "#{node.left.accept(self)} #{node.operator} #{node.right.accept(self)}"
    end

    def visit_assign_node(node)
      "#{node.ident.name} #{node.operator} #{node.expression.accept(self)}"
    end

    def visit_if_node(node)
      result = "if #{node.condition.accept(self)} then\n#{nested(node.then_statement)}"
      result += "\n#{indent}else\n#{nested(node.else_statement)}" if node.else_statement
      result
    end

    def visit_while_node(node)
      "while #{node.condition.accept(self)} do\n#{nested(node.statement)}"
    end

    def visit_repeat_node(node)
      "repeat\n#{nested(node.statement)}\n#{indent}until #{node.condition.accept(self)}"
    end

    def visit_proc_call_node(node)
      "#{node.name.name}(#{node.parameters.accept(self)})"
    end

    def visit_func_call_node(node)
      "#{node.name.name}(#{node.parameters.accept(self)})"
    end

    private

    def indent
      " " * (@level * @indent_size)
    end

    def line(node)
      "#{indent}#{node.accept(self)}"
    end

    def nested(node)
      @level += 1
      result = line(node)
      @level -= 1
      result
    end
  end
end
