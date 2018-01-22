describe FileReader do
  let(:file_reader) { FileReader.new('sample.txt') }

  describe 'FileReader' do
    it 'should  throw error if no such file' do
      expect(file_reader.file_exist?).to eq false
    end

    it 'should read the content from file' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan')
      expect(file_reader.read_file).to eq('Driver Dan')
    end

    it 'should compute the speed after read' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan
                                                             Trip Dan 06:00 12:00 68')
      file_reader.read_file
      driver_info = file_reader.process_trip.calculate_speed_for_trip_sheet(file_reader.trip_registry)
      puts driver_info
      expect(file_reader.trip_registry.get_speed('Dan')).to be > 0
    end

    it 'should not accept driver command if insufficient argument given' do
      expect(file_reader).to receive(:file_read).and_return('Driver')
      file_reader.read_file
      expect(file_reader.trip_registry.get_hash_book).to be_empty
    end

    it 'should not accept trip command if insufficient argument given' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan
                                                             Trip Dan ')
      file_reader.read_file
      expect(file_reader.trip_registry.get_trip_duration('Dan')).to eq 0
    end

    it 'should reject trip if speed is less than 5 mph' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan
                                                             Trip Dan 12:00 14:00 2')
      file_reader.read_file
      expect(file_reader.trip_registry.get_speed('Dan')).to eq 0
    end

    it 'should reject trip if speed is greater than 100' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan
                                                             Trip Dan 12:00 12:010 190')
      file_reader.read_file
      expect(file_reader.trip_registry.get_speed('Dan')).to eq 0
    end

    it 'should reject trip if driven is not registered' do
      expect(file_reader).to receive(:file_read).and_return('Trip Dan 12:00 12:010 190')
      file_reader.read_file
      expect(file_reader.trip_registry.get_hash_book).to be_empty
    end

    it 'should add duration and total_miles to driver record' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan
                                                             Trip Dan 12:00 12:30 10
                                                             Trip Dan 12:00 12:30 40')
      file_reader.read_file
      file_reader.process_trip.calculate_speed_for_trip_sheet(file_reader.trip_registry)
      expect(file_reader.trip_registry.get_speed('Dan')).to be > 0
    end

    it 'should ignore empty line in file and continue' do
      expect(file_reader).to receive(:file_read).and_return('Driver Dan

                                                             Trip Dan 12:00 12:30 40')
      file_reader.read_file
      expect(file_reader.trip_registry.get_trip_duration('Dan')).to be > 0
    end
  end
end