class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = [] # dodat prazan array zbog static_pages/home, za fail submission micropostova
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url # request.refferer vraca nazad na stranu koja je izdala delete req
  end

  private

    # strong params
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # Ucitava micropostove current usera, ukoliko logovan user nije onaj ciji
    # su micropostovi, on se redirectuje nazad na root_url (onemogucava mu se
    # da obrise postove)
    # ID od micropost je jedinstven za svaki tako da se po tome moze videti da
    # li pripada current_useru ili ne
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
