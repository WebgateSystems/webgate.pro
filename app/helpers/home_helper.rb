module HomeHelper
  def cache_key_for_projects
    count          = Project.count
    max_updated_at = Project.maximum(:updated_at).try(:utc).try(:to_fs, :number)
    # Also include translations updated_at to invalidate cache when translations change
    max_translation_updated_at = begin
      result = ActiveRecord::Base.connection.select_one(
        'SELECT MAX(updated_at) as max_updated_at FROM project_translations'
      )
      result&.dig('max_updated_at')&.to_time&.utc&.to_fs(:number)
    rescue StandardError
      nil
    end
    "projects/all-#{count}-#{max_updated_at}-t#{max_translation_updated_at}"
  end

  def cache_key_for_members
    count = Member.count
    max_updated_at = Member.maximum(:updated_at).try(:utc).try(:to_fs, :number)
    # Also include translations updated_at to invalidate cache when translations change
    # Using direct SQL query to get max updated_at from member_translations table
    max_translation_updated_at = begin
      result = ActiveRecord::Base.connection.select_one(
        'SELECT MAX(updated_at) as max_updated_at FROM member_translations'
      )
      result&.dig('max_updated_at')&.to_time&.utc&.to_fs(:number)
    rescue StandardError
      nil
    end
    "members/all-#{count}-#{max_updated_at}-t#{max_translation_updated_at}"
  end
end
