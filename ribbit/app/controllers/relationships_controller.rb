class RelationshipsController < ApplicationController

  def create
    relationship = Relationship.new(params[:relationship])
    # relationship.follower_id = current_user.id
    relationship.follower = current_user

    # if relationship.save
    #   redirect_to relationship.followed # isti sistem, show view
    # else
    #   flash[:error] = "Couldnt Follow"
    #   redirect_to relationship.followed
    # end

    flash[:error] = "Couldnt Follow" unless relationship.save
    redirect_to relationship.followed
  end

  def destroy
    relationship = Relationship.find(params[:id])
    user = relationship.followed # vraca se na usera koji je bio pracen
    relationship.destroy
    redirect_to user
  end

end
