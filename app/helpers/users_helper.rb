module UsersHelper
  def gravatar_img_tag(user, size: 80)
    gr_id = Digest::MD5::hexdigest user.email
    image_tag("https://secure.gravatar.com/avatar/#{gr_id}?s=#{size}",
      alt: user.name, class: 'gravatar')
  end

  def pagination(page_number = 1)
    page_number = 1 if page_number.nil?
    User.where(id: ((page_number.to_i - 1)*3 + 1)..page_number.to_i*3)
  end

  def page_number_plus
    n = params[:page].nil? ? 1 : params[:page].to_i

    if 3*n + 1 > User.count
      0
    else
      n + 1
    end
  end

  def page_number_minus
    params[:page].nil? ? 0 : params[:page].to_i - 1
  end
end
