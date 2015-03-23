class SubjectsController < ApplicationController

  layout 'admin'

  before_action :confirm_logged_in

  def index
    @subjects = Subject.sorted
  end

  def show
    @subject = Subject.find(params[:id])
  end

  def new
    # New radi i bez ove instance (jer form_for ga ne zahteva, polja su empty
    # onda)
    # Ali je good practise da se ipak definise
    @subject = Subject.new({:name => "Default"})
    @subject_count = Subject.count + 1 # dodato za select iz view
  end

  def create
    # Koraci za generisanje novog recorda:
    # 1. Instantiate a new obj using form parameters:
    # MASS ASSIGNEMENT/STRONG PARAMETERS:
    # Nije prakticno zbog cega je premesteno dole u private:
    # @subject = Subject.new(params.require(:subject).permit(:name, :position, :visible))
    @subject = Subject.new(subject_params)

    # 2. Save obj
    if @subject.save
      # Save successful, redirect to index action
      # redirect_to(:action => 'index')

      flash[:notice] = "Subject created successfully."

      redirect_to action: 'index'
    else
      # Save failed, redisplay form with old data
      @subject_count = Subject.count + 1 # dodato za select iz view
      render 'new'
    end

  end

  def edit
    @subject = Subject.find(params[:id])
    @subject_count = Subject.count # dodato za select iz view
  end

  def update
    # Slicno kao i create
    @subject = Subject.find(params[:id])

    if @subject.update_attributes(subject_params)

      flash[:notice] = "Subject updated successfully."

      redirect_to action: 'show', id: @subject.id
    else
      @subject_count = Subject.count # dodato za select iz view
      render 'edit'
    end

  end

  def delete
    @subject = Subject.find(params[:id])
  end

  def destroy
    # @subject = Subject.find(params[:id])
    # @subject.destroy # za destroy ne treba IF jer retko kad pravi greske
    subject = Subject.find(params[:id]).destroy # primer chainovanja

    # DB record je izbrisan ali ostaje temp obj koji moze da se upotrebi
    flash[:notice] = "Subject '#{subject.name}' destroyed successfully."

    redirect_to action: 'index'
  end

  private

    # Moze da se koristi u svim actions a ne samo create npr
    # Radi lakse citljivosti i organizacije premesteno je u private method:
    def subject_params
      params.require(:subject).permit(:name, :position, :visible)
    end
end

# FORM INPUT
# ----------
#
# params >> cuva sve HTTP parametre
#
# Konvencija za slozenije app:
# 2D Array
# <input type="text" name="subject[name]"/>
# params[:subject][:name]
#
# Ovo omogucava da se passuje ceo params[:subject] prilikom kreiranja:
# subject = Subject.new(params[:subject])
#
#
# FORM RAILS:
# 1.FORM_TAG
#
# <%= form_tag(:action = > 'create') do %>
#   <%= text_field_tag('subject[name]') %>
#
#   <%= text_field(:subject, :name) %> # ovo je Obj.attribute, ukoliko postoji
#   onda se koristi kao current value (popunjava text field u html)
#
#   <%= submit_tag("Create Subject") %>
# <% end %>
#
# 2. FORM_FOR(shorthand za pristup Obj)
#
# <%= form_for(:subject, :url => {:action => 'create'}) do |f| %>
#
#   <%= f.text_field(:name) %>
#
#   <%= submit_tag("Create Subject") %>
# <% end %>
#
#
# MASS ASSIGNEMENT + STRONG PARAMETERS
# ------------------------------------
#
# Rails je kroz razvoj imao mnoga resenja za mass assignement.
# Rails v4 uvodi obavezne strong parameters.
# Zastita se premesta iz modela u ctrler.
# Ova zastita je po defaultu uvek ukljucena, to znaci da svi parametri koji
# mogu da se mass assignementuju su blockirani. Prolaze samo oni koji su
# explicitno permitovani:
#
# params.permit(:first_name, :last_name) # dopusteni parametri
# params.require(:subject) # vraca subject hash kao params[:subject]
#
# # moze da se kombinuje:
# params.require(:subject).permit(:name, :position, :visible)
#
#
#
# CREATE VS UPDATE
# ----------------
#
# Veoma slicni, razlike su:
#
# params[:id]
# > new/create ne zahtevaju ID
# > za edit/update su OBAVEZNI
#
# Form processing
# > create koristi new i save methode (Subject.new/ subject.save)
# > Update koristi find i update_attributes (Subject.find
# / subject.update_attrbutes())
#
# DELETE AND DESTROY
# ------------------
#
# params[:id]
# > delete / destory zahtevaju ID kao i da record postoji u DB
#
# Form processing
# > destroy koristi find i destory methode
#
#
# > Veoma cesto delete action uopste nema view (stranu)
# > Zbog toga cesto nije neophodno uopste praviti instance var
#
#
# FLASH HASH MESSAGE
# ------------------
#
# Skladisti poruku u SESSION
# Posle svakog req prise stare poruke
# Najcesce se koristi nakon redirect kad zelimo da prosledimo i neku poruku.
#
# Flash sadrzi vise key-eva ( notice, error itd.. )
# Moguce je koristi i custom key-eve radi drugacijeg css formatiranja.
# flash[:notice] = "Ovo je test poruka"
