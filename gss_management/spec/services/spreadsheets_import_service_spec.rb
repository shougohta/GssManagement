require 'rails_helper'

RSpec.describe SpreadsheetsImportService do
  let(:spreadsheet_id) { 'test_spreadsheet_id' }
  let(:range) { 'A1:F10' }
  let(:service) { described_class.new(spreadsheet_id, range) }

  describe '#execute' do
    let(:mock_spreadsheet) { instance_double(Google::Spreadsheets) }
    let(:mock_response) { double('response', values: mock_values) }
    let(:mock_values) do
      [
        ['Student Name', 'Gender', 'Class Level', 'Home State', 'Major', 'Extracurricular Activity'],
        ['John Doe', 'Male', 'Senior', 'CA', 'Computer Science', 'Basketball']
      ]
    end

    before do
      allow(Google::Spreadsheets).to receive(:new).and_return(mock_spreadsheet)
      allow(mock_spreadsheet).to receive(:get_values).and_return(mock_response)
      allow(DynamicTableService).to receive(:new).and_return(double('dynamic_table_service', drop_table_if_exists: nil, create_table: nil, gss_table_name: 'users_test'))
    end

    it 'imports data from Google Spreadsheet' do
      expect(ActiveRecord::Base.connection).to receive(:execute).with(/INSERT INTO users_test/)
      service.execute
    end

    it 'creates a dynamic model' do
      expect(Object).to receive(:const_set).with('sample_users ', kind_of(Class))
      service.execute
    end

    it 'returns data as json' do
      result = service.execute
      expect(result).to be_an(Array)
      expect(result.first).to include('student_name', 'gender', 'class_level', 'home_state', 'major', 'extracurricular_activity')
    end

    context 'when spreadsheet is empty' do
      let(:mock_values) { [] }

      it 'returns nil' do
        expect(service.execute).to be_nil
      end
    end

    context 'when an error occurs' do
      before do
        allow(mock_spreadsheet).to receive(:get_values).and_raise(StandardError.new('Test error'))
      end

      it 'logs the error and raises it' do
        expect(Rails.logger).to receive(:error).with(/Error importing spreadsheet: Test error/)
        expect { service.execute }.to raise_error(StandardError, 'Test error')
      end
    end
  end

  describe '#gss_table_name' do
    it 'returns the correct table name' do
      expect(service.send(:gss_table_name)).to eq('users_test_s')
    end
  end

  describe '#gss_model_name' do
    it 'returns the correct model name' do
      expect(service.send(:gss_model_name)).to eq('UsersTestS')
    end
  end
end