class Product < ActiveRecord::Base

  # REFERENCA
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true

  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: "must be a URL for GIF, JPG or PNG image" # custom error message
  }

  # Za CACHING
  # Thinking about it, we only need to re-render
  # things if a product changed, and even then we need to render only the prod-
  # ucts that actually changed.
  def self.latest
    Product.order(:updated_at).last # lepo kratko resenje
  end


  private

    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        # Custom error message, base je naziv hash-a
        errors.add(:base, 'Line Item Present')
        return false
      end
    end
end


# CACHING
#
# # Aktivacija cachinga:
# enviromets/development.rb >> config.action_controller.perform_caching = true
#
# # VIEW caching:
# 1. Celokupan cache entry se naziva 'store'
# <% cache ['store', Product.latest] %>
#
# 2. Individualni entry u cache zovemo 'entry':
# <% cache ['entry', product] %>
#
# Bracketed sections can be nested to arbitrary depth, which is why those in
# the Rails community have come to refer to this as RUSSIAN DOLL CACHING.
