class DigestEmailsController < ApplicationController
 
 
 
  def create
    
    @check = DigestEmail.find_by_email(params[:email])
    unless @check
       DigestEmail.create(:email => params[:email], :edition=>params[:edition])
    end
    
  end



end
