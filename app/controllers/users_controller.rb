class UsersController < ApplicationController
before_action :correct_user,   only: [:edit, :update] 
  #editとupdateの場合は, 事前にログインしているかどうかを確認する
  
  def show
    #配列の表示
    @user = User.find(params[:id])
    #パラメータが一致するuserを検索
    @microposts = @user.microposts.order(created_at: :desc)
    #投稿された時間に沿って並べ替え
    @all_users = User.all
  end

  def new
    #新しいインスタンスを生成
    @user = User.new
    #新しいuserをUserモデルに加え,userインスタンス変数に保持させる
  end

  def create
    #新しいインスタンスを作成
    @user = User.new(user_params)
    #新しいuserハッシュをUserモデルに加え,userインスタンス変数に保持させる
    if @user.save
    #保存が成功するか確認
      flash[:success] = "Welcome to the Sample App!"
      #保存できたら"成功"の"msgを表示
      redirect_to @user 
      # userインスタンス変数にリダイレクトする
    else
      render 'new'
      #成功しなかった場合は新規登録.htmlを表示
    end
  end

  def edit
    #データの編集
    @user = User.find(params[:id])
    #指定のidをもつuserをUserモデルの中から検索しユーザー変数に保持させる
  end
  
  def update
    #データの更新
    @user = User.find(params[:id])
    #指定のidをもつuserをUserモデルの中から検索  
  if @user.update(user_params)
      #userハッシュのデータの更新に成功した場合
      redirect_to @user, notice: 'ユーザー情報をアップデートしました'
      # user情報の更新
  else
      #保存に失敗した場合
      render 'edit'
      # 編集画面へ戻す
  end
  end

def followings
# followings機能の実装
    @user  = User.find(params[:id])      
    #指定のidをもつuserハッシュをUserモデルの中から検索してuserインスタンス変数に保持させる
    @followings = @user.following_users  
    #インスタンス変数followingsに一意のfollowings_userと紐づけされたuserインスタンス変数を保持させる
end

def followers 
    #follower機能の実装
    @user  = User.find(params[:id])
    #指定のidをもつuserハッシュをUserモデルの中から検索してuserインスタンス変数に保持させる
    @followers = @user.follower_users
    #インスタンス変数followerに一意のfollower_userと紐づけされたuserインスタンス変数を保持させる
end

  # # def create likes 
  # # def likes
  # # def like
  #   @micropost = Micropost.find(params[:micropost_id])
  #   current_user.create_like(@micropost)
  #   redirect_to likes_user_path(current_user)
  # end

def likes
  @user = User.find(params[:id])
  @feed_likes = @user.like_microposts.order(created_at: :desc)
  render 'likes/feed_likes'
end


 def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.remove_like(@micropost)
    redirect_to :back 
 end

  def index
  # @user  = User.find(params[:id])
  # @all_user  = User.find(params[:id])
  # @all_users = User.where(active: true)
  @all_users = User.order("created_at")
  end
  
  def all_users
    # User.where(active: true)
    # User.order("created_at")
    User.all
  end
  
  
  private
  #このファイル内でだけ参照が可能なインスタンス
def correct_user
  @user = User.find(params[:id])
  #指定のidをもつuser・ハッシュをUserモデルの中から検索してuserインスタンス変数に保持させる 
  redirect_to(root_url) unless @user == current_user
  #もしuserがログインしていない場合,ホーム画面にリダイレクトする
end

def user_params
  #userハッシュの定義
  params.require(:user).permit(:name, :email, :password, :age, :profile,
                                 :password_confirmation)
  # paramsは :user というキーを持ち、
  # params[:user] が :name 及び :email及び:password及び :password_confirmationというキーを持つハッシュであることを検証する
 
end

end

