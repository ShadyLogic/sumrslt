class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :post_id
      t.string :post_url
      t.integer :blog_id

      t.timestamps null: false
    end
  end
end
