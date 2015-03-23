class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains


  private

    # Exception raise: automatski izvrsava rollback ovde, i vraca error nazad
    # u ctrl gde je mozemo handlovati uz pomoc begin/end
    def ensure_an_admin_remains
      if User.count.zero?
        raise "Cant delete last user"
      end
    end
end
