class ServicesController < ApplicationController
  def new
    @congregations = Congregation.all
    if params[:last]
      @last = Service.find_by(date: Date.parse(params[:last]))
      @resource = OpenStruct.new(date: @last.date + 7, body: "", congregation_id: @last.congregation_id)
    else
      @resource = OpenStruct.new(date: Date.today.beginning_of_week(:sunday), body: "")
    end
  end

  def create
    @resource = OpenStruct.new(date: Date.parse(params[:resource][:date]), body: params[:resource][:body],
                               congregation_id: params[:resource][:congregation_id])
    begin
      congregation = Congregation.find_by(id: params[:resource][:congregation_id])
      s = Service.from_email(params[:resource][:date], params[:resource][:body],
                             congregation)
    rescue Exception => e
      flash[:alert] = e.to_s
      render :new
      return
    end
    redirect_to new_service_path(last: s.date, congregation_id: params[:resource][:congregation_id])
  end

  def songs
    @cutoff = params[:cutoff].to_f
    @books = Book.includes(songs: :services).all
    @other_songs = Song.where(book: nil).order(:title).includes(:services)
  end

  def services
    @services = Service.includes(songs: :book).order(:date)
  end

  def stats
  end
end
