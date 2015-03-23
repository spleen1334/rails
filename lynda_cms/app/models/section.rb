class Section < ActiveRecord::Base

  belongs_to :page

  has_many :section_edits
  has_many :editors, :through => :section_edits, :class_name => "AdminUser"


  # Custom gem
  # scope, limitira pages na one koji pripadaju nekom subject
  acts_as_list :scope => :page

  # CALLBACKS
  after_save :touch_page

  # Validacija
  CONTENT_TYPES = ['text' ,'HTML']

  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  validates_inclusion_of :content_type, :in => CONTENT_TYPES,
                  :message => "must be one of: #{CONTENT_TYPES.join(', ')}"
  validates_presence_of :content



  scope :visible, lambda { where(visible: true) }
  scope :invisible, lambda { where(visible: false) }
  scope :sorted, lambda { order("sections.position ASC") }
  scope :newest_first, lambda { order("sections.created_at DESC") }
  # %..% > ovako se vrsi pretraga u SQL(name LIKE '%naziv%')
  scope :search, lambda { |query| where("name LIKE ?", "%#{query}%") }

  private

    def touch_page
      # touch: (samo updatuje timestamp)
      # subject.update_attribute(:updated_at, Time.now)
      page.touch
    end
end
