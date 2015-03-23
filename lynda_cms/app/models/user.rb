class User < ActiveRecord::Base

  # Default naziv za tabelu je model plural: users
  # Ovako se customizuje:
  # self.table_name = 'admin_users'
  #
  # Automatski ucitava sve columns > attribute methods (getters / setters)

end

# RAILS CONSOLE:
#
# SUBJECT.TO_SQL > OVO JE VEOMA KORISNO, PRIKAZUJE SQL KOJI JE GENERISAN
#
# subject.new_record? > ovaj method proverava da li postoji takav zapis u db
# vraca true ukoliko jos nije saved u db, false ukoliko postoji u db
#
# KREIRANJE RECORD:
#
# NEW NACIN:
# subject = Subject.new
# subject.name = "First Subject"
# ...
#
# subject = Subject.new(name: "First Subject", position: 1, visible: true)
#
# subject.save > snimi u db
#
#
# CREATE NACIN:
# subject = Subject.create(name: "Second Subject", position: 2)
#
#
# SAVE > return true/false
# CREATE > vraca novi obj
#
#
# UPDATE RECORD:
#
# FIND/SAVE - POJEDINACAN COLUMN
# subject = Subject.find(1) # ovo je id
# subject.name = "Nesto"
# subject.save
#
# FIND/UPDATE_ATTRIBUTES - VISE COLUMN ISTOVREMENO
# subject = Subject.find(1)
# subject.update_attributes(name: "Nesto", position:2)
#
# DESTROY RECORD:
# subject = Subject.find(3)
# subject.destory
# Nakon brisanja ostaje privremeni OBJ sa podacima recorda koji je obrisan
#
#
# FINDING RECORDS:
#
# PRIMARY KEY FINDER ( ID ):
# Subject.find(2)
# > Vraca obj ili error
#
#
# DYNAMIC FINDERS:
# Subject.find_by_id(2) > dynamic finder - vraca NIL umesto errora
# > Korisno kada nismo sigurni da li record postoji u db
#
# Generisu se automatski za svaki COLUMN:
# Subject.find_by_id(2)
# Subject.find_by_name("Nesto")
#
# ALL RECORDS:
# Subject.all > vraca array
#
# FIRST/LAST:
# Subject.first, Subject.last
#
#
# QUERY METHODS:
#
# Za njih je bitno da ne izvrsavaju DB query odmah!
#
# WHERE(CONDITIONS):
# Subject.where(visible: true)
# Subject.where(visible: true).order('position ASC')
#
# Condition expression types:
# (Svi se koriste sa .where, i mogu da se chainuju)
# 1.String >
# ne preporucuje se zbog SQL injectiona
#
# 2.Array >
# ["name = ? AND visible = true", "First Subject"]
# ? - omogucava escapovanje SQL
#
# 3.Hash >
# { :name => "First Subject", :visible => true }
# { name: "First Subject", visible: true }
# Takodje escapovan, safe
# Svaki key-value par se spaja sa AND
#
# Postoje odredjena ogranicenja u koriscenju hash:
# Nema OR, LIKE, less than/ greater then
#
#
# ORDER, LIMIT, OFFSET
#
# ORDER(sql_fragment)
# Sortiranje recorda
# >> sql_fragment:
#    table_name.column_name ASC/DESC
#
# LIMIT(integer)
# Ogranicava broj recorda iz query(rezultat)
#
# OFFSET(integer)
# Preskace recorde, npr kod paginacije (preskoci 20 recorda sa prve strane)
#
#
# NAMED SCOPES:
# Custom queries, oni omogucavaju da definisemo nas ActiveRelation query.
# (methode kao sto su where, order itd..)
#
# Lambda =
# Anonimne funkcije u ruby (postoje jos i proc malo drugacije).
#
# Evaluated when called, NOT when defined. (za razliku od methoda)
# NPR, ovo bi bilo nemoguce sa method, zato sto bi Time.now uvek
# imao vrednost u trenutku definisanja ne bi se menjao nakon toga:
# scope :recent, lambda { where(created_at: 1.week.ago..Time.now) }
#
#
# scope :active, lambda { where(active: true) }
# scope :active, -> { where(active: true) } # ovo je starije
#
# Scope je samo short verzija methode:
# def self.active
#   where(active: true)
# end
#
# Scope moze da prima i argumente:
# scope :sa_custom_arg, lambda {|argument|  where(content_type: argument) }
