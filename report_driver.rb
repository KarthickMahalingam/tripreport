require_relative 'lib/file_reader'
require_relative 'lib/report_error'
# Main script that drives the trip processing
# Parse the input from text file and generates a report
# Input file is passes through command line
# Execution -- ruby report_driver.rb input_file.txt
class ReportDriver
  attr_reader :filename

  def validate_argument?
    raise(ReportError, 'Please specify input filename') if ARGV.length != 1
    @filename = ARGV[0]
    true
  end

  def file_reader
    FileReader.new(filename)
  end

  def generate_report
    file_reader.validate_and_read_file if validate_argument?
  end

  report = ReportDriver.new
  report.generate_report
end