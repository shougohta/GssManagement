class SpreadsheetsImportController < ApplicationController
  # Spreadsheetsの取り込み処理
  def update
    result = ::SpreadsheetsImportUsecase.new(params).call

    render json: { status: result[:status], data: result[:item] }, status: :ok
  rescue StandardError => e
    render json: { status: 'error', message: e.message }, status: :internal_server_error
  end
end
