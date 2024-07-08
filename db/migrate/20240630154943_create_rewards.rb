class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.text :title, null: false
      t.float :probability, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # Add a check constraint for probability to be within 0.1 to 99.9 with one decimal place
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE rewards
          ADD CONSTRAINT probability_range
          CHECK (probability >= 0.1 AND probability <= 99.9 AND floor(probability * 10) = probability * 10);
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE rewards
          DROP CONSTRAINT probability_range;
        SQL
      end
    end
  end
end
