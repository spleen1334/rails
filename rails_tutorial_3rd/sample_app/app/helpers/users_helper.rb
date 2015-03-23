module UsersHelper

  # Gravatar profile slike
  def gravatar_for(user)
    # MD5 hash korisnikove email adrese
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
