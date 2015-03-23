class Page < ActiveRecord::Base

  belongs_to :subject
  # Ukoliko je join tabela nazvan drugacije od rails konvencije
  # dodaje se join_table argument
  # has_and_belongs_to_many :admin_users, join_table: "admin_users_pages"
  #
  # Ukoliko zelimo da promenimo naziv relacije, koristimo naziv i argument
  # class_name da bi ga povezali sa pravim Modelom
  has_and_belongs_to_many :editors, :class_name => "AdminUser"

  has_many :sections


  # Custom gem
  # scope, limitira pages na one koji pripadaju nekom subject
  acts_as_list :scope => :subject

  # CALLBACKS
  before_validation :add_default_permalink
  after_save :touch_subject
  after_destroy :delete_related_sections


  # Validation
  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  validates_presence_of :permalink
  validates_length_of :permalink, :within => 3..255
  validates_uniqueness_of :permalink

  scope :visible, lambda { where(visible: true) }
  scope :invisible, lambda { where(visible: false) }
  scope :sorted, lambda { order("pages.position ASC") }
  scope :newest_first, lambda { order("pages.created_at DESC") }
  # %..% > ovako se vrsi pretraga u SQL(name LIKE '%naziv%')
  scope :search, lambda { |query| where("name LIKE ?", "%#{query}%") }


  private

    def add_default_permalink
      if permalink.blank?
        # parameterize > pretvara name/string u nesto sto je pogodno za URL
        self.permalink = "#{id}-#{name.parameterize}"
      end
    end

    def touch_subject
      # touch: (samo updatuje timestamp)
      # subject.update_attribute(:updated_at, Time.now)
      subject.touch
    end

    def delete_related_sections
      self.sections.each do |section|
        # Kada se jednom obrise strana
        # ovo BRISE sve sekcije koje pripadaju toj strani.
        # Moze i da se pomeri ili nesto drugo
        # section.destroy
      end
    end

end
