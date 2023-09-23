class CreateLocations < Jennifer::Migration::Base
  def up
    create_table :locations do |t|
      t.string :name, {:null => false}
      t.string :type, {:null => false}
      t.string :dimension, {:null => false}
    end
  end

  def down
    drop_table :locations if table_exists? :locations
  end
end
