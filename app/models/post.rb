class Post
  include Mongoid::Document
  belongs_to :author
  belongs_to :blog
  embeds_one :blog
  embeds_one :author

  embeds_many :replies
  accepts_nested_attributes_for :author, :blog, :replies

  field :labels, type: Array
  field :replies_count, type: Integer


  attr_protected :password

end
