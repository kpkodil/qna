class CreateRewardOwnings < ActiveRecord::Migration[6.1]
  def change
    create_table :reward_ownings do |t|
      t.references :user, null: false
      t.references :reward, null: false

      t.timestamps
    end
  end
end
