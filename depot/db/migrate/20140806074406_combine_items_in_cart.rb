class CombineItemsInCart < ActiveRecord::Migration

  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # Izbroj kolicinu proizvoda u cart
      # .group > slicno sto i select, selektuje i sortira po attr
      # .sum > racuna vrednost colone
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # Ukloni pojedinacan item
          cart.line_items.where(product_id: product_id).delete_all

          # Napravi jedan item umesto vise njih
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # Split item with quantity>1 into multiple items
    LineItem.where("quantity>1").each do |line_item|
      # Add individual item
      # Lepo resenje za petlju:
      # (line_item.quantity).times >> npr 5.times
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
      end

      # Remove original item
      line_item.destory
    end
  end

end

# UP METHOD:
# 1. Iterate over each Cart.
# 2. For each cart, we get a sum of the quantity fields for each of the line
#    items
#    associated with this cart, grouped by product_id . The resulting sums will
#    be a list of ordered pairs of product_id s and quantity.
# 3. We iterate over these sums, extracting the product_id and quantity from
#    each.
# 4. In cases where the quantity is greater than one, we will delete all of the
#    individual line items associated with this cart and this product and replace
#    them with a single line item with the correct quantity.
