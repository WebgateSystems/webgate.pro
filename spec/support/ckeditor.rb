# Used to fill ckeditor fields
# @param [String] locator label text for the textarea or textarea id
def fill_in_ckeditor(locator, params = {})
  # Find out ckeditor id at runtime using its label
  locator = find('label', text: locator)[:for] if page.has_css?('label', text: locator)
  # Fill the editor content
  page.execute_script <<-SCRIPT
      var ckeditor = CKEDITOR.instances.#{locator}
      ckeditor.setData('#{params[:with]}')
      ckeditor.focus()
      ckeditor.updateElement()
  SCRIPT
end
