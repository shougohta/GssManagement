module SpreadsheetsImport
  class IndexUsecase
    def call
      table_names = get_gss_table_names_from_database()
      {status: :ok, table_names: table_names}
    end 

    private

    def get_gss_table_names_from_database
      all_tables = ActiveRecord::Base.connection.tables
      all_tables.select { |table| table.start_with?('users_') }
    end
  end
end
