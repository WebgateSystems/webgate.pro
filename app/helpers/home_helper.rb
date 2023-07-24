module HomeHelper
  def cache_key_for_projects
    count          = Project.count
    max_updated_at = Project.maximum(:updated_at).try(:utc).try(:to_fs, :number)
    "projects/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_members
    count          = Member.count
    max_updated_at = Member.maximum(:updated_at).try(:utc).try(:to_fs, :number)
    "members/all-#{count}-#{max_updated_at}"
  end
end
