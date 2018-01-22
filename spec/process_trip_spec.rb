describe ProcessTrip do
  let(:trip_registry) { TripRegistry.new }
  let(:process_trip) { ProcessTrip }
  trip_input = %w[Driver Dan]

  describe 'ProcessTrip' do
    it 'should create a driver in trip_registry' do
      process_trip.new(trip_input, trip_registry).parse_trip_line
      expect(trip_registry.get_hash_book.has_key?('Dan') ).to be_truthy
    end

    it 'should raise argument error' do
      trip_input = %w[Driver]
      process_trip1 = process_trip.new(trip_input,trip_registry)
      expect(process_trip1.valid_command_length?).to be_falsey
    end

    it 'should raise argument error' do
      trip_input = %w[Driver]
      process_trip1 = process_trip.new(trip_input,trip_registry)
      expect(process_trip1.errors).to_not be_empty
    end

    it 'should raise error if start time is greater than end time' do
      process_trip1 = process_trip.new(trip_input,trip_registry)
      trip_input = %w[Trip Dan 07:00 04:00 23]
      process_trip1 = process_trip.new(trip_input,trip_registry)
      expect(process_trip1.valid_time_interval_and_not_empty?).to be_falsey
    end
  end
end