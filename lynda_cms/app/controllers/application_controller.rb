class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  # AUTHENTICATION METHOD, dostupa svim ctrl
  private

  # Login check
  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = 'Please log in.'
      redirect_to :controller => 'access', action: 'login' #ctrl je obavezan ovde, da bi radio i u ostalim ctrl inace ce traziti action koji ne postoji u drugim ctrl
      return false # halts the before_actoin
    else
      return true # return true nije obavezan, bitan je FALSE
    end
  end
end

# Cross Site Request Forgery
# Ukratko predstavlja fake-vanje nekog request npr ka banci
#
# Korisnik ostane logovan na nekom sajtu, hacker napravi lazni request
# npr: <img src="http://bankaccount.com/transfer?asd&to=evilhacker" />
# Browser ovde misli da je u pitanju obicna slika, dok hacker moze ovo da
# iskoristi da uzme cookies, session info ...
#
# Zbog toga sto je korisnik logovan, website prihvata request misleci da je
# u pitanju req poslat od strane samog korisnika.i izvrsava trazenu komandu.
#
# Prevencija CSRF:
# 1. Require user authentication
# 2. Logout inactive users
# 3. GET >> readonly
# 4. Actions that expect POST should ONLY respond to POST req
#
# RAILS ima builtin mehanizam za odbranu od CSRF.
# On automatski generise authenticity token koji se dodaje u SVAKU formu.
# Na osnovu tog tokena rails zna da li je req poslat od pravog usera.
#
# Ovo se aktiva sledecom commandom:
# protect_from_forgery with: :exception
#
# Nalazi se u application_controller, i posto svi ostali ctrl nasledjuju od
# ApplicationControllera svi ctrl imaju ovo activno po defaultu.
#
# POSEBNA NAPOMENA ZA JS/AJAX:
# <%= csrf_meta_tag %>
# Ovo mora da se doda u <head> da bi se koristile iste zastite i kod js/ajax.
