module HomeHelper
  def cache_key_for_members
    count          = Member.count
    max_updated_at = Member.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "members/all-#{count}-#{max_updated_at}"
  end
end
