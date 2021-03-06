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
    month_one = start_time.to_datetime.strftime('%b').strip()
    month_two = end_time.to_datetime.strftime('%b').strip()
    year_one = start_time.to_datetime.strftime('%Y').strip().to_i
    year_two = Date.today.strftime('%Y').to_i
    
    if (day_two != day_one) 
        
        if start_time > Time.now + 1.year
          if (month_two == month_one) 
            @time_string = "#{start_time.to_datetime.strftime('%B %e')}-#{end_time.to_datetime.strftime('%e')}"
          else
            @time_string = "#{start_time.to_datetime.strftime('%B %e')}-#{end_time.to_datetime.strftime('%b %e')}"
          end
        else
          
          number_of_days = (end_time.to_datetime - start_time.to_datetime).to_i + 1
          if (number_of_days > 1)
            @time_string = "until #{end_time.to_datetime.strftime('%B %e')}"
            @time_string = "#{@time_string}<br><span style='font-size:11px'>(#{number_of_days} days)</span>"
          else
             @time_string = "#{start_time.to_datetime.strftime('%A, %B %e')} <div style='font-size:12px; margin-top:3px;'>#{start_time.to_datetime.strftime('%l:%M%p')} until the next day at #{end_time.to_datetime.strftime('%l:%M%p')}</div>"
          end
          
         
        end
  
        

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
        @time_string = "#{start_time.to_datetime.strftime('%A, %B %e')}<br><div style='margin-top:4px;font-size:15px'>#{@start}#{s_am}-#{@end}#{e_am}</div>"
      else
        @time_string = "#{start_time.to_datetime.strftime('%A, %B %e')}<br><div style='margin-top:4px; font-size:15px'>#{@start}#{s_am}-#{@end}#{e_am}</div>"
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
  
  def strip_html(string)
    
    if string
      

      
      return string.gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<\s*br\s*\/?>/i,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ').gsub("<div>"," ").gsub("</div>"," ")
      
      #return string
    end
    
  end
  
  
  
end
