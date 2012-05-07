module ApplicationHelper

  def avatar_url(user)
    user.image_url
  end

  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis]
    Redcarpet.new(text, *options).to_html.html_safe
  end
end
