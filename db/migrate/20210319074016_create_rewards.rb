class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.belongs_to :question, null: false, foreign_key: true

      t.string :title
      t.text :image_url

      t.timestamps
    end
  end
end
