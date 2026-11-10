# frozen_string_literal: true

require_relative "../lib/ruby_lexer"

code = "if 1 then a = 0 else x = 2"

lexer = RubyLexer::Lexer.new(code)

begin
  parser = RubyLexer::Parser.new(lexer)
  root = parser.main_program

  printer = RubyLexer::PrettyPrinterIndent.new
  puts printer.print(root)
rescue RubyLexer::BaseError => e
  warn e.message
end
