module Admin::TechnologyGroupsHelper
  def color_square(group)
    if group.color && !group.color.blank?
      "<i class='fa fa-2x fa-square' style='color:#{group.color};'></i>"
    else
      '&nbsp;'
    end
  end
end
