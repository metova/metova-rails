module Metova
  class FeedbacksController < Metova::ApplicationController

    respond_to :html, :json, :js

    def new
      @feedback = Metova::Feedback.new
    end

    def create
      @feedback = Metova::Feedback.new(params[:feedback])
      @feedback.device = request.env['HTTP_USER_AGENT']
      @feedback.referer = request.env['HTTP_REFERER']
      if @feedback.submit!
        flash[:notice] = 'Your feedback was submitted successfully!'
      else
        flash[:error] = 'There was an error submitting feedback.'
      end
      respond_with @feedback, location: feedback_path
    end

    def show
    end

  end
end