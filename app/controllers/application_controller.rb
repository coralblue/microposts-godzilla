class ApplicationController < ActionController::Base
  #ActionController::Baseを継承したApplicationController
  protect_from_forgery with: :exception
  # CSRF Tokenが一致しなかった場合に例外を投げる
  include SessionsHelper
  #SessionsHelperを事前に読み込んでおく
  private
  #当該ファイルの外からは参照が出来無いインスタンス
  def logged_in_user
  #logged_in_user メソッドの定義
    unless logged_in?
    #ログインしていない場合のみ処理を行う
      store_location
      #store_locationメソッドで、アクセスしようとしたURLを保存しています。
      flash[:danger] = "Please log in."
      # ログインするようにというエラーmsg表示
      redirect_to login_url
      # ログイン画面のURLにリダイレクトで画面遷移
    end
  end
end