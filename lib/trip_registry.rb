# Hash to store the driver trip information
class TripRegistry
  def initialize
    @hash_book = {}
  end

  def insert_driver(driver_name)
    hash_book[driver_name] = { trip_duration:  0,
                               total_miles:  0,
                               speed: 0
    }
  end

  def get_hash_book
    hash_book
  end

  def get_trip_duration(driver_name)
    hash_book[driver_name][:trip_duration].to_f
  end

  def set_trip_duration(driver_name, trip_duration)
    hash_book[driver_name][:trip_duration] += trip_duration
  end

  def set_total_miles(driver_name, total_miles)
    hash_book[driver_name][:total_miles] += total_miles.round
  end

  def get_total_miles(driver_name)
    hash_book[driver_name][:total_miles]
  end

  def driver_present?(driver_name)
    hash_book.key?(driver_name)
  end

  def set_speed(driver_name, speed)
    hash_book[driver_name][:speed] = speed
  end

  def get_speed(driver_name)
    hash_book[driver_name][:speed]
  end

  def get_driver_info(driver_name)
    hash_book[driver_name]
  end

  def sort_by_mph
    hash_book.sort_by {|driver_name, driver_info| driver_info[:total_miles]}
  end

  private

  attr_accessor :hash_book
end