class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # @micropost je obj (nije jos saveovan u db) koji koristimo
      # u _micropost_form template
      @micropost = current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
