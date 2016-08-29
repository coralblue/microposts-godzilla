class LikesController < ApplicationController
  before_action :logged_in_user

  def create 
    @micropost = Micropost.find(params[:micropost_id])
    current_user.create_like(@micropost)
    # B) redirect_to likes_user_path(user)'一覧ページに画面遷移
    # A)redirect_to @user ←画面遷移せずに, データの更新だけ行う
    # redirect_to :back 
    #redirect_to :shared/feed_likes
    # render 'shared/feed_likes'
    # render "shared/feed_likes"
    # render `feed_likes`
    # @feed_likes = current_user.like_microposts.includes(:user).order(created_at: :desc)
    # render 'feed_likes'
    redirect_to likes_user_path(current_user) #likeした投稿一覧ページへリダイレクト
  end
#伊藤メソッド
# def create 
#   @micropost = Micropost.find(params[:micropost_id])
#   current_user.create_like(@micropost)
#   redirect_to likes_user_path(current_user)   #likeした投稿一覧ページへリダイレクト
# end

 def destroy
    # @micropost = Micropost.find_by(params[:micropost_id])
    @micropost = Micropost.find(params[:micropost_id])
    # current_user.creat_like(@micropost)
    # current_user.destroy_like(@micropost)
    current_user.remove_like(@micropost)
    redirect_to :back 
 end
end


# # if logged_in?
    
# #   def create
# #     @micropost = likes_mircoposts.find_by(micropost_id: micropost.id)
# #     # current_user.likes(micropost_id: micropost.id)
# #   end

# # @user = User.find(params[:id])
# # @like = Like.find(params[:id])

#   def create
#     #<%= link_to "like", likes_path(id: micropost.id), method: :post %>を押すとこのcreateアクションがインスタンス化（実行）されます。
    
#     #likes POST   /likes(.:format)                likes#create
#     #上記rake routesの意味は  "likesというURL" ＋ "httpメソッドのPOST"がrailsサーバにリクエストされると likes#create
#     #つまりlikes_controllerのcreateアクション（この部分）を実行するという事になります。
#     #単にこのアクションを呼び出すだけでしたら<%= link_to "like", likes_path, method: :post %>で呼び出せます(生成されるURLは"/likes")
#     #(id: micropost.id)がついているのは、likeしたいmicropostのidをパラメータとして付与し、コントローラに渡したいからです。
#     #(id: micropost.id)のmicropost.idが6番だと "/likes?id=6"というURLになります。この６という数字をコントローラで取得するには parms[:id]です。※超重要
    
#     #createアクション内では user_id == current_user.id で、micropost_id == お気に入りしたいmicropostのidという形でデータベースに保存する処理を書きます。
#     #この処理は以下のように書けます。
#     # @micropost = Micropost.find_by(id: params[:id]) #Micropostテーブルからid がparams:idのインスタンスを取得する
#     # current_user.like(@micropost)

#     # @micropost = Micropost.find_or_create_by(params[:micropost_id])
#     @micropost = Micropost.find(params[:micropost_id])
#     # current_user.like(@micropost)
#     current_user.likes(@micropost)
#   end

# ==========
# app/controllers/relationships_controller.rb

# class RelationshipsController < ApplicationController
#   before_action :logged_in_user

#   def create
#     @user = User.find(params[:followed_id])
#     current_user.follow(@user)
#   end

#   def destroy
#     @user = current_user.following_relationships.find(params[:id]).followed
#     current_user.unfollow(@user)
#   end
# end
# ==========
#   def destroy
#     @micropost = Micropost.find_by(params[:micropost_id]).like
#     # current_user.like(@micropost)
#     current_user.likes(@micropost)
#   end

# # def remove_like(micropost)
# #     like = likes.find_by(micropost_id: micropost.id)
# #     like.destroy if like
# # end

# #end
