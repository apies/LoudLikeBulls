#require require Rails.root.join('app', 'models')
require Rails.root.join("app/models/googler")
require Rails.root.join("app/models/blogger")

Dir[Rails.root.join("app/models/*.rb")].each {|f| require f}
Dir[Rails.root.join("app/lib/*.rb")].each {|f| require f}


namespace :loud_like_bulls do

  class Migrator < Blogger
    extend GooglerTestingService
  end

  def swap_attribute(hash, attribute, prefix)
    hash["#{prefix}_#{attribute}"] = hash[attribute]
    hash.delete(attribute)
    hash
  end

  desc "migrate all posts on blogger to a local db"
  
  task :migrate_from_blogger => :environment do
    puts "your blog is being migrated from blogger!"
    
    Migrator.include_test_client
    migrator = Migrator.new(:token => 'fake-t0ken', :service => 'blogger')
    posts = migrator.all_posts(2360593805083673688).map do |result| 
      post = result.to_hash
      post["replies_count"] = post["replies"]["totalItems"].to_i
      post.delete("replies")
      swap_attribute(post, "id", "blogger")
      post["blog"] = swap_attribute(post["blog"], "id", "blogger_blog")
      post["author"] = swap_attribute(post["author"], "id", "blogger_author")
      post 
    end
    posts.each {|p| Post.create(p) }
    puts "your blog is done being migrated from blogger!"


  end

end