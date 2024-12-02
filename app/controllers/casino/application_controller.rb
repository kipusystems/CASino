# frozen_string_literal: true

require_dependency 'casino/sessions_helper'
module Casino
  class ApplicationController < ActionController::Base
    layout 'application'

    unless Rails.env.development?
      rescue_from ActionView::MissingTemplate, with: :missing_template
    end

    def cookies
      super
    end

    protected

    def missing_template(exception)
      render plain: 'Format not supported', status: :not_acceptable
    end
  end
end
