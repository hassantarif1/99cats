class UsermailerMailer < ApplicationMailer
    default :from => "99cats@appacademy.com"

    # Welcome Page for users
    def welcome_email(user)
        @user = user
        @url = "localhost:3316/cats"
        mail(to: user.email, subject: "Welcome to our website!")
    end
    # Validations Email for wronng password
    
    def wrong_password(user)
        @user = user
        @url = "localhost:3316/cats"
        mail(to: @user.email, subject: "Validation Email, password is wrong !")
    end

end
