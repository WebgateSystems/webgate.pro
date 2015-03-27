class AddJobTitleToMembers < ActiveRecord::Migration
  def up
    Member.add_translation_fields! job_title: :string
  end

  def down
    remove_column :member_translations, :job_title
  end
end
