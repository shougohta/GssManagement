module SpreadsheetsImport
  class DestroyUsecase
    def initialize(form)
      @form = form
    end

    def call
      drop_table(form[:table_name])
      {status: :ok}
    end

    private

    attr_reader :form

    def drop_table(table_name)
      ActiveRecord::Base.connection.execute("DROP TABLE #{table_name}")
    end
  end
end
