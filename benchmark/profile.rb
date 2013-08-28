require_relative './setup'

result = RubyProf.profile { 100.times { |n| SquireTest.send("key_#{n}") } }

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
