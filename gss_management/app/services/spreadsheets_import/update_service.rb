module SpreadsheetsImport
  class UpdateService
    require 'google/apis/sheets_v4'
    require 'googleauth' 

    def initialize(spreadsheet_id, range)
      @spreadsheet_id = spreadsheet_id
      @range = range
    end

    def execute
      begin
        res = Ggl::Spreadsheets.new.get_values(spreadsheet_id, range)
        return if res.values.empty?

        # DynamicTableServiceのインスタンスを作成
        # gss_table_nameを引数として渡し、動的テーブルの操作を行うためのサービスを初期化
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
      # ActiveRecordモデルインスタンスとして扱った方がJson形式への変換がシンプルになる
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
    attr_reader :spreadsheet_id, :range

    def table_id
      @table_id ||= spreadsheet_id[-5..-1].downcase
    end

    def gss_table_name
      @gss_table_name ||= "users_#{table_id}"
    end

    # tableizeメソッドはモデルクラス名をテーブル名に変換してくれる。
    # "AdminUser".tableize #=> admin_users
    # 
    # classifyメソッドはテーブル名をクラス名に変換してくれる。
    # "people".classify #=> "Person"
    def gss_model_name
      @gss_model_name ||= gss_table_name.classify
    end
  end
end
