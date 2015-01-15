module Metova
  class FeedbacksController < Metova::ApplicationController

    def new
      @feedback = Metova::Feedback.new
    end

    def create
    end

  end
end