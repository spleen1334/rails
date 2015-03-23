class Ribbit < ActiveRecord::Base
  attr_accessible :content, :user_id

  # Ovo se aktivara za sve operacije sa modelom
  # Slicno kao i before_ u ctrl
  # nemora sql u "", moze i methods, :hash itd..
  # U Rails 4 se koristi preko block {}, a scope ide preko lambdi ->
  #  default_scope { where(published: true)  }
  #  Scope sluzi samo za filtriranje, obicno ga koristimo u ctrl
  default_scope order: "created_at DESC"

  # SQL RELACIJA (user_id)
  belongs_to :user

  validate :content, length: { maximum: 140 }
end
