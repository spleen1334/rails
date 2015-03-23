class Micropost < ActiveRecord::Base
  belongs_to :user

  # CarrierWave gem za upload podataka
  mount_uploader :picture, PictureUploader

  # scope, ovde je to izlaz iz db
  # scope u rails je lamba funkcija, proc ili anonimna funkcija 11.16 u knjizi
  # u starijim verzijam je morao direktiniji sql order('created_at DESC')
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

    # validacija za velicinu slike, validate
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "Should be less then 5MB")
      end
    end
end



# ASSOCIATION METHODS
#####################
# micropost.user                 - Returns the User object associated with the micropost
# user.microposts                - Returns a collection of the user’s microposts
# user.microposts.create(arg)    - Creates a micropost associated with user
# user.microposts.create!(arg)   - Creates a micropost associated with user (exception on failure)
# user.microposts.build(arg)     - Returns a new Micropost object associated with user
# user.microposts.find_by(id: 1) - Finds the micropost with id 1 and user_id equal to user.id
