module ErrorLogging
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :log_and_render_error
  end

  private

  def log_and_render_error(exception)
    log_error(exception)
    render json: { status: 'error', message: exception.message }, status: :internal_server_error
  end

  def log_error(exception)
    Rails.logger.error("Error: #{exception.message}\nBacktrace:\n#{exception.backtrace.join("\n")}")
  end
end