module ApplicationHelper
  def json_safe(text)
    (strip_html(text) || '').gsub(/\n/, "\\n").gsub(/\r/, "\\r").strip
  end

    def yield_for(content_sym, default)
      output = content_for(content_sym)
      output = default if output.blank?
      output
    end

  def strip_html(text)
    if text
      text = text.gsub(%r{</?[^>]+?>}, "\n")
      text = text.gsub(/%3Cbr%3E/,"\n")
      text = text.gsub(/%20/,' ')
      text = text.gsub(/&nbsp;/,' ')
      text = text.gsub(/%26nbsp/, ' ')
      text = text.strip()
      text = text.to_xs
    end
  end
  
  
  def calc_end_plan_time(start_time,end_time)
    
    day_one = start_time.to_datetime.strftime('%j').strip().to_i
    day_two = end_time.to_datetime.strftime('%j').strip().to_i
    
    if (day_two != day_one) 
       @time_string = "until #{end_time.to_datetime.strftime('%b %e')}"
    else 
    
      @start = start_time.to_datetime.strftime('%l').strip()
      min = start_time.to_datetime.strftime('%M')
      if min != "00"
        @start = "#{@start}:#{min}"
      end
    
      @end = end_time.to_datetime.strftime('%l').strip()
      min2 = end_time.to_datetime.strftime('%M')
      if min2 != "00"
        @end = "#{@end}:#{min2}"
      end
    
      s_am = start_time.to_datetime.strftime('%p').downcase()
      e_am = end_time.to_datetime.strftime('%p').downcase()
    
      if s_am == e_am
        @time_string = "#{@start}#{s_am}-#{@end}#{e_am}"
      else
        @time_string = "#{@start}#{s_am}-#{@end}#{e_am}"
      end
    end
    
    return @time_string
   end
  
  
  
  def decimal_distance(distance)
     distance = distance.to_f
     if distance < 5
       (distance * 10).round.to_f / 10
     else
       distance.round 
     end
  end
  
  def render_string_with_breaks(string)
 
    if string
      if string =~ /\n/
       string.gsub!(/\n/,"<br>")
      else
       string
      end
    end
      
  end
  
  
  def strip_line_breaks(string)
    
    if string
      

      
      return string.gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<\s*br\s*\/?>/i,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ')
      
      #return string
    end
    
  end
  
  
end
