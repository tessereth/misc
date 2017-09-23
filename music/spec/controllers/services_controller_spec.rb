require "rails_helper"

RSpec.describe ServicesController, :type => :controller do
  describe "GET #new" do
    it "returns HTTP 200" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders new service template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "redirects to new service page with correct last date and congregation ID upon save" do
      post :create, params: {
             resource: {
               date: Date.today,
               body: "",
               congregation_id: 1
             }
           }
      expect(response).to redirect_to :action => :new, :last => Date.today, :congregation_id => 1
    end
  end
end
