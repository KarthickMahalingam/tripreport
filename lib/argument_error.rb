class ArgumentError < StandardError
  def initialize(error_line, msg = 'Warning: Invalid contents in file' )
    puts "#{error_line} : #{msg}"
  end
end