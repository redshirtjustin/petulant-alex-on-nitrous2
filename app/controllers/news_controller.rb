class NewsController < ApplicationController
def index
    # display text and links
    end

    def login
    # login form
    end

    def attempt_login
        if params[:email].present? and params[:password].present?
            found_user = User.where(email: params[:email]).first
            if found_user 
                authorized_user = found_user.authenticate(params[:password])
            end
        end
        if authorized_user
            #TODO: mark user as logged in
            flash[:notice] = "You are now logged in."
            redirect_to(action: 'menu')
        else
            flash[:notice] = "Invalid email/password combinations."
            redirect_to(action: 'login')
        end       
    end

    def logout
        # TODO: mark user as logged out
        flash[:notice] = "Logged Out"
        redirect_to(action: 'login')
    end
end
