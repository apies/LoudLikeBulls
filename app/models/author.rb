class Author
  include Mongoid::Document
  embedded_in :post


  attr_protected :password
end
