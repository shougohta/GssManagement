module SpreadsheetsImport
  class UpdateUsecase
    def initialize(form)
      @form = form
    end

    def call
      sample_users = ::SpreadsheetsImport::UpdateService.new(form).execute
      {status: :ok, item: sample_users}
    end

    private

    attr_reader :form
  end
end
