class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_not_found(status = :not_found)
    if status == :forbidden
      render file: 'public/403.html', status: status
    else
      render file: 'public/404.html', status: status
    end
  end

end
