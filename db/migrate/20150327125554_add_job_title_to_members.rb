class AddJobTitleToMembers < ActiveRecord::Migration[5.2]
  def self.up
    Member.add_translation_fields! job_title: :string
  end

  def self.down
    remove_column :member_translations, :job_title
  end
end
