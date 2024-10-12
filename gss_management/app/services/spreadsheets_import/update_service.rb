module SpreadsheetsImport
  class UpdateService
    require 'google/apis/sheets_v4'
    require 'googleauth' 

    def initialize(form)
      @form = form
      @spreadsheets_service = Ggl::Spreadsheets.new # Ggl::Spreadsheetsのインスタンスを生成
    end

    def execute
      begin
        # スプレッドシートIDとgidを取得
        spreadsheet_id = convert_url_to_spreadsheet_id(form[:url])
        gid = extract_gid(form[:url])
        
        # gidを使ってタブ名を取得
        sheet_title = @spreadsheets_service.get_sheet_title(spreadsheet_id, gid)

        # Google Sheetsからデータを取得
        res = @spreadsheets_service.get_values(spreadsheet_id, "#{sheet_title}!A:F")
        return if res.values.empty?

        # DynamicTableServiceのインスタンスを作成
        dynamic_table_service = SpreadsheetsImport::DynamicTableService.new(gss_table_name)

        dynamic_table_service.drop_table_if_exists
        dynamic_table_service.create_table

        res.values.drop(1).each do |row_data|
          row = Row.new(*row_data)
          attributes = row.to_h.slice(:student_name, :gender, :class_level, :home_state, :major, :extracurricular_activity)

          # 動的テーブルにデータを挿入
          ActiveRecord::Base.connection.execute("INSERT INTO #{dynamic_table_service.gss_table_name} (#{attributes.keys.join(', ')}) VALUES (#{attributes.values.map { |v| ActiveRecord::Base.connection.quote(v) }.join(', ')})")
        end
      rescue StandardError => e
        Rails.logger.error("Error importing spreadsheet: #{e.message}")
        raise
      end

      # メソッド内で定義しないと動的クラスでテーブル名に参照できない
      table_name = gss_table_name

      # 動的モデルを作成
      klass = Class.new(ActiveRecord::Base) do |c|
        c.table_name = table_name
      end
      dynamic_model = Object.const_set(gss_model_name, klass)
      
      # 動的テーブルのデータを取得
      data = dynamic_model.all.as_json
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
    attr_reader :form

    def convert_url_to_spreadsheet_id(url)
      match_data = url.match(/(?<=\/d\/)([^\/]+)/)
      raise ArgumentError, "Invalid URL format" unless match_data

      match_data[0]
    end

    def extract_gid(url)
      match_data = url.match(/gid=(\d+)/)
      raise ArgumentError, "Invalid gid format" unless match_data

      match_data[1]
    end

    def gss_table_name
      @gss_table_name ||= "table_#{spreadsheet_name}"
    end

    def gss_model_name
      @gss_model_name ||= gss_table_name.classify
    end

    def spreadsheet_name
      @spreadsheet_name ||= form[:name]
    end
  end
end
