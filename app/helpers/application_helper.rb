module ApplicationHelper
  
  def format_date(datetime)
    return  '' if datetime.nil?
    return datetime.strftime("%Y-%m-%d %H:%M:%S")
  end
    
end
