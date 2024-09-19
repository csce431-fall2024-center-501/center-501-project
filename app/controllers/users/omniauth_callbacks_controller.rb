class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    ADMIN_EMAILS = ['kjj@tamu.edu', 'ryan.pavlik@tamu.edu', 'kfogle6782@tamu.edu', 'pearlynntoh@tamu.edu', 'saradyl@tamu.edu']

    # google_oauth2 is the method that is called when the user logs in with Google
    def google_oauth2
        user = User.from_google(**from_google_params)
        if user.present?
        sign_out_all_scopes
        flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect user, event: :authentication
        else
        flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google',
        reason: "#{auth.info.email} is not authorized."
        redirect_to new_user_session_path
        end
    end

    protected
    def after_omniauth_failure_path_for(_scope)
        new_user_session_path
    end

    def after_sign_in_path_for(resource_or_scope)
        stored_location_for(resource_or_scope) || root_path
    end
    
    private
    def from_google_params
        @from_google_params ||= {
        uid: auth.uid,
        email: auth.info.email,
        full_name: auth.info.name,
        avatar_url: auth.info.image,
        user_type: ADMIN_EMAILS.include?(auth.info.email) ? 'admin' : 'user'
        }
    end
    def auth
        @auth ||= request.env['omniauth.auth']
    end
end