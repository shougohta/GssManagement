module SpreadsheetsImport
  class ShowUsecase
    def initialize(params)
      @params = params
    end

    def call
      table = get_table_records

      { status: :ok, table: table }
    end

    private

    attr_reader :params

    def get_table_records
      # メソッド内で定義しないと動的クラスでテーブル名に参照できない
      table_name = gss_table_name
      
      # 動的モデルを作成
      # ActiveRecordモデルインスタンスとして扱った方がJson形式への変換がシンプルになる
      klass = Class.new(ActiveRecord::Base) do |c|
        c.table_name = table_name
      end
      dynamic_model = Object.const_set(gss_model_name, klass)
      
      # 動的テーブルのデータを取得
      dynamic_model.all.as_json
    end

    def gss_table_name
      @gss_table_name ||= params[:table_name]
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
