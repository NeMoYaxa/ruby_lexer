# frozen_string_literal: true

require_relative "../lib/ruby_lexer"

code = "if hello == 123#\nend"

lexer = RubyLexer::Lexer.new(code)

loop do
  token = lexer.next_token

  # puts "type = #{token.type}, value = #{token.value}, position = #{token.position.line}:#{token.position.column}"
  print "#{token.value} "
  break if token.type == RubyLexer::TokenType::EOF
end
