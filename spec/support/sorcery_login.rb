module Sorcery
  module TestHelpers
    module Rails
      module Integration
        def login_user_post(email, password)
          page.driver.post(sessions_url, { email:, password:, remember_me: false })
        end

        def logout_user_get
          page.driver.get(logout_url)
        end
      end
    end
  end
end
