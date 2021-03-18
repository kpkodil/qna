class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.belongs_to :linkable, polymorphic: true
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
