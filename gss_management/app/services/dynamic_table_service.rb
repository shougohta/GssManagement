class DynamicTableService
  def initialize(gss_table_name)
    @gss_table_name = gss_table_name
  end

  attr_reader :gss_table_name

  def create_table
    ActiveRecord::Migration.create_table(gss_table_name) do |t|
      t.string :student_name
      t.string :gender
      t.string :class_level
      t.string :home_state
      t.string :major
      t.string :extracurricular_activity
    end
  end

  def drop_table_if_exists
    ActiveRecord::Migration.drop_table(gss_table_name) if ActiveRecord::Base.connection.table_exists?(gss_table_name)
  end
end