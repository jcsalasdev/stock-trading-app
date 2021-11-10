module ApplicationHelper

    def gravatar_for(user, options = { size: 80})
        email_address = user.email.downcase
        hash = Digest::MD5.hexdigest(email_address)
        size = options[:size]
        gravatar_url = "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
        image_tag(gravatar_url, alt: user.email, class: "rounded-circle shadow mx-auto d-block mt-2")
    end

end
