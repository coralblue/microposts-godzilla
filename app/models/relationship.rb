class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  # belongs_to favorite_micropost : Like, class_name; "Microposts"

end