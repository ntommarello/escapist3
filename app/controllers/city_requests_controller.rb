class CityRequestsController < ApplicationController
  include GeoKit::Geocoders
  
  
  def create
    if @city = CityRequest.create(params[:request_city])
      
      loc = MultiGeocoder.geocode(params[:request_city][:city])
      if loc.success
        @city.lat = loc.lat
        @city.lng = loc.lng
        @city.save!
      end
 
      render :text => "Thanks, we'll let you know!"
    else
      render :nothing => true, :status => 400
    end
  end
end
