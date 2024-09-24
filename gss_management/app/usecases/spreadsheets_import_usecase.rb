class SpreadsheetsImportUsecase
  def initialize(form)
    @form = form
  end

  def call
    sample_users = ::SpreadsheetsImportService.new(spreadsheet_id, range).execute
    {status: :ok, item: sample_users}
  end

  private

  attr_reader :form

  def spreadsheet_id
    @spreadsheet_id ||= convert_url_to_spreadsheet_id(form[:url])
  end

  def range
    @range ||= form[:range]
  end

  def convert_url_to_spreadsheet_id(url)
    match_data = url.match(/(?<=\/d\/)([^\/]+)/)
    raise ArgumentError, "Invalid URL format" unless match_data

    match_data[0]
  end
end
