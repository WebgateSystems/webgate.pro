module Select2Helper
  def select2(value, element_selector)
    select2_container = first(element_selector.to_s)
    select2_container.find('.select2-choice').click

    find(:xpath, '//body').find('input.select2-input').set(value)
    page.execute_script(%|$("input.select2-input:visible").keyup();|)
    drop_container = '.select2-results'
    find(:xpath, '//body').find("#{drop_container} li", text: value).click
  end
end
