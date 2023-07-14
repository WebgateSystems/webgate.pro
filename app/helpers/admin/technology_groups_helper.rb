module Admin
  module TechnologyGroupsHelper
    def color_square(group)
      if group.color.present?
        "<i class='fa fa-2x fa-square' style='color:#{group.color};'></i>"
      else
        '&nbsp;'
      end
    end
  end
end
