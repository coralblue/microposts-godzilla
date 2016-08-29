class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
      # @like.micropost = current_user.likes.build
      # @like.micropost = current_user.likes.microposts.build
      # @like.micropost = current_user.like.micropost.build
      # @like.micropost = current_like.micropost.build
      # @like.micropost = likes.micropost.build
      # @like.micropost = likes.microposts.build
      # @like.micropost = likes_path.microposts.build ← 前のエラーでlikes_urlを求められたので変更したがNG
      # @like.micropost = likes_path.micropost.build
      # @like.micropost = likes_path(id: micropost.id)
      # @micropost= likes_path(id: micrpost.id)
      # @micropost = likes_path.micropost.build
      #@micropost = like_path.micropost.build 
       #コレが一番正解に近そうなエラーでてました: No route matches {:action=>"destroy", :controller=>"likes"} missing required keys: [:id]
      # @micropost = likes_path(id: micropost.id)
      # @micropost = like_path(id: micropost.id)
       #振り出しに戻る的エラー:undefined local variable or method `micropost' for #<StaticPagesController:0x00000003d14888> Did you mean? @micropost
      #@micropost = like_path(micropost_id: micropost.id) 
      #@micropost = likes_path(micropost_id: micropost.id)
    end
  end
end