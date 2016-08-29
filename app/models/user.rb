class User < ActiveRecord::Base
#ActiveRecord::Baseを継承したruby
  before_save { self.email = self.email.downcase }
#保存する前にemailを全部小文字にする
  validates :name, presence: true, length: { maximum: 50 }
#名前が確実に入力されていることを確認する.文字数上限は50文字
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#emailの正規表現
  validates :email, presence: true, length: { maximum: 255 },
#emailは確実に入力されていることを確認する.文字数上限は255文字
                    format: { with: VALID_EMAIL_REGEX },
                    #フォーマットは前述のVALID_EMAIL_REGEX
                    uniqueness: { case_sensitive: false }
                    #対象のフィールドがデータベース内で一意である必要がある.大文字小文字の差は無視
  validates :age ,  numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 130}, on: :update
  #updateの際にだけ利用が可能. 数値入力が必要.整数のみ(only_integer),文字制限:0〜130文字
  # validates :profile, presence: true, length: { minimum: 2, maximum: 145 } , on: :update
  has_secure_password
  #クラスメソッドhas_secure_passwordはバリデーションとユーザー認証(authentication)を行う
 has_many :microposts
  #userローカル変数はmicropostsローカル変数を保持できる
  has_many :following_relationships, class_name:  "Relationship",
  #following_relatonshipsはクラス・メソッドRepatinshipを継承
                                     foreign_key: "follower_id",
                                     #follower_idで外部制約
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  #usersはfollowing_relationships関係にあるfollowしたuserをfollowing_userとして多数保有する 
  has_many :follower_relationships, class_name:  "Relationship",
  #usersはfollower_relationships関係にあるfollowしたuserをfollowing_userとして多数保有する 
                                    foreign_key: "followed_id",
  #usersテーブルに存在するidのみfollowed_idに入るように外部キー制約を設定
                                    dependent:   :destroy
                                    #destroyの際にデータを削除
                                    
  has_many :follower_users, through: :follower_relationships, source: :follower
  #followされているuserをfollower_relationshipを通してfollower_usrsとして複数保有することが出来る
  #
  has_many :likes, dependent: :destroy 
  #userはlikesを多数保有できるが, destoryした時にデータ消去する
  has_many :like_microposts, through: :likes, source: :micropost
  #userはmicropostsの中から,likesされた関係にあるmicropostsをlike_micropostsとして多数保有することが出来る
 # 他のユーザーをフォローする
  def follow(other_user)
    #他のuserをfollowするインスタンスの定義
    following_relationships.find_or_create_by(followed_id: other_user.id)
    #followed_idカラムに入ったother_user.idに該当があるか検索し,無ければ新規登録する
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    #自分以外のuserをunfollowsするインスタンスの定義
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    #followed_idカラムに入ったother_user.idに該当があるか検索してfollowing_relationshipを探す
    following_relationship.destroy if following_relationship
    #もし該当するfollowing_relationshipがあれば削除
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    #他のuserをfollowしているかどうかの確認を行うインスタンスの定義
    following_users.include?(other_user)
    #following_usersがother_userカラムに含まれているか検索
  end
 
################
#該当:  # 他のユーザーをフォローする
  def create_like(micropost)  
   likes.find_or_create_by(micropost_id: micropost.id) 
  end

#該当:  # フォローしているユーザーをアンフォローする
 def remove_like(micropost)
   like = likes.find_by(micropost_id: micropost.id)
   like.destroy if like
 end   
 
#該当:  # あるユーザーをフォローしているかどうか？
   def like?(micropost)
     like_microposts.include?(micropost)
     # def like?(other_user)
     # like_microposts.include?(other_user)
   end

  def feed_items
    #feed_itemメソッドの定義:現在のユーザーのフォローしているユーザーのマイクロポストを取得
    Micropost.where(user_id: following_user_ids + [self.id])
    #Feed_itemsメソッド:user_idがフォローしているユーザーと自分のつぶやきを取得
  end
  
  def feed_likes
    Micropost.where(micropost_id: micropost.id + [self.id])
  end
end  

def all_users
    # User.where(active: true)
    # User.order("created_at")
    User.all
end
  
################

# # お気に入りツイート追加
# def create_like(micropost)
#   #micrpostをlikeするインスタンスの定義
#   likes.find_or_create_by(micropost_id: micropost.id)
#   #micropost_idカラムで likeしたmicropost.idがあるか検索し, 無ければ新規登録
# end

# # お気に入りツイート削除
# def remove_like(micropost)
#   #unlikeするインスタンスの定義
#    like = likes.find_by(micropost_id: micropost.id)
#    #micropost_idカラムにlikeした micropost.idがあるか検索する
#    like.destroy if like
#   #もしlikeがあれば,そのlikeを削除する
# end

# # ある投稿をlikeしているかどうか？
# def like?(micropost)
#   #likeしているmicropostが存在するか確認を行うインスタンスの定義
#     like_microposts.include?(micropost)
#   #likeしたmicropostがmicropostテーブルに存在するか確認
# end



# def remove_like(micropost)
#     like = likes.find_by(micropost_id: micropost.id)
#     like.destroy if like
# #===
# # お気に入りツイート追加
# def create_like(micropost)
#   likes.find_or_create_by(micropost_id: micropost.id) 
# end

# # お気に入りツイート削除
# def remove_like(micropost)
#    like = likes.find_by(micropost_id: micropost.id)
#    like.destroy if like
# end

# # ある投稿をlikeしているかどうか？
# def like?(micropost)
#   #likeしているmicropostが存在するか確認を行うインスタンスの定義
#     like_microposts.include?(micropost)
#   #likeしたmicropostがmicropostテーブルに存在するか確認
# end
# end
# end

# #==
# def destroy
#     @micropost = Micropost.find_by(params[:micropost_id]).like
#     current_user.likes(@micropost)  #← ◎