class Like < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user
end

# class Like < ActiveRecord::Base
# has_many :micropost
#  belongs_to :user
# end

