class ServicesController < ApplicationController
  def new
    if params[:last]
      @last = Service.find_by(date: Date.parse(params[:last]))
      @resource = OpenStruct.new(date: @last.date + 7, body: "")
    else
      @resource = OpenStruct.new(date: Date.today.beginning_of_week(:sunday), body: "")
    end
  end

  def create
    @resource = OpenStruct.new(date: Date.parse(params[:resource][:date]), body: params[:resource][:body])
    begin
      s = Service.from_email(params[:resource][:date], params[:resource][:body])
    rescue Exception => e
      flash[:alert] = e.to_s
      render :new
    end
    redirect_to new_service_path(last: s.date)
  end
end
