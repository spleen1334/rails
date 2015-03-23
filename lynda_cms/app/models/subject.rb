class Subject < ActiveRecord::Base

  # has_one :page
  #
  # Dependent: za automatsko brisanje
  # svih releated pages od subjekta
  # has_many :pages, :dependent => :destroy
  #
  # Dependent je rails callback, mi smo to u Page uradili
  # sa nasim custom callback (after_destroy :delete_related_sections)
  has_many :pages

  # Custom gem
  acts_as_list

  # VALIDACIJA
  # presence+length onemogucava spaces u podacima
  validates_presence_of :name
  validates_length_of :name, :maximum => 255

  scope :visible, lambda { where(visible: true) }
  scope :invisible, lambda { where(visible: false) }
  scope :sorted, lambda { order("subjects.position ASC") }
  scope :newest_first, lambda { order("subjects.created_at DESC") }
  # %..% > ovako se vrsi pretraga u SQL(name LIKE '%naziv%')
  scope :search, lambda { |query| where("name LIKE ?", "%#{query}%") }



end
