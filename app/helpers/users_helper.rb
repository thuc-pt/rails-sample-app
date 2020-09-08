module UsersHelper
  def gravatar_for user
    id = Digest::MD5.hexdigest user.email
    url = Settings.gravatar_link << id.to_s
    image_tag(url, class: "avatar")
  end
end
