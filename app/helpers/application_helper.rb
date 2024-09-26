# frozen_string_literal: true

module ApplicationHelper

    def sign_in_user
        "<a href=\"#{signin_url}\">Sign In</a>".html_safe
    end
    
    def sign_up_user
        "<a href=\"#{signup_url}\">Sign Up</a>".html_safe
    end

    def cat_link(cat)
        short_description = cat.description.slice(0,20)
        short_description += " ..." if short_description.length > 10
        html = "<a href=\"#{cat_url(cat)}\">"
        html += html_escape(cat.name) + "(#{html_escape(short_description)})"
        html += "</a>"
        html.html_safe
    end
end


