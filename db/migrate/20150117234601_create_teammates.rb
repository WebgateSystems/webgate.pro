class CreateTeammates < ActiveRecord::Migration
  def self.up
    create_table :teammates do |t|
      t.string :name
      t.text :shortdesc
      t.text :description
      t.string :avatar

      t.timestamps
    end
    Teammate.create_translation_table! name: :string,  shortdesc: :text,
                                      description: :text
  end

  def self.down
    Teammate.drop_translation_table!
    drop_table :teammates
  end
end
