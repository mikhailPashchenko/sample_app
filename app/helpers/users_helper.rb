module UsersHelper
  def gravatar_img_tag(user, size: 80)
    gr_id = Digest::MD5::hexdigest user.email
    image_tag("https://secure.gravatar.com/avatar/#{gr_id}?s=#{size}",
      alt: user.name, class: 'gravatar')
  end
end
