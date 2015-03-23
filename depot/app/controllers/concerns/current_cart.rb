module CurrentCart

  extend ActiveSupport::Concern

  private

  # Proverava da li postoji cart sa prosledjenim id
  # Ukoliko ne, kreira novi i updatuje session var
  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

end

# CONCERNS
#
# To je neka vrsta organizacije koda za modele/ctrl.
# http://blog.andywaite.com/2012/12/23/exploring-concerns-for-rails-4/
#
# Moze se koristiti i u vise modela/ctrl. (nesto kao shared)

