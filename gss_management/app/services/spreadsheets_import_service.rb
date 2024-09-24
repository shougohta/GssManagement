class SpreadsheetsImportService
  require 'google/apis/sheets_v4'
  require 'googleauth'

  def initialize(spreadsheet_id, range)
    @spreadsheet_id = spreadsheet_id
    @range = range
  end

  def execute
    begin
      res = google_spreadsheet_service.get_values(spreadsheet_id, range)
      return if res.values.empty?
  
      res.values.drop(1).each do |row_data|
        row = Row.new(*row_data)
        attributes = row.to_h.slice(
          :student_name,
          :gender,
          :class_level,
          :home_state,
          :major,
          :extracurricular_activity
        )
  
        user = SampleUser.find_or_initialize_by(attributes)
        user.save!
      end
    rescue StandardError => e
      # ログ記録やエラー処理を追加
      Rails.logger.error("Error importing spreadsheet: #{e.message}")
      raise
    end
    SampleUser.all
  end

  # 行の構造を定義
  Row = Struct.new(
    :student_name,            # 生徒名
    :gender,                  # 性別
    :class_level,             # 学年
    :home_state,              # 出身州
    :major,                   # 専攻
    :extracurricular_activity # 課外活動
  )

  private

  attr_reader :spreadsheet_id, :range

    def google_spreadsheet_service
      @google_spreadsheet_service ||= Google::Spreadsheets.new
    end
end
