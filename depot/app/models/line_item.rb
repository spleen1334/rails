class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  # Sabiranje za view
  def total_price
    product.price * quantity
  end
end

# TIPS
# If a table has foreign keys,
# the corresponding model should have a belongs_to for each.
