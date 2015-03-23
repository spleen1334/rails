module SessionsHelper

  # Uloguj korisnika, kreiraj session
  def log_in(user)
    session[:user_id] = user.id # session je ovde rails method
  end

  # Ucitaj trenutnog korisnika iz sessiona ukoliko postoji + cookie
  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])

    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # raise # ovo namerno dize exception da bi videli da li testovi rade
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end

    # (user_id = session[:user_id]) >> ruby konstrukcija specificna vrsta
    # asignementa:
    # if session[:user_id]
    #   @curent_user ||= User.find_by(id: session[:user_id])
  end

  # Proveri da li je neko logovan
  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete( :user_id )
    @current_user = nil
  end

  # Cookies
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    # permanent > cookies[:remember_token] = { value:   remember_token,
    #                              expires: 20.years.from_now.utc }
    # signed > sifrira cookie pre nego sto ga posalje u browser
  end

  # COokies logout
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Provera usera, da li pravilan user
  def current_user?(user)
    user == current_user
  end


  # FRIENDLY REDIRECT
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
