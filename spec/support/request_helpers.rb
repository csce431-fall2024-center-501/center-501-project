# spec/support/request_helpers.rb
module RequestHelpers
    # Helper method to test redirection to root_url
    def test_redirect_to_root(target_url, alert_message)
      get target_url
      expect(response).to redirect_to(root_url)
      if alert_message
        follow_redirect!
        expect(response.body).to include(alert_message)
      end
    end
    
    def test_redirect_to_signin(target_url, alert_message)
      get target_url
      expect(response).to redirect_to(new_user_session_path)
      if alert_message
        follow_redirect!
        expect(response.body).to include(alert_message)
      end
    end
  end