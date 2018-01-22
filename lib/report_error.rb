class ReportError < StandardError
  def initialize(msg = 'Unknown Error')
    puts "Error: #{msg}"
    exit
  end
end