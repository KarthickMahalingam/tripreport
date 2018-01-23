require_relative 'trip_registry'
require_relative 'trip_processor'
# Performs file reading operation from the specified input file
class FileReader
  attr_reader :filename, :trip_registry, :trip_processor
  def initialize(filename)
    @filename = filename
    @trip_registry = TripRegistry.new
    @trip_processor = TripProcessor
  end

  def validate_and_read_file
    raise ReportError, 'Invalid Filename. No such file exist' unless file_exist?
    raise ReportError, 'Empty file specified' if file_empty?
    read_file
    trip_processor.calculate_speed_for_trip_sheet(trip_registry)
    print_report
  end

  def file_exist?
    File.exist?(filename)
  end

  def file_empty?
    File.zero?(filename)
  end

  def file_read
    File.open(filename, 'r').read
  end

  def input_line_to_array(input_line)
    input_line.strip.split(' ')
  end

  def read_file
    file_read.each_line do |input_line|
      if input_line.length != 1
        trip_processor.new(input_line_to_array(input_line), trip_registry).parse_trip_line
      end
    end
  end

  def sort_hash_book_desc
    trip_registry.sort_by_mph.reverse
  end

  def print_report
    sort_hash_book_desc.each do |driver_name, driver_info|
      print "#{driver_name}: #{driver_info[:total_miles]} miles"
      puts " @ #{driver_info[:speed].to_s} mph" unless driver_info[:speed].zero?
    end
  end
end