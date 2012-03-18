module ApplicationHelper
  def escape_arrow(text)
    text.gsub("<",'&lt;').gsub(">",'&gt;')
  end
  def line_break(text)
    text.gsub("\n",'<br \>')
  end
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis]
    Redcarpet.new(text, *options).to_html.html_safe
    
  end
end
