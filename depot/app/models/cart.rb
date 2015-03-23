class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  # QTY u LineItems
  # Povecaj kvantite za 1 ukoliko vec postoji LineItem
  # U suprotnom napravi novi LineItem sa product_id
  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)

    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end

    current_item
  end

  # Sabiranje za view
  def total_price
    # to_a > to array
    # sum > rails method za sabiranje iz array
    # ovde item.total_price poziva method iz LINEITEM MODELA !!
    line_items.to_a.sum { |item| item.total_price }
  end

end


# RELACIJA
# sa line_item (model)
