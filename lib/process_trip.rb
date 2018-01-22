require_relative 'argument_error'
require_relative 'trip_registry'
require 'time'
require 'pry'
# Validates the file content performs appropriate action
class ProcessTrip
  attr_reader :trip_line, :trip_registry, :time_difference, :errors
  def initialize(trip_input, trip_registry)
    @trip_line = trip_input
    @errors = { trip_line => [] }
    @trip_registry = trip_registry
  end

  def parse_trip_line
    process_command if valid_command? && valid_command_length?
  end

  def process_command
    add_driver_command if command == 'Driver'
    process_trip_command if command == 'Trip'
  end

  def valid_command_length?
    if trip_line.length != 2 && trip_line[0] == 'Driver'
      raise_argument_error('Incorrect length. Req:2')
      return false
    elsif trip_line.length != 5 && trip_line[0] == 'Trip'
      raise_argument_error('Incorrect length. Req:5')
      return false
    end
    true
  end

  def valid_command?
    command_set = %w[Driver Trip]
    raise_argument_error('Invalid command') unless command_set.include?(command)
    true
  end

  def raise_argument_error(msg)
    errors[trip_line] << msg
    raise ArgumentError.new(trip_line, msg)
  rescue ArgumentError
  end

  def add_driver_command
    trip_registry.insert_driver(driver_name) if errors[trip_line].empty?
  end

  def valid_time_interval?
    if start_time > end_time
      raise_argument_error('Should have Start time < End time')
      return false
    end
    true
  end

  def process_trip_command
    @time_difference = calculate_time_difference if valid_time_interval_and_not_empty?
    update_trip_details if driver_present? && average_speed_in_range?
  end

  def update_trip_details
    trip_registry.set_trip_duration(driver_name, time_difference)
    trip_registry.set_total_miles(driver_name, total_miles)
  end

  def valid_time_interval_and_not_empty?
    valid_time_interval? && errors[trip_line].empty?
  end

  def self.calculate_speed_for_trip_sheet(trip_registry)
    trip_registry.get_hash_book.each do |driver_name, trip_details|
      speed = compute_speed_and_update(driver_name, trip_registry)
      trip_registry.set_speed(driver_name, speed)
    end
  end

  def self.compute_speed_and_update(driver_name, trip_registry)
    distance = trip_registry.get_total_miles(driver_name)
    time_taken_in_hour = trip_registry.get_trip_duration(driver_name) / MINUTES_TO_HOUR
    speed = if time_taken_in_hour.nonzero?
              (distance / time_taken_in_hour).round
            else
              0
            end
  end

  private

  MIN_SPEED = 5
  MAX_SPEED = 100
  MINUTES_TO_HOUR = 60

  def driver_name
    trip_line[1]
  end

  def command
    trip_line[0]
  end

  def total_miles
    trip_line[4].to_f
  end

  def driver_present?
    return true if trip_registry.driver_present?(driver_name)
    false
  end

  def average_speed_in_range?
    avg_speed = calculate_current_trip_speed
    return true if avg_speed > MIN_SPEED && avg_speed < MAX_SPEED
    false
  end

  def calculate_current_trip_speed
    total_miles / (time_difference / MINUTES_TO_HOUR)
  end

  def calculate_time_difference
    (end_time - start_time) / MINUTES_TO_HOUR
  end

  def start_time
    strip_time(trip_line[2])
  end

  def end_time
    strip_time(trip_line[3])
  end

  def strip_time(time)
    Time.strptime(time, '%H:%M')
  end
end