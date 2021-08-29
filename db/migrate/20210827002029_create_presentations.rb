class CreatePresentations < ActiveRecord::Migration[6.1]
  def change
    create_table :presentations do |t|
      t.string :title
      t.numeric :time

      t.timestamps
    end
  end
end
