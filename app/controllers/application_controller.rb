class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #コントローラー内で、ヘルパーを使用するためのinclude宣言
  include SessionsHelper
  #messageかmicropostのreplyか判断
  include MessagesHelper
  #会話のテーブル作成のためのヘルパー
  include ConversationHelper
end
