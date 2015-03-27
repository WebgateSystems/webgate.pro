class RenameColumnInMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.rename :shortdesc, :education
    end

    change_table :member_translations do |t|
      t.rename :shortdesc, :education
    end
  end
end
