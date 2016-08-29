class MicropostsController < ApplicationController
  #ApplicationControllerを継承したMicropostsController
before_action :logged_in_user, only: [:create, :destroy]
 #createとdestroyを行う場合は, 事前にログインしているかどうかを確認する

  def create
    #新規のインスタンスを作成
    # @micropost = current_user.microposts.build if logged_in?
    #ログインしている場合, Micropostにmicropostハッシュを新規作成し, micropostインスタンス変数に保持させる
    # Micropost.new(user_id: current_user.id)と同じ
 
    @micropost = current_user.microposts.build(micropost_params)
    #ログインしているUserと紐付いている投稿として新たに投稿をmicropost_paramsに設定した内容で追加←何を追加したのかナゾ
    if @micropost.save
    #もしmicropostインスタンス変数の保存が成功したら
      flash[:success] = "Micropost created!"
    # 成功msgを表示
      redirect_to root_url
    #ホーム画面にリダイレクト画面遷移
    else
    #それ以外の場合は
    @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
    # feed_itemsで現在のユーザーのフォローしているユーザーのマイクロポストを取得
    #order(created_at: :desc)で作成日時が新しいものが上にくるように並び替え
    #includes(:user)の部分は、つぶやきに含まれるユーザー情報をあらかじめ先読み（プリロード）する処理を行うために用います
    #先読み（プリロード）:@feed_itemsからアイテムを取り出すたびに、それに紐付いたユーザーの情報をDBから取り出さずに済みます
    
      render 'static_pages/home'
    #static_pagesファイルのhome画面に画面遷移
    #MicropostsControllerのcreateメソッドでもエラーが発生した場合はstatic_pages/homeテンプレートを使用する
    end
  end

  def destroy
    #インスタンスの破棄 (N/Aにする)
    @micropost = current_user.microposts.find_by(id: params[:id])
    #ログインしているかどうか,現在のuserハッシュで確認して,micropostインスタンス変数に保持させる
    return redirect_to root_url if @micropost.nil?
    #micropostインスタンス変数が空データ(ヌルポ)の場合,ホーム画面にリダイレクト画面遷移
    
    @micropost.destroy
    #micropostインスタンス変数に”破棄”インスタンスを実行する場合
    flash[:success] = "Micropost deleted"
    #"破棄"のメッセージを表示
    redirect_to request.referrer || root_url
    # リファラー(該当ページに遷移する直前に閲覧されていた参照元（遷移元・リンク元）ページのURL)又はroot_urlにリダイレクト画面遷移
  end
  
  private
  #このファイル内でだけ参照が可能なインスタンス
  def micropost_params
    #micropostハッシュの指定
    params.require(:micropost).permit(:content)
    # :micropostを保有し, :contentというキーを持つハッシュであることを検証する
  end
end