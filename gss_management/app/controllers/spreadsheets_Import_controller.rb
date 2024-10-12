class SpreadsheetsImportController < ApplicationController
  # テーブル名の一覧を取得
  def index
    begin
      result = ::SpreadsheetsImport::IndexUsecase.new.call

      render json: { status: result[:status], data: result[:table_names] }, status: :ok
    rescue StandardError => e
      render json: { status: 'error', message: e.message }, status: :internal_server_error
    end
  end

  # テーブル詳細を返す
  def show
    result = ::SpreadsheetsImport::ShowUsecase.new(params).call

    render json: { status: result[:status], data: result[:table] }, status: :ok
  rescue StandardError => e
    render json: { status: 'error', message: e.message }, status: :internal_server_error
  end

  # Spreadsheetsの取り込み処理
  def update
    result = ::SpreadsheetsImport::UpdateUsecase.new(params).call

    render json: { status: result[:status], data: result[:item] }, status: :ok
  rescue StandardError => e
    render json: { status: 'error', message: e.message }, status: :internal_server_error
  end
end
