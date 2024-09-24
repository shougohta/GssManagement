class SpreadsheetsImportUsecase
  def initialize(form)
    @form
  end

  def call
    ::SpreadsheetsImportService.new(spreadsheet_id, range).execute
  end

  private

  attr_reader :form

  def spreadsheet_id
    @spreadsheet_id = form[:spreadsheet_id]
  end

  def range
    @range = form[:range]
  end
end