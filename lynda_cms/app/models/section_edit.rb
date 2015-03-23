class SectionEdit < ActiveRecord::Base

  belongs_to :editor, class_name: "AdminUser", foreign_key: "admin_user_id"
  # section.section_edits.map { |se| se.editor } # za gornje Rich Join table
  belongs_to :section

end
